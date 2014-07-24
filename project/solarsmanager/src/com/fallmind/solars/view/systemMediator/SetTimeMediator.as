package com.fallmind.solars.view.systemMediator
{
	import com.fallmind.solars.ApplicationFacade;
	import com.fallmind.solars.model.CheckProxy.CheckCurrentSetupProxy;
	import com.fallmind.solars.model.CheckProxy.CheckSetTimeProxy;
	import com.fallmind.solars.model.CheckProxy.TimeData;
	import com.fallmind.solars.model.CurrentDataProxy;
	import com.fallmind.solars.model.GetCurrentSetupProxy;
	import com.fallmind.solars.model.LoginProxy;
	import com.fallmind.solars.model.SendOrderProxy;
	import com.fallmind.solars.view.component.solarSystem.SetTimeView;
	
	import flash.events.Event;
	import mx.controls.Alert;
	
	import mx.events.CloseEvent;
	import mx.managers.PopUpManager;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class SetTimeMediator extends Mediator
	{
		public static const NAME:String = "SetTimeMediator";
		private var sendOrderProxy:SendOrderProxy;
		//private var checkCurrentSetupProxy:CheckCurrentSetupProxy;
		private var checkSetTimeProxy:CheckSetTimeProxy;
		private var getCurrentSetupProxy:GetCurrentSetupProxy;
		
		private var currentDataProxy:CurrentDataProxy;
		private var loginProxy:LoginProxy;
		
		private var lastOperation:int = 0;
		private var SEARCH:int = 0;
		private var SAVE:int = 1;
		
		public function SetTimeMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);
			
			loginProxy = LoginProxy(facade.retrieveProxy(LoginProxy.NAME));
			currentDataProxy = CurrentDataProxy(facade.retrieveProxy(CurrentDataProxy.NAME));
			sendOrderProxy = SendOrderProxy(facade.retrieveProxy(SendOrderProxy.NAME));
			//checkCurrentSetupProxy = CheckCurrentSetupProxy(facade.retrieveProxy(CheckCurrentSetupProxy.NAME));
			getCurrentSetupProxy = GetCurrentSetupProxy(facade.retrieveProxy(GetCurrentSetupProxy.NAME));
			checkSetTimeProxy = CheckSetTimeProxy(facade.retrieveProxy(CheckSetTimeProxy.NAME));
			
			setTimeView.addEventListener(SetTimeView.CLOSE_SET_TIME_VIEW, closeWindow);
			setTimeView.addEventListener(SetTimeView.SAVE_TIME, saveTime);	
			
			setTimeView.setState(0);
		}
		
		private function saveTime(e:Event):void {
			lastOperation = SAVE;
			setTimeView.setState(1);
			
			var timeTxt:String = "";
			for(var j:int = 0; j < 2 - int(setTimeView.yearText.text.substr(2, 2)).toString(16).length; j++) {
 				timeTxt += "0";
 			}
 			timeTxt += int(setTimeView.yearText.text.substr(2,2)).toString(16);
 			for(var j:int = 0; j < 2 - int(setTimeView.monthText.text).toString(16).length; j++) {
 				timeTxt += "0";
 			}
 			timeTxt += int(setTimeView.monthText.text).toString(16);
 			for(var j:int = 0; j < 2 - int(setTimeView.dayText.text).toString(16).length; j++) {
 				timeTxt += "0";
 			}
 			timeTxt += int(setTimeView.dayText.text).toString(16);
 			for(var j:int = 0; j < 2 - int(setTimeView.hourText.text).toString(16).length; j++) {
 				timeTxt += "0";
 			}
 			timeTxt += int(setTimeView.hourText.text).toString(16);
 			for(var j:int = 0; j < 2 - int(setTimeView.minuteText.text).toString(16).length; j++) {
 				timeTxt += "0";
 			}
 			timeTxt += int(setTimeView.minuteText.text).toString(16);
 			for(var j:int = 0; j < 2 - int(setTimeView.secondText.text).toString(16).length; j++) {
 				timeTxt += "0";
 			}
 			timeTxt += int(setTimeView.secondText.text).toString(16);
 			
 			setTimeView.setState(1);
 			sendOrderProxy.setSystemTime(loginProxy.getUserName(), loginProxy.getUserPassword(), currentDataProxy.getCurrentSystemID(), timeTxt, currentDataProxy.getARM_ID());
 			//checkCurrentSetupProxy.setSystemInfo(loginProxy.getUserName(), loginProxy.getUserPassword(), currentDataProxy.getCurrentSystemID(), new Date());
 			//checkCurrentSetupProxy.startCheck();
 			checkSetTimeProxy.setData(saveUserSetup());
 			checkSetTimeProxy.setSystemInfo(loginProxy.getUserName(), loginProxy.getUserPassword(), currentDataProxy.getCurrentSystemID(), new Date());
			checkSetTimeProxy.startCheck();
		}
		private function saveUserSetup():TimeData {
			var timeData:TimeData = new TimeData();
			timeData.dayText = setTimeView.dayText.text;
			timeData.hourText = setTimeView.hourText.text;
			timeData.minuteText = setTimeView.minuteText.text;
			timeData.monthText = setTimeView.monthText.text;
			timeData.secondText = setTimeView.secondText.text;
			timeData.yearText = setTimeView.yearText.text;
			
			return timeData;
		}
		private function closeWindow(e:Event):void {
			lastOperation = SEARCH;
			currentDataProxy.startQuery();
			PopUpManager.removePopUp(setTimeView);
			this.setViewComponent(null);
		}
		public function init():void {
			setTimeView.addEventListener(SetTimeView.CLOSE_SET_TIME_VIEW, closeWindow);
			setTimeView.addEventListener(SetTimeView.SAVE_TIME, saveTime);	
			
			setTimeView.setState(0);
		}
		public function get setTimeView():SetTimeView {
			return viewComponent as SetTimeView;
		}
		public override function listNotificationInterests():Array {
			return [
				//CheckCurrentSetupProxy.CHECK_CURRENT_SETUP_FAILED,
				//CheckCurrentSetupProxy.CHECK_CURRENT_SETUP_OVERTIME,
				//CheckCurrentSetupProxy.CHECK_CURRENT_SETUP_SUCCESS,
				CheckSetTimeProxy.CHECK_SET_TIME_FAILED,
				CheckSetTimeProxy.CHECK_SET_TIME_OVERTIME,
				CheckSetTimeProxy.CHECK_SET_TIME_SUCCESS,
				CheckSetTimeProxy.CHECK_SET_TIME_WRONG,
				ApplicationFacade.GET_SYSTEM_TIME,
				GetCurrentSetupProxy.GET_CURRENT_SETUP_SUCCESS,
				SendOrderProxy.CONSOLE_STOPED
			];
		}
		private function showDetail(e:CloseEvent):void {
			switch(e.detail) {
				case Alert.YES:
					sendNotification(ApplicationFacade.SHOW_TIME_WRONG_DETAIL);
					break;
				case Alert.NO:
					break;
			}
		}
		public override function handleNotification(notification:INotification):void {
			if(notification.getName() == CheckSetTimeProxy.CHECK_SET_TIME_OVERTIME) {
				Alert.show("设置系统时间超时");
				if(setTimeView != null) {
					setTimeView.setState(2);
				}
			} else if(notification.getName() == CheckSetTimeProxy.CHECK_SET_TIME_WRONG) {
				if(setTimeView == null) {
					Alert.show("设置系统时间失败，是否查看详细信息？", "警告", Alert.YES | Alert.NO, null, showDetail);
				} else {
					setTimeView.setState(0);
					getCurrentSetupProxy.getCurrentSetup(loginProxy.getUserName(), loginProxy.getUserPassword(), currentDataProxy.getCurrentSystemID());
				}
			} else if(notification.getName() == CheckSetTimeProxy.CHECK_SET_TIME_SUCCESS) {
				Alert.show("设置系统时间成功");
				if(setTimeView != null) {
					setTimeView.setState(0);
					setTimeView.colorBack();
					setTimeView.setData(checkSetTimeProxy.systemTime);
				}
			}
			if(setTimeView == null) {
				return;
			}
			switch(notification.getName()) {
				case SendOrderProxy.CONSOLE_STOPED:
					setTimeView.setState(0);
					getCurrentSetupProxy.getCurrentSetup(loginProxy.getUserName(), loginProxy.getUserPassword(), currentDataProxy.getCurrentSystemID());
					break;
				case ApplicationFacade.GET_SYSTEM_TIME:
					sendOrderProxy.getSystemTime(loginProxy.getUserName(), loginProxy.getUserPassword(),  currentDataProxy.getCurrentSystemID(), currentDataProxy.getARM_ID());
					//checkCurrentSetupProxy.setSystemInfo(loginProxy.getUserName(), loginProxy.getUserPassword(), currentDataProxy.getCurrentSystemID(), new Date());
					//checkCurrentSetupProxy.startCheck();
					getCurrentSetupProxy.getCurrentSetup(loginProxy.getUserName(), loginProxy.getUserPassword(), currentDataProxy.getCurrentSystemID());
					break;
				case GetCurrentSetupProxy.GET_CURRENT_SETUP_SUCCESS:
					if(lastOperation == SEARCH) {
						setTimeView.setData(getCurrentSetupProxy.getData().SystemSetup.row.@ARM_Time);
					} else {
						setTimeView.checkData(getCurrentSetupProxy.getData().SystemSetup.row.@ARM_Time);
					}
					break;
				//case CheckCurrentSetupProxy.CHECK_CURRENT_SETUP_FAILED:
					//setTimeView.setState(1);
					//break;
				/*case CheckCurrentSetupProxy.CHECK_CURRENT_SETUP_OVERTIME:
					if(lastOperation == SEARCH) {
						setTimeView.setState(2);
						getCurrentSetupProxy.getCurrentSetup(loginProxy.getUserName(), loginProxy.getUserPassword(), currentDataProxy.getCurrentSystemID());
					}
					else {
						setTimeView.setState(3);
					}
					break;*/
			}
		}

	}
}