package com.fallmind.solars.model.CheckProxy
{
	import com.fallmind.solars.model.bussiness.SolarDelegate;
	
	import flash.events.TimerEvent;
	
	/**
	 * 检测获取系统参数指令是否发送成功
	 */
	public class CheckCurrentSetupProxy extends CheckProxy
	{
		public static const NAME:String = "CheckCurrentSetupProxy";
		public static const CHECK_CURRENT_SETUP_SUCCESS:String = "CheckCurrentSetupSuccess";
		public static const CHECK_CURRENT_SETUP_FAILED:String = "CheckCurrentSetupFailed";
		public static const CHECK_CURRENT_SETUP_OVERTIME:String = "CheckCurrentSetupOverTime";
		
		public function CheckCurrentSetupProxy(data:Object = null)
		{
			super(NAME, data);
			
			successStr = CHECK_CURRENT_SETUP_SUCCESS;
			failedStr = CHECK_CURRENT_SETUP_FAILED;
			overTimeStr = CHECK_CURRENT_SETUP_OVERTIME;
		}
		public override function timerHandler(e:TimerEvent):void {
			var delegate:SolarDelegate = new SolarDelegate(this);
			delegate.checkOrder(userName, password, systemID, sendTime, CheckProxy.CHECK_CURRENT_SETUP);
		}
		
	}
}