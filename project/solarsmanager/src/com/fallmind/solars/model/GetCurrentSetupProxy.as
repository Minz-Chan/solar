package com.fallmind.solars.model
{
	import com.fallmind.solars.model.bussiness.SolarDelegate;
	
	import mx.rpc.IResponder;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	import com.fallmind.solars.ApplicationFacade;
	
	public class GetCurrentSetupProxy extends Proxy implements IProxy, IResponder
	{
		public static const NAME:String = "GetCurrentSetupProxy";
		public static const GET_CURRENT_SETUP_SUCCESS:String = "GetCurrentSetupSuccess";
		public static const GET_CURRENT_SETUP_FAILED:String = "GetCurrentSetupFailed";
		public function GetCurrentSetupProxy(data:Object = null)
		{
			super(NAME, data);
		}
		// 获取当前系统设置
		public function getCurrentSetup(userName:String, password:String, systemID:String):void {
			var delegate:SolarDelegate = new SolarDelegate(this);
			delegate.getCurrentSetup(userName, password, systemID);
		}
		public function result(rpcEvent:Object):void {
			setData(XML(rpcEvent.result));
			sendNotification(GET_CURRENT_SETUP_SUCCESS);
		}
		public function fault(rpcEvent:Object):void {
			sendNotification(ApplicationFacade.CONNECT_WEBSERVICE_FAILED, "GetCurrentSetup");
		}

	}
}