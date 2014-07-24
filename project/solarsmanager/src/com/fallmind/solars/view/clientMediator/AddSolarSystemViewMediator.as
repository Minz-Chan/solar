package com.fallmind.solars.view.clientMediator
{
	import com.fallmind.solars.ApplicationFacade;
	import com.fallmind.solars.model.AddSolarSystemProxy;
	import com.fallmind.solars.model.CheckProxy.CheckPassword2Proxy;
	import com.fallmind.solars.model.CheckProxy.CheckSelfCheckProxy;
	import com.fallmind.solars.model.CurrentDataProxy;
	import com.fallmind.solars.model.GetConsoleStateProxy;
	import com.fallmind.solars.model.LoginProxy;
	import com.fallmind.solars.model.SendOrderProxy;
	import com.fallmind.solars.model.SolarInfoProxy;
	import com.fallmind.solars.model.bussiness.ConfigManager;
	import com.fallmind.solars.view.component.clientSetup.AddSolarSystemView;
	
	import flash.events.Event;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	
	import mx.controls.Alert;
	import mx.managers.PopUpManager;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	/**
	 * 添加太阳能系统界面的管理类，
	 * 用于响应界面的各种事件，比如保存，取消
	 */
	public class AddSolarSystemViewMediator extends Mediator
	{
		// 名字，其他类可以通过这个名字找到这个类
		public static const NAME:String = "AddSolarSystemViewMediator";
		
		private var loginProxy:LoginProxy; 	// 从这里获取用户名和密码
		private var checkPassword2Proxy:CheckPassword2Proxy;	// 定时检测密码指令是否超时，错误，或成功
		private var addProxy:AddSolarSystemProxy;	// 负责添加系统
		private var sendOrderProxy:SendOrderProxy;	// 负责发送设置密码指令
		private var currentDataProxy:CurrentDataProxy;	// 因为系统安装情况设置界面所需要的参数要从这个类中获取，所以要弹出统安装情况设置界面就要先设置这个对象的参数
		private var solarInfo:SolarInfoProxy;
		private var checkSelfCheckProxy:CheckSelfCheckProxy;	// 添加完小区后要发送自检指令
		private var getConsoleStateProxy:GetConsoleStateProxy;	// 检查控制台是否开启
		// 图片上传有关变量
		private var imageSelect:FileReference;
		private var nativeImageRoute:String;
		private var remoteImageRoute:String;	
		private var nativeImageType:String;	
		private var remoteImage:String;		
		
		private var belCommunityID:String;	// 要添加系统所属的小区ID
		private var systemID:String;
		
		private var defaultARMPassword:String;	// 默认ARM密码，从配置表中读取
		
		private var username:String;	// 用户名
		private var password:String;	// 密码
		
		private var config:ConfigManager;	// 配置表
		
		private var m_password:String;	// 主控器密码，如果为空，则为配置表中的默认密码，否则为用户所设置密码
		
		private var hasBrowed:Boolean = false; //标记是否已经加载文件路径，也就是是否按过浏览按钮 
		public function AddSolarSystemViewMediator(viewComponent:Object):void {
			super(NAME, viewComponent);
			
			// 获取程序所需proxy，proxy提供了功能函数
			loginProxy = LoginProxy(facade.retrieveProxy(LoginProxy.NAME));		
			checkPassword2Proxy = CheckPassword2Proxy(facade.retrieveProxy(CheckPassword2Proxy.NAME));
			addProxy = AddSolarSystemProxy(facade.retrieveProxy(AddSolarSystemProxy.NAME));
			sendOrderProxy = SendOrderProxy(facade.retrieveProxy(SendOrderProxy.NAME));
			currentDataProxy = CurrentDataProxy(facade.retrieveProxy(CurrentDataProxy.NAME));
			solarInfo = SolarInfoProxy(facade.retrieveProxy(SolarInfoProxy.NAME));
			checkSelfCheckProxy = CheckSelfCheckProxy(facade.retrieveProxy(CheckSelfCheckProxy.NAME));
			getConsoleStateProxy = GetConsoleStateProxy(facade.retrieveProxy(GetConsoleStateProxy.NAME));
			
			username = loginProxy.getUserName();	// 获取用户名和密码
			password = loginProxy.getUserPassword();
			
			config = ConfigManager.getManageManager();	// 获取配置表
			remoteImageRoute = config.imageUploadURL;	// 获取图片上传参数
			remoteImage = config.imageURL;
			defaultARMPassword = config.getDefaultARMPassword();
			
			// 打开图片浏览窗口
			imageSelect = new FileReference();
			imageSelect.addEventListener(Event.SELECT, userselect);
			imageSelect.addEventListener(Event.COMPLETE, completeHandler);
			
			editView.addEventListener(AddSolarSystemView.CLOSE_SOLARSYSTEM_VIEW, closeHandler);
			editView.addEventListener(AddSolarSystemView.SAVE_SOLARSYSTEM, saveHandler);
			editView.addEventListener(AddSolarSystemView.BROW_IMAGE, browImageHandler);
			editView.addEventListener(AddSolarSystemView.UPLOAD_IMAGE, uploadImageHandler);
		}
		/**
		 * 因为本类管理的界面是个弹出窗口，弹出窗口的一个特点就是如果窗口关闭，那么窗口的引用被清空。
		 * 清空以后本类就没法绑定到弹出窗口上，所以每次弹出窗口时都要把本类绑定到弹出窗口上，即重新执行一次
		 * init函数。所有与界面元素(本例是editView)有关的操作都要重新执行一次。
		 */
		public function init():void {
			editView.addEventListener(AddSolarSystemView.CLOSE_SOLARSYSTEM_VIEW, closeHandler);
			editView.addEventListener(AddSolarSystemView.SAVE_SOLARSYSTEM, saveHandler);
			editView.addEventListener(AddSolarSystemView.BROW_IMAGE, browImageHandler);
			editView.addEventListener(AddSolarSystemView.UPLOAD_IMAGE, uploadImageHandler);
		}
		// 如果选择了图片，就把hasBrowed设为true，以便上传时判断是否选择图片
		private function browImageHandler(e:Event):void {
			hasBrowed = true;
			imageSelect.browse();
		}
		// 响应关闭弹出窗口的事件
		private function closeHandler(e:Event):void {
			closeWindow();	
		}
		// 关闭弹出窗口时要处理的变量
		private function closeWindow():void {
			hasBrowed = false;
			remoteImage = "";
			// PopUpManager是AS3中管理弹出窗口的类。removePopUp移除弹出窗口
			PopUpManager.removePopUp(editView);
			// 把本类的界面元素设为空
			this.setViewComponent(null);
		}
		private function uploadImageHandler(e:Event):void {
			// 用hasBrowed判断是否已经选择了图片，如果没有选择图片，弹出提示
			if(hasBrowed) {
				// 上传图片
				var urlRequest:URLRequest = new URLRequest(remoteImageRoute);
				imageSelect.upload(urlRequest);
			} else {
				Alert.show("请先选择图片");
				return;
			}
		}
		// 当图片载入完毕，会执行这个函数
		private function completeHandler(e:Event):void {
			// config.imageURL是远程服务器上的路径，图片就是传到这个路径下。这个值从配置表中读取。remoteImage就是上传路径
			remoteImage = config.imageURL + imageSelect.name;
			// 在图片框中显示图片
			editView.imageField.source = remoteImage;

			editView.imageField.addEventListener(Event.COMPLETE, updateComplete);
		}
		// 图片显示完以后设置图片框的参数
		private function updateComplete(e:Event):void {
			editView.imageField.width = 240;
			editView.imageField.height = 133;
			editView.imageField.content.width = 240;
			editView.imageField.content.height = 133;
		}
		// 图片上传完毕后显示图片在服务器上的地址
		private function userselect(e:Event):void {
			editView.stateText = "图片在服务器上的路径：" + config.imageURL + imageSelect.name;;
		}
		// 响应添加太阳能系统的保存按钮
		private function saveHandler(e:Event):void {
			// solarInfo保存了所有太阳能系统的信息，判断是否系统名和主控器ID是否已经存在
			for each(var item:XML in solarInfo.getData().row.(@BelCommunityID==belCommunityID)) {
				if(item.@System_Name == editView.systemNameInput.text) {
					Alert.show("系统名已存在");
					return;
				}
				if(item.@ARM_ID == editView.ARM_ID_Input.text) {
					Alert.show("主控器ID已存在");
					return;
				}
			}
			// 如果没有设置主控器密码，就用配置表中的默认密码
			if(editView.ARMPasswordInput.text == "") {
				m_password = defaultARMPassword;
				editView.ARMPasswordInput.text = m_password;
			} else {
				m_password = editView.ARMPasswordInput.text;
			}
			
			checkPassword2Proxy.setData(editView.ARMPasswordInput.text);
			
			Alert.show("请在太阳能系统管理的厂家配置中设置系统安装情况");
			// 调用addProxy中添加太阳能系统的功能函数
			addProxy.addSolarSystem(username, password, editView.systemNameInput.text, editView.managerInput.text,
				editView.managerPhoneInput.text, belCommunityID, editView.ARM_ID_Input.text, 
				editView.setupTime, remoteImage, m_password);
				
		}
		public function get editView():AddSolarSystemView {
			return viewComponent as AddSolarSystemView;
		}
		// 列出本类所响应的所有事件（不包括界面元素发送的事件，界面元素的事件由AS3的事件机制处理，这里的是pureMVC的事件机制
		public override function listNotificationInterests():Array {
			return [
				ApplicationFacade.ADD_SOLARSYSTEM,
				AddSolarSystemProxy.ADD_SOLARSYSTEM_SUCCESS,
				CheckPassword2Proxy.CHECK_PASSWORD2_FAILED,
				CheckPassword2Proxy.CHECK_PASSWORD2_OVERTIME,
				CheckPassword2Proxy.CHECK_PASSWORD2_SUCCESS,
				CheckPassword2Proxy.CHECK_PASSWORD2_WRONG,
				CheckSelfCheckProxy.CHECK_SELF_CHECK_FAILED,
				CheckSelfCheckProxy.CHECK_SELF_CHECK_OVERTIME,
				CheckSelfCheckProxy.CHECK_SELF_CHECK_SUCCESS,
				GetConsoleStateProxy.CONSOLE_IS_CLOSE,
				GetConsoleStateProxy.CONSOLE_IS_OPEN
			];
		}
	
		public override function handleNotification(notification:INotification):void {
			switch(notification.getName()) {
				// 点击添加太阳能系统的按钮，发送的事件，由本界面元素的父界面发送
				case ApplicationFacade.ADD_SOLARSYSTEM:
					// 保存当前的小区ID
					belCommunityID = notification.getBody().toString();
					break;
				// 向数据库中添加太阳能系统成功，只是向数据库中添加，
				case AddSolarSystemProxy.ADD_SOLARSYSTEM_SUCCESS:
					// 保存系统ID（因为系统ID是添加以后才确定的，所以要在添加成功后获取）
					systemID = notification.getBody().toString();
					
					getConsoleStateProxy.getConsoleState(username, password, systemID);		//   获取控制台状态
					// 初始化checkPassword2Proxy，用来检测密码设置是否成功
					checkPassword2Proxy.setData(m_password);
					break;
				// 控制台开启
				case GetConsoleStateProxy.CONSOLE_IS_OPEN:	
					ApplicationFacade.consoleStarted = true;
					// 发送自检指令
					sendOrderProxy.selfCheck(username, password, systemID, editView.ARM_ID_Input.text);
					// 初始化checkSelfCheckProxy，用来检测自检是否成功
					checkSelfCheckProxy.setSystemInfo(username, password, systemID, new Date());
					// 开始检测
					checkSelfCheckProxy.startCheck();
					break;
				// 控制台未开启
				case GetConsoleStateProxy.CONSOLE_IS_CLOSE:	
				    ApplicationFacade.consoleStarted = false;
				    Alert.show("控制台软件未开启或控制台软件串口未打开，指令无法发送！");
				    break;
				// 自检超时
				case CheckSelfCheckProxy.CHECK_SELF_CHECK_OVERTIME:
					if(editView != null) {
						editView.setState(0);
					}
					Alert.show("自检指令超时，请检查系统是否安装");
					break;
				// 正在进行自检
				case CheckSelfCheckProxy.CHECK_SELF_CHECK_FAILED:
					if(editView != null) {
						editView.setState(3);
					}
					break;
				// 自检成功返回，说明添加太阳能系统的硬件部分也已经安装
				case CheckSelfCheckProxy.CHECK_SELF_CHECK_SUCCESS:
					if(editView != null) {
						editView.setState(0);
					}
					// 判断通讯状态
					if(checkSelfCheckProxy.getData().row[0].@WirelessMaster_Normal == "0" ||
						checkSelfCheckProxy.getData().row[0].@WirelessSlave == "0" ||
						checkSelfCheckProxy.getData().row[0].@ARM == "0") {
						Alert.show("该太阳能系统的通讯异常，无法发送指令！");
					} else {
						// 发送设置密码指令
						sendOrderProxy.setSystemPassword(username, password, systemID, m_password, editView.ARM_ID_Input.text);
						// 检测设置密码指令是否执行成功
						checkPassword2Proxy.setSystemInfo(username, password, systemID, new Date());
						checkPassword2Proxy.startCheck();
						if(editView != null) {
							editView.setState(1);
						}
					}
					break;
				// 主控器密码设置成功
				case CheckPassword2Proxy.CHECK_PASSWORD2_SUCCESS:
					//Alert.show("是否要配置系统安装情况？", "提示", Alert.YES | Alert.NO, null, showSetInstall);
					if(editView != null) {
						editView.setState(0);
					}
					break;
				// 设置值和控制台的返回值不同，说明设置失败
				case CheckPassword2Proxy.CHECK_PASSWORD2_WRONG:
					if(editView != null) {
						editView.setState(0);
						editView.checkPassword(checkPassword2Proxy.realPassword);
					} else {
						Alert.show("抱歉，设置系统密码失败，您可以在太阳能系统管理中重新设置密码。");
					}
					break;
				// 设置超时
				case CheckPassword2Proxy.CHECK_PASSWORD2_OVERTIME:
					if(editView != null) {
						editView.setState(2);
					}
					Alert.show("设置密码指令超时");
					break;
			}
		}
		
	}
}
