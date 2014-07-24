package com.fallmind.solars.view.systemMediator
{
	import com.fallmind.solars.ApplicationFacade;
	import com.fallmind.solars.model.CheckProxy.SysMeterageUnitConfig;
	import com.fallmind.solars.model.CurrentDataProxy;
	import com.fallmind.solars.model.GetFuelProxy;
	import com.fallmind.solars.model.GetSystemMeterageUnitConfigProxy;
	import com.fallmind.solars.model.LoginProxy;
	import com.fallmind.solars.model.SaveSystemMeterageUnitConfigProxy;
	import com.fallmind.solars.view.component.solarSystem.SystemDataModeView;
	
	import flash.events.Event;
	
	import mx.controls.Alert;
	import mx.controls.ComboBox;
	import mx.managers.PopUpManager;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;

	public class SystemDataModeViewMediator extends Mediator
	{
		public static const NAME:String = "SystemDataModeViewMediator"; 
		
		private var getSystemMeterageUnitConfigProxy:GetSystemMeterageUnitConfigProxy;
		private var getFuelProxy:GetFuelProxy;
		private var loginProxy:LoginProxy;
		private var currentDataProxy:CurrentDataProxy;
		private var saveSystemMeterageUnitConfigProxy:SaveSystemMeterageUnitConfigProxy;
		
		private var isFromSystemInstallationView = false;
		private var config:SysMeterageUnitConfig;
		private var isDataLoadedComplete:int; 	// 0:未装载; 1,2:部分装载; 3:装载完毕
		private var oilList:Array;  			// 燃油类型 FuelType:1
		private var gasList:Array;				// 燃气类型 FuelType:2
		private var eleList:Array;				// 电力当量 FuelType:3
		private var heatList:Array;				// 热力当量 FuelType:4
		
		public function SystemDataModeViewMediator(viewComponent:Object) {
			super(NAME, viewComponent);
			
			isDataLoadedComplete = 0;
			oilList = new Array();
			gasList = new Array();
			eleList = new Array();
			heatList = new Array();
			
			loginProxy = LoginProxy(facade.retrieveProxy(LoginProxy.NAME));
			currentDataProxy = CurrentDataProxy(facade.retrieveProxy(CurrentDataProxy.NAME));
			getSystemMeterageUnitConfigProxy = GetSystemMeterageUnitConfigProxy(facade
					.retrieveProxy(GetSystemMeterageUnitConfigProxy.NAME));
			getFuelProxy = GetFuelProxy(facade.retrieveProxy(GetFuelProxy.NAME));
			saveSystemMeterageUnitConfigProxy = SaveSystemMeterageUnitConfigProxy(facade
					.retrieveProxy(SaveSystemMeterageUnitConfigProxy.NAME));
			
			// 初始化UI事件监听器
			initEventListener();
		}
		
		override public function listNotificationInterests():Array {
			return [
				ApplicationFacade.SHOW_DATA_MODE,
				GetSystemMeterageUnitConfigProxy.GET_SYSTEM_METERAGEUNIT_SUCCESS,
				GetSystemMeterageUnitConfigProxy.GET_SYSTEM_METERAGEUNIT_FAILURE,
				GetFuelProxy.GET_FUEL_SUCCESS, 
				GetFuelProxy.GET_FUEL_FAILURE,
				SaveSystemMeterageUnitConfigProxy.SAVE_SYSTEM_METERAGEUNIT_SUCCESS,
				SaveSystemMeterageUnitConfigProxy.SAVE_SYSTEM_METERAGEUNIT_FAILURE,
				SystemInstallationMediator.OPEN_DATAMODEVIEW_FROM_SYSINSTALLVIEW
			];
		}
		
		override public function handleNotification(notification:INotification):void {
			switch(notification.getName()){
				case ApplicationFacade.SHOW_DATA_MODE:	// 攫取数据模式设置进行填充
					getSystemDataModeViewData();
					break;			
				case GetSystemMeterageUnitConfigProxy.GET_SYSTEM_METERAGEUNIT_SUCCESS:	// 辅助计量单元配置项数据抓取完毕
				case GetFuelProxy.GET_FUEL_SUCCESS:										// 燃料类型列表抓取
					isDataLoadedComplete++;
					if(isDataLoadedComplete >= 2){
						oilList = getFuelProxy.getFuelsByType("1");
						gasList = getFuelProxy.getFuelsByType("2");
						eleList = getFuelProxy.getFuelsByType("3");
						heatList = getFuelProxy.getFuelsByType("4");
						//setSysMeterageUnitConfig(XML(getSystemMeterageUnitConfigProxy.getData()));
						config = getSystemMeterageUnitConfigProxy.getConfig();
						updateUIData(config); 
						isDataLoadedComplete = 0;
						if(sdmView != null){
							sdmView.updateUI();			// 刷新界面
						}
					}
					break;
				case GetSystemMeterageUnitConfigProxy.GET_SYSTEM_METERAGEUNIT_FAILURE:
				case GetFuelProxy.GET_FUEL_FAILURE:
					isDataLoadedComplete = 0;
					Alert.show("数据初始化失败！");
					closeViewHandler(null);
					break;
				case SaveSystemMeterageUnitConfigProxy.SAVE_SYSTEM_METERAGEUNIT_SUCCESS: // 系统相关计量单元配置保存成功
					Alert.show("数据配置项保存成功！");
					break;
				case SaveSystemMeterageUnitConfigProxy.SAVE_SYSTEM_METERAGEUNIT_FAILURE: // 系统相关计量单元配置保存成功
					Alert.show("数据配置项保存失败！");
					break;
				case SystemInstallationMediator.OPEN_DATAMODEVIEW_FROM_SYSINSTALLVIEW: 	// 从“系统安装情况”页面进入
					isFromSystemInstallationView = true;
					break;
			}
		}
		
		/**
		 * 抓取界面所需数据
		 */ 
		public function getSystemDataModeViewData():void{
			getSystemMeterageUnitConfigProxy.getSystemMeterageUnitConfig(loginProxy.getUserName()
						, loginProxy.getUserPassword(), currentDataProxy.getCurrentSystemID());
			/*
			getFuelProxy.getFuelsByFuelType(loginProxy.getUserName(), loginProxy.getUserPassword()
				, "1", oilList);
			getFuelProxy.getFuelsByFuelType(loginProxy.getUserName(), loginProxy.getUserPassword()
				, "2", gasList);
			*/
			getFuelProxy.getFuelsByFuelType(loginProxy.getUserName(), loginProxy.getUserPassword()
				, "all");
		}
		
		/**
		 * 将值数据更新到ComboBox上
		 */ 
		public function updateData2Combox(c:ComboBox, provider:Array, value:int):void{
			var i:int;
			for(i = 0; i < provider.length; i++){
				if(Number(provider[i].data.toString()) == value){
					c.selectedIndex = i;
				}
			}
		}
		
		/**
		 * 根据返回的辅助计量单元配置项数据更新界面
		 */ 
		public function updateUIData(config:SysMeterageUnitConfig):void{
			if(config == null || sdmView == null) 
				return;
				
			sdmView.cbOilType.enabled = false;
			sdmView.cbGasType.enabled = false;	
				
			// 更新ComboBox
			updateData2Combox(sdmView.cbTotalWaterType, sdmView.totalWaterType, config.totalWaterType);
			updateData2Combox(sdmView.cbTotalEleType, sdmView.totalEleType, config.totalEleType);
			updateData2Combox(sdmView.cbHeatSupplyType, sdmView.heatSupplyType, config.heatSupplyType);
			updateData2Combox(sdmView.cbBackWaterType, sdmView.backWaterType, config.backWaterType);
			updateData2Combox(sdmView.cbCollector1Type, sdmView.collector1Type, config.heatCollector1Type);
			updateData2Combox(sdmView.cbCollector2Type, sdmView.collector2Type, config.heatCollector2Type);
			updateData2Combox(sdmView.cbCollector3Type, sdmView.collector3Type, config.heatCollector3Type);
			updateData2Combox(sdmView.cbAuxiliaryType, sdmView.auxiliaryType, config.auxiliaryType);
			
			// 填充燃油、燃气类型
			sdmView.cbOilType.dataProvider = oilList;
			sdmView.cbGasType.dataProvider = gasList;
			
			// 燃油类型/燃气类型可
			if(sdmView.cbAuxiliaryType.selectedLabel == "燃油辅助"){
				sdmView.cbOilType.enabled = true;
				sdmView.cbGasType.enabled = false;
				// 抓取填充燃油类型资料并按值选定燃油类型
				updateData2Combox(sdmView.cbOilType, oilList, config.auxiliaryFuelId);
				
			}else if(sdmView.cbAuxiliaryType.selectedLabel == "燃气辅助"){
				sdmView.cbOilType.enabled = false;
				sdmView.cbGasType.enabled = true;
				// 抓取填充燃气类型资料并按值选定燃气类型
				updateData2Combox(sdmView.cbGasType, gasList, config.auxiliaryFuelId);
			}
			
			// 更新Text
			sdmView.txtTotalWaterFactor.text		= config.totalWaterFactor.toString();
			sdmView.txtTotalEleFactor.text 			= config.totalEleFactor.toString();
			sdmView.txtHeatSupplyFactor.text		= config.heatSupplyFactor.toString();
			sdmView.txtBackWaterFactor.text 		= config.backWaterFactor.toString();
			sdmView.txtHeatCollector1Factor.text	= config.heatCollector1Factor.toString();
			sdmView.txtHeatCollector2Factor.text	= config.heatCollector2Factor.toString();
			sdmView.txtHeatCollector3Factor.text	= config.heatCollector3Factor.toString();
			sdmView.txtAuxiliaryEleFactor.text		= config.auxiliaryEleFactor.toString();
			sdmView.txtAirHeat_COP.text				= config.airHeat_COP.toString();
			
			// 系统泵阀配置项
			sdmView.rgWaterInflowCollector1Type.selectedValue 	= config.waterInflowCollector1Type.toString();
			sdmView.rgWaterInflowCollector2Type.selectedValue	= config.waterInflowCollector2Type.toString();
			sdmView.rgWaterInflowCollector3Type.selectedValue	= config.waterInflowCollector3Type.toString();
			
			sdmView.chbCPumpCollector1Status.selected			= (config.cPumpCollector1Status == 1)? true : false;
			sdmView.chbCPumpCollector2Status.selected			= (config.cPumpCollector2Status == 1)? true : false;
			sdmView.chbCPumpCollector3Status.selected			= (config.cPumpCollector3Status == 1)? true : false;
			
			sdmView.rgPSWaterAddPumpType.selectedValue			= config.pSWaterAddPumpType.toString();
			sdmView.rgPSCirclePumpType.selectedValue			= config.pSCirclePumpType.toString();
			sdmView.rgAWaterAddPumpType.selectedValue			= config.aWaterAddPumpType.toString();
			
			sdmView.chbBackwaterCirclePumpStatus.selected		= (config.backwaterCirclePumpStatus == 1)? true : false;
			sdmView.chbBackwaterEleValveStatus.selected			= (config.backwaterEleValveStatus == 1)? true : false;
			sdmView.chbSupplyHeatCirclePumpStatus.selected		= (config.supplyHeatCirclePumpStatus == 1)? true : false;
			sdmView.chbSupplyHeatEleValveStatus.selected		= (config.supplyHeatEleValveStatus == 1)? true : false;
			sdmView.chbAHeatAddCirclePumpStatus.selected		= (config.aHeatAddCirclePumpStatus == 1)? true : false;
			sdmView.chbAHeatAddEleValveStatus.selected			= (config.aHeatAddEleValveStatus == 1)? true : false;
			
		}
		
		
		
		
		
		public function get sdmView(): SystemDataModeView {
			return viewComponent as SystemDataModeView;
		}
		
		public function initEventListener():void {
			sdmView.addEventListener(SystemDataModeView.CLOSE_DATAMODE_VIEW, closeViewHandler);
			sdmView.addEventListener(SystemDataModeView.QUERY_DATAMODE_VIEW, queryHandler);
			sdmView.addEventListener(SystemDataModeView.SAVE_DATAMODE_VIEW, saveHandler);
		}
		
		public function closeViewHandler(e:Event):void {
			// lastOperation = SEARCH;
			// firstDisplayData = true;
			currentDataProxy.startQuery();
			PopUpManager.removePopUp(sdmView);
			this.setViewComponent(null);
			
			if(isFromSystemInstallationView) {
				isFromSystemInstallationView = false;
				var solarSystemManageMediator:SolarSystemManageMediator = SolarSystemManageMediator(facade.retrieveMediator(SolarSystemManageMediator.NAME));
				solarSystemManageMediator.showInstallStateWithoutAuthority();
			}
			
		}
		
		public function queryHandler(e:Event):void{
			getSystemDataModeViewData();
		}
		
		public function saveHandler(e:Event):void{
			var newConfig:SysMeterageUnitConfig = new SysMeterageUnitConfig();
			newConfig = sdmView.configBuf;
			
			// 不同辅助单元类型所对应的原料Id设置
			if(sdmView.cbAuxiliaryType.selectedLabel == "燃油辅助"){
				newConfig.auxiliaryFuelId = sdmView.cbOilType.selectedItem.data;
				newConfig.auxiliaryFuelName = sdmView.cbOilType.selectedLabel;
			}else if(sdmView.cbAuxiliaryType.selectedLabel == "燃气辅助"){
				newConfig.auxiliaryFuelId = sdmView.cbGasType.selectedItem.data;
				newConfig.auxiliaryFuelName = sdmView.cbGasType.selectedLabel;
			}else if(sdmView.cbAuxiliaryType.selectedLabel == "电锅炉辅助"){
				newConfig.auxiliaryFuelId = eleList[0].data;					// 电力（当量）
			}else if(sdmView.cbAuxiliaryType.selectedLabel == "热泵辅助"){
				newConfig.auxiliaryFuelId = heatList[0].data;					//  热力（当量）
			}else{
				newConfig.auxiliaryFuelId = 0;
				newConfig.auxiliaryFuelName = "";
			}
			
			
			
			var updatedStr:String = ""
					 + "TotalWaterType:" + newConfig.totalWaterType							// 总进水表_类型
					 + ";TotalWaterFactor:" + newConfig.totalWaterFactor					// 总进水表_倍率
					 + ";TotalEleType:" + newConfig.totalEleType							// 系统耗电_类型
					 + ";TotalEleFactor:" + newConfig.totalEleFactor						// 系统耗电_倍率
					 + ";HeatSupplyType:" + newConfig.heatSupplyType						// 供热单元_供热_类型
					 + ";HeatSupplyFactor:" + newConfig.heatSupplyFactor					// 供热单元_供热_倍率
					 + ";BackWaterType:" + newConfig.backWaterType							// 供热单元_回水_类型
					 + ";BackWaterFactor:" + newConfig.backWaterFactor						// 供热单元_回水_倍率
					 + ";HeatCollector1Type:" + newConfig.heatCollector1Type				// 集热Ⅰ单元_类型
					 + ";HeatCollector1Factor:" + newConfig.heatCollector1Factor			// 集热Ⅰ单元_倍率
					 + ";HeatCollector2Type:" + newConfig.heatCollector2Type				// 集热Ⅱ单元_类型
					 + ";HeatCollector2Factor:" + newConfig.heatCollector2Factor			// 集热Ⅱ单元_倍率
					 + ";HeatCollector3Type:" + newConfig.heatCollector3Type				// 集热Ⅲ单元_类型
					 + ";HeatCollector3Factor:" + newConfig.heatCollector3Factor			// 集热Ⅲ单元_倍率
					 + ";AuxiliaryType:" + newConfig.auxiliaryType							// 辅助单元_类型
					 + ";AuxiliaryEleFactor:" + newConfig.auxiliaryEleFactor				// 辅助单元_倍率（辅助表互感系数）
					 + ";AirHeat_COP:" + newConfig.airHeat_COP								// 辅助单元_效率（辅助设备转化效率）
					 + ";AuxiliaryFuelId:" + newConfig.auxiliaryFuelId						// 燃料具体类型
					 + ";WaterInflowCollector1Type:" + newConfig.waterInflowCollector1Type	// 集Ⅰ进水泵阀类型
					 + ";WaterInflowCollector2Type:" + newConfig.waterInflowCollector2Type	// 集Ⅱ进水泵阀类型
					 + ";WaterInflowCollector3Type:" + newConfig.waterInflowCollector3Type	// 集Ⅲ进水泵阀类型
					 + ";CPumpCollector1Status:" + newConfig.cPumpCollector1Status			// 集I循环泵安装与否
					 + ";CPumpCollector2Status:" + newConfig.cPumpCollector2Status			// 集II循环泵安装与否
					 + ";CPumpCollector3Status:" + newConfig.cPumpCollector3Status			// 集III循环泵安装与否
					 + ";PSWaterAddPumpType:" + newConfig.pSWaterAddPumpType				// 产供补水泵阀类型
					 + ";PSCirclePumpType:" + newConfig.pSCirclePumpType					// 产供循环泵阀类型
					 + ";AWaterAddPumpType:" + newConfig.aWaterAddPumpType					// 辅助补水泵阀类型
					 + ";BackwaterCirclePumpStatus:" + newConfig.backwaterCirclePumpStatus	// 回水循环泵状态
					 + ";BackwaterEleValveStatus:" + newConfig.backwaterEleValveStatus		// 回水电动阀状态
					 + ";SupplyHeatCirclePumpStatus:" + newConfig.supplyHeatCirclePumpStatus// 供热水循环泵状态
					 + ";SupplyHeatEleValveStatus:" + newConfig.supplyHeatEleValveStatus	// 供热水电动阀状态
					 + ";AHeatAddCirclePumpStatus:" + newConfig.aHeatAddCirclePumpStatus	// 辅助加热循环泵
					 + ";AHeatAddEleValveStatus:" + newConfig.aHeatAddEleValveStatus 		// 辅助加热电动阀
					 + ";IfUpload:0";														// 置配置更新标志，以使数据可以同步至企业端
	
			saveSystemMeterageUnitConfigProxy.saveSystemMeterageUnitConfig(loginProxy.getUserName()
						, loginProxy.getUserPassword(), currentDataProxy.getCurrentSystemID()
						, updatedStr);
			
			// 请求更新配置项信息
			isDataLoadedComplete--;
			getSystemMeterageUnitConfigProxy.getSystemMeterageUnitConfig(loginProxy.getUserName()
						, loginProxy.getUserPassword(), currentDataProxy.getCurrentSystemID());
						
			
		}
		
		
	}
}