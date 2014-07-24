package com.fallmind.solars.model.CheckProxy
{
	import com.fallmind.solars.model.bussiness.SolarDelegate;
	
	import flash.events.TimerEvent;
	/**
	 * 检测手动加热指令是否发送成功
	 */
	public class CheckManualAddTempProxy extends CheckProxy
	{
		public static const NAME:String = "CheckManualAddTempProxy";
		public static const CHECK_MANUAL_ADD_TEMP_SUCCESS:String = "CheckManualAddTempSuccess";
		public static const CHECK_MANUAL_ADD_TEMP_FAILED:String = "CheckManualAddTempFailed";
		public static const CHECK_MANUAL_ADD_TEMP_OVERTIME:String = "CheckManualAddTempOverTime";
		
		public function CheckManualAddTempProxy(data:Object = null)
		{
			super(NAME, data);
			
			successStr = CHECK_MANUAL_ADD_TEMP_SUCCESS;
			failedStr = CHECK_MANUAL_ADD_TEMP_FAILED;
			overTimeStr = CHECK_MANUAL_ADD_TEMP_OVERTIME;
		}
		public override function timerHandler(e:TimerEvent):void {
			var delegate:SolarDelegate = new SolarDelegate(this);
			delegate.checkOrder(userName, password, systemID, sendTime, CheckProxy.CHECK_MANUAL_ADD_TEMP);
		}
	}
}