package com.fallmind.solars.model
{
	import com.fallmind.solars.model.bussiness.SolarDelegate;
	
	import mx.rpc.IResponder;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	import com.fallmind.solars.ApplicationFacade;
	
	public class SelfCheckProxy extends Proxy implements IProxy, IResponder
	{
		public static const NAME:String = "SelfCheckProxy";
		public static const GET_SELF_CHECK_SUCCESS:String = "GetSelfCheckSuccess";
		
		public function SelfCheckProxy(data:Object = null)
		{
			super(NAME, data);
		}
		// 自检
		public function selfCheck(username:String, password:String, systemID:String):void {
			var delegate:SolarDelegate = new SolarDelegate(this);
			delegate.selfCheck(username, password, systemID);
		}
		public function result(rpcEvent:Object):void {
			setData(XML(rpcEvent.result));
			sendNotification(GET_SELF_CHECK_SUCCESS);
		}
		public function fault(rpcEvent:Object):void {
			sendNotification(ApplicationFacade.CONNECT_WEBSERVICE_FAILED,"SelfCheck");
		}

	}
}