package com.fallmind.solars.view
{
	import com.fallmind.solars.ApplicationFacade;
	import com.fallmind.solars.model.CurrentDataProxy;
	import com.fallmind.solars.model.GetUserDetailProxy;
	import com.fallmind.solars.model.GetWeatherProxy;
	import com.fallmind.solars.model.LoginProxy;
	import com.fallmind.solars.view.component.MenuBarView;
	
	import flash.events.Event;
	
	import mx.controls.LinkButton;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class MenuMediator extends Mediator
	{
		public static const NAME:String = "menuMediator";
		private var loginProxy:LoginProxy;
		private var currentDataProxy:CurrentDataProxy;
		
		private var anotherLoginProxy:GetUserDetailProxy;
		
		private var getWeatherProxy:GetWeatherProxy;
		
		public function MenuMediator(note:Object)
		{
			super(NAME, note);
			loginProxy = LoginProxy(facade.retrieveProxy(LoginProxy.NAME));
			
			currentDataProxy = CurrentDataProxy(facade.retrieveProxy(CurrentDataProxy.NAME));
			anotherLoginProxy = GetUserDetailProxy(facade.retrieveProxy(GetUserDetailProxy.NAME));
			getWeatherProxy = GetWeatherProxy(facade.retrieveProxy(GetWeatherProxy.NAME));
			
			menuView.addEventListener(MenuBarView.CHANGE_INFO_VIEW, stopGetSystemData);
			menuView.addEventListener(MenuBarView.CHANGE_SYSTEM_VIEW, startGetSystemData);
			menuView.addEventListener(MenuBarView.RELOAD_DATA, reloadDataHandler);
		}
		private function reloadDataHandler(e:Event):void {
			loginProxy.login(loginProxy.getUserName(), loginProxy.getUserPassword());
		}
		override public function listNotificationInterests():Array {
			return [
				LoginProxy.LOGIN_SUCCESS,
				ApplicationFacade.APP_LOGOUT,
				GetUserDetailProxy.GET_USER_DETAIL_SUCCESS
				//ApplicationFacade.SHOW_MANAGEVIEW
			];
		}
		override public function handleNotification(notification:INotification):void {
			switch(notification.getName()) {
				case GetUserDetailProxy.GET_USER_DETAIL_SUCCESS:
					//menuView.treeData = loginProxy.getAreaInfo();
					menuView.treeData = anotherLoginProxy.getData().Area;
					if(anotherLoginProxy.getData().UserTypeID == "3" || anotherLoginProxy.getData().UserTypeID == "4" || anotherLoginProxy.getData().UserTypeID == "5") {
						//menuView.linkBarMenu.selectedIndex = 2;
						//menuView.infoManageViewStack.selectedIndex = 0;
						LinkButton(menuView.linkBarMenu.getChildAt(2)).enabled = false;
						LinkButton(menuView.linkBarMenu.getChildAt(3)).enabled = false;
					}
					break;
				case ApplicationFacade.APP_LOGOUT:
					currentDataProxy.stopQuery();
					break;
			}
		}
		protected function get menuView():MenuBarView {
			return viewComponent as MenuBarView;
		}
		
		private function startGetSystemData(e:Event):void {
			sendNotification(ApplicationFacade.CLEAR_CURRENT_DATA_VIEW);
			sendNotification(ApplicationFacade.DISABLE_SYSTEM_MENU);
			sendNotification(ApplicationFacade.CHANGE_SYSTEM, menuView.areaTree.selectedItem.@System_ID);
			
			ApplicationFacade.getCurrentData = 0;
			currentDataProxy.setSystemID(menuView.areaTree.selectedItem.@System_ID);
			currentDataProxy.startQuery();
			
			getWeatherProxy.getWeather(menuView.areaTree.selectedItem.@BelongCityName);
			
		}
		private function stopGetSystemData(e:Event):void {
			currentDataProxy.stopQuery();
			sendNotification(ApplicationFacade.CLEAR_STATUS_BAR);
		}
	}
}