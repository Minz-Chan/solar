package com.fallmind.solars.model
{
	import com.fallmind.solars.model.bussiness.SolarDelegate;
	
	import mx.rpc.IResponder;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	import com.fallmind.solars.ApplicationFacade;
	
	public class GetRegionProxy extends Proxy implements IProxy, IResponder
	{
		public static const NAME:String = "GetRegionProxy";
		public static const GET_REGION_SUCCESS:String = "GetRegionSuccess";
		public static const GET_REGION_FAILED:String = "GetRegionFailed";
		public function GetRegionProxy(data:Object = null)
		{
			super(NAME, data);
		}
		
		public function result(rpcEvent:Object):void {
			this.setData(XML(rpcEvent.result));
			sendNotification(GET_REGION_SUCCESS, rpcEvent.result);
		}
		public function fault(rpcEvent:Object):void {
			sendNotification(ApplicationFacade.CONNECT_WEBSERVICE_FAILED, "GetArea");
		}
		// 获取当前区域数据
		public function getRegion(userName:String, password:String):void {
			var solarDelegate:SolarDelegate = new SolarDelegate(this);
			solarDelegate.getRegion(userName, password);
		}
		public function get regionInfo():XML {
			return data as XML;
		}
	}
}