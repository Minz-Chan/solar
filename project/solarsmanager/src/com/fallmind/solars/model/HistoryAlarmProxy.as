package com.fallmind.solars.model
{
	import com.fallmind.solars.model.bussiness.SolarDelegate;
	
	import mx.rpc.IResponder;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	import com.fallmind.solars.ApplicationFacade;
	
	public class HistoryAlarmProxy extends Proxy implements IProxy, IResponder
	{
		public static const NAME:String = "HistoryAlarmProxy";
		public static const GET_HISTORY_ALARM_SUCCESS:String = "GetHistoryAlarmSuccess";
		public static const GET_HISTORY_ALARM_FAILED:String = "GetHistoryAlarmFailed";
		public function HistoryAlarmProxy(data:Object = null)
		{
			super(NAME, data);
		}
		// 获取历史警报
		public function getHistoryAlarm(userName:String, password:String, systemID:String, startTime:String, endTime:String):void {
			var delegate:SolarDelegate = new SolarDelegate(this);
			delegate.getHistoryAlarm(userName, password, systemID, startTime, endTime);
		}
		public function result(rpcEvent:Object):void {
			this.setData(XML(rpcEvent.result));
			sendNotification(GET_HISTORY_ALARM_SUCCESS);
		}
		public function fault(rpcEvent:Object):void {
			sendNotification(ApplicationFacade.CONNECT_WEBSERVICE_FAILED, "GetHistoryAlarm");
		}

	}
}