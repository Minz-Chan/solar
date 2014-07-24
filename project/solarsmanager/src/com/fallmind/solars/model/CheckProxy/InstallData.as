// ActionScript file
package com.fallmind.solars.model.CheckProxy {
	/**
	 * 保存太阳能系统当前安装情况的数据结构
	 */
	public class InstallData {
		public var j1State:int;
		public var j2State:int;
		public var j3State:int;
		public var jConnect:int;
		public var circleConnect:int;
		public var airPumpState:int;
		public var airStart:int;
		public var airPumpConnect:int;
		public var elecPumpState:int;
		public var elecStart:int;
		public var elecPumpConnect:int;
		public var coldPumpState:int;
		public var coldPumpConnect:int;
		public var Collector_Cubage:String;
		public var ProductBox_Cubage:String;
		public var ProductBox_height:String;
		public var PLSensorRange:String;
		public var OfferBox_Cubage:String;
		public var OfferBox_height:String;
		public var OLSensorRange:String;
		public var AirHeat_COP:String;
		public var ElecHeat_Value:String;
		public var ElecHeat_Efficient:String;
		public var ElecFactor:Number;
		public var ExtraElecFactor:Number;
		
		public var ColdHose_Fix:int;
		public var Collector_in_line_Fix:int;
	}
}