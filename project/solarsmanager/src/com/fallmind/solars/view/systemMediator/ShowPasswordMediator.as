package com.fallmind.solars.view.systemMediator
{
	import com.fallmind.solars.ApplicationFacade;
	import com.fallmind.solars.model.CheckProxy.CheckGetPasswordProxy;
	import com.fallmind.solars.model.CurrentDataProxy;
	import com.fallmind.solars.model.GetCurrentSetupProxy;
	import com.fallmind.solars.model.LoginProxy;
	import com.fallmind.solars.model.SendOrderProxy;
	import com.fallmind.solars.view.component.solarSystem.ShowPasswordView;
	
	import flash.events.Event;
	
	import mx.managers.PopUpManager;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class ShowPasswordMediator extends Mediator
	{
		public static const NAME:String = "ShowPasswordMediator";
		private var checkGetPasswordProxy:CheckGetPasswordProxy;
		private var currentDataProxy:CurrentDataProxy;
		private var loginProxy:LoginProxy;
		private var sendOrderProxy:SendOrderProxy;
		private var getCurrentSetupProxy:GetCurrentSetupProxy;
		
		private var userName:String;
		private var password:String;
		
		public function ShowPasswordMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);
		
			currentDataProxy = CurrentDataProxy(facade.retrieveProxy(CurrentDataProxy.NAME));
			loginProxy = LoginProxy(facade.retrieveProxy(LoginProxy.NAME));
			sendOrderProxy = SendOrderProxy(facade.retrieveProxy(SendOrderProxy.NAME));
			getCurrentSetupProxy = GetCurrentSetupProxy(facade.retrieveProxy(GetCurrentSetupProxy.NAME));
			checkGetPasswordProxy = CheckGetPasswordProxy(facade.retrieveProxy(CheckGetPasswordProxy.NAME));
			
			userName = loginProxy.getUserName();
			password = loginProxy.getUserPassword();
			
			showPasswordView.addEventListener(ShowPasswordView.CLOSE_SHOW_PASSWORD_VIEW, closeWindow);
			showPasswordView.addEventListener(ShowPasswordView.SHOW_PASSWORD, showPassword);
			
		
		}
		public function get showPasswordView():ShowPasswordView{
			return viewComponent as ShowPasswordView;
		}
		public function init():void {
			showPasswordView.addEventListener(ShowPasswordView.CLOSE_SHOW_PASSWORD_VIEW, closeWindow);
			showPasswordView.addEventListener(ShowPasswordView.SHOW_PASSWORD, showPassword);
			
		}
		private function closeWindow(e:Event):void {
			currentDataProxy.startQuery();
			checkGetPasswordProxy.stopCheck();
			PopUpManager.removePopUp(showPasswordView);
			this.setViewComponent(null);
		}
		private function showPassword(e:Event):void {
			showPasswordView.setState(1);
			sendOrderProxy.getSystemPassword(userName, password, currentDataProxy.getCurrentSystemID(), currentDataProxy.getARM_ID());
			checkGetPasswordProxy.setSystemInfo(userName, password, currentDataProxy.getCurrentSystemID(), new Date());
			checkGetPasswordProxy.startCheck();
		}
		public override function listNotificationInterests():Array {
			return [
				ApplicationFacade.SHOW_PASSWORD,
				CheckGetPasswordProxy.CHECK_GET_PASSWORD_SUCCESS,
				GetCurrentSetupProxy.GET_CURRENT_SETUP_SUCCESS,
				CheckGetPasswordProxy.CHECK_GET_PASSWORD_FAILED,
				CheckGetPasswordProxy.CHECK_GET_PASSWORD_OVERTIME,
				SendOrderProxy.CONSOLE_STOPED
			];
		}
		public override function handleNotification(notification:INotification):void {
			if(showPasswordView == null) {
				return;
			}
			switch(notification.getName()) {
				case SendOrderProxy.CONSOLE_STOPED:
					showPasswordView.stateText.text = "指令发送失败";
					getCurrentSetupProxy.getCurrentSetup(userName, password, currentDataProxy.getCurrentSystemID());
					break;
				case ApplicationFacade.SHOW_PASSWORD:
					showPasswordView.setState(3);
					
					getCurrentSetupProxy.getCurrentSetup(userName, password, currentDataProxy.getCurrentSystemID());
					break;
				case CheckGetPasswordProxy.CHECK_GET_PASSWORD_SUCCESS:
					showPasswordView.setState(0);
					getCurrentSetupProxy.getCurrentSetup(userName, password, currentDataProxy.getCurrentSystemID());
					break;
				case GetCurrentSetupProxy.GET_CURRENT_SETUP_SUCCESS:
					var time:String = getCurrentSetupProxy.getData().SystemSetup.row.@ARM_Password;
					var myPattern:RegExp = /T/;
					showPasswordView.passwordText.text = time;
					break;
				case CheckGetPasswordProxy.CHECK_GET_PASSWORD_FAILED:
					showPasswordView.setState(1);
					break;
				case CheckGetPasswordProxy.CHECK_GET_PASSWORD_OVERTIME:
					showPasswordView.setState(2);
					getCurrentSetupProxy.getCurrentSetup(userName, password, currentDataProxy.getCurrentSystemID());
					break;
			}
		}
	}
}