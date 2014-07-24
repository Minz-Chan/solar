// ActionScript file
package com.fallmind.solars.model.CheckProxy {
	import com.fallmind.solars.model.Convert;
	import com.fallmind.solars.model.bussiness.ConfigManager;
	import com.fallmind.solars.model.bussiness.SolarDelegate;
	
	import flash.events.TimerEvent;
	/**
	 * 判断设置系统时间的指令是否发送成功
	 */
	public class CheckSetTimeProxy extends CheckSetProxy {
		public static const NAME:String = "CheckSetTimeProxy";
		public static const CHECK_SET_TIME_OVERTIME:String = "CheckSetTimeOvertime";// 指令超时发送的事件
		public static const CHECK_SET_TIME_FAILED:String = "CheckSetTimeFailed";	// 指令正在发送的事件
 		public static const CHECK_SET_TIME_SUCCESS:String = "CheckSetTimeSuccess";// 指令执行成功发送的事件
		public static const CHECK_SET_TIME_WRONG:String = "CheckSetTimeWrong";	// 当设置不成功时发送的事件
		
		private var config:ConfigManager;
		
		public var systemTime:String;
		
		public function CheckSetTimeProxy(data:Object = null) {
			super(NAME, data);
			
			successStr = CHECK_SET_TIME_SUCCESS;
			failedStr = CHECK_SET_TIME_FAILED;
			overTimeStr = CHECK_SET_TIME_OVERTIME;
			wrongStr = CHECK_SET_TIME_WRONG;
			
			config = ConfigManager.getManageManager();
		}
		public function get timeData():TimeData {
			return data as TimeData;
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
			var myTime:String = result.SystemSetup.row.@ARM_Time;
			systemTime = myTime;
			var myPattern:RegExp = /T/;
			myTime = myTime.replace(myPattern, " ");
			var date:Date = Convert.convertToDate(myTime);
			var userTime:Date = new Date(timeData.yearText, int(timeData.monthText) - 1, timeData.dayText, timeData.hourText, timeData.minuteText, timeData.secondText);
			// 如果太阳能系统返回的时间和设置的时间相差在超时时间内，说明设置成功，否则设置失败
			if(Math.abs(userTime.getTime() - date.getTime()) <= config.getOverTime()) {
				return true;
			} else {
				return false;
			}
					
		}
	}
}