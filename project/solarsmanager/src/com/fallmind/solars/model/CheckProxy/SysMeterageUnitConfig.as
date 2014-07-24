package com.fallmind.solars.model.CheckProxy
{
	public class SysMeterageUnitConfig
	{
		/**
		 * 保存太阳能系统可配置项的数据结构
		 */
		 public var systemId:int;					// 当前系统ID
		 public var totalWaterType:int;				// 总进水表_类型
		 public var totalWaterFactor:int;			// 总进水表_倍率
		 public var totalEleType:int;				// 系统耗电_类型
		 public var totalEleFactor:int;				// 系统耗电_倍率
		 public var heatSupplyType:int;				// 供热单元_供热_类型
		 public var heatSupplyFactor:int;			// 供热单元_供热_倍率
		 public var backWaterType:int;				// 供热单元_回水_类型
		 public var backWaterFactor:int;			// 供热单元_回水_倍率
		 public var heatCollector1Type:int;			// 集热Ⅰ单元_类型
		 public var heatCollector1Factor:int;		// 集热Ⅰ单元_倍率
		 public var heatCollector2Type:int;			// 集热Ⅱ单元_类型
		 public var heatCollector2Factor:int;		// 集热Ⅱ单元_倍率
		 public var heatCollector3Type:int;			// 集热Ⅲ单元_类型
		 public var heatCollector3Factor:int;		// 集热Ⅲ单元_倍率
		 public var auxiliaryType:int;				// 辅助单元_类型(计量表)
		 public var auxiliaryDeviceType:int;		// 辅助单元_类型(设备)
		 public var auxiliaryEleFactor:int;			// 辅助单元_倍率（辅助表互感系数）
		 public var airHeat_COP:int;				// 辅助单元_效率（辅助设备转化效率）
		 public var auxiliaryFuelId:int;			// 燃料具体类型
		 public var heatValue:int;					// 辅助原料热值
		 public var unit:String;					// 辅助原料计算单位
		 public var auxiliaryFuelName:String;		// 燃料具体类型名称
		 public var waterInflowCollector1Type:int;	// 集Ⅰ进水泵阀类型
		 public var waterInflowCollector2Type:int;	// 集Ⅱ进水泵阀类型
		 public var waterInflowCollector3Type:int;	// 集Ⅲ进水泵阀类型
		 public var cPumpCollector1Status:int;		// 集I循环泵安装与否
		 public var cPumpCollector2Status:int;		// 集II循环泵安装与否
		 public var cPumpCollector3Status:int;		// 集III循环泵安装与否
		 public var pSWaterAddPumpType:int;			// 产供补水泵阀类型
		 public var pSCirclePumpType:int;			// 产供循环泵阀类型
		 public var aWaterAddPumpType:int;			// 辅助补水泵阀类型
		 //public var backwaterPumpType:int;			// 回水泵阀类型
		 //public var supplyHeatPumpType:int;			// 供热水泵阀类型
		 //public var aHeatAddPumpType:int;			// 辅助加热泵阀类型
		 public var backwaterCirclePumpStatus:int;	// 回水循环泵状态
		 public var backwaterEleValveStatus:int;	// 回水电动阀状态
		 public var supplyHeatCirclePumpStatus:int;	// 供热水循环泵状态
		 public var supplyHeatEleValveStatus:int;	// 供热水电动阀状态
		 public var aHeatAddCirclePumpStatus:int;	// 辅助加热循环泵
		 public var aHeatAddEleValveStatus:int;		// 辅助加热电动阀
		 
	}
}