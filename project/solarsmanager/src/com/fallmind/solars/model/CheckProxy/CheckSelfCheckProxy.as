package com.fallmind.solars.model.CheckProxy
{
	import com.fallmind.solars.model.bussiness.SolarDelegate;
	
	import flash.events.TimerEvent;
	/**
	 * 判断自检指令是否成功
	 */
	public class CheckSelfCheckProxy extends CheckProxy
	{
		public static const NAME:String = "CheckSelfCheckProxy";
		public static const CHECK_SELF_CHECK_SUCCESS:String = "CheckSelfCheckSuccess";
		public static const CHECK_SELF_CHECK_FAILED:String = "CheckSelfCheckFailed";
		public static const CHECK_SELF_CHECK_OVERTIME:String = "CheckSelfCheckOverTime";
		
		public function CheckSelfCheckProxy(data:Object = null)
		{
			super(NAME, data);
			
			successStr = CHECK_SELF_CHECK_SUCCESS;
			failedStr = CHECK_SELF_CHECK_FAILED;
			overTimeStr = CHECK_SELF_CHECK_OVERTIME;
		}
		public override function timerHandler(e:TimerEvent):void {
			var delegate:SolarDelegate = new SolarDelegate(this);
			delegate.checkSelfCheck(userName, password, systemID, sendTime);
		}
		public override function result(rpcEvent:Object):void {
			if(rpcEvent.result != null) {
				this.setData(XML(rpcEvent.result));
				timer.stop();
				sendNotification(successStr);
			} else {
				if(timer.currentCount == int(overTime / checkTime)) {
					sendNotification(overTimeStr);
					return;
				}
				sendNotification(failedStr);
			}
		}
		
	}
}