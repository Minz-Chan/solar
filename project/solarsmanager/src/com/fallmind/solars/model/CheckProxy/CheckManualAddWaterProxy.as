package com.fallmind.solars.model.CheckProxy
{
	import com.fallmind.solars.model.bussiness.SolarDelegate;
	
	import flash.events.TimerEvent;
	/**
	 * 检测手动加水指令是否发送成功
	 */
	public class CheckManualAddWaterProxy extends CheckProxy
	{
		public static const NAME:String = "CheckManualAddWaterProxy";
		public static const CHECK_MANUAL_ADD_WATER_SUCCESS:String = "CheckManualAddWaterSuccess";
		public static const CHECK_MANUAL_ADD_WATER_FAILED:String = "CheckManualAddWaterFailed";
		public static const CHECK_MANUAL_ADD_WATER_OVERTIME:String = "CheckManualAddWaterOverTime";
		
		public function CheckManualAddWaterProxy(data:Object = null)
		{
			super(NAME, data);
			
			successStr = CHECK_MANUAL_ADD_WATER_SUCCESS;
			failedStr = CHECK_MANUAL_ADD_WATER_FAILED;
			overTimeStr = CHECK_MANUAL_ADD_WATER_OVERTIME;
		}
		public override function timerHandler(e:TimerEvent):void {
			var delegate:SolarDelegate = new SolarDelegate(this);
			delegate.checkOrder(userName, password, systemID, sendTime, CheckProxy.CHECK_MANUAL_ADD_WATER);
		}
	}
}