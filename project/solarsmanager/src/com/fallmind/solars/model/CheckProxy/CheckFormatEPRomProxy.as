package com.fallmind.solars.model.CheckProxy
{
	import com.fallmind.solars.model.bussiness.SolarDelegate;
	
	import flash.events.TimerEvent;
	/**
	 *  判断格式化主控器指令是否发送成功
	 */
	public class CheckFormatEPRomProxy extends CheckProxy
	{
		public static const NAME:String = "CheckFormatEPRomProxy";
		public static const CHECK_FORMAT_EPROM_SUCCESS:String = "CheckFormatEPRomSuccess";
		public static const CHECK_FORMAT_EPROM_FAILED:String = "CheckFormatEPRomFailed";
		public static const CHECK_FORMAT_EPROM_OVERTIME:String = "CheckFormatEPRomOverTime";
		
		public function CheckFormatEPRomProxy(data:Object = null)
		{
			super(NAME, data);
			
			successStr = CHECK_FORMAT_EPROM_SUCCESS;
			failedStr = CHECK_FORMAT_EPROM_FAILED;
			overTimeStr = CHECK_FORMAT_EPROM_OVERTIME;
		}
		public override function timerHandler(e:TimerEvent):void {
			var delegate:SolarDelegate = new SolarDelegate(this);
			delegate.checkOrder(userName, password, systemID, sendTime, CheckProxy.CHECK_FORMAT_EPROM);
		}
	}
}