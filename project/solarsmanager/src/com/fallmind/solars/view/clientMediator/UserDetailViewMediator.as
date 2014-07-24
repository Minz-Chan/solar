package com.fallmind.solars.view.clientMediator
{
	import com.fallmind.solars.ApplicationFacade;
	import com.fallmind.solars.model.GetUserInfoProxy;
	import com.fallmind.solars.model.LoginProxy;
	import com.fallmind.solars.model.SaveUserDetailProxy;
	import com.fallmind.solars.model.bussiness.ConfigManager;
	import com.fallmind.solars.view.component.clientSetup.EditUserInfoView;
	import com.fallmind.solars.view.component.clientSetup.UserDetailView;
	
	import flash.events.Event;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	
	import mx.collections.ArrayCollection;
	import mx.containers.TitleWindow;
	import mx.controls.Alert;
	import mx.managers.PopUpManager;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	/**
	 * 登录模块的视图管理类，接受用户登录事件，交给model层去处理
	 */
	public class UserDetailViewMediator extends Mediator
	{
		public static const NAME:String = "UserDetailMediator";
		public static const GET_USER_DETAIL:String = "GetUserDetail";
		public static const SAVE_USER_DETAIL:String = "SaveUserDetail";
		public static const SAVE_USER_DETAIL_RETURN:String = "SaveUserDetailReturn";
		
		//public var selectedCommunity:Array;
		private var loginProxy:LoginProxy;
		private var userID:int;
		
		private var isCurrentUser:Boolean = false;// 判断选择用户是否为当前用户
		private var userTypeArray:Array = [
			"超级管理员",
			"企业管理员",
			"小区管理员",
			"政府用户",
			"普通操作员"
		];
		private var firstCreateWindow:Boolean = true;
		private var saveUserDetailProxy:SaveUserDetailProxy;
		private var userName:String;
		private var password:String;
		private var isAddUser:Boolean = false;
		
		private var imageSelect:FileReference;
		private var nativeImageRoute:String;
		private var remoteImageRoute:String;	// 上传图片的服务器程序地址
		private var nativeImageType:String;	
		private var remoteImage:String;		// 服务器端图片的路径
		
		private var hasBrowed:Boolean = false;
		private var config:ConfigManager;
		
		public function UserDetailViewMediator(note:Object)
		{
			super(NAME, note);
			// 侦听所管理的视图类的事件
			//selectedCommunity.push(new CommunityData());
			loginProxy = LoginProxy(facade.retrieveProxy(LoginProxy.NAME));
			userName = loginProxy.getData().UserName;
			password = loginProxy.getData().UserPassword;
			//solarInfoProxy = SolarInfoProxy(facade.retrieveProxy(SolarInfoProxy.NAME));
			saveUserDetailProxy = SaveUserDetailProxy(facade.retrieveProxy(SaveUserDetailProxy.NAME));
			
			config = ConfigManager.getManageManager();
			remoteImageRoute = config.imageUploadURL;
			remoteImage = config.imageURL;
			
			imageSelect = new FileReference();
			imageSelect.addEventListener(Event.SELECT, userselect);
			imageSelect.addEventListener(Event.COMPLETE, completeHandler);
			
			
			userDetailView.addEventListener(UserDetailView.ADD_COMMUNITY_OF_USER, addCommunityOfUser);
			userDetailView.addEventListener(UserDetailView.DELETE_COMMUNITY_OF_USER, deleteCommunityOfUser);
			userDetailView.addEventListener(UserDetailView.SAVE_USER_DETAIL, saveHandler);
			userDetailView.addEventListener(UserDetailView.CLOSE_USER_DETAIL_VIEW, closeWindowHandler);
			userDetailView.userTypeBox.dataProvider = userTypeArray;
			
			userDetailView.addEventListener(UserDetailView.BROW_USER_IMAGE, browImageHandler);
			userDetailView.addEventListener(UserDetailView.UPLOAD_USER_IMAGE, uploadImageHandler);
		}
		private function completeHandler(e:Event):void {
			remoteImage = config.imageURL + imageSelect.name;
			userDetailView.imageField.source = remoteImage;
			//editView.imageField.source = "http://127.0.0.1/userImage/upload/blockPattern1.bmp";
		}
		private function userselect(e:Event):void {
			userDetailView.stateText = "服务器图片路径：" + config.imageURL + imageSelect.name;
		}
		private function uploadImageHandler(e:Event):void {
			if(hasBrowed) {
				var urlRequest:URLRequest = new URLRequest(remoteImageRoute);
				imageSelect.upload(urlRequest);
				hasBrowed = false;
			} else {
				Alert.show("请先选择图片");
				return;
			}
		}
		private function browImageHandler(e:Event):void {
			hasBrowed = true;
			imageSelect.browse();
		}
		private function closeWindowHandler(e:Event):void {
			closeWindow();
		}
		private function closeWindow():void {
			hasBrowed = false;
			remoteImage = "";
			PopUpManager.removePopUp(userDetailView);
			this.setViewComponent(null);
		}
		public function init():void {
			userDetailView.addEventListener(UserDetailView.ADD_COMMUNITY_OF_USER, addCommunityOfUser);
			userDetailView.addEventListener(UserDetailView.DELETE_COMMUNITY_OF_USER, deleteCommunityOfUser);
			userDetailView.userTypeBox.dataProvider = userTypeArray;
			userDetailView.addEventListener(UserDetailView.SAVE_USER_DETAIL, saveHandler);
			userDetailView.addEventListener(UserDetailView.CLOSE_USER_DETAIL_VIEW, closeWindowHandler);
			
			userDetailView.addEventListener(UserDetailView.BROW_USER_IMAGE, browImageHandler);
			userDetailView.addEventListener(UserDetailView.UPLOAD_USER_IMAGE, uploadImageHandler);
			
			isCurrentUser = false;
		}
		
		private function saveHandler(e:Event):void {
			var userDetailData:UserDetailData = new UserDetailData();
			userDetailData.userID = userID.toString();
			userDetailData.userName = userDetailView.userNameInput.text.toString();
			userDetailData.userPassword = userDetailView.userPasswordInput.text.toString();
			userDetailData.userPhone = userDetailView.userPhoneInput.text.toString();
			userDetailData.userPictureRoute = remoteImage;
			
			if(isCurrentUser) {
				loginProxy.setUserName(userDetailData.userName);
				loginProxy.setUserPassword(userDetailData.userPassword);
			}
			
			// 判断是否有权限设置用户类型
			var userTypeID:int = userDetailView.userTypeBox.selectedIndex + 1;
			if(userTypeID <= loginProxy.getData().UserTypeID && userID != loginProxy.getData().UserID) {
				Alert.show("没有权限设置这个用户类型");
				return;
			}
			
			userDetailData.userTypeID = (userDetailView.userTypeBox.selectedIndex + 1).toString();
			var communityArray:ArrayCollection = new ArrayCollection;
			for each(var cd:CommunityData in userDetailView.selectedCommunity) {
				var obj:Object = new Object();
				obj = {
					communityID : cd.id.toString(),
					rightID : cd.rightID.toString() 
				};
				communityArray.addItem(obj);
			}
			saveUserDetailProxy.saveUserDetail(userName, password, userDetailData, communityArray);
			//saveUserDetailProxy.saveUserDetail(userName, password, userDetailData, communityArray);
			
		
			//remoteImageRoute = "";  // 把上传的路径置空
		}
		
		private function createWin(className:Class):void {
			var u:TitleWindow = className(PopUpManager.createPopUp(userDetailView.parent, className, true));
			PopUpManager.centerPopUp(u);
			if(firstCreateWindow) {
				facade.registerMediator(new EditUserInfoMediator(u));
				firstCreateWindow = false;
			} else {
				var temp:EditUserInfoMediator = facade.retrieveMediator(EditUserInfoMediator.NAME) as EditUserInfoMediator;
				temp.setViewComponent(u); 
				temp.init();
			}
		}
		private function addCommunityOfUser(e:Event):void {
			createWin(EditUserInfoView);
			sendNotification(ApplicationFacade.ADD_COMMUNITY_OF_USER, userDetailView.userTypeBox.selectedIndex + 1);
		}
		private function deleteCommunityOfUser(e:Event):void {
			for(var i:int = 0; i < userDetailView.selectedCommunity.length; i++) {
				if( userDetailView.selectedCommunity[i].id == userDetailView.selectedCommunityDataGrid.selectedItem.id) {
					userDetailView.selectedCommunity.splice(i,1);
				}
			}
			userDetailView.selectedCommunityDataGrid.invalidateList();
		}
		/**
		 * 这里列出了该类所侦听的所有事件。只要是他关心的事件都要列在这里
		 */
		override public function listNotificationInterests():Array {
			return [ 
						UserInfoViewMediator.ADD_USER,
						GetUserInfoProxy.LOAD_USERINFO_SUCCESS,
						GetUserInfoProxy.LOAD_USERINFO_FAILED,
						EditUserInfoMediator.ADD_COMMUNITY_OF_USER_RETURN,
						SaveUserDetailProxy.SAVE_USER_DETAIL_FAILED,
						SaveUserDetailProxy.SAVE_USER_DETAIL_SUCCESS
			 		];
		}
		
		/**
		 * 这里是对事件的处理
		 */
		override public function handleNotification(note:INotification):void {
			switch(note.getName()) {
				case GetUserInfoProxy.LOAD_USERINFO_SUCCESS:
					var xml:XML = note.getBody() as XML;
					userID = int(note.getBody().UserID);
					userDetailView.userNameInput.text = note.getBody().UserName;
					userDetailView.userPhoneInput.text = note.getBody().UserPhone;
					userDetailView.userPasswordInput.text = note.getBody().UserPassword;
					userDetailView.confirmUserPasswordInput.text = note.getBody().UserPassword;
					userDetailView.userTypeBox.selectedIndex = int(note.getBody().UserTypeID) - 1;
					userDetailView.selectedCommunity = switchXML2Array(note.getBody().Area);
					
					remoteImage = note.getBody().UserPictureRoute;
					userDetailView.imageField.source = remoteImage;
					
					if(loginProxy.getUserName() == note.getBody().UserName) {
						isCurrentUser = true;
					} else {
						isCurrentUser = false;
					}
					break;
				case GetUserInfoProxy.LOAD_USERINFO_FAILED:
					Alert.show("载入用户信息错误");
					break;
				case UserInfoViewMediator.ADD_USER:
					isAddUser = true;
					userID = 0;		// 如果是添加用户，把用户ID设为0
					break;
				case EditUserInfoMediator.ADD_COMMUNITY_OF_USER_RETURN:
					for each(var c:CommunityData in note.getBody()) {
						var exist:Boolean = false;
						for each(var sc:CommunityData in userDetailView.selectedCommunity) {
							if(sc.id == c.id ) {
								exist = true;
								sc.rightID = c.rightID;
								if(sc.rightID == 1) {
									sc.right = "基本查询";
								} else if(sc.rightID == 2) {
									sc.right = "主控操作";
								} else if(sc.rightID == 3) {
									sc.right = "厂家权限";
								}
								break;
							}
						}
						if(!exist) {
							userDetailView.selectedCommunity.push(c);
						}
					}
					userDetailView.selectedCommunityDataGrid.invalidateList();
					break;
				case SaveUserDetailProxy.SAVE_USER_DETAIL_FAILED:
					Alert.show(note.getBody().toString());
					break;
				case SaveUserDetailProxy.SAVE_USER_DETAIL_SUCCESS:
					sendNotification(SAVE_USER_DETAIL_RETURN, userDetailView.selectedCommunity[0]);
					closeWindow();
					break;
			}
		}
		protected function get userDetailView():UserDetailView {
			return viewComponent as UserDetailView;
		}
		private function switchXML2Array(source:XMLList):Array {
			var array:Array = new Array();
			var areaList:Array = new Array();
			for each(var country:XML in source.Area) {
				areaList.push(country.@name);
				if(country.Area != null) {
					for each(var province:XML in country.Area) {
						areaList.push(province.@name);
						if(province.Area != null) {
							if(province.@typeID == "4") {
								if(province.CommunityInfo != null) {
									for each(var community:XML in province.CommunityInfo) {
										var data:CommunityData = new CommunityData();
										data.community = community.@name;
										data.right = community.@CommunityRight;
										data.id = int(community.@id);
										data.highestRightID = int(community.@userRightID);
										data.rightID = int(community.@userRightID);
										data.country = areaList[0].toString();
										data.province = areaList[1].toString();
										data.city = areaList[1].toString();
										
										array.push(data);
									}
									
								}
								areaList.pop();
							}
							else {
								for each(var city:XML in province.Area) {
									areaList.push(city.@name);
									if(city.CommunityInfo != null) {
										for each(var community:XML in city.CommunityInfo) {
											var data:CommunityData = new CommunityData();
											data.community = community.@name;
											data.right = community.@CommunityRight;
											data.id = int(community.@id);
											data.rightID = int(community.@userRightID);
											data.highestRightID = int(community.@userRightID);
											data.country = areaList[0].toString();
											data.province = areaList[1].toString();
											data.city = areaList[2].toString();
											array.push(data);
										}
									}
									areaList.pop();
								}
							}
						}
						areaList.pop();
					}
				}
				areaList.pop();
			}
			return array;
		}
	}
}
	