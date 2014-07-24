package com.fallmind.solars.model.CheckProxy
{
	import com.fallmind.solars.model.bussiness.SolarDelegate;
	
	import flash.events.TimerEvent;
	
	/**
	 * 设置太阳能系统密码
	 */
	public class CheckPasswordProxy extends CheckSetProxy {
		public static const NAME:String = "CheckPasswordSetupProxy";
		public static const CHECK_PASSWORD_SUCCESS:String = "CheckPasswordSuccess";
		public static const CHECK_PASSWORD_FAILED:String = "CheckPasswordFailed";
		public static const CHECK_PASSWORD_OVERTIME:String = "CheckPasswordOverTime";
		public static const CHECK_PASSWORD_WRONG:String = "CheckPasswordWrong";
		
		public var realPassword:String;
		
		public function CheckPasswordProxy(data:Object = null)
		{
			super(NAME, data);
			
			successStr = CHECK_PASSWORD_SUCCESS;
			failedStr = CHECK_PASSWORD_FAILED;
			overTimeStr = CHECK_PASSWORD_OVERTIME;
			wrongStr = CHECK_PASSWORD_WRONG;
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
			if(passwordData != result.SystemSetup.row[0].@ARM_Password) {
				return false;
			} else {
				return true;
			}
		}
		public function get passwordData():String {
			return data as String;
		}
	}
}