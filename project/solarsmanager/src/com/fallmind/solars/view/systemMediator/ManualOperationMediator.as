package com.fallmind.solars.view.systemMediator
{
	import com.fallmind.solars.model.CheckProxy.CheckManualAddTempProxy;
	import com.fallmind.solars.model.CheckProxy.CheckManualAddWaterProxy;
	import com.fallmind.solars.model.CurrentDataProxy;
	import com.fallmind.solars.model.GetSystemInstallProxy;
	import com.fallmind.solars.model.LoginProxy;
	import com.fallmind.solars.model.SendOrderProxy;
	import com.fallmind.solars.view.component.solarSystem.ManualOperationView;
	
	import flash.events.Event;
	
	import mx.controls.Alert;
	import mx.managers.PopUpManager;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	
	public class ManualOperationMediator extends Mediator
	{
		public static const NAME:String = "ManualOperationMediator";
		private var currentSystemInfo:CurrentDataProxy;
		private var checkManualAddWaterProxy:CheckManualAddWaterProxy;
		private var checkManualAddTempProxy:CheckManualAddTempProxy;
		private var getInstallProxy:GetSystemInstallProxy;
		private var sendOrderProxy:SendOrderProxy;
		
		private var loginProxy:LoginProxy;
		
		private var lastColdPumpIndex:int;
		private var lastElecPumpIndex:int;
		private var lastAirPumpIndex:int;
		
		private var pumpState:int;
		public function ManualOperationMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);
			currentSystemInfo = CurrentDataProxy(facade.retrieveProxy(CurrentDataProxy.NAME));
			sendOrderProxy = SendOrderProxy(facade.retrieveProxy(SendOrderProxy.NAME));
			loginProxy = LoginProxy(facade.retrieveProxy(LoginProxy.NAME));
			
			getInstallProxy = GetSystemInstallProxy(facade.retrieveProxy(GetSystemInstallProxy.NAME));
			
			checkManualAddWaterProxy = CheckManualAddWaterProxy(facade.retrieveProxy(CheckManualAddWaterProxy.NAME));
			checkManualAddTempProxy = CheckManualAddTempProxy(facade.retrieveProxy(CheckManualAddTempProxy.NAME));
			
			manualOperationView.addEventListener(ManualOperationView.ADD_TEMP, addTemp);
			manualOperationView.addEventListener(ManualOperationView.ADD_WATER, addWater);
			manualOperationView.addEventListener(ManualOperationView.CLOSE_MANUAL_VIEW, closeWindowHandler);
			
			getInstallProxy.getSystemInstall(loginProxy.getUserName(), loginProxy.getUserPassword(), currentSystemInfo.getCurrentSystemID());
		}
		private function addTemp(e:Event):void {
			manualOperationView.setState("temp", 1);
			if(pumpState == ManualOperationView.ELEC_DISABLE_AIR_ENABLE) {
				//sendOrderProxy.manualAddTemp(loginProxy.getUserName(), loginProxy.getUserPassword(), currentSystemInfo.getCurrentSystemID(), manualOperationView.maxTemp.text, manualOperationView.startElec.selected, currentSystemInfo.getARM_ID());
				sendOrderProxy.manualAddTemp(loginProxy.getUserName(), loginProxy.getUserPassword(), currentSystemInfo.getCurrentSystemID(), manualOperationView.maxTemp.text, false, currentSystemInfo.getARM_ID());
			} else if(pumpState == ManualOperationView.ELEC_ENABLE_AIR_DISABLE) {
				sendOrderProxy.manualAddTemp(loginProxy.getUserName(), loginProxy.getUserPassword(), currentSystemInfo.getCurrentSystemID(), manualOperationView.maxTemp.text, true, currentSystemInfo.getARM_ID());
			} else if(pumpState == ManualOperationView.ELEC_ENABLE_AIR_ENABLE) {
				sendOrderProxy.manualAddTemp(loginProxy.getUserName(), loginProxy.getUserPassword(), currentSystemInfo.getCurrentSystemID(), manualOperationView.maxTemp.text, manualOperationView.startElec.selected, currentSystemInfo.getARM_ID());
			}
			checkManualAddTempProxy.setSystemInfo(loginProxy.getUserName(), loginProxy.getUserPassword(), currentSystemInfo.getCurrentSystemID(), new Date());
			checkManualAddTempProxy.startCheck();
		}
		private function addWater(e:Event):void {
			manualOperationView.setState("water", 1);
			sendOrderProxy.manualAddWater(loginProxy.getUserName(), loginProxy.getUserPassword(), currentSystemInfo.getCurrentSystemID(), manualOperationView.maxWater.text, currentSystemInfo.getARM_ID());
			checkManualAddWaterProxy.setSystemInfo(loginProxy.getUserName(), loginProxy.getUserPassword(), currentSystemInfo.getCurrentSystemID(), new Date());
			checkManualAddWaterProxy.startCheck();
		}

		public override function listNotificationInterests():Array {
			return [
				CheckManualAddWaterProxy.CHECK_MANUAL_ADD_WATER_SUCCESS,
				CheckManualAddWaterProxy.CHECK_MANUAL_ADD_WATER_OVERTIME,
				CheckManualAddWaterProxy.CHECK_MANUAL_ADD_WATER_FAILED,
				CheckManualAddTempProxy.CHECK_MANUAL_ADD_TEMP_SUCCESS,
				CheckManualAddTempProxy.CHECK_MANUAL_ADD_TEMP_FAILED,
				CheckManualAddTempProxy.CHECK_MANUAL_ADD_TEMP_OVERTIME,
				SendOrderProxy.CONSOLE_STOPED,
				GetSystemInstallProxy.GET_SYSTEM_INSTALL_SUCCESS
			];
		}
		private function closeWindowHandler(e:Event):void {
			currentSystemInfo.startQuery();
			PopUpManager.removePopUp(manualOperationView);
			this.setViewComponent(null);
		}
		
		public function init():void {
			manualOperationView.addEventListener(ManualOperationView.ADD_TEMP, addTemp);
			manualOperationView.addEventListener(ManualOperationView.ADD_WATER, addWater);
			manualOperationView.addEventListener(ManualOperationView.CLOSE_MANUAL_VIEW, closeWindowHandler);
			
			getInstallProxy.getSystemInstall(loginProxy.getUserName(), loginProxy.getUserPassword(), currentSystemInfo.getCurrentSystemID());
		}
		
		public override function handleNotification(notification:INotification):void {
			if(notification.getName() == CheckManualAddWaterProxy.CHECK_MANUAL_ADD_WATER_OVERTIME) {
				Alert.show("手动加水指令超时");
			} else if(notification.getName() == CheckManualAddTempProxy.CHECK_MANUAL_ADD_TEMP_OVERTIME) {
				Alert.show("手动加热指令超时");
			}
			if(manualOperationView == null) {
				return;
			}
			switch(notification.getName()) {
				case GetSystemInstallProxy.GET_SYSTEM_INSTALL_SUCCESS:
					checkPumpState(getInstallProxy.getData().row[0]);
					break;
				case SendOrderProxy.CONSOLE_STOPED:
					manualOperationView.setState("water", 3);
					break;
				case CheckManualAddWaterProxy.CHECK_MANUAL_ADD_WATER_SUCCESS:
					manualOperationView.setState("water", 0);
					break;
				case CheckManualAddWaterProxy.CHECK_MANUAL_ADD_WATER_OVERTIME:
					manualOperationView.setState("water", 2);
					break;
				case CheckManualAddWaterProxy.CHECK_MANUAL_ADD_WATER_FAILED:
					manualOperationView.setState("water", 1);
					break;
				case CheckManualAddTempProxy.CHECK_MANUAL_ADD_TEMP_SUCCESS:
					manualOperationView.setState("temp", 0);
					break;
				case CheckManualAddTempProxy.CHECK_MANUAL_ADD_TEMP_FAILED:
					manualOperationView.setState("temp", 1);
					break;
				case CheckManualAddTempProxy.CHECK_MANUAL_ADD_TEMP_OVERTIME:
					manualOperationView.setState("temp", 2);
					break;
			}
		}
		private function checkPumpState(xml:XML):void {
			var elec:String = String(xml.@ElecHeat_Fix).charAt(0);
			var air:String = String(xml.@AirHeat_Fix).charAt(0);
			if(elec == "1" && air != "0") {
				pumpState = ManualOperationView.ELEC_ENABLE_AIR_ENABLE;
				manualOperationView.setAddTempState(pumpState);
			} else if(elec == "1" && air == "0") {
				pumpState = ManualOperationView.ELEC_ENABLE_AIR_DISABLE;
				manualOperationView.setAddTempState(pumpState);
			} else if(elec == "0" && air != "0") {
				pumpState = ManualOperationView.ELEC_DISABLE_AIR_ENABLE;
				manualOperationView.setAddTempState(pumpState);
			} else if(elec == "0" && air == "0") {
				pumpState = ManualOperationView.ELEC_DISABLE_AIR_DISABLE;
				manualOperationView.setAddTempState(pumpState);
			}
		}
		public function get manualOperationView():ManualOperationView {
			return viewComponent as ManualOperationView;
		}
	}
}