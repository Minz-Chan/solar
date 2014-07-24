package com.fallmind.solars.view.clientMediator
{
	import com.fallmind.solars.ApplicationFacade;
	import com.fallmind.solars.model.AllUserInfoProxy;
	import com.fallmind.solars.model.DeleteUserProxy;
	import com.fallmind.solars.model.LoginProxy;
	import com.fallmind.solars.view.component.clientSetup.UserDetailView;
	import com.fallmind.solars.view.component.clientSetup.UserInfoManageView;
	
	import flash.events.Event;
	
	import mx.containers.TitleWindow;
	import mx.controls.Alert;
	import mx.managers.PopUpManager;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	/**
	 * 登录模块的视图管理类，接受用户登录事件，交给model层去处理
	 */
	public class UserInfoViewMediator extends Mediator
	{
		public static const NAME:String = "UserInfoMediator";
		public static const ADD_USER:String = "AddUser";
		public static const SHOW_USER_DETAIL:String = "ShowUserDetail";
		public static const DELETE_USER:String = "DeleteUser";
		public static const GET_USER_INFO:String = "GetUserInfo";
		private var deleteUserProxy:DeleteUserProxy;
		private var loginProxy:LoginProxy;
		private var allUserInfoProxy:AllUserInfoProxy;
		private var currentUserInfo:XML;
		private var allUserInfo:XML;
		private var firstCreateWindow:Boolean = true;
		private var userName:String;
		private var password:String;
		
		private var lastUserBelong:CommunityData = null;
		
		private var lastCountrySelectIndex:int = 0;
		private var lastProvinceSelectIndex:int = 0;
		private var lastCitySelectIndex:int = 0;
		private var lastCommunitySelectIndex:int = 0;
		
		public function UserInfoViewMediator(note:Object)
		{
			super(NAME, note);
			// 侦听所管理的视图类的事件
			
			loginProxy = LoginProxy(facade.retrieveProxy(LoginProxy.NAME));
			
			allUserInfoProxy = AllUserInfoProxy(facade.retrieveProxy(AllUserInfoProxy.NAME));
			deleteUserProxy = DeleteUserProxy(facade.retrieveProxy(DeleteUserProxy.NAME));
			
			userInfoView.addEventListener(UserInfoManageView.ADD_USER, addUser);
			userInfoView.addEventListener(UserInfoManageView.DELETE_USER, deleteUser);
			userInfoView.addEventListener(UserInfoManageView.SHOW_USER_DETAIL, showUserDetail);
			userInfoView.addEventListener(UserInfoManageView.SHOW_ALL_USERS, showAllUsersHandler);
		}
		private function showAllUsersHandler(e:Event):void {
			showAllUsers();
		}
		private function showAllUsers():void {
			var userList:XMLList = allUserInfo.row;
			var userExist:Boolean = false;
			var temp:XML = new XML("<root></root>");
			for each(var item:XML in userList) {
				for each(var item2:XML in temp.children()) {
					if(item.@UserName == item2.@UserName) {
						userExist = true;
					}
				}
				if(!userExist) {
					temp.appendChild(item);
				}
				userExist = false;
			}
			userInfoView.allUserInfoData = temp.children();
		}
		private function createWin():void {
			var u:TitleWindow = UserDetailView(PopUpManager.createPopUp(userInfoView.parent.parent.parent.parent.parent, UserDetailView, true));
			//u.x = userInfoView.stage.width / 2 - u.width / 2;
			//u.y = userInfoView.stage.height / 2 - u.height / 2;
			PopUpManager.centerPopUp(u);
			if( firstCreateWindow) {
				facade.registerMediator(new UserDetailViewMediator(u));
				firstCreateWindow = false;
			} else {
				var temp:UserDetailViewMediator = facade.retrieveMediator(UserDetailViewMediator.NAME) as UserDetailViewMediator;
				temp.setViewComponent(u); 
				temp.init();
			}
		}
		private function showUserDetail(e:Event):void {
			lastCountrySelectIndex = userInfoView.countryBox.selectedIndex;
			lastProvinceSelectIndex = userInfoView.provinceBox.selectedIndex;
			lastCitySelectIndex = userInfoView.cityBox.selectedIndex;
			lastCommunitySelectIndex = userInfoView.communityBox.selectedIndex;
			
			createWin();
			//var d:String = userInfoView.userInfoDataGrid.selectedItem.@UserID;
			this.sendNotification(ApplicationFacade.GET_USER_INFO, userInfoView.userInfoDataGrid.selectedItem.@UserID);
			
			//trace(userInfoView.userInfoDataGrid.selectedItem.@UserID);
		}
		private function addUser(e:Event):void {
			createWin();
			this.sendNotification(ADD_USER);
		}
		private function deleteUser(e:Event):void {
			lastCountrySelectIndex = userInfoView.countryBox.selectedIndex;
			lastProvinceSelectIndex = userInfoView.provinceBox.selectedIndex;
			lastCitySelectIndex = userInfoView.cityBox.selectedIndex;
			lastCommunitySelectIndex = userInfoView.communityBox.selectedIndex;
			
			deleteUserProxy.deleteCommunityInfo(userName, password, userInfoView.userInfoDataGrid.selectedItem.@UserID);
		}
		/**
		 * 这里列出了该类所侦听的所有事件。只要是他关心的事件都要列在这里
		 */
		override public function listNotificationInterests():Array {
			return [ 
					  LoginProxy.LOGIN_SUCCESS,
					  AllUserInfoProxy.LOAD_ALLUSER_SUCCESS,
					  DeleteUserProxy.DELETE_USER_SUCCESS,
					  DeleteUserProxy.DELETE_USER_FAILED,
					  UserDetailViewMediator.SAVE_USER_DETAIL_RETURN
			 		];
		}
		
		/**
		 * 这里是对事件的处理
		 */
		override public function handleNotification(notification:INotification):void {
			switch(notification.getName()) {
				case LoginProxy.LOGIN_SUCCESS:
					userName = loginProxy.getData().UserName;
					password = loginProxy.getData().UserPassword;
					
					currentUserInfo = XML(loginProxy.getData());
					if(!currentUserInfo.Area.hasComplexContent()) {
						break;
					}
					/*if(currentUserInfo.Area.hasComplexContent()) {
						userInfoView.countryButtonData = currentUserInfo.Area.Area;
						userInfoView.provinceButtonData = currentUserInfo.Area.Area[0].Area;
						userInfoView.cityButtonData = currentUserInfo.Area.Area[0].Area[0].Area;
						userInfoView.communityButtonData = userInfoView.cityButtonData[0].CommunityInfo;
					}*/
					
					if(lastUserBelong != null) {
						userInfoView.countryButtonData = currentUserInfo.Area.Area;
						for(var i:int = 0; i < userInfoView.countryButtonData.length(); i++) {
							if(userInfoView.countryButtonData[i].@name == lastUserBelong.country) {
								userInfoView.countryBox.selectedIndex = i;
								break;
							}
						}
						userInfoView.provinceButtonData = userInfoView.countryBox.selectedItem.Area;
						for(var i:int = 0; i < userInfoView.provinceButtonData.length(); i++) {
							if(userInfoView.provinceButtonData[i].@name == lastUserBelong.province) {
								userInfoView.provinceBox.selectedIndex = i;
							}
						}
						userInfoView.cityButtonData = userInfoView.provinceBox.selectedItem.Area;
						for(var i:int = 0; i < userInfoView.cityButtonData.length(); i++) {
							if(userInfoView.cityButtonData[i].@name == lastUserBelong.city) {
								userInfoView.cityBox.selectedIndex = i;
							}
						}
						userInfoView.communityButtonData = userInfoView.cityBox.selectedItem.CommunityInfo;
						for(var i:int = 0; i < userInfoView.communityButtonData.length(); i++) {
							if(userInfoView.communityButtonData[i].@name == lastUserBelong.community) {
								userInfoView.communityBox.selectedIndex = i;
							}
						}
						lastUserBelong = null;
					} else {
						userInfoView.countryButtonData = currentUserInfo.Area.Area;
						userInfoView.countryBox.selectedIndex = lastCountrySelectIndex;
						
						userInfoView.provinceButtonData = userInfoView.countryBox.selectedItem.Area;
						userInfoView.provinceBox.selectedIndex = lastProvinceSelectIndex;
						
						userInfoView.cityButtonData = userInfoView.provinceBox.selectedItem.Area;
						userInfoView.cityBox.selectedIndex = lastCitySelectIndex;
						
						userInfoView.communityButtonData = userInfoView.cityBox.selectedItem.CommunityInfo;
						userInfoView.communityBox.selectedIndex = lastCommunitySelectIndex;
					}
					break;
				case AllUserInfoProxy.LOAD_ALLUSER_SUCCESS:
					allUserInfo = XML(allUserInfoProxy.getData());
					
					userInfoView.totalUserInfo = allUserInfo.row;
					//trace(allUserInfo.UserInfo);
					userInfoView.allUserInfoData = userInfoView.totalUserInfo.(@CommunityID==userInfoView.communityBox.selectedItem.@id);
					
					//userInfoView.allUserInfoData = userInfoView.totalUserInfo;
					//showAllUsers();
					break;
				case DeleteUserProxy.DELETE_USER_SUCCESS:
					//loginProxy.login(userName, password);
					loginProxy.refresh();
					break;
				case DeleteUserProxy.DELETE_USER_FAILED:
					Alert.show("删除失败");
					break;
				case UserDetailViewMediator.SAVE_USER_DETAIL_RETURN:
					lastUserBelong = notification.getBody() as CommunityData;
					//loginProxy.login(userName, password);
					loginProxy.refresh();
					break;
			}
		}
		protected function get userInfoView():UserInfoManageView {
			return viewComponent as UserInfoManageView;
		}
	}
}