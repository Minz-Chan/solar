package com.fallmind.solars.view.systemMediator
{
	import com.fallmind.solars.model.CheckProxy.CheckARMRestartProxy;
	import com.fallmind.solars.model.CheckProxy.CheckFormatEPRomProxy;
	import com.fallmind.solars.model.CurrentDataProxy;
	import com.fallmind.solars.model.LoginProxy;
	import com.fallmind.solars.model.SendOrderProxy;
	import com.fallmind.solars.view.component.solarSystem.RestartSystemView;
	
	import flash.events.Event;
	
	import mx.managers.PopUpManager;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	import mx.controls.Alert;
	
	public class RestartSystemMediator extends Mediator
	{
		public static const NAME:String = "RestartSystemMediator";
		private var sendOrderProxy:SendOrderProxy;
		private var checkRestartSystemProxy:CheckARMRestartProxy;
		private var loginProxy:LoginProxy;
		private var currentDataProxy:CurrentDataProxy;
		public function RestartSystemMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);
			
			sendOrderProxy = SendOrderProxy(facade.retrieveProxy(SendOrderProxy.NAME));
			checkRestartSystemProxy = CheckARMRestartProxy(facade.retrieveProxy(CheckARMRestartProxy.NAME));
			loginProxy = LoginProxy(facade.retrieveProxy(LoginProxy.NAME));
			currentDataProxy = CurrentDataProxy(facade.retrieveProxy(CurrentDataProxy.NAME));
			
			restartSystemView.addEventListener(RestartSystemView.CONFIRM_RESTART_SYSTEM, confirmRestart);
			restartSystemView.addEventListener(RestartSystemView.CLOSE_RESTART_SYSTEM, closeWindowHandler);
			
			restartSystemView.stateText.htmlText = "<font color='#FF0000'>确定要重启太阳能系统 ?</font><br>";
			
			restartSystemView.restartButton.enabled = true;
		}
		private function closeWindowHandler(e:Event):void {
			closeWindow();
		}
		public function init():void {
			restartSystemView.addEventListener(RestartSystemView.CONFIRM_RESTART_SYSTEM, confirmRestart);
			restartSystemView.addEventListener(RestartSystemView.CLOSE_RESTART_SYSTEM, closeWindowHandler);
			restartSystemView.stateText.htmlText = "<font color='#FF0000'>确定要重启太阳能系统 ?</font><br>";
			
			restartSystemView.restartButton.enabled = true;
		}
		private function closeWindow():void {
			currentDataProxy.startQuery();
			PopUpManager.removePopUp(restartSystemView);
			this.setViewComponent(null);
		}
		private function confirmRestart(e:Event):void {
			sendOrderProxy.restartSystem(loginProxy.getUserName(), loginProxy.getUserPassword(), currentDataProxy.getCurrentSystemID(), currentDataProxy.getARM_ID());
			checkRestartSystemProxy.setSystemInfo(loginProxy.getUserName(), loginProxy.getUserPassword(), currentDataProxy.getCurrentSystemID(), new Date());
			checkRestartSystemProxy.startCheck();
		}
		public function get restartSystemView():RestartSystemView {
			return viewComponent as RestartSystemView;
		}
		
		public override function listNotificationInterests():Array {
			return [
				CheckARMRestartProxy.CHECK_ARM_RESTART_FAILED,
				CheckARMRestartProxy.CHECK_ARM_RESTART_OVERTIME,
				CheckARMRestartProxy.CHECK_ARM_RESTART_SUCCESS,
				SendOrderProxy.CONSOLE_STOPED
			];
		}
		public override function handleNotification(notification:INotification):void {
			switch(notification.getName()) {
				case SendOrderProxy.CONSOLE_STOPED:
					if(restartSystemView != null) {
						restartSystemView.stateText.htmlText = "<font color='#FF0000'>重启失败</font><br>";
						restartSystemView.restartButton.enabled = true;
					}
					break;
				case CheckARMRestartProxy.CHECK_ARM_RESTART_FAILED:
					if(restartSystemView != null) {
						restartSystemView.stateText.htmlText = "<font color='#FF0000'>正在重启……</font><br>";
						restartSystemView.restartButton.enabled = false;
					}
					break;
				case CheckARMRestartProxy.CHECK_ARM_RESTART_OVERTIME:
					if(restartSystemView != null) {
						restartSystemView.stateText.htmlText = "<font color='#FF0000'>重启指令超时</font><br>";
						restartSystemView.restartButton.enabled = true;
					} else {
						Alert.show("重启指令超时");
					}
					break;
				case CheckARMRestartProxy.CHECK_ARM_RESTART_SUCCESS:
					if(restartSystemView != null) {
						restartSystemView.stateText.htmlText = "<font color='#FF0000'>重启成功</font><br>";
						restartSystemView.restartButton.enabled = true;
					} 
					break;
			}
		}

	}
}