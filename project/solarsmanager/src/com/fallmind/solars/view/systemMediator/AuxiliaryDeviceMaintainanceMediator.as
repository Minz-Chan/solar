package com.fallmind.solars.view.systemMediator
{
	import com.fallmind.solars.ApplicationFacade;
	import com.fallmind.solars.model.CurrentDataProxy;
	import com.fallmind.solars.model.GetCurrentSetupProxy;
	import com.fallmind.solars.model.LoginProxy;
	import com.fallmind.solars.model.SaveSystemMeterageUnitConfigProxy;
	import com.fallmind.solars.view.component.solarSystem.AuxiliaryDeviceMaintainanceView;
	
	import flash.events.Event;
	
	import mx.controls.Alert;
	import mx.managers.PopUpManager;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;

	public class AuxiliaryDeviceMaintainanceMediator extends Mediator
	{
		public static const NAME:String = "AuxiliaryDeviceMaintainanceMediator";
		private var currentSystemInfo:CurrentDataProxy;
		private var getCurrentSetupProxy:GetCurrentSetupProxy;
		private var loginProxy:LoginProxy;
		private var saveSystemMeterageUnitConfigProxy:SaveSystemMeterageUnitConfigProxy;
		
		
		public function AuxiliaryDeviceMaintainanceMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			
			currentSystemInfo = CurrentDataProxy(facade.retrieveProxy(CurrentDataProxy.NAME));
			getCurrentSetupProxy = GetCurrentSetupProxy(facade.retrieveProxy(GetCurrentSetupProxy.NAME));
			loginProxy = LoginProxy(facade.retrieveProxy(LoginProxy.NAME));
			saveSystemMeterageUnitConfigProxy = SaveSystemMeterageUnitConfigProxy(facade
					.retrieveProxy(SaveSystemMeterageUnitConfigProxy.NAME));
			
			init();
		}
		
		
		public override function listNotificationInterests():Array {
			return [
				ApplicationFacade.SHOW_AUXILIARYDEVICEMAINTAINANCE_VIEW,
				GetCurrentSetupProxy.GET_CURRENT_SETUP_SUCCESS,
				SaveSystemMeterageUnitConfigProxy.SAVE_SYSTEM_METERAGEUNIT_SUCCESS,
				SaveSystemMeterageUnitConfigProxy.SAVE_SYSTEM_METERAGEUNIT_FAILURE
			];
		}
		
		private function saveConfigHandler(e:Event):void {
			
			var updatedStr:String = "AirHeat_Fix:" + auxiliaryDeviceMaintainanceView.getNewAirHeatFix();
			
			saveSystemMeterageUnitConfigProxy.saveSystemMeterageUnitConfig(loginProxy.getUserName()
						, loginProxy.getUserPassword(), currentSystemInfo.getCurrentSystemID()
						, updatedStr);
		
		}
		
		private function closeWindowHandler(e:Event):void {
			currentSystemInfo.startQuery();
			PopUpManager.removePopUp(auxiliaryDeviceMaintainanceView);
			this.setViewComponent(null);
		}
		
		public function init():void {

			auxiliaryDeviceMaintainanceView.addEventListener(AuxiliaryDeviceMaintainanceView.SAVE_CONFIG, saveConfigHandler);
			auxiliaryDeviceMaintainanceView.addEventListener(AuxiliaryDeviceMaintainanceView.CLOSE_ADM_VIEW, closeWindowHandler);
			
			//getInstallProxy.getSystemInstall(loginProxy.getUserName(), loginProxy.getUserPassword(), currentSystemInfo.getCurrentSystemID()); 
		}
		
		public override function handleNotification(notification:INotification):void {
			switch(notification.getName()) {
				case ApplicationFacade.SHOW_AUXILIARYDEVICEMAINTAINANCE_VIEW:
					//getCurrentSetupProxy.getCurrentSetup(
					getCurrentSetupProxy.getCurrentSetup(loginProxy.getUserName(), loginProxy.getUserPassword(), currentSystemInfo.getCurrentSystemID());
					break;
				case GetCurrentSetupProxy.GET_CURRENT_SETUP_SUCCESS:
					if(auxiliaryDeviceMaintainanceView != null) {
						auxiliaryDeviceMaintainanceView.setData(getCurrentSetupProxy.getData().SystemSetup.row.@AirHeat_Fix);
					}
					break;
				case SaveSystemMeterageUnitConfigProxy.SAVE_SYSTEM_METERAGEUNIT_SUCCESS: // 系统相关计量单元配置保存成功
					Alert.show("设置成功！");
					closeWindowHandler(null);
					break;
				case SaveSystemMeterageUnitConfigProxy.SAVE_SYSTEM_METERAGEUNIT_FAILURE: // 系统相关计量单元配置保存成功
					Alert.show("设置失败！请重试！");
					break;
			}
		}
		
		public function get auxiliaryDeviceMaintainanceView():AuxiliaryDeviceMaintainanceView {
			return viewComponent as AuxiliaryDeviceMaintainanceView;
		}
		
	}
}