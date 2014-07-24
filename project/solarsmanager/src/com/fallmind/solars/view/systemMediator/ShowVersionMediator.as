package com.fallmind.solars.view.systemMediator
{
	import com.fallmind.solars.ApplicationFacade;
	import com.fallmind.solars.model.CheckProxy.CheckCurrentSetupProxy;
	import com.fallmind.solars.model.CurrentDataProxy;
	import com.fallmind.solars.model.GetCurrentSetupProxy;
	import com.fallmind.solars.model.LoginProxy;
	import com.fallmind.solars.model.SendOrderProxy;
	import com.fallmind.solars.view.component.solarSystem.ShowVersionView;
	
	import flash.events.Event;
	
	import mx.managers.PopUpManager;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class ShowVersionMediator extends Mediator
	{
		public static const NAME:String = "ShowVersionMediator";
		private var checkCurrentSetupProxy:CheckCurrentSetupProxy;
		private var currentDataProxy:CurrentDataProxy;
		private var loginProxy:LoginProxy;
		private var sendOrderProxy:SendOrderProxy;
		private var getCurrentSetupProxy:GetCurrentSetupProxy;
		
		private var userName:String;
		private var password:String;
		
		public function ShowVersionMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);
			
			checkCurrentSetupProxy = CheckCurrentSetupProxy(facade.retrieveProxy(CheckCurrentSetupProxy.NAME));
			currentDataProxy = CurrentDataProxy(facade.retrieveProxy(CurrentDataProxy.NAME));
			loginProxy = LoginProxy(facade.retrieveProxy(LoginProxy.NAME));
			sendOrderProxy = SendOrderProxy(facade.retrieveProxy(SendOrderProxy.NAME));
			getCurrentSetupProxy = GetCurrentSetupProxy(facade.retrieveProxy(GetCurrentSetupProxy.NAME));
			
			userName = loginProxy.getUserName();
			password = loginProxy.getUserPassword();
			
			showVersionView.addEventListener(ShowVersionView.CLOSE_SHOW_VERSION_VIEW, closeWindow);
			showVersionView.addEventListener(ShowVersionView.SHOW_VERSION, showVersionHandler);
			
			showVersionView.stateText.text = " ";
		}
		private function showVersionHandler(e:Event):void {
			//showVersionView.stateText.text = "正在获取数据";
			showVersionView.setState(1);
			//getCurrentSetupProxy.getCurrentSetup(userName, password, currentDataProxy.getCurrentSystemID());
			sendOrderProxy.getSystemVersion(userName, password, currentDataProxy.getCurrentSystemID(), currentDataProxy.getARM_ID());
			checkCurrentSetupProxy.setSystemInfo(userName, password, currentDataProxy.getCurrentSystemID(), new Date());
			checkCurrentSetupProxy.startCheck();
		}
		public function get showVersionView():ShowVersionView {
			return viewComponent as ShowVersionView;
		}
		public function init():void {
			showVersionView.addEventListener(ShowVersionView.CLOSE_SHOW_VERSION_VIEW, closeWindow);
			showVersionView.addEventListener(ShowVersionView.SHOW_VERSION, showVersionHandler);
			showVersionView.stateText.text = " ";
		}
		private function closeWindow(e:Event):void {
			currentDataProxy.startQuery();
			checkCurrentSetupProxy.stopCheck();
			PopUpManager.removePopUp(showVersionView);
			this.setViewComponent(null);
		}
		public override function listNotificationInterests():Array {
			return [
				ApplicationFacade.SHOW_VERSION,
				CheckCurrentSetupProxy.CHECK_CURRENT_SETUP_SUCCESS,
				GetCurrentSetupProxy.GET_CURRENT_SETUP_SUCCESS,
				CheckCurrentSetupProxy.CHECK_CURRENT_SETUP_FAILED,
				CheckCurrentSetupProxy.CHECK_CURRENT_SETUP_OVERTIME,
				SendOrderProxy.CONSOLE_STOPED
			];
		}
		public override function handleNotification(notification:INotification):void {
			if(showVersionView == null) {
				return;
			}
			switch(notification.getName()) {
				case SendOrderProxy.CONSOLE_STOPED:
					showVersionView.stateText.text = "指令发送失败";
					getCurrentSetupProxy.getCurrentSetup(userName, password, currentDataProxy.getCurrentSystemID());
					break;
				case ApplicationFacade.SHOW_VERSION:
					//showVersionView.stateText.text = "正在获取数据";
					showVersionView.setState(3);
					//sendOrderProxy.getSystemPassword(userName, password, currentDataProxy.getCurrentSystemID());
					//sendOrderProxy.getSystemVersion(userName, password, currentDataProxy.getCurrentSystemID(), currentDataProxy.getARM_ID());
					//checkCurrentSetupProxy.setSystemInfo(userName, password, currentDataProxy.getCurrentSystemID(), new Date());
					//checkCurrentSetupProxy.startCheck();
					getCurrentSetupProxy.getCurrentSetup(userName, password, currentDataProxy.getCurrentSystemID());
					break;
				case CheckCurrentSetupProxy.CHECK_CURRENT_SETUP_SUCCESS:
					//showVersionView.stateText.text = "最新数据";
					showVersionView.setState(0);
					getCurrentSetupProxy.getCurrentSetup(userName, password, currentDataProxy.getCurrentSystemID());
					break;
				case GetCurrentSetupProxy.GET_CURRENT_SETUP_SUCCESS:
					showVersionView.timeText.text = getCurrentSetupProxy.getData().SystemSetup.row.@ARM_Version;
					break;
				case CheckCurrentSetupProxy.CHECK_CURRENT_SETUP_FAILED:
					//showVersionView.stateText.text = "正在获取数据";
					showVersionView.setState(1);
					break;
				case CheckCurrentSetupProxy.CHECK_CURRENT_SETUP_OVERTIME:
					//showVersionView.stateText.htmlText = "<font color='#FF0000'>获取数据超时</font><br>";
					showVersionView.setState(2);
					getCurrentSetupProxy.getCurrentSetup(userName, password, currentDataProxy.getCurrentSystemID());
					break;
			}
		}
	}
}