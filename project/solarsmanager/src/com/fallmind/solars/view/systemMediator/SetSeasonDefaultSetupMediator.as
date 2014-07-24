package com.fallmind.solars.view.systemMediator
{
	import com.fallmind.solars.ApplicationFacade;
	import com.fallmind.solars.model.CheckProxy.CheckSeasonSetupProxy;
	import com.fallmind.solars.model.CheckProxy.SeasonData;
	import com.fallmind.solars.model.CurrentDataProxy;
	import com.fallmind.solars.model.LoginProxy;
	import com.fallmind.solars.model.SeasonDefaultSetupProxy;
	import com.fallmind.solars.model.SendOrderProxy;
	import com.fallmind.solars.view.component.solarSystem.SeasonDefaultSetupView;
	
	import flash.events.Event;
	
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	import mx.managers.PopUpManager;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class SetSeasonDefaultSetupMediator extends Mediator
	{
		public static const NAME:String = "SetSeasonDefaultSetupMediator";
		public static const CHECK_GET_SEASON_SETUP:String = "CheckGetSeasonSetup";
		public static const CHECK_SET_SEASON_SETUP:String = "CheckSetSeasonSetup";
		private var loginProxy:LoginProxy;
		private var currentDataProxy:CurrentDataProxy;
		
		private var seasonDefaultSetupProxy:SeasonDefaultSetupProxy;

		
		private var sendOrderProxy:SendOrderProxy;
		
		private var firstDisplayData:Boolean = true;
		
		private var lastOperation:int = 0;
		private var SEARCH:int = 0;
		private var SAVE:int = 1;
		
		private var checkSeasonSetupProxy:CheckSeasonSetupProxy;
		public function SetSeasonDefaultSetupMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);
			loginProxy = LoginProxy(facade.retrieveProxy(LoginProxy.NAME));
			currentDataProxy = CurrentDataProxy(facade.retrieveProxy(CurrentDataProxy.NAME));
			seasonDefaultSetupProxy = SeasonDefaultSetupProxy(facade.retrieveProxy(SeasonDefaultSetupProxy.NAME));
			
			sendOrderProxy = SendOrderProxy(facade.retrieveProxy(SendOrderProxy.NAME));
			checkSeasonSetupProxy = CheckSeasonSetupProxy(facade.retrieveProxy(CheckSeasonSetupProxy.NAME));
		
			
			seasonDefaultSetupView.addEventListener(SeasonDefaultSetupView.CLOSE_SEASON_DEFAULT_SETUP_VIEW, closeWindow);
			seasonDefaultSetupView.addEventListener(SeasonDefaultSetupView.SAVE_SEASON_DEFAULT_SETUP, saveHandler);
			seasonDefaultSetupView.addEventListener(SeasonDefaultSetupView.SHOW_SEASON_SETUP, showSeasonSetup);
			
			seasonDefaultSetupView.setState(0);
			// 隐藏查询按钮
			seasonDefaultSetupView.searchButton.visible = false;
		}
		// 第一次弹出窗口就执行构造函数，如果不是第一次，就执行init函数
		private function showSeasonSetup(e:Event):void {
			// 隐藏查询按钮
			seasonDefaultSetupView.searchButton.visible = false;
			
			lastOperation = SEARCH;
			seasonDefaultSetupView.setState(0);
			sendOrderProxy.getSeasonDefaultSetup(loginProxy.getData().UserName, loginProxy.getData().UserPassword,  currentDataProxy.getCurrentSystemID(), currentDataProxy.getARM_ID());
			seasonDefaultSetupProxy.getSeasonDefaultSetup(loginProxy.getData().UserName, loginProxy.getData().UserPassword, currentDataProxy.getCurrentSystemID());
		}
		
		private function saveHandler(e:Event):void {
			lastOperation = SAVE;
			
			seasonDefaultSetupView.setState(1);
			var saTime_Month:String =seasonDefaultSetupView.SA_StartTime_Month.text;
			if(int(saTime_Month).toString(16).length == 1) {
				saTime_Month = "0" + int(saTime_Month).toString(16);
			}
			var saTime_Day:String = seasonDefaultSetupView.SA_StartTime_Day.text;
			if(int(saTime_Day).toString(16).length == 1) {
				saTime_Day = "0" + int(saTime_Day).toString(16);
			}
			var wsTime_Month:String =seasonDefaultSetupView.WS_StartTime_Month.text;
			if(int(wsTime_Month).toString(16).length == 1) {
				wsTime_Month = "0" + int(wsTime_Month).toString(16);
			}
			var wsTime_Day:String = seasonDefaultSetupView.WS_StartTime_Day.text;
			if(int(wsTime_Day).toString(16).length == 1) {
				wsTime_Day = "0" + int(wsTime_Day).toString(16);
			}
			
			seasonDefaultSetupView.setState(1);
			sendOrderProxy.setSeasonDefaultSetup(loginProxy.getUserName(), loginProxy.getUserPassword(), currentDataProxy.getCurrentSystemID(),
				saTime_Month + saTime_Day,
				(int(seasonDefaultSetupView.SA_Collector_T_H.text) + 55).toString(16), wsTime_Month + wsTime_Day,
				(int(seasonDefaultSetupView.WS_Collector_T_H.text) + 55).toString(16), currentDataProxy.getARM_ID());
				
			checkSeasonSetupProxy.setData(saveUserSetup());
			checkSeasonSetupProxy.setSystemInfo(loginProxy.getUserName(), loginProxy.getUserPassword(), currentDataProxy.getCurrentSystemID(), new Date());
			checkSeasonSetupProxy.startCheck();
			
		}
		private function saveUserSetup():SeasonData {
			var seasonData:SeasonData = new SeasonData();
			seasonData.SA_Collector_T_H = seasonDefaultSetupView.SA_Collector_T_H.text;
			seasonData.SA_StartTime_Day = seasonDefaultSetupView.SA_StartTime_Day.text;
			seasonData.SA_StartTime_Month = seasonDefaultSetupView.SA_StartTime_Month.text;
			seasonData.WS_Collector_T_H = seasonDefaultSetupView.WS_Collector_T_H.text;
			seasonData.WS_StartTime_Day = seasonDefaultSetupView.WS_StartTime_Day.text;
			seasonData.WS_StartTime_Month = seasonDefaultSetupView.WS_StartTime_Month.text;
			
			return seasonData;
		}
		
		private function closeWindow(e:Event):void {
			lastOperation = SEARCH;
		
			currentDataProxy.startQuery();
			firstDisplayData = true;
			PopUpManager.removePopUp(seasonDefaultSetupView);
			this.setViewComponent(null);
		}
		
		public function init():void {
			seasonDefaultSetupView.addEventListener(SeasonDefaultSetupView.CLOSE_SEASON_DEFAULT_SETUP_VIEW, closeWindow);
			seasonDefaultSetupView.addEventListener(SeasonDefaultSetupView.SAVE_SEASON_DEFAULT_SETUP, saveHandler);
			seasonDefaultSetupView.addEventListener(SeasonDefaultSetupView.SHOW_SEASON_SETUP, showSeasonSetup);
			
			seasonDefaultSetupView.setState(0);
		}
		
		public override function listNotificationInterests():Array {
			return [
				ApplicationFacade.SHOW_SEASON_DEFAULT_SETUP_VIEW,
				CheckSeasonSetupProxy.CHECK_SEASON_SETUP_SUCCESS,
				SeasonDefaultSetupProxy.GET_SEASON_DEFAULT_SETUP_SUCCESS,
				CheckSeasonSetupProxy.CHECK_SEASON_SETUP_FAILED,
				CheckSeasonSetupProxy.CHECK_SEASON_SETUP_OVERTIME,
				CheckSeasonSetupProxy.CHECK_SEASON_SETUP_WRONG,
				SendOrderProxy.CONSOLE_STOPED
			];
		}
		
		public function get seasonDefaultSetupView():SeasonDefaultSetupView {
			return viewComponent as SeasonDefaultSetupView;
		}
		private function showDetail(e:CloseEvent):void {
			switch(e.detail) {
				case Alert.YES:
					sendNotification(ApplicationFacade.SHOW_SEASON_WRONG_DETAIL);
					break;
				case Alert.NO:
					break;
			}
		}
		public override function handleNotification(notification:INotification):void {
			if(notification.getName() == CheckSeasonSetupProxy.CHECK_SEASON_SETUP_OVERTIME) {
				Alert.show("四季默认参数设置超时");
				if(seasonDefaultSetupView != null) {
					seasonDefaultSetupView.setState(2);
				}
			} else if(notification.getName() == CheckSeasonSetupProxy.CHECK_SEASON_SETUP_WRONG) {
				if(seasonDefaultSetupView != null) {
					seasonDefaultSetupProxy.getSeasonDefaultSetup(loginProxy.getData().UserName, loginProxy.getData().UserPassword, currentDataProxy.getCurrentSystemID());
					seasonDefaultSetupView.setState(0);
				} else {
					Alert.show("四季默认参数设置失败，是否查看详细信息？", "警告", Alert.YES | Alert.NO, null, showDetail);
				}
			} else if(notification.getName() == CheckSeasonSetupProxy.CHECK_SEASON_SETUP_SUCCESS) {
				Alert.show("设置四季默认参数成功");
				if(seasonDefaultSetupView != null) {
					seasonDefaultSetupView.setState(0);
					seasonDefaultSetupView.colorBack();
					seasonDefaultSetupView.setFromSeasonData(SeasonData(checkSeasonSetupProxy.getData()));
				}
			}
			if(seasonDefaultSetupView == null) {
				return;
			}
			switch(notification.getName()) {
				case SendOrderProxy.CONSOLE_STOPED:
					seasonDefaultSetupView.setState(0);
					seasonDefaultSetupProxy.getSeasonDefaultSetup(loginProxy.getData().UserName, loginProxy.getData().UserPassword, currentDataProxy.getCurrentSystemID());
					break;
				case ApplicationFacade.SHOW_SEASON_DEFAULT_SETUP_VIEW:
					seasonDefaultSetupProxy.getSeasonDefaultSetup(loginProxy.getData().UserName, loginProxy.getData().UserPassword, currentDataProxy.getCurrentSystemID());
					sendOrderProxy.getSeasonDefaultSetup(loginProxy.getData().UserName, loginProxy.getData().UserPassword,  currentDataProxy.getCurrentSystemID(), currentDataProxy.getARM_ID());
					break;
				case SeasonDefaultSetupProxy.GET_SEASON_DEFAULT_SETUP_SUCCESS:
					if(seasonDefaultSetupView != null) {
						if(lastOperation == SEARCH) {
							seasonDefaultSetupView.setData(seasonDefaultSetupProxy.getData().row[0]);
						} else {
							seasonDefaultSetupView.checkReturnData(seasonDefaultSetupProxy.getData().row[0]);
						}
						seasonDefaultSetupView.textInputEnable(true);
					}
					break;
				//case CheckSeasonSetupProxy.CHECK_SEASON_SETUP_FAILED:
					//seasonDefaultSetupView.setState(1);
					//break;
			}
		}

	}
}