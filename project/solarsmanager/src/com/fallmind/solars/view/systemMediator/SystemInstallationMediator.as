package com.fallmind.solars.view.systemMediator
{
	import com.fallmind.solars.ApplicationFacade;
	import com.fallmind.solars.model.CheckProxy.CheckGetInstallProxy;
	import com.fallmind.solars.model.CheckProxy.CheckSetInstallProxy;
	import com.fallmind.solars.model.CheckProxy.InstallData;
	import com.fallmind.solars.model.CurrentDataProxy;
	import com.fallmind.solars.model.GetSystemInstallProxy;
	import com.fallmind.solars.model.LoginProxy;
	import com.fallmind.solars.model.SaveSystemMeterageUnitConfigProxy;
	import com.fallmind.solars.model.SendOrderProxy;
	import com.fallmind.solars.model.SetElecFactorProxy;
	import com.fallmind.solars.view.component.solarSystem.SystemInstallationView;
	
	import flash.events.Event;
	
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	import mx.managers.PopUpManager;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class SystemInstallationMediator extends Mediator
	{
		public static const NAME:String = "SystemInstallationMediator";
		public static const SET_SYSTEM_INSTALL_STATE:String = "SetSystemInstallState";
		public static const CHECK_SET_SYSTEM_INSTALL_STATE:String = "CheckSetSystemInstall";
		public static const OPEN_DATAMODEVIEW_FROM_SYSINSTALLVIEW = "OpenDataModeViewFromSysInstallView";
		private var currentDataProxy:CurrentDataProxy;
		
		private var userName:String;
		private var password:String;
		private var loginProxy:LoginProxy;
		private var sendOrderProxy:SendOrderProxy;
		
		private var getSystemInstallProxy:GetSystemInstallProxy;
		//private var checkCurrentSetupProxy:CheckCurrentSetupProxy;
		private var checkSetInstallProxy:CheckSetInstallProxy;
		private var checkGetInstallProxy:CheckGetInstallProxy;
		private var setElecFactorProxy:SetElecFactorProxy;
		private var saveSystemMeterageUnitConfigProxy:SaveSystemMeterageUnitConfigProxy;
		private var firstDisplayData:Boolean = true;
		
		private var lastOperation:int = 0;
		private var SEARCH:int = 0;
		private var SAVE:int = 1;
		
		public function SystemInstallationMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);
			
			currentDataProxy = CurrentDataProxy(facade.retrieveProxy(CurrentDataProxy.NAME));
			
			loginProxy = LoginProxy(facade.retrieveProxy(LoginProxy.NAME));
			sendOrderProxy = SendOrderProxy(facade.retrieveProxy(SendOrderProxy.NAME));
			setElecFactorProxy = SetElecFactorProxy(facade.retrieveProxy(SetElecFactorProxy.NAME));
			//checkCurrentSetupProxy = CheckCurrentSetupProxy(facade.retrieveProxy(CheckCurrentSetupProxy.NAME));
			checkSetInstallProxy = CheckSetInstallProxy(facade.retrieveProxy(CheckSetInstallProxy.NAME));
			checkGetInstallProxy = CheckGetInstallProxy(facade.retrieveProxy(CheckGetInstallProxy.NAME));
			
			getSystemInstallProxy = GetSystemInstallProxy(facade.retrieveProxy(GetSystemInstallProxy.NAME));
			
			saveSystemMeterageUnitConfigProxy = SaveSystemMeterageUnitConfigProxy(facade
					.retrieveProxy(SaveSystemMeterageUnitConfigProxy.NAME));
			
			
			editView.addEventListener(SystemInstallationView.CLOSE_SOLARSYSTEM_VIEW, closeWindowHandler);
			editView.addEventListener(SystemInstallationView.SAVE_SOLARSYSTEM, saveHandler);
			editView.addEventListener(SystemInstallationView.SHOW_INSTALL_STATE, showInstallState);
			editView.addEventListener(SystemInstallationView.CONFIG_DATA_MODE, configDatamodeHandler);
			
			userName = loginProxy.getUserName();
			password = loginProxy.getUserPassword();
			
			editView.setState(0);
		}
		
		public function init():void {
			editView.addEventListener(SystemInstallationView.CLOSE_SOLARSYSTEM_VIEW, closeWindowHandler);
			editView.addEventListener(SystemInstallationView.SAVE_SOLARSYSTEM, saveHandler);
			editView.addEventListener(SystemInstallationView.SHOW_INSTALL_STATE, showInstallState);
			editView.addEventListener(SystemInstallationView.CONFIG_DATA_MODE, configDatamodeHandler);
			
			editView.setState(0);
		}
		private function showInstallState(e:Event):void {
			lastOperation = SEARCH;
			editView.setState(3);
			sendOrderProxy.getSystemState(userName, password, currentDataProxy.getCurrentSystemID(), currentDataProxy.getARM_ID());
			checkGetInstallProxy.setSystemInfo(userName, password, currentDataProxy.getCurrentSystemID(), new Date());
			checkGetInstallProxy.startCheck();
			//getSystemInstallProxy.getSystemInstall(userName, password, currentDataProxy.getCurrentSystemID());
		}
		
		
		protected function get editView():SystemInstallationView {
			return viewComponent as SystemInstallationView;
		}
		private function setFactor(totalFactor:String, extraFactor:String):void {
			editView.ElecFactor.text = totalFactor;
			editView.ExtraElecFactor.text = extraFactor;
		}
		private function saveHandler(e:Event):void {
			lastOperation = SAVE;
			
			setElecFactorProxy.SetElecFactor(editView.ElecFactor.text.toString(), editView.ExtraElecFactor.text.toString(), 
				editView.Collector_in_line_Fix.selectedIndex.toString(), currentDataProxy.getCurrentSystemID());
			
			var _installState:String =
			  editView.j1State.selectedIndex.toString()
			+ editView.j2State.selectedIndex.toString()
			+ editView.j3State.selectedIndex.toString()
			+ editView.jConnect.selectedIndex.toString()
			+ editView.circleConnect.selectedIndex.toString()
			+ ((editView.airPumpState.selectedIndex.toString() == "0") ? "0": "1")
			+ editView.airStart.selectedIndex.toString()
			+ editView.airPumpConnect.selectedIndex.toString()
			+ editView.elecPumpState.selectedIndex.toString()
			+ editView.elecStart.selectedIndex.toString()
			+ editView.elecPumpConnect.selectedIndex.toString()
			+ editView.coldPumpState.selectedIndex.toString()
			+ editView.coldPumpConnect.selectedIndex.toString() + "000";
			
			var installState:String = "";
			for(var i:int = _installState.length - 1; i >= 0; i--) {
				installState += _installState.charAt(i);
			}
			
			if(installState.substr(13, 3) == "000") {
				Alert.show( "请配置集热板安装情况");
				return;
			}
			
			var stateArray:Array = new Array();
			stateArray.push(parseInt(installState, 2).toString(16));
			
			if(editView.Collector_Cubage.text == "") {
				Alert.show("集热板面积未配置");
				return;
			} else {
				stateArray.push(int(editView.Collector_Cubage.text).toString(16));
			}
			if(editView.ProductBox_Cubage.text == "") {
				Alert.show("产热水箱容积未配置");
				return;
				
			} else {
				stateArray.push(int(editView.ProductBox_Cubage.text).toString(16));
			}
			if(editView.OfferBox_Cubage.text == "") {
				Alert.show( "供热水箱容积未配置");
				return;
				
			} else {
				stateArray.push(int(editView.OfferBox_Cubage.text).toString(16));
			}
			if(editView.ProductBox_height.text == "") {
				Alert.show("产热水箱高度未配置");
				return;
				
			} else {
				stateArray.push((Number(editView.ProductBox_height.text) * 10).toString(16));
			}
			if(editView.OfferBox_height.text == "") {
				Alert.show("供热水箱高度未配置");
				return;
				
			} else {
				stateArray.push((Number(editView.OfferBox_height.text) * 10).toString(16));
			}
			if(editView.PLSensorRange.text == "") {
				Alert.show("产热水箱水位传感器量程未配置");
				return;
			} else {
				stateArray.push((Number(editView.PLSensorRange.text) * 10).toString(16));
			}
			if(editView.OLSensorRange.text == "") {
				Alert.show("供热水箱水位传感器量程未配置");
				return;
			} else {
				stateArray.push((Number(editView.OLSensorRange.text) * 10).toString(16));
			}
			if(editView.airPumpState.selectedIndex != 0 && editView.AirHeat_COP.text == "") {
				//Alert.show("辅助加热设备的COP未配置");
				//return;
				stateArray.push("FFFF");
			} else if(editView.airPumpState.selectedIndex == 0 && editView.AirHeat_COP.text != "") {
				//Alert.show("没有安装空气源热泵，不能配置空气源热泵COP");
				//return;
				stateArray.push("FFFF");
			} else if( editView.airPumpState.selectedIndex == 0 && editView.AirHeat_COP.text == ""){
				stateArray.push("FFFF");
			} else if(editView.airPumpState.selectedIndex != 0 && editView.AirHeat_COP.text != "") {
				stateArray.push(Math.round((Number(editView.AirHeat_COP.text) * 100)).toString(16));
			} else {
				stateArray.push("FFFF");
			}
			
			if(editView.ElecHeat_Value.text == "" && editView.elecPumpState.selectedIndex == 1) {
				//Alert.show("电加热值未配置");
				//return;
				stateArray.push("FFFF");
			} else if(editView.elecPumpState.selectedIndex == 0 && editView.ElecHeat_Value.text != "") {
				//Alert.show("没有安装电加热，不能配置电加热值");
				//return;
				stateArray.push("FFFF");
			}else if(editView.elecPumpState.selectedIndex == 0 && editView.ElecHeat_Value.text == "") {
				stateArray.push("FFFF");
			} else if(editView.elecPumpState.selectedIndex == 1 && editView.ElecHeat_Value.text != "") {
				stateArray.push(int(editView.ElecHeat_Value.text).toString(16));
			}
			
			if(editView.ElecHeat_Efficient.text == "" && editView.elecPumpState.selectedIndex == 1) {
				//Alert.show("电加热效率未配置");
				//return;
				stateArray.push("FF");
			} else if(editView.elecPumpState.selectedIndex == 0 && editView.ElecHeat_Efficient.text != "") {
				//Alert.show("没有安装电加热，不能配置电加热效率");
				//return;
				stateArray.push("FF");
			}else if(editView.elecPumpState.selectedIndex == 0 && editView.ElecHeat_Efficient.text == "") {
				stateArray.push("FF");
			} else if(editView.elecPumpState.selectedIndex == 1 && editView.ElecHeat_Efficient.text != "") {
				stateArray.push(int(editView.ElecHeat_Efficient.text).toString(16));
			}
			// 检查数据是否超过限制
			if(!checkLimit()) {
				return;
			}
			editView.setState(1);
			
			// 保存辅助加热设备类型
			saveSystemMeterageUnitConfigProxy.saveSystemMeterageUnitConfig(loginProxy.getUserName()
						, loginProxy.getUserPassword(), currentDataProxy.getCurrentSystemID()
						, "AuxiliaryDeviceType:" + editView.airPumpState.selectedIndex.toString());
			
			
			sendOrderProxy.setInstallState(loginProxy.getUserName(), loginProxy.getUserPassword(), currentDataProxy.getCurrentSystemID(), stateArray, currentDataProxy.getARM_ID());
			
			checkSetInstallProxy.setSystemInfo(userName, password, currentDataProxy.getCurrentSystemID(), new Date());
			checkSetInstallProxy.startCheck();
			checkSetInstallProxy.setData(saveUserInstallSet());
		}
		/**
		 * 检查数据是否超过限制
		 */
		private function checkLimit():Boolean {
			if(int(editView.Collector_Cubage.text) >= 65535) {
					Alert.show("集热板容积超过限制");
					return false;
				}
				if(int(editView.ProductBox_Cubage.text) >= 65535) {
					Alert.show("产热水箱储水量超过限制");
					return false;
				}
				if(int(editView.OfferBox_Cubage.text) >= 65535) {
					Alert.show("供热水箱储水量超过限制");
					return false;
				}
				if(Number(editView.AirHeat_COP.text) >= 655.35) {
					Alert.show("空气源热泵COP超过限制");
					return false;
				}
				if(int(editView.ElecHeat_Value.text) >= 65535) {
					Alert.show("电加热值超过限制");
					return false;
				}
				if(int(editView.ProductBox_height.text) >= 255) {
					Alert.show("产热水箱高度超过限制");
					return false;
				}
				if(int(editView.OfferBox_height.text) >= 255) {
					Alert.show("供热水箱高度超过限制");
					return false;
				}
				if(int(editView.PLSensorRange.text) >= 255) {
					Alert.show("产热水箱安装的水位传感器最大量程超过限制");
					return false;
				}
				if(int(editView.OLSensorRange.text) >= 255) {
					Alert.show("供热水箱安装的水位传感器最大量程超过限制");
					return false;
				}
				
				if(int(editView.ElecHeat_Efficient.text) > 100) {
					//Alert.show("电加热效率超过限制");
					//return false;
					editView.ElecHeat_Efficient.text = "100";
				}
				return true;
		}
		/**
		 * 储存用户对系统安装的设置,以便判断安装情况是否按用户所设置的那样
		 */
		public function saveUserInstallSet():InstallData {
			var installData:InstallData = new InstallData();
			installData.AirHeat_COP = editView.AirHeat_COP.text;
			installData.airPumpConnect = editView.airPumpConnect.selectedIndex;
			installData.airPumpState = editView.airPumpState.selectedIndex;
			installData.airStart = editView.airStart.selectedIndex;
			installData.circleConnect = editView.circleConnect.selectedIndex;
			installData.coldPumpConnect = editView.coldPumpConnect.selectedIndex;
			installData.coldPumpState = editView.coldPumpState.selectedIndex;
			installData.Collector_Cubage = editView.Collector_Cubage.text;
			installData.ElecHeat_Efficient = editView.ElecHeat_Efficient.text;
			installData.ElecHeat_Value = editView.ElecHeat_Value.text;
			installData.elecPumpConnect = editView.elecPumpConnect.selectedIndex;
			installData.elecPumpState = editView.elecPumpState.selectedIndex;
			installData.elecStart = editView.elecStart.selectedIndex;
			installData.j1State = editView.j1State.selectedIndex;
			installData.j2State = editView.j2State.selectedIndex;
			installData.j3State = editView.j3State.selectedIndex;
			installData.jConnect = editView.jConnect.selectedIndex;
			installData.OfferBox_Cubage = editView.OfferBox_Cubage.text;
			installData.OfferBox_height = editView.OfferBox_height.text;
			installData.OLSensorRange = editView.OLSensorRange.text;
			installData.PLSensorRange = editView.PLSensorRange.text;
			installData.ProductBox_Cubage = editView.ProductBox_Cubage.text;
			installData.ProductBox_height = editView.ProductBox_height.text;
			installData.ElecFactor = Number(editView.ElecFactor.text);
			installData.ExtraElecFactor = Number(editView.ExtraElecFactor.text);
			
			installData.Collector_in_line_Fix = editView.Collector_in_line_Fix.selectedIndex;
			
			return installData;
		}
		public override function listNotificationInterests():Array {
			return [
				ApplicationFacade.SHOW_SYSTEM_INSTALL,
				CheckSetInstallProxy.CHECK_SET_INSTALL_FAILED,
				CheckSetInstallProxy.CHECK_SET_INSTALL_OVERTIME,
				CheckSetInstallProxy.CHECK_SET_INSTALL_SUCCESS,
				CheckSetInstallProxy.CHECK_SET_INSTALL_WRONG,
				GetSystemInstallProxy.GET_SYSTEM_INSTALL_SUCCESS,
				SendOrderProxy.CONSOLE_STOPED,
				CheckGetInstallProxy.CHECK_GET_INSTALL_FAILED,
				CheckGetInstallProxy.CHECK_GET_INSTALL_OVERTIME,
				CheckGetInstallProxy.CHECK_GET_INSTALL_SUCCESS
			];
		}
		private function showDetail(e:CloseEvent):void {
			switch(e.detail) {
				case Alert.YES:
					sendNotification(ApplicationFacade.SHOW_INSTALL_WRONG_DETAIL);
					break;
				case Alert.NO:
					break;
			}
		}
		public override function handleNotification(notification:INotification):void {
			if(notification.getName() == CheckSetInstallProxy.CHECK_SET_INSTALL_OVERTIME) {
				Alert.show("系统安装情况设置超时");
				if(editView != null) {
					editView.setState(2);
				}
			} else if(notification.getName() == CheckSetInstallProxy.CHECK_SET_INSTALL_WRONG) {// 如果设置失败，也就是实际值与设置值不同
				// 如果设置界面还存在，就把设置界面中相应的设置值变红
				if(editView != null) {
					getSystemInstallProxy.getSystemInstall(userName, password, currentDataProxy.getCurrentSystemID());
					editView.setState(0);
				} else {
					Alert.show("系统安装情况设置失败，是否查看详细信息？", "警告", Alert.YES | Alert.NO, null, showDetail);
				}
			} else if(notification.getName() == CheckSetInstallProxy.CHECK_SET_INSTALL_SUCCESS) {
				Alert.show("设置系统安装情况成功");
				if(editView != null) {
					editView.setState(0);
					editView.colorBack();
					editView.setFromInstallData(InstallData(checkSetInstallProxy.getData()));
				}
			}
			if(editView == null) {
				return;
			}
			switch(notification.getName()) {
				case CheckGetInstallProxy.CHECK_GET_INSTALL_SUCCESS:
					lastOperation = SEARCH;
					editView.setState(0);
					getSystemInstallProxy.getSystemInstall(userName, password, currentDataProxy.getCurrentSystemID());
					break;
				case CheckGetInstallProxy.CHECK_GET_INSTALL_OVERTIME:
					lastOperation = SEARCH;
					editView.setState(4);
					getSystemInstallProxy.getSystemInstall(userName, password, currentDataProxy.getCurrentSystemID());
					break;
				case CheckGetInstallProxy.CHECK_GET_INSTALL_FAILED:
					editView.setState(3);
					break;
				case SendOrderProxy.CONSOLE_STOPED:
					//getSystemInstallProxy.getSystemInstall(userName, password, currentDataProxy.getCurrentSystemID());
					editView.setState(0);
					break;
				case ApplicationFacade.SHOW_SYSTEM_INSTALL:
					sendOrderProxy.getSystemState(userName, password, currentDataProxy.getCurrentSystemID(), currentDataProxy.getARM_ID());
					getSystemInstallProxy.getSystemInstall(userName, password, currentDataProxy.getCurrentSystemID());
					editView.setState(0);
					break;
				case GetSystemInstallProxy.GET_SYSTEM_INSTALL_SUCCESS:
					if(editView != null) {
						if(lastOperation == SEARCH) {
							editView.stateEnable(true);
							if(getSystemInstallProxy.getData().row[0].@Collector1_Fix == undefined) {
								editView.setDefaultData();
							} else {
								editView.setData(getSystemInstallProxy.getData().row[0]);	
							}	
						} else if(lastOperation == SAVE) {
							editView.stateEnable(true);
							editView.checkReturnData(getSystemInstallProxy.getData().row[0]);
						}
					}
					break;
			}
		}
		
		private function closeWindowHandler(e:Event):void {
			lastOperation = SEARCH;
			firstDisplayData = true;
			currentDataProxy.startQuery();
			PopUpManager.removePopUp(editView);
			this.setViewComponent(null);
		}
		
		private function configDatamodeHandler(e:Event):void {
			closeWindowHandler(null);
			var solarSystemManageMediator:SolarSystemManageMediator = SolarSystemManageMediator(facade.retrieveMediator(SolarSystemManageMediator.NAME));
			solarSystemManageMediator.showDataModeWithoutAuthority();
			sendNotification(OPEN_DATAMODEVIEW_FROM_SYSINSTALLVIEW);	// 通知"数据模式配置"页面此次从系统安装页面进入
		}
	}
}