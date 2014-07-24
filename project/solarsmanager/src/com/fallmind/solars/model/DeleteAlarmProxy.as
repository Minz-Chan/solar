package com.fallmind.solars.model
{
	import com.fallmind.solars.model.bussiness.SolarDelegate;
	
	import mx.rpc.IResponder;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	import com.fallmind.solars.ApplicationFacade;
	
	public class DeleteAlarmProxy extends Proxy implements IProxy, IResponder
	{
		public static const NAME:String = "DeleteAlarmProxy";
		public static const DELETE_ALARM_SUCCESS:String = "DeleteAlarmSuccess";
		public function DeleteAlarmProxy(data:Object = null)
		{
			super(NAME, data);
		}
		/**
		 * 删除警告
		 * @param userName 用户名
		 * @param password 密码
		 * @param alarmIDArray 要删除的警告ID数组
		 */
		public function deleteAlarm(userName:String, password:String, alarmID:String):void {
			var delegate:SolarDelegate = new SolarDelegate(this);
			delegate.deleteAlarm(userName, password, alarmID);
		}
		public function result(rpcEvent:Object):void {
			sendNotification(DELETE_ALARM_SUCCESS);
		}
		public function fault(rpcEvent:Object):void {
			sendNotification(ApplicationFacade.CONNECT_WEBSERVICE_FAILED, "DeleteAlarm");
		}
	}
}