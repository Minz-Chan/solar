package com.fallmind.solars.view.systemMediator
{
	import com.fallmind.solars.model.CheckProxy.CheckFormatEPRomProxy;
	import com.fallmind.solars.model.CurrentDataProxy;
	import com.fallmind.solars.model.LoginProxy;
	import com.fallmind.solars.model.SendOrderProxy;
	import com.fallmind.solars.view.component.solarSystem.FormatEpromView;
	
	import flash.events.Event;
	
	import mx.managers.PopUpManager;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	import mx.controls.Alert;
	
	public class FormatEpromMediator extends Mediator
	{
		public static const NAME:String = "FormatEpromMediator";
		private var sendOrderProxy:SendOrderProxy;
		private var checkFormatEpromProxy:CheckFormatEPRomProxy;
		private var loginProxy:LoginProxy;
		private var currentDataProxy:CurrentDataProxy;
		public function FormatEpromMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);
			
			sendOrderProxy = SendOrderProxy(facade.retrieveProxy(SendOrderProxy.NAME));
			checkFormatEpromProxy = CheckFormatEPRomProxy(facade.retrieveProxy(CheckFormatEPRomProxy.NAME));
			loginProxy = LoginProxy(facade.retrieveProxy(LoginProxy.NAME));
			currentDataProxy = CurrentDataProxy(facade.retrieveProxy(CurrentDataProxy.NAME));
			
			formatEpromView.addEventListener(FormatEpromView.CONFIRM_FORMAT_EPROM, confirmFormat);
			formatEpromView.addEventListener(FormatEpromView.CLOSE_FORMAT_EPROM, closeWindowHandler);
			
			formatEpromView.stateText.htmlText = "<font color='#FF0000'>确定要格式化主控器 ?</font><br>";
			formatEpromView.formatButton.enabled = true;
		}
		private function closeWindowHandler(e:Event):void {
			closeWindow();
		}
		public function init():void {
			formatEpromView.addEventListener(FormatEpromView.CONFIRM_FORMAT_EPROM, confirmFormat);
			formatEpromView.addEventListener(FormatEpromView.CLOSE_FORMAT_EPROM, closeWindowHandler);
			formatEpromView.stateText.htmlText = "<font color='#FF0000'>确定要格式化主控器 ?</font><br>";
			formatEpromView.formatButton.enabled = true;
		}
		private function closeWindow():void {
			currentDataProxy.startQuery();
			PopUpManager.removePopUp(formatEpromView);
			this.setViewComponent(null);
		}
		private function confirmFormat(e:Event):void {
			sendOrderProxy.formatEpprom(loginProxy.getUserName(), loginProxy.getUserPassword(), currentDataProxy.getCurrentSystemID(), currentDataProxy.getARM_ID());
			checkFormatEpromProxy.setSystemInfo(loginProxy.getUserName(), loginProxy.getUserPassword(), currentDataProxy.getCurrentSystemID(), new Date());
			checkFormatEpromProxy.startCheck();
		}
		public function get formatEpromView():FormatEpromView {
			return viewComponent as FormatEpromView;
		}
		
		public override function listNotificationInterests():Array {
			return [
				CheckFormatEPRomProxy.CHECK_FORMAT_EPROM_FAILED,
				CheckFormatEPRomProxy.CHECK_FORMAT_EPROM_OVERTIME,
				CheckFormatEPRomProxy.CHECK_FORMAT_EPROM_SUCCESS,
				SendOrderProxy.CONSOLE_STOPED
			];
		}
		public override function handleNotification(notification:INotification):void {
			switch(notification.getName()) {
				case SendOrderProxy.CONSOLE_STOPED:
					//checkFormatEpromProxy.stopCheck();
					if(formatEpromView != null) {
						formatEpromView.stateText.htmlText = "<font color='#FF0000'>格式化失败</font><br>";
						formatEpromView.formatButton.enabled = true;
					}
					break;
				case CheckFormatEPRomProxy.CHECK_FORMAT_EPROM_FAILED:
					if(formatEpromView != null) {
						formatEpromView.stateText.htmlText = "<font color='#FF0000'>正在格式化……</font><br>";
						formatEpromView.formatButton.enabled = false;
					}
					break;
				case CheckFormatEPRomProxy.CHECK_FORMAT_EPROM_OVERTIME:
					if(formatEpromView != null) {
						formatEpromView.stateText.htmlText = "<font color='#FF0000'>格式化指令超时</font><br>";
						formatEpromView.formatButton.enabled = true;
					} else {
						Alert.show("格式化指令超时");
					}
					break;
				case CheckFormatEPRomProxy.CHECK_FORMAT_EPROM_SUCCESS:
					if(formatEpromView != null) {
						formatEpromView.stateText.htmlText = "<font color='#FF0000'>格式化成功</font><br>";
						formatEpromView.formatButton.enabled = true;
					}
					break;
			}
		}

	}
}