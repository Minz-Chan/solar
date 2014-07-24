package com.fallmind.solars.model
{
	import com.fallmind.solars.ApplicationFacade;
	import com.fallmind.solars.model.bussiness.SolarDelegate;
	
	import mx.rpc.IResponder;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class GetHistoryDataProxy extends Proxy implements IProxy, IResponder
	{
		public static const NAME:String = "GetHistoryDataProxy";
		public static const GET_HISTORYDATA_SUCCESS:String = "GetHistoryDataSuccess";
		public static const GET_HISTORYDATA_FAILED:String = "GetHistoryDataFailed";
		public function GetHistoryDataProxy(data:Object = null)
		{
			super(NAME, data);
			
		}
		// 获取历史数据
		public function GetHistoryData(userName:String, password:String, systemID:String, startTime:String, endTime:String, index:String, size:String):void {
			var delegate:SolarDelegate = new SolarDelegate(this);
			delegate.getHistoryData(userName, password, systemID, startTime, endTime, index, size);
		}
		
		public function result(rpcEvent:Object):void {
			setData(XML(rpcEvent.result));
			sendNotification(GET_HISTORYDATA_SUCCESS);
		}
		
		public function fault(rpcEvent:Object):void {
			sendNotification(ApplicationFacade.CONNECT_WEBSERVICE_FAILED, "GetHistoryData");	
		}
		
		public function get historyData():XML {
			return data as XML;
		}

	}
}