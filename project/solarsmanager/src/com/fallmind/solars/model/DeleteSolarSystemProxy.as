package com.fallmind.solars.model
{
	import mx.rpc.IResponder;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	import com.fallmind.solars.model.bussiness.SolarDelegate;
	import com.fallmind.solars.ApplicationFacade;
	
	public class DeleteSolarSystemProxy extends Proxy implements IProxy, IResponder
	{
		public static const NAME:String = "DeleteSolarSystemProxy";
		public static const DELETE_SOLARSYSTEM_SUCCESS:String = "DeleteSolarSystemSuccess";
		public static const DELETE_SOLARSYSTEM_FAILED:String = "DeleteSolarSystemFailed";
		public function DeleteSolarSystemProxy(data:Object = null)
		{
			super(NAME, data);
		}
		
		public function result(rpcEvent:Object):void {
			sendNotification(DELETE_SOLARSYSTEM_SUCCESS, rpcEvent.result);
		}
		public function fault(rpcEvent:Object):void {
			sendNotification(ApplicationFacade.CONNECT_WEBSERVICE_FAILED, "DeleteSolarSystem");
		}
		/**
		 * 根据系统ID，删除太阳能系统
		 */
		public function deleteSolarSystem(userName:String, password:String, systemID:String):void {
			var solarDelegate:SolarDelegate = new SolarDelegate(this);
			solarDelegate.deleteSolarSystem(userName, password, systemID);
		}
	}
}