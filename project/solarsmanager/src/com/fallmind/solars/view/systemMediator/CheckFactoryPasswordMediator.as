package com.fallmind.solars.view.systemMediator
{
	import com.fallmind.solars.ApplicationFacade;
	import com.fallmind.solars.model.bussiness.ConfigManager;
	import com.fallmind.solars.view.component.solarSystem.InputPasswordView;
	import mx.managers.PopUpManager;
	
	import flash.events.Event;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	import mx.controls.Alert;
	
	public class CheckFactoryPasswordMediator extends Mediator
	{
		public static const NAME:String = "CheckFactoryPasswordMediator";
		private var configManager:ConfigManager;
		private var factoryPassword:String;
		private var inputPassword:String;
		private var orderText:String;
		public function CheckFactoryPasswordMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);
			
			configManager = ConfigManager.getManageManager();
			factoryPassword = configManager.getFactoryPassword();
			
			checkFactoryPasswordView.addEventListener(InputPasswordView.CONFIRM, confirmHandler);
			checkFactoryPasswordView.addEventListener(InputPasswordView.CANCEL, cancelHandler);
		}
		public function init():void {
			checkFactoryPasswordView.addEventListener(InputPasswordView.CONFIRM, confirmHandler);
			checkFactoryPasswordView.addEventListener(InputPasswordView.CANCEL, cancelHandler);
		}
		public function get checkFactoryPasswordView():InputPasswordView {
			return viewComponent as InputPasswordView;
		}
		public function cancelHandler(e:Event):void {
			closeWindow();	
		}
		private function closeWindow():void {
			PopUpManager.removePopUp(checkFactoryPasswordView);
			this.setViewComponent(null);
		}
		public function confirmHandler(e:Event):void {
			if(factoryPassword == checkFactoryPasswordView.passwordInput.text) {
				sendNotification(orderText);
				closeWindow();
			} 
			else {
				Alert.show("密码错误");
				sendNotification(ApplicationFacade.CHECK_FACTORY_PASSWORD_FAILED);
			}
		}
		
		public override function listNotificationInterests():Array {
			return [
				ApplicationFacade.CHECK_FACTORY_PASSWORD
			];
		}
		public override function handleNotification(notification:INotification):void {
			switch(notification.getName()) {
				case ApplicationFacade.CHECK_FACTORY_PASSWORD:
					orderText = notification.getBody().toString();
					break;
			}
		}
		
		
	}
}