package com.fallmind.solars.model
{
	import com.fallmind.solars.model.bussiness.SolarDelegate;
	
	import mx.rpc.IResponder;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	import com.fallmind.solars.ApplicationFacade;
	
	public class SolarInfoProxy extends Proxy implements IProxy, IResponder
	{
		public static const NAME:String = "SolarInfoProxy";
		public static const LOAD_SOLARSYSTEM_SUCCESS:String = "LoadSolarSystemSuccess";
		public static const LOAD_SOLARSYSTEM_FAILED:String = "LoadSolarSystemFailed";
		public function SolarInfoProxy(data:Object = null)
		{
			super(NAME, data);
		}
		// 获取用户管辖下的所有太阳能系统数据
		public function getSolarsSystem(userName:String, password:String):void {
			var solarDelegate:SolarDelegate = new SolarDelegate(this);
			solarDelegate.getSolarSystem(userName, password);
		}
		public function result(rpcEvent:Object):void {
			setData(XML(rpcEvent.result));
			sendNotification(LOAD_SOLARSYSTEM_SUCCESS, solarSystemInfo);
		}
		public function fault(rpcEvent:Object):void {
			sendNotification(ApplicationFacade.CONNECT_WEBSERVICE_FAILED, "GetSolarSystem");
		}
		public function get solarSystemInfo():XML {
			return data as XML;
		}
		public function getUserRightID(systemID:String):String {
			return solarSystemInfo.row.(@System_ID == systemID).@UserRight_ID;
		}
	}
}