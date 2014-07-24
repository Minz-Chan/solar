// ActionScript file
package com.fallmind.solars.model.CheckProxy
{
	import com.fallmind.solars.model.bussiness.SolarDelegate;
	
	import flash.events.TimerEvent;
	/**
	 * 验证获取系统默认参数的指令是否执行成功
	 */
	public class CheckGetSeasonSetupProxy extends CheckProxy
	{
		public static const NAME:String = "CheckGetSeasonSetupProxy";
		public static const CHECK_GET_SEASON_SETUP_SUCCESS:String = "CheckGetSeasonSetupSuccess";
		public static const CHECK_GET_SEASON_SETUP_FAILED:String = "CheckGetSeasonSetupFailed";
		public static const CHECK_GET_SEASON_SETUP_OVERTIME:String = "CheckGetSeasonSetupOverTime";
		
		public function CheckGetSeasonSetupProxy(data:Object = null)
		{
			super(NAME, data);
			
			successStr = CHECK_GET_SEASON_SETUP_SUCCESS;
			failedStr = CHECK_GET_SEASON_SETUP_FAILED;
			overTimeStr = CHECK_GET_SEASON_SETUP_OVERTIME;
		}
		public override function timerHandler(e:TimerEvent):void {
			var delegate:SolarDelegate = new SolarDelegate(this);
			delegate.checkOrder(userName, password, systemID, sendTime, CheckProxy.CHECK_SEASON_SETUP);
		}
		
	}
}