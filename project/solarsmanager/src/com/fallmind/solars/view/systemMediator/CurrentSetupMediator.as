package com.fallmind.solars.view.systemMediator
{
	import com.fallmind.solars.ApplicationFacade;
	import com.fallmind.solars.model.CheckProxy.CheckCurrentSetupProxy;
	import com.fallmind.solars.model.CurrentDataProxy;
	import com.fallmind.solars.model.GetCurrentSetupProxy;
	import com.fallmind.solars.model.LoginProxy;
	import com.fallmind.solars.model.SendOrderProxy;
	import com.fallmind.solars.model.bussiness.ConfigManager;
	import com.fallmind.solars.view.component.solarSystem.CurrentSetupOldView;
	import com.fallmind.solars.view.component.solarSystem.CurrentSetupView;
	
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	import mx.managers.PopUpManager;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class CurrentSetupMediator extends Mediator
	{
		public static const NAME:String = "CurrentSetupMediator";
		public static const CHECK_GET_CURRENT_SETUP:String = "CheckGetCurrentSetup";
		private var currentSystemData:CurrentDataProxy;
		private var loginProxy:LoginProxy;
		private var username:String;
		private var password:String;
		private var sendOrderProxy:SendOrderProxy;
		private var getCurrentSetupProxy:GetCurrentSetupProxy;
		
		private var offerBoxLow:String;
		private var productBoxLow:String;
		
		private var boostPump_Work:String;
		
		private var checkCurrentSetupProxy:CheckCurrentSetupProxy;
		
		
		public function CurrentSetupMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);
			
			currentSystemData = CurrentDataProxy(facade.retrieveProxy(CurrentDataProxy.NAME));
			
			loginProxy = LoginProxy(facade.retrieveProxy(LoginProxy.NAME));
			sendOrderProxy = SendOrderProxy(facade.retrieveProxy(SendOrderProxy.NAME));
			checkCurrentSetupProxy = CheckCurrentSetupProxy(facade.retrieveProxy(CheckCurrentSetupProxy.NAME));
			getCurrentSetupProxy = GetCurrentSetupProxy(facade.retrieveProxy(GetCurrentSetupProxy.NAME));
			
			username = loginProxy.getData().UserName;
			password = loginProxy.getData().UserPassword;
			
			/* currentSetupView.addEventListener(CurrentSetupView.CLOSE_CURRENT_SETUP_VIEW, closeHandler);
			currentSetupView.addEventListener(CurrentSetupView.SHOW_CURRENT_SETUP, showCurrentSetup);
			
			currentSetupView.searchButton.enabled = true; */
			if(isNewVersion()) {
				init();
			} else {
				initOld();
			}
		}
		private function showCurrentSetup(e:Event):void {
			currentSetupView.setState(1);
			sendOrderProxy.getCurrentSetup(username, password, currentSystemData.getCurrentSystemID(), currentSystemData.getARM_ID());
			//getCurrentSetupProxy.getCurrentSetup(username, password, currentSystemData.getCurrentSystemID());
			if(isNewVersion()) {
				// 下发查询輔助设备加热时间段值指令   Added by Minz.Chan 2013.01.28
				sendOrderProxy.getCurrentSetupAuxiliaryDeviceWork(username, password, currentSystemData.getCurrentSystemID(), currentSystemData.getARM_ID());			
			}
			
			checkCurrentSetupProxy.setSystemInfo(username, password, currentSystemData.getCurrentSystemID(), new Date());
			checkCurrentSetupProxy.startCheck();
		}
		
		public function init():void {
			currentSetupView.addEventListener(CurrentSetupView.CLOSE_CURRENT_SETUP_VIEW, closeHandler);
			currentSetupView.addEventListener(CurrentSetupView.SHOW_CURRENT_SETUP, showCurrentSetup);
			
			currentSetupView.searchButton.enabled = true;
			
		}
		
		public function initOld():void {
			currentSetupView.addEventListener(CurrentSetupOldView.CLOSE_CURRENT_SETUP_VIEW, closeHandler);
			currentSetupView.addEventListener(CurrentSetupOldView.SHOW_CURRENT_SETUP, showCurrentSetup);
			
			currentSetupView.searchButton.enabled = true;
			
		}
		private function closeHandler(e:Event):void {
			closeWindow();
		}
		private function closeWindow():void {
			if(checkCurrentSetupProxy.isRun()) {
				checkCurrentSetupProxy.stopCheck();
			}
			currentSystemData.startQuery();
			if(isNewVersion()) {
				PopUpManager.removePopUp(CurrentSetupView(currentSetupView));
			} else {
				PopUpManager.removePopUp(CurrentSetupOldView(currentSetupView));
			}
			
			this.setViewComponent(null);
		}
		
		public override function listNotificationInterests():Array {
			return [
				ApplicationFacade.GET_CURRENT_SETUP,
				CheckCurrentSetupProxy.CHECK_CURRENT_SETUP_SUCCESS,
				GetCurrentSetupProxy.GET_CURRENT_SETUP_SUCCESS,
				CheckCurrentSetupProxy.CHECK_CURRENT_SETUP_FAILED,
				CheckCurrentSetupProxy.CHECK_CURRENT_SETUP_OVERTIME,
				SendOrderProxy.CONSOLE_STOPED
			];
		}
		
		public override function handleNotification(notification:INotification):void {
			if(currentSetupView == null) {
				return;
			}
			switch(notification.getName()) {
				case SendOrderProxy.CONSOLE_STOPED:
					getCurrentSetupProxy.getCurrentSetup(username, password, currentSystemData.getCurrentSystemID());
					currentSetupView.setState(0);
					break;
				case ApplicationFacade.GET_CURRENT_SETUP:
					currentSetupView.setState(3);
					getCurrentSetupProxy.getCurrentSetup(username, password, currentSystemData.getCurrentSystemID());
					break;	
				case CheckCurrentSetupProxy.CHECK_CURRENT_SETUP_SUCCESS:
					getCurrentSetupProxy.getCurrentSetup(username, password, currentSystemData.getCurrentSystemID());
					currentSetupView.setState(0);
					break;
				case GetCurrentSetupProxy.GET_CURRENT_SETUP_SUCCESS:
					if(currentSetupView != null) {
						currentSetupView.setData(getCurrentSetupProxy.getData() as XML);
					}
					break;
				case CheckCurrentSetupProxy.CHECK_CURRENT_SETUP_FAILED:
					//currentSetupView.setData(getCurrentSetupProxy.getData() as XML);
					currentSetupView.setState(1);
					//Alert.show("获取当前设置失败");
					break;
				case CheckCurrentSetupProxy.CHECK_CURRENT_SETUP_OVERTIME:
					currentSetupView.setState(2);
					getCurrentSetupProxy.getCurrentSetup(username, password, currentSystemData.getCurrentSystemID());
					break;
			}
		}
		public function get currentSetupView():Object {
			if(isNewVersion()) {
				return viewComponent as CurrentSetupView;
			} else {
				return viewComponent as CurrentSetupOldView;
			}
			
		}
		
		public static function float2Hex(float:Number):String {
			var hex:String = "";
			var byteArray:ByteArray = new ByteArray();
			byteArray.writeFloat(float);
			for(var i:int = 3; i >= 0; i--) {
				hex += int(byteArray[i]).toString(16);
			}
			return hex;
		}
		
		/**
		 * 检测是否是新版系统
		 * 参  数：
		 *   无
		 * 返回值：
		 *   true, 新版系统
		 *   false, 旧版系统
		 */ 
		private function isNewVersion():Boolean {
			var config:ConfigManager = ConfigManager.getManageManager();
			var newVersion:String = config.getNewVersion();
			var currentVersion:String = currentSystemData.getARM_Version();
			
			if(currentVersion != null && currentVersion != ""
			  && currentVersion >= newVersion ) {
			  	// 新版
				return true;
			} else {
				// 旧版
				return false;
			}
		}

	}
}