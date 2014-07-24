package com.fallmind.solars.view.systemMediator
{
	import com.fallmind.solars.model.CheckProxy.CheckCurrentSetupProxy;
	import com.fallmind.solars.model.CheckProxy.CheckPasswordProxy;
	import com.fallmind.solars.model.CurrentDataProxy;
	import com.fallmind.solars.model.GetCurrentSetupProxy;
	import com.fallmind.solars.model.LoginProxy;
	import com.fallmind.solars.model.SendOrderProxy;
	import com.fallmind.solars.view.component.solarSystem.SetSystemPasswordView;
	import com.fallmind.solars.ApplicationFacade;
	
	import flash.events.Event;
	
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	import mx.managers.PopUpManager;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class SetSystemPasswordMediator extends Mediator
	{
		public static const NAME:String = "SetSystemPasswordMediator";
		private var sendOrderProxy:SendOrderProxy;
		private var currentDataProxy:CurrentDataProxy;
		private var loginProxy:LoginProxy;
		//private var checkCurrentSetupProxy:CheckCurrentSetupProxy;
		private var checkPasswordProxy:CheckPasswordProxy;
		private var getCurrentSetupProxy:GetCurrentSetupProxy;
		private var firstDisplayData:Boolean = true;
		
		private var setPassword:int = 0;
		private var getPassword:int = 1;
		private var state:int = setPassword;
		public function SetSystemPasswordMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);
			sendOrderProxy = SendOrderProxy(facade.retrieveProxy(SendOrderProxy.NAME));
			currentDataProxy = CurrentDataProxy(facade.retrieveProxy(CurrentDataProxy.NAME));
			loginProxy = LoginProxy(facade.retrieveProxy(LoginProxy.NAME));
			//checkCurrentSetupProxy = CheckCurrentSetupProxy(facade.retrieveProxy(CheckCurrentSetupProxy.NAME));
			getCurrentSetupProxy = GetCurrentSetupProxy(facade.retrieveProxy(GetCurrentSetupProxy.NAME));
			checkPasswordProxy = CheckPasswordProxy(facade.retrieveProxy(CheckPasswordProxy.NAME));
			
			setSystemPasswordView.addEventListener(SetSystemPasswordView.CLOSE_SET_PASSWORD_VIEW, closeWindow);
			setSystemPasswordView.addEventListener(SetSystemPasswordView.SAVE_PASSWORD, savePassword);
			
			setSystemPasswordView.setState(0);
		}
		public function init():void {
			setSystemPasswordView.addEventListener(SetSystemPasswordView.CLOSE_SET_PASSWORD_VIEW, closeWindow);
			setSystemPasswordView.addEventListener(SetSystemPasswordView.SAVE_PASSWORD, savePassword);
		
			
			setSystemPasswordView.setState(0);
		}
		
		private function closeWindow(e:Event):void {
			firstDisplayData = true;
			currentDataProxy.startQuery();
			PopUpManager.removePopUp(setSystemPasswordView);
			
			state = setPassword;
			this.setViewComponent(null);
		}
		private function savePassword(e:Event):void {
			state = setPassword;
			
			setSystemPasswordView.setState(1);
			
			var password:String = setSystemPasswordView.newPassword.text;
			sendOrderProxy.setSystemPassword(loginProxy.getUserName(), loginProxy.getUserPassword(), currentDataProxy.getCurrentSystemID(), password, currentDataProxy.getARM_ID());
			
			checkPasswordProxy.setData(password);
			checkPasswordProxy.setSystemInfo(loginProxy.getUserName(), loginProxy.getUserPassword(), currentDataProxy.getCurrentSystemID(), new Date());
			checkPasswordProxy.startCheck();
		}
		public function get setSystemPasswordView():SetSystemPasswordView {
			return viewComponent as SetSystemPasswordView;
		}
		
		public override function listNotificationInterests():Array {
			return [
				CheckPasswordProxy.CHECK_PASSWORD_FAILED,
				CheckPasswordProxy.CHECK_PASSWORD_OVERTIME,
				CheckPasswordProxy.CHECK_PASSWORD_SUCCESS,
				CheckPasswordProxy.CHECK_PASSWORD_WRONG,
				GetCurrentSetupProxy.GET_CURRENT_SETUP_SUCCESS,
				SendOrderProxy.CONSOLE_STOPED
			];
		}
		private function showDetail(e:CloseEvent):void {
			switch(e.detail) {
				case Alert.YES:
					sendNotification(ApplicationFacade.SHOW_PASSWORD_WRONG_DETAIL);
					break;
				case Alert.NO:
					break;
			}
		}
		public override function handleNotification(notification:INotification):void {
			switch(notification.getName()) {
				case SendOrderProxy.CONSOLE_STOPED:
					if(setSystemPasswordView != null) {
						getCurrentSetupProxy.getCurrentSetup(loginProxy.getUserName(), loginProxy.getUserPassword(), currentDataProxy.getCurrentSystemID());
						setSystemPasswordView.setState(0);
					}
					break;
				case CheckPasswordProxy.CHECK_PASSWORD_OVERTIME:
					Alert.show("设置密码超时");
					if(setSystemPasswordView != null) {
						setSystemPasswordView.setState(2);
					}
					break;
				case CheckPasswordProxy.CHECK_PASSWORD_WRONG:
					if(setSystemPasswordView != null) {
						//setSystemPasswordView.checkData(checkPasswordProxy.realPassword);
						setSystemPasswordView.setState(3);
					} else {
						Alert.show("系统密码设置错误");
					}
					break;
				case CheckPasswordProxy.CHECK_PASSWORD_SUCCESS:
					Alert.show("设置系统密码成功");
					if(setSystemPasswordView != null) {
						setSystemPasswordView.setState(0);
						setSystemPasswordView.colorBack();
						setSystemPasswordView.setData(checkPasswordProxy.realPassword);
					}
					break;
				
			}
		}

	}
}