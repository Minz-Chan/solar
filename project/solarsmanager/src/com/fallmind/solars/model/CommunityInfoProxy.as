package com.fallmind.solars.model
{
	import com.fallmind.solars.model.bussiness.SolarDelegate;
	
	import mx.rpc.IResponder;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	import com.fallmind.solars.ApplicationFacade;
	
	public class CommunityInfoProxy extends Proxy implements IProxy, IResponder
	{
		public static const NAME:String = "CommunityInfoProxy";
		public static const LOAD_SOLARSYSTEM_SUCCESS:String = "LoadSolarSystemSuccess";
		public static const LOAD_SOLARSYSTEM_FAILED:String = "LoadSolarSystemFailed";
		public function CommunityInfoProxy(data:Object = null)
		{
			super(NAME, data);
		}
		/**
		 * 获取用户所管辖的所有太阳能系统
		 * @param userName 用户名
		 * @param password 密码
		 */
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
	}
}