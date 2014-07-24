package com.fallmind.solars.model
{
	import com.fallmind.solars.model.bussiness.SolarDelegate;
	
	import mx.rpc.IResponder;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	import com.fallmind.solars.ApplicationFacade;
	
	public class SeasonDefaultSetupProxy extends Proxy implements IProxy, IResponder
	{
		public static const NAME:String = "SeasonDefaultSetupProxy";
		public static const GET_SEASON_DEFAULT_SETUP_SUCCESS:String = "GetSeasonDefaultSetupSuccess";
		public static const GET_SEASON_DEFAULT_SETUP_FAILED:String = "GetSeasonDefaultSetupFailed";
		public function SeasonDefaultSetupProxy(data:Object = null)
		{
			super(NAME, data);
		}
		// 获取季节默认配置
		public function getSeasonDefaultSetup(username:String, password:String, systemID:String):void {
			var delegate:SolarDelegate = new SolarDelegate(this);
			delegate.getSeasonDefaultSetup(username, password, systemID);
		}
		public function result(rpcEvent:Object):void {
			setData(XML(rpcEvent.result));
			sendNotification(GET_SEASON_DEFAULT_SETUP_SUCCESS);
		}
		public function fault(rpcEvent:Object):void {
			sendNotification(ApplicationFacade.CONNECT_WEBSERVICE_FAILED, "GetSeasonSetup");
		}
	}
}