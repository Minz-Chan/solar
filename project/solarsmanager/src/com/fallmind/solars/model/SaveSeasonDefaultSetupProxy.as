package com.fallmind.solars.model
{
	import com.fallmind.solars.model.bussiness.SolarDelegate;
	
	import mx.rpc.IResponder;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	import com.fallmind.solars.ApplicationFacade;
	
	public class SaveSeasonDefaultSetupProxy extends Proxy implements IProxy, IResponder
	{
		public static const NAME:String = "SaveSeasonDefaultSetupProxy";
		public static const SAVE_SEASON_DEFAULT_SETUP_SUCCESS:String = "SaveSeasonDefaultSetupSuccess";
		public static const SAVE_SEASON_DEFAULT_SETUP_FAILED:String = "SaveSeasonDefaultSetupFailed";
		public function SaveSeasonDefaultSetupProxy(data:Object = null)
		{
			super(NAME, data);
		}
		// 保存季节默认配置
		public function saveData(username:String, password:String, setupID:String, saStartTime:String, saCollector:String, wsStartTime:String, wsCollector:String):void {
			var delegate:SolarDelegate = new SolarDelegate(this);
			delegate.saveSeasonDefaultSetup(username, password, setupID, saStartTime, saCollector, wsStartTime, wsCollector);
		}
		public function result(rpcEvent:Object):void {
			sendNotification(SAVE_SEASON_DEFAULT_SETUP_SUCCESS);
		}
		public function fault(rpcEvent:Object):void {
			sendNotification(ApplicationFacade.CONNECT_WEBSERVICE_FAILED, "SaveSeasonSetup");
		}

	}
}