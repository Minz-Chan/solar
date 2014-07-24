package com.fallmind.solars.model {
	import com.fallmind.solars.model.bussiness.SolarDelegate;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.IResponder;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	import com.fallmind.solars.ApplicationFacade;
	
	public class DeleteAllAlarmProxy extends Proxy implements IProxy, IResponder {
		public static const NAME:String = "DeleteAllAlarmProxy";
		public static const DELETE_ALL_ALARM_SUCCESS:String = "DeleteAllAlarmSuccess";
		public function DeleteAllAlarmProxy(data:Object = null) {
			super(NAME, data);
		}
		/**
		 * 删除所有警报数据
		 */
		public function deleteAllAlarm(userName:String, password:String, alarm:ArrayCollection):void {
			var delegate:SolarDelegate = new SolarDelegate(this);
			delegate.deleteAllAlarm(userName, password, alarm);
		}
		public function result(rpcEvent:Object):void {
			sendNotification(DELETE_ALL_ALARM_SUCCESS);
		}
		public function fault(rpcEvent:Object):void {
			sendNotification(ApplicationFacade.CONNECT_WEBSERVICE_FAILED, "DeleteAllAlarm");
		}
	}
}