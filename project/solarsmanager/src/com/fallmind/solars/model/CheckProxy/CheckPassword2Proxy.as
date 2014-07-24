// ActionScript file
package com.fallmind.solars.model.CheckProxy
{
	import com.fallmind.solars.model.bussiness.SolarDelegate;
	
	import flash.events.TimerEvent;
	
	import mx.formatters.DateFormatter;
	
	public class CheckPassword2Proxy extends CheckSetProxy {
		public static const NAME:String = "CheckPassword2SetupProxy";
		public static const CHECK_PASSWORD2_SUCCESS:String = "CheckPassword2Success";
		public static const CHECK_PASSWORD2_FAILED:String = "CheckPassword2Failed";
		public static const CHECK_PASSWORD2_OVERTIME:String = "CheckPassword2OverTime";
		public static const CHECK_PASSWORD2_WRONG:String = "CheckPassword2Wrong";
		
		public var realPassword:String;
		public function CheckPassword2Proxy(data:Object = null)
		{
			super(NAME, data);
			
			successStr = CHECK_PASSWORD2_SUCCESS;
			failedStr = CHECK_PASSWORD2_FAILED;
			overTimeStr = CHECK_PASSWORD2_OVERTIME;
			wrongStr = CHECK_PASSWORD2_WRONG;
		}
		protected override function timerHandler(e:TimerEvent):void {
			var delegate:SolarDelegate = new SolarDelegate(this);
			delegate.checkSetSetup(userName, password, systemID, sendTime);
		}
		protected override function completeHandler(e:TimerEvent):void {
			return;
		}
		/**
		 * 判断返回的设置值与用户希望的设置值是否相同
		 */
		protected override function check(result:XML):Boolean {
			realPassword = result.SystemSetup.row[0].@ARM_Password;
			if(userPassword != result.SystemSetup.row[0].@ARM_Password) {
				return false;
			} else {
				return true;
			}
		}
		public function get userPassword():String {
			return data as String;
		}
		public function setTime(date:Date):void {
			var time:String;
			var fr:DateFormatter = new DateFormatter();
			fr.formatString = "YYYY-MM-DD JJ:NN:SS";
			this.sendTime = fr.format(date);
		}
	}
}