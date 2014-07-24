package com.fallmind.solars.view.clientMediator
{
	import com.fallmind.solars.model.EditSolarSystemProxy;
	import com.fallmind.solars.model.LoginProxy;
	import com.fallmind.solars.model.SolarInfoProxy;
	import com.fallmind.solars.model.bussiness.ConfigManager;
	import com.fallmind.solars.view.component.clientSetup.EditSolarSystemView;
	
	import flash.events.Event;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	
	import mx.controls.Alert;
	import mx.managers.PopUpManager;
	
	import org.puremvc.as3.patterns.mediator.Mediator;


	public class EditSolarSystemViewMediator extends Mediator
	{
		public static const NAME:String = "EditSolarSystemViewMediator";
		private var editProxy:EditSolarSystemProxy;
		private var loginProxy:LoginProxy;
		private var solarInfo:SolarInfoProxy;
				// 图片上传有关变量
		private var imageSelect:FileReference;
		private var nativeImageRoute:String;
		private var remoteImageRoute:String;	
		private var nativeImageType:String;	
		private var remoteImage:String;		
		
		private var belCommunityID:String;
		
		private var systemID:String;
		
		private var username:String;	// 用户名
		private var password:String;	// 密码
		
		private var config:ConfigManager;	// 配置表
		private var hasBrowed:Boolean = false; //标记是否已经加载文件路径，也就是是否按过浏览按钮 
		
		private var lastSolarSystemName:String;
		private var lastARM_ID:String;
		public function EditSolarSystemViewMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			loginProxy = LoginProxy(facade.retrieveProxy(LoginProxy.NAME));		// 获取程序所需proxy
			editProxy = EditSolarSystemProxy(facade.retrieveProxy(EditSolarSystemProxy.NAME));
			solarInfo = SolarInfoProxy(facade.retrieveProxy(SolarInfoProxy.NAME));
			
			username = loginProxy.getUserName();	// 获取用户名和密码
			password = loginProxy.getUserPassword();
			
			config = ConfigManager.getManageManager();	// 获取配置表
			remoteImageRoute = config.imageUploadURL;	// 获取图片上传参数
			remoteImage = config.imageURL;
			
			imageSelect = new FileReference();
			imageSelect.addEventListener(Event.SELECT, userselect);
			imageSelect.addEventListener(Event.COMPLETE, completeHandler);
			
			editView.addEventListener(EditSolarSystemView.CLOSE_SOLARSYSTEM_VIEW2, closeHandler);
			editView.addEventListener(EditSolarSystemView.SAVE_SOLARSYSTEM2, saveHandler);
			editView.addEventListener(EditSolarSystemView.BROW_IMAGE2, browImageHandler);
			editView.addEventListener(EditSolarSystemView.UPLOAD_IMAGE2, uploadImageHandler);
		}
		
		public function init():void {
			editView.addEventListener(EditSolarSystemView.CLOSE_SOLARSYSTEM_VIEW2, closeHandler);
			editView.addEventListener(EditSolarSystemView.SAVE_SOLARSYSTEM2, saveHandler);
			editView.addEventListener(EditSolarSystemView.BROW_IMAGE2, browImageHandler);
			editView.addEventListener(EditSolarSystemView.UPLOAD_IMAGE2, uploadImageHandler);
		}
		public function setSystemData(data:XML):void {
			lastSolarSystemName = data.@System_Name;
			lastARM_ID = data.@ARM_ID;
			belCommunityID = data.@BelCommunityID;
			systemID = data.@System_ID;
			remoteImage = data.@SysPictureRoute;
			editView.setData(data);
		}
		public function get editView():EditSolarSystemView {
			return viewComponent as EditSolarSystemView;
		}
		
		private function browImageHandler(e:Event):void {
			hasBrowed = true;
			imageSelect.browse();
		}
		private function closeHandler(e:Event):void {
			closeWindow();	
		}
		
		private function closeWindow():void {
			hasBrowed = false;
			remoteImage = "";
			PopUpManager.removePopUp(editView);
			this.setViewComponent(null);
		}
		private function uploadImageHandler(e:Event):void {
			if(hasBrowed) {
				var urlRequest:URLRequest = new URLRequest(remoteImageRoute);
				imageSelect.upload(urlRequest);
			} else {
				Alert.show("请先选择图片");
				return;
			}
		}
		private function completeHandler(e:Event):void {
			remoteImage = config.imageURL + imageSelect.name;
			editView.imageField.source = remoteImage;
			
			editView.imageField.addEventListener(Event.COMPLETE, updateComplete);
		}
		private function updateComplete(e:Event):void {
			editView.imageField.width = 240;
			editView.imageField.height = 133;
			editView.imageField.content.width = 240;
			editView.imageField.content.height = 133;
		}
		private function userselect(e:Event):void {
			editView.stateText = "图片在服务器上的路径：" + config.imageURL + imageSelect.name;
		}
		private function saveHandler(e:Event):void {
			for each(var item:XML in solarInfo.getData().row.(@BelCommunityID==belCommunityID)) {
				if(item.@System_Name == editView.systemNameInput.text && editView.systemNameInput.text != lastSolarSystemName) {
					Alert.show("系统名已存在");
					return;
				}
				if(item.@ARM_ID == editView.ARM_ID_Input.text && editView.ARM_ID_Input.text != lastARM_ID) {
					Alert.show("主控器ID已存在");
					return;
				}
			}
			editProxy.editSolarSystem(username, password, systemID, editView.systemNameInput.text, editView.managerInput.text,
				editView.managerPhoneInput.text, editView.ARM_ID_Input.text, editView.setupTime, remoteImage);
		}
		
		
	}
}