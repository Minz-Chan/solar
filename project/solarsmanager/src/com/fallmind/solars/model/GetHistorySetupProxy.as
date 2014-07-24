package com.fallmind.solars.model
{
	import com.fallmind.solars.model.bussiness.SolarDelegate;
	
	import mx.rpc.IResponder;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	import com.fallmind.solars.ApplicationFacade;
	
	public class GetHistorySetupProxy extends Proxy implements IProxy, IResponder
	{
		public static const NAME:String = "GetHistorySetupProxy";
		public static const GET_HISTORYSETUP_SUCCESS:String = "GetHistorySetupSuccess";
		public static const GET_HISTORYSETUP_FAILED:String = "GetHistorySetupFailed";
		public function GetHistorySetupProxy(data:Object = null)
		{
			super(NAME, data);
			
		}
		// 获取历史设置
		public function GetHistorySetup(userName:String, password:String, systemID:String, startTime:String, endTime:String):void {
			var delegate:SolarDelegate = new SolarDelegate(this);
			delegate.getHistorySetup(userName, password, systemID, startTime, endTime);
		}
		
		public function result(rpcEvent:Object):void {
			setData(XML(rpcEvent.result));
			sendNotification(GET_HISTORYSETUP_SUCCESS);
		}
		
		public function fault(rpcEvent:Object):void {
			sendNotification(ApplicationFacade.CONNECT_WEBSERVICE_FAILED, "GetHistorySetup");	
		}
		
		public function get historySetup():XML {
			return data as XML;
		}

	}
}