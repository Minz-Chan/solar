// ActionScript file
package com.fallmind.solars.view.clientMediator
{
	import com.fallmind.solars.model.LoginProxy;
	import com.fallmind.solars.model.SaveCommunityInfoProxy;
	import com.fallmind.solars.model.bussiness.ConfigManager;
	import com.fallmind.solars.view.component.clientSetup.EditCommunityInfoView;
	
	import flash.events.Event;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	
	import mx.controls.Alert;
	import mx.managers.PopUpManager;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	/**
	 * 响应修改小区信息的界面的事件
	 */
	public class EditCommunityInfoMediator extends Mediator
	{
		public static const NAME:String = "EditCommunityMediator";
		private var saveCommunityInfoProxy:SaveCommunityInfoProxy;
		private var communityInfoMediator:CommunityInfoMediator;
		private var loginProxy:LoginProxy;
		private var userName:String;
		private var password:String;
		private var belongAreaID:int;
		private var communityID:int;
		private var isInsert:Boolean;
		private var communityData:XML;
		
		private var imageSelect:FileReference;
		private var nativeImageRoute:String;
		private var remoteImageRoute:String;	// 上传图片的服务器程序地址
		private var nativeImageType:String;	
		private var remoteImage:String;		// 服务器端图片的路径
		private var config:ConfigManager;
		
		private var hasBrowed:Boolean = false;
		
		private var currentCommunityName:String;
		public function EditCommunityInfoMediator(note:Object)
		{
			super(NAME, note);
			// 侦听所管理的视图类的事件
			loginProxy = LoginProxy(facade.retrieveProxy(LoginProxy.NAME));
			communityInfoMediator = CommunityInfoMediator(facade.retrieveMediator(CommunityInfoMediator.NAME));
			
			var userData:XML = loginProxy.getData() as XML;
            userName = userData.UserName;
            password = userData.UserPassword;
            
            imageSelect = new FileReference();
            imageSelect.addEventListener(Event.SELECT, userselect);
            imageSelect.addEventListener(Event.COMPLETE, completeHandler);
            
            config = ConfigManager.getManageManager();
			remoteImageRoute = config.imageUploadURL;
			remoteImage = config.imageURL;
            
			editCommunityInfoView.addEventListener(EditCommunityInfoView.SAVE_COMMUNITYINFO, saveHandle);
			editCommunityInfoView.addEventListener(EditCommunityInfoView.CLOSE_WINDOW, closeWindowHandler);
			saveCommunityInfoProxy = SaveCommunityInfoProxy(facade.retrieveProxy(SaveCommunityInfoProxy.NAME));
			editCommunityInfoView.addEventListener(EditCommunityInfoView.BROW_COMMUNITY_IMAGE, browHandler);
			editCommunityInfoView.addEventListener(EditCommunityInfoView.UPLOAD_COMMUNITY_IMAGE, uploadHandler);
		}
		private function completeHandler(e:Event):void {
			remoteImage = config.imageURL + imageSelect.name;
			editCommunityInfoView.imageField.source = remoteImage;
			//editView.imageField.source = "http://127.0.0.1/userImage/upload/blockPattern1.bmp";
		}
		private function userselect(e:Event):void {
			editCommunityInfoView.stateText = "服务器图片路径：" + config.imageURL + imageSelect.name;
		}
		private function uploadHandler(e:Event):void {
			if(hasBrowed) {
				var urlRequest:URLRequest = new URLRequest(remoteImageRoute);
				imageSelect.upload(urlRequest);
				hasBrowed = false;
			} else {
				Alert.show("请先选择图片");
				return;
			}
		}
		private function browHandler(e:Event):void {
			hasBrowed = true;
			imageSelect.browse();
		}
		public function init():void {
			editCommunityInfoView.addEventListener(EditCommunityInfoView.SAVE_COMMUNITYINFO, saveHandle);
			editCommunityInfoView.addEventListener(EditCommunityInfoView.CLOSE_WINDOW, closeWindowHandler);
			editCommunityInfoView.addEventListener(EditCommunityInfoView.BROW_COMMUNITY_IMAGE, browHandler);
			editCommunityInfoView.addEventListener(EditCommunityInfoView.UPLOAD_COMMUNITY_IMAGE, uploadHandler);
		}
		private function closeWindowHandler(e:Event):void {
			closeWindow();
		}
		private function closeWindow():void {
			hasBrowed = false;
			remoteImage = "";
			PopUpManager.removePopUp(editCommunityInfoView);
			this.setViewComponent(null);
		}
		
		/**
		 * 这里列出了该类所侦听的所有事件。只要是他关心的事件都要列在这里
		 */
		override public function listNotificationInterests():Array {
			return [ CommunityInfoMediator.EDIT_COMMUNITY,
					  CommunityInfoMediator.ADD_COMMUNITY,
					  SaveCommunityInfoProxy.COMMUNITY_NAME_EXIST
					  //SaveCommunityInfoProxy.SAVE_SOLARSYSTEM_FAILED,
					  //SaveCommunityInfoProxy.SAVE_SOLARSYSTEM_SUCCESS];
					  ];
		}
		
		/**
		 * 这里是对事件的处理,一个是编辑事件，一个是添加事件，编辑事件包含的数据是所编辑的小区的信息
		 * 添加事件包含的数据是所编辑小区所属于的区域的ID
		 */
		override public function handleNotification(notification:INotification):void {
			switch(notification.getName()) {
				case SaveCommunityInfoProxy.COMMUNITY_NAME_EXIST:
					Alert.show("抱歉，该小区名已经存在。请用其他小区名。");
					break;
				case CommunityInfoMediator.EDIT_COMMUNITY:
					//belongAreaID = int(notification.getBody().@belongAreaID);
					//communityID = int(notification.getBody().@id);
					currentCommunityName = notification.getBody().@CommunityName;
					
					communityData = notification.getBody() as XML;
					editCommunityInfoView.communityName.text = notification.getBody().@CommunityName;
					editCommunityInfoView.communityAddress.text = notification.getBody().@CommunityAddress;
					editCommunityInfoView.communityPhone.text = notification.getBody().@CommunityPhone;
					editCommunityInfoView.communityPassword.text = notification.getBody().@CommunityPassword;
					editCommunityInfoView.manageUnit.text = notification.getBody().@ManageUnit;
					editCommunityInfoView.managerPhone.text = notification.getBody().@ManagerPhone;
					editCommunityInfoView.manager.text = notification.getBody().@Manager;
					
					remoteImage = notification.getBody().@PictureRoute;
					editCommunityInfoView.imageField.source = remoteImage;
					isInsert = false;		// 标记是插入还是更新
					break;
				case CommunityInfoMediator.ADD_COMMUNITY:
					belongAreaID = notification.getBody().toString();
					communityID = 0;
					isInsert = true;
					break;
				/*case SaveCommunityInfoProxy.SAVE_SOLARSYSTEM_FAILED:	// 失败就提示
					Alert.show(notification.getBody().toString());
					break;
				case SaveCommunityInfoProxy.SAVE_SOLARSYSTEM_SUCCESS:	// 成功就刷新
					Alert.show("保存成功");
					loginProxy.login(userName, password);		// 再登陆一次，重新取得所有数据
					break;*/
			}
		}
		protected function get editCommunityInfoView():EditCommunityInfoView {
			return viewComponent as EditCommunityInfoView;
		}
		
		private function saveHandle(e:Event):void {
			var communityInfo:Object = new Object();
			var xml:XML = loginProxy.getData() as XML;
			var userName:String = xml.UserName;
			var userID:String = xml.UserID;
			var userTypeID:String = xml.UserTypeID;
			if( editCommunityInfoView.communityName.text == "" || editCommunityInfoView.communityPassword.text == "") {
				Alert.show("用户名和密码不允许为空");
				return;
			}
			if(isInsert) {
				for each(var item:XML in communityInfoMediator.communityInfoView.communityData) {
					if(item.@CommunityName == editCommunityInfoView.communityName.text) {
						Alert.show("小区已经在列表中");
						return;
					}
				}
			} else {
				var count:int = 0;
				if(currentCommunityName != editCommunityInfoView.communityName.text) {
					for each(var item:XML in communityInfoMediator.communityInfoView.communityData) {
						if(item.@CommunityName == editCommunityInfoView.communityName.text) {
							Alert.show("小区已经在列表中");
							return;
						}
					}
				}
			}
			if( isInsert ) {
				communityInfo = {
					userID : userID,
					userTypeID : userTypeID,
					communityID : 0,
					belongAreaID : belongAreaID.toString(),
					communityName : editCommunityInfoView.communityName.text == "" ? " " : editCommunityInfoView.communityName.text,
					communityPassword : editCommunityInfoView.communityPassword.text == " " ? null : editCommunityInfoView.communityPassword.text,
					communityAddress : editCommunityInfoView.communityAddress.text == " " ? null : editCommunityInfoView.communityAddress.text,
					communityPhone : editCommunityInfoView.communityPhone.text == " " ? null : editCommunityInfoView.communityPhone.text,
					manageUnit : editCommunityInfoView.manageUnit.text == " " ? null : editCommunityInfoView.manageUnit.text,
					managerPhone : editCommunityInfoView.managerPhone.text == " " ? null : editCommunityInfoView.managerPhone.text,
					manager : editCommunityInfoView.manager.text == " " ? null : editCommunityInfoView.manager.text,
					pictureRoute : remoteImage
				};
				
				saveCommunityInfoProxy.insertCommunityInfo(userName, password, communityInfo);
			} else {
				communityInfo = {
					userID : userID,
					userTypeID : userTypeID,
					communityID : communityData.@CommunityID,
					belongAreaID : communityData.@BelongAreaID,
					communityName : editCommunityInfoView.communityName.text,
					communityPassword : editCommunityInfoView.communityPassword.text,
					communityAddress : editCommunityInfoView.communityAddress.text,
					communityPhone : editCommunityInfoView.communityPhone.text,
					manageUnit : editCommunityInfoView.manageUnit.text,
					managerPhone : editCommunityInfoView.managerPhone.text,
					manager : editCommunityInfoView.manager.text,
					//manager : null,
					pictureRoute : remoteImage
				};
				saveCommunityInfoProxy.updateCommunityInfo(userName, password, communityInfo);
			}
			
		}
	}
}