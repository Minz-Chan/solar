package com.fallmind.solars.model
{
	import com.fallmind.solars.model.bussiness.SolarDelegate;
	
	import mx.rpc.IResponder;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;

	import com.fallmind.solars.ApplicationFacade;
	public class EditSolarSystemProxy extends Proxy implements IProxy, IResponder
	{
		public static const NAME:String = "EditSolarSytemProxy";
		public static const EDIT_SOLARSYSTEM_SUCCESS:String = "EditSolarSystemSuccess";
		public static const EDIT_SOLARSYSTEM_FAILED:String = "EditSolarSystemFailed";
		
		public function EditSolarSystemProxy(data:Object = null)
		{
			super(NAME, data);
			
		}
		/**
		 * 修改太阳能系统的信息
		 */
		public function editSolarSystem(userName:String, password:String, systemID:String, systemName:String, manager:String, managerPhone:String, armID:String, setupTime:String, imageURL:String):void {
			var delegate:SolarDelegate = new SolarDelegate(this);
			delegate.editSolarSystem(userName, password, systemID, systemName, manager, managerPhone, armID, setupTime, imageURL);
		}
		public function result(rpcEvent:Object):void {
			sendNotification(EDIT_SOLARSYSTEM_SUCCESS, rpcEvent.result);
		}
		public function fault(rpcEvent:Object):void {
			sendNotification(ApplicationFacade.CONNECT_WEBSERVICE_FAILED, "EditSolarSystem");
		}
	}
}