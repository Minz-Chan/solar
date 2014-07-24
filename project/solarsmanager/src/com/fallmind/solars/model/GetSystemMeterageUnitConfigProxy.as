package com.fallmind.solars.model
{
	import com.fallmind.solars.model.CheckProxy.SysMeterageUnitConfig;
	import com.fallmind.solars.model.bussiness.SolarDelegate;
	
	import mx.rpc.IResponder;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;

	/**
	 * 获取系统相关计量单元配置项的代理类 
	 */
	public class GetSystemMeterageUnitConfigProxy extends Proxy implements IProxy, IResponder
	{
		public static const NAME:String = "GetSystemMeterageUnitConfigProxy";
		public static const GET_SYSTEM_METERAGEUNIT_SUCCESS:String = "GetSystemMeterageUnitConfigSuccess";
		public static const GET_SYSTEM_METERAGEUNIT_FAILURE:String = "GetSystemMeterageUnitConfigFailure";
		
		private var config:SysMeterageUnitConfig;
		
		public function GetSystemMeterageUnitConfigProxy(data:Object = null)
		{
			super(NAME, data);
		}
		
		public function getSystemMeterageUnitConfig(userName:String, password:String, systemId:String):void
		{
			var delegate:SolarDelegate = new SolarDelegate(this);
			delegate.getSystemMeterageUnitConfig(userName, password, systemId);
		}
		
		public function result(data:Object):void
		{
			setData(XML(data.result));
			setSysMeterageUnitConfig(XML(data.result));
			sendNotification(GetSystemMeterageUnitConfigProxy.GET_SYSTEM_METERAGEUNIT_SUCCESS);
		}
		
		public function fault(info:Object):void
		{
			sendNotification(GetSystemMeterageUnitConfigProxy.GET_SYSTEM_METERAGEUNIT_FAILURE);
		}
		
		/**
		 * 将返回的XML结构与SysMeterageUnitConfig结构绑定
		 */ 
		public function setSysMeterageUnitConfig(data:XML):void{
			if(config == null){
				config = new SysMeterageUnitConfig();
			}
			
			var xmlConfig:XMLList = XMLList(data.children()[0]);
			config.systemId 					= Number(xmlConfig[0].@System_ID.toString());
			config.totalWaterType 				= Number(xmlConfig[0].@TotalWaterType.toString());				// 总进水表_类型
			config.totalWaterFactor 			= Number(xmlConfig[0].@TotalWaterFactor.toString());			// 总进水表_倍率
			config.totalEleType					= Number(xmlConfig[0].@TotalEleType.toString());				// 系统耗电_类型
			config.totalEleFactor				= Number(xmlConfig[0].@TotalEleFactor.toString());				// 系统耗电_倍率
			config.heatSupplyType 				= Number(xmlConfig[0].@HeatSupplyType.toString());				// 供热单元_供热_类型
			config.heatSupplyFactor 			= Number(xmlConfig[0].@HeatSupplyFactor.toString());			// 供热单元_供热_倍率
			config.backWaterType 				= Number(xmlConfig[0].@BackWaterType.toString());				// 供热单元_回水_类型
			config.backWaterFactor 				= Number(xmlConfig[0].@BackWaterFactor.toString());				// 供热单元_回水_倍率
			config.heatCollector1Type 			= Number(xmlConfig[0].@HeatCollector1Type.toString());			// 集热Ⅰ单元_类型
			config.heatCollector1Factor 		= Number(xmlConfig[0].@HeatCollector1Factor.toString());		// 集热Ⅰ单元_倍率
			config.heatCollector2Type 			= Number(xmlConfig[0].@HeatCollector2Type.toString());			// 集热Ⅱ单元_类型
			config.heatCollector2Factor			= Number(xmlConfig[0].@HeatCollector2Factor.toString());		// 集热Ⅱ单元_倍率
			config.heatCollector3Type 			= Number(xmlConfig[0].@HeatCollector3Type.toString());			// 集热Ⅲ单元_类型
			config.heatCollector3Factor 		= Number(xmlConfig[0].@HeatCollector3Factor.toString());		// 集热Ⅲ单元_倍率
			config.auxiliaryType 				= Number(xmlConfig[0].@AuxiliaryType.toString());				// 辅助单元_类型(计量表)
			config.auxiliaryDeviceType 			= Number(xmlConfig[0].@AirHeat_Fix.toString().charAt(0));		// 辅助单元_类型(设备)
			config.auxiliaryEleFactor			= Number(xmlConfig[0].@AuxiliaryEleFactor.toString());			// 辅助单元_倍率（辅助表互感系数）
			config.airHeat_COP					= Number(xmlConfig[0].@AirHeat_COP.toString());					// 辅助单元_效率（辅助设备转化效率）
			config.auxiliaryFuelId 				= Number(xmlConfig[0].@AuxiliaryFuelId.toString());				// 燃料具体类型
			config.heatValue					= Number(xmlConfig[0].@HeatValue.toString());	
			config.unit							= xmlConfig[0].@Unit.toString();
			config.auxiliaryFuelName 			= xmlConfig[0].@AuxiliaryFuelName.toString();					// 燃料具体类型名称
			config.waterInflowCollector1Type 	= Number(xmlConfig[0].@WaterInflowCollector1Type.toString());	// 集Ⅰ进水泵阀类型
			config.waterInflowCollector2Type 	= Number(xmlConfig[0].@WaterInflowCollector2Type.toString());	// 集Ⅱ进水泵阀类型
			config.waterInflowCollector3Type	= Number(xmlConfig[0].@WaterInflowCollector3Type.toString());	// 集Ⅲ进水泵阀类型
			config.cPumpCollector1Status	 	= Number(xmlConfig[0].@CPumpCollector1Status.toString());		// 集I循环泵安装与否
			config.cPumpCollector2Status	 	= Number(xmlConfig[0].@CPumpCollector2Status.toString());		// 集II循环泵安装与否
			config.cPumpCollector3Status 		= Number(xmlConfig[0].@CPumpCollector3Status.toString());		// 集III循环泵安装与否
			config.pSWaterAddPumpType 			= Number(xmlConfig[0].@PSWaterAddPumpType.toString());			// 产供补水泵阀类型
			config.pSCirclePumpType 			= Number(xmlConfig[0].@PSCirclePumpType.toString());			// 产供循环泵阀类型
			config.aWaterAddPumpType 			= Number(xmlConfig[0].@AWaterAddPumpType.toString());			// 辅助补水泵阀类型
			//config.backwaterPumpType = Number(xmlConfig[0].@BackwaterPumpType.toString());				
			//config.supplyHeatPumpType = Number(xmlConfig[0].@SupplyHeatPumpType.toString());				
			//config.aHeatAddPumpType = Number(xmlConfig[0].@AHeatAddPumpType.toString());					
			config.backwaterCirclePumpStatus 	= Number(xmlConfig[0].@BackwaterCirclePumpStatus.toString());		// 回水循环泵状态
			config.backwaterEleValveStatus 		= Number(xmlConfig[0].@BackwaterEleValveStatus.toString());			// 回水电动阀状态
		 	config.supplyHeatCirclePumpStatus 	= Number(xmlConfig[0].@SupplyHeatCirclePumpStatus.toString());	// 供热水循环泵状态
		 	config.supplyHeatEleValveStatus 	= Number(xmlConfig[0].@SupplyHeatEleValveStatus.toString());		// 供热水电动阀状态
		 	config.aHeatAddCirclePumpStatus 	= Number(xmlConfig[0].@AHeatAddCirclePumpStatus.toString());		// 辅助加热循环泵
		 	config.aHeatAddEleValveStatus 		= Number(xmlConfig[0].@AHeatAddEleValveStatus.toString());			// 辅助加热电动阀
		}

		public function getConfig():SysMeterageUnitConfig{
			return config;
		}
		
	}
}