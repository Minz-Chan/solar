package com.fallmind.solars.model.CheckProxy
{
	import com.fallmind.solars.model.bussiness.SolarDelegate;
	
	import flash.events.TimerEvent;
	/**
	 *  检测主控器重启指令是否发送成功
	 */
	public class CheckARMRestartProxy extends CheckProxy
	{
		public static const NAME:String = "CheckARMRestartProxy";
		public static const CHECK_ARM_RESTART_SUCCESS:String = "CheckARMRestartSuccess";
		public static const CHECK_ARM_RESTART_FAILED:String = "CheckARMRestartFailed";
		public static const CHECK_ARM_RESTART_OVERTIME:String = "CheckARMRestartOverTime";
		
		
		public function CheckARMRestartProxy(data:Object = null)
		{
			super(NAME, data);
			
			successStr = CHECK_ARM_RESTART_SUCCESS;
			failedStr = CHECK_ARM_RESTART_FAILED;
			overTimeStr = CHECK_ARM_RESTART_OVERTIME;
		}
		public override function timerHandler(e:TimerEvent):void {
			var delegate:SolarDelegate = new SolarDelegate(this);
			delegate.checkOrder(userName, password, systemID, sendTime, CheckProxy.CHECK_ARM_RESTART);
		}	
	}
}