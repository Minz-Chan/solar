package com.fallmind.solars.view.systemMediator
{
	import com.fallmind.solars.ApplicationFacade;
	import com.fallmind.solars.model.CheckProxy.CheckCurrentSetupProxy;
	import com.fallmind.solars.model.CurrentDataProxy;
	import com.fallmind.solars.model.GetCurrentSetupProxy;
	import com.fallmind.solars.model.LoginProxy;
	import com.fallmind.solars.model.SendOrderProxy;
	import com.fallmind.solars.model.SolarInfoProxy;
	import com.fallmind.solars.view.component.solarSystem.InputPasswordView;
	
	import flash.events.Event;
	
	import mx.managers.PopUpManager;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;

	public class InputPasswordMediator extends Mediator
	{
		public static const NAME:String = "InputPasswordView";
		public static const PASSWORD_WRONG:String = "PasswordWrong";
		private var systemID:String;
		private var solarInfoProxy:SolarInfoProxy;
		private var orderContent:String;
		private var checkCurrentSetupProxy:CheckCurrentSetupProxy;
		private var sendOrderProxy:SendOrderProxy;
		private var loginProxy:LoginProxy;
		private var currentSystemProxy:CurrentDataProxy;
		private var getCurrentSetupProxy:GetCurrentSetupProxy;
		
		public function InputPasswordMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);
			
			solarInfoProxy = SolarInfoProxy(facade.retrieveProxy(SolarInfoProxy.NAME));
			
			inputPasswordView.addEventListener(InputPasswordView.CONFIRM, confirmHandler);
			inputPasswordView.addEventListener(InputPasswordView.CANCEL, cancelHandler);
			
			loginProxy = LoginProxy(facade.retrieveProxy(LoginProxy.NAME));
			checkCurrentSetupProxy = CheckCurrentSetupProxy(facade.retrieveProxy(CheckCurrentSetupProxy.NAME));
			sendOrderProxy = SendOrderProxy(facade.retrieveProxy(SendOrderProxy.NAME));
			currentSystemProxy = CurrentDataProxy(facade.retrieveProxy(CurrentDataProxy.NAME));
			getCurrentSetupProxy = GetCurrentSetupProxy(facade.retrieveProxy(GetCurrentSetupProxy.NAME));
		}
		public function get inputPasswordView():InputPasswordView {
			return viewComponent as InputPasswordView;
		}
		
		public function init():void {
			inputPasswordView.addEventListener(InputPasswordView.CONFIRM, confirmHandler);
			inputPasswordView.addEventListener(InputPasswordView.CANCEL, cancelHandler);
		}
		
		public override function listNotificationInterests():Array {
			return [
				ApplicationFacade.CONFIRM_PASSWORD,
				CheckCurrentSetupProxy.CHECK_CURRENT_SETUP_FAILED,
				CheckCurrentSetupProxy.CHECK_CURRENT_SETUP_OVERTIME,
				CheckCurrentSetupProxy.CHECK_CURRENT_SETUP_SUCCESS,
				GetCurrentSetupProxy.GET_CURRENT_SETUP_SUCCESS
			];
		}
		
		public override function handleNotification(notification:INotification):void {
			if(inputPasswordView == null) {
				return;
			}
			switch(notification.getName()) {
				case ApplicationFacade.CONFIRM_PASSWORD:
					systemID = Order(notification.getBody()).systemID;
					orderContent = Order(notification.getBody()).orderContent;
					break;
				case CheckCurrentSetupProxy.CHECK_CURRENT_SETUP_SUCCESS:
					getCurrentSetupProxy.getCurrentSetup(loginProxy.getUserName(), loginProxy.getUserPassword(), currentSystemProxy.getCurrentSystemID());
					break;
				case CheckCurrentSetupProxy.CHECK_CURRENT_SETUP_FAILED:
					inputPasswordView.setState(1);
					break;
				case CheckCurrentSetupProxy.CHECK_CURRENT_SETUP_OVERTIME:
					//inputPasswordView.setState(2);
					getCurrentSetupProxy.getCurrentSetup(loginProxy.getUserName(), loginProxy.getUserPassword(), currentSystemProxy.getCurrentSystemID());
					break;
				case GetCurrentSetupProxy.GET_CURRENT_SETUP_SUCCESS:
					//trace(getCurrentSetupProxy.getData().SystemSetup.row.@ARM_Password.@ARM_Password);
					if(getCurrentSetupProxy.getData().SystemSetup.row.@ARM_Password == inputPasswordView.passwordInput.text.toString()) {
						closeWindow();
						sendNotification(orderContent);
					}
					else {
						inputPasswordView.stateText.text = "请输入密码";
						sendNotification(PASSWORD_WRONG);
					}
					break;
			}
		}
		
		private function confirmHandler(e:Event):void {
			inputPasswordView.setState(1);
			sendOrderProxy.getSystemPassword(loginProxy.getUserName(), loginProxy.getUserPassword(), currentSystemProxy.getCurrentSystemID(), currentSystemProxy.getARM_ID());
			checkCurrentSetupProxy.setSystemInfo(loginProxy.getUserName(), loginProxy.getUserPassword(), currentSystemProxy.getCurrentSystemID(), new Date());
			checkCurrentSetupProxy.startCheck();
		}	
		private function cancelHandler(e:Event):void {
			closeWindow();
		}
		private function closeWindow():void {
			if(checkCurrentSetupProxy.isRun()) {
				checkCurrentSetupProxy.stopCheck();
			}
			currentSystemProxy.startQuery();
			PopUpManager.removePopUp(inputPasswordView);
			this.setViewComponent(null);
		}
	}
}