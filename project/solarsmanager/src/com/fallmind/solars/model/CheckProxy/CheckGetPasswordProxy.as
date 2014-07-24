// ActionScript file
// ActionScript file
package com.fallmind.solars.model.CheckProxy
{
	import com.fallmind.solars.model.bussiness.SolarDelegate;
	
	import flash.events.TimerEvent;
	
	/**
	 * 验证获取密码指令是否执行成功
	 */
	public class CheckGetPasswordProxy extends CheckProxy
	{
		public static const NAME:String = "CheckGetPasswordProxy";
		public static const CHECK_GET_PASSWORD_SUCCESS:String = "CheckGetPasswordSuccess";
		public static const CHECK_GET_PASSWORD_FAILED:String = "CheckGetPasswordFailed";
		public static const CHECK_GET_PASSWORD_OVERTIME:String = "CheckGetPasswordOverTime";
		
		public function CheckGetPasswordProxy(data:Object = null)
		{
			super(NAME, data);
			
			successStr = CHECK_GET_PASSWORD_SUCCESS;
			failedStr = CHECK_GET_PASSWORD_FAILED;
			overTimeStr = CHECK_GET_PASSWORD_OVERTIME;
		}
		public override function timerHandler(e:TimerEvent):void {
			var delegate:SolarDelegate = new SolarDelegate(this);
			delegate.checkOrder(userName, password, systemID, sendTime, CheckProxy.CHECK_CURRENT_SETUP);
		}
		
	}
}