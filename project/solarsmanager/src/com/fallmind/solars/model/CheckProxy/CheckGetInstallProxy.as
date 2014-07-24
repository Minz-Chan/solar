// ActionScript file
// ActionScript file
package com.fallmind.solars.model.CheckProxy
{
	import com.fallmind.solars.model.bussiness.SolarDelegate;
	
	import flash.events.TimerEvent;
	
	/**
	 * 验证获取系统安装情况是否执行成功
	 */
	public class CheckGetInstallProxy extends CheckProxy
	{
		public static const NAME:String = "CheckGetInstallProxy";
		public static const CHECK_GET_INSTALL_SUCCESS:String = "CheckGetInstallSuccess";
		public static const CHECK_GET_INSTALL_FAILED:String = "CheckGetInstallFailed";
		public static const CHECK_GET_INSTALL_OVERTIME:String = "CheckGetInstallOverTime";
		
		public function CheckGetInstallProxy(data:Object = null)
		{
			super(NAME, data);
			
			successStr = CHECK_GET_INSTALL_SUCCESS;
			failedStr = CHECK_GET_INSTALL_FAILED;
			overTimeStr = CHECK_GET_INSTALL_OVERTIME;
		}
		public override function timerHandler(e:TimerEvent):void {
			var delegate:SolarDelegate = new SolarDelegate(this);
			delegate.checkOrder(userName, password, systemID, sendTime, CheckProxy.CHECK_CURRENT_SETUP);
		}
		
	}
}