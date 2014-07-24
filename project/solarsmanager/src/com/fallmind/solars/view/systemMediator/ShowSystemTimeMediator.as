package com.fallmind.solars.view.systemMediator
{
	import com.fallmind.solars.ApplicationFacade;
	import com.fallmind.solars.model.CheckProxy.CheckCurrentSetupProxy;
	import com.fallmind.solars.model.CurrentDataProxy;
	import com.fallmind.solars.model.GetCurrentSetupProxy;
	import com.fallmind.solars.model.LoginProxy;
	import com.fallmind.solars.model.SendOrderProxy;
	import com.fallmind.solars.view.component.solarSystem.ShowSystemTimeView;
	
	import flash.events.Event;
	
	import mx.managers.PopUpManager;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class ShowSystemTimeMediator extends Mediator
	{
		public static const NAME:String = "ShowSystemTimeMediator";
		private var checkCurrentSetupProxy:CheckCurrentSetupProxy;
		private var currentDataProxy:CurrentDataProxy;
		private var loginProxy:LoginProxy;
		private var sendOrderProxy:SendOrderProxy;
		private var getCurrentSetupProxy:GetCurrentSetupProxy;
		
		private var userName:String;
		private var password:String;
		
		public function ShowSystemTimeMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);
			
			checkCurrentSetupProxy = CheckCurrentSetupProxy(facade.retrieveProxy(CheckCurrentSetupProxy.NAME));
			currentDataProxy = CurrentDataProxy(facade.retrieveProxy(CurrentDataProxy.NAME));
			loginProxy = LoginProxy(facade.retrieveProxy(LoginProxy.NAME));
			sendOrderProxy = SendOrderProxy(facade.retrieveProxy(SendOrderProxy.NAME));
			getCurrentSetupProxy = GetCurrentSetupProxy(facade.retrieveProxy(GetCurrentSetupProxy.NAME));
			
			userName = loginProxy.getUserName();
			password = loginProxy.getUserPassword();
			
			showSystemTimeView.addEventListener(ShowSystemTimeView.CLOSE_SHOW_TIME_VIEW, closeWindow);
			showSystemTimeView.addEventListener(ShowSystemTimeView.SHOW_TIME, showTimeHandler);
			
			showSystemTimeView.stateText.text = " ";
		}
		public function get showSystemTimeView():ShowSystemTimeView {
			return viewComponent as ShowSystemTimeView;
		}
		public function init():void {
			showSystemTimeView.addEventListener(ShowSystemTimeView.CLOSE_SHOW_TIME_VIEW, closeWindow);
			showSystemTimeView.addEventListener(ShowSystemTimeView.SHOW_TIME, showTimeHandler);
			showSystemTimeView.stateText.text = " ";
		}
		private function closeWindow(e:Event):void {
			currentDataProxy.startQuery();
			checkCurrentSetupProxy.stopCheck();
			PopUpManager.removePopUp(showSystemTimeView);
			this.setViewComponent(null);
		}
		private function showTimeHandler(e:Event):void {
			//showSystemTimeView.stateText.text = "正在获取数据";
			showSystemTimeView.setState(1);
			sendOrderProxy.getSystemTime(userName, password, currentDataProxy.getCurrentSystemID(), currentDataProxy.getARM_ID());
			checkCurrentSetupProxy.setSystemInfo(userName, password, currentDataProxy.getCurrentSystemID(), new Date());
			checkCurrentSetupProxy.startCheck();
		}
		public override function listNotificationInterests():Array {
			return [
				ApplicationFacade.SHOW_SYSTEM_TIME,
				CheckCurrentSetupProxy.CHECK_CURRENT_SETUP_SUCCESS,
				GetCurrentSetupProxy.GET_CURRENT_SETUP_SUCCESS,
				CheckCurrentSetupProxy.CHECK_CURRENT_SETUP_FAILED,
				CheckCurrentSetupProxy.CHECK_CURRENT_SETUP_OVERTIME,
				SendOrderProxy.CONSOLE_STOPED
			];
		}
		public override function handleNotification(notification:INotification):void {
			if(showSystemTimeView == null) {
				return;
			}
			switch(notification.getName()) {
				case SendOrderProxy.CONSOLE_STOPED:
					showSystemTimeView.stateText.text = "指令发送失败";
					getCurrentSetupProxy.getCurrentSetup(userName, password, currentDataProxy.getCurrentSystemID());
					break;
				case ApplicationFacade.SHOW_SYSTEM_TIME:
					//showSystemTimeView.stateText.text = "正在获取数据";
					showSystemTimeView.setState(3);
					//sendOrderProxy.getSystemTime(userName, password, currentDataProxy.getCurrentSystemID(), currentDataProxy.getARM_ID());
					//checkCurrentSetupProxy.setSystemInfo(userName, password, currentDataProxy.getCurrentSystemID(), new Date());
					//checkCurrentSetupProxy.startCheck();
					getCurrentSetupProxy.getCurrentSetup(userName, password, currentDataProxy.getCurrentSystemID());
					break;
				case CheckCurrentSetupProxy.CHECK_CURRENT_SETUP_SUCCESS:
					//showSystemTimeView.stateText.text = "最新数据";
					showSystemTimeView.setState(0);
					getCurrentSetupProxy.getCurrentSetup(userName, password, currentDataProxy.getCurrentSystemID());
					break;
				case GetCurrentSetupProxy.GET_CURRENT_SETUP_SUCCESS:
					var time:String = getCurrentSetupProxy.getData().SystemSetup.row.@ARM_Time;
					var myPattern:RegExp = /T/;
					time = time.replace(myPattern, " ");
					
					showSystemTimeView.timeText.text = time;
					break;
				case CheckCurrentSetupProxy.CHECK_CURRENT_SETUP_FAILED:
					//showSystemTimeView.stateText.text = "正在获取数据";
					showSystemTimeView.setState(1);
					break;
				case CheckCurrentSetupProxy.CHECK_CURRENT_SETUP_OVERTIME:
					//showSystemTimeView.stateText.htmlText = "<font color='#FF0000'>获取数据超时</font><br>";
					showSystemTimeView.setState(2);
					getCurrentSetupProxy.getCurrentSetup(userName, password, currentDataProxy.getCurrentSystemID());
					break;
			}
		}
	}
}