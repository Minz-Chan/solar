package com.fallmind.solars.model
{
	import com.fallmind.solars.model.bussiness.SolarDelegate;
	
	import mx.rpc.IResponder;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	import com.fallmind.solars.ApplicationFacade;
	
	public class GetUserInfoProxy extends Proxy implements IProxy, IResponder
	{
		public static const NAME:String = "GetUserInfoProxy";
		public static const LOAD_USERINFO_SUCCESS:String = "LoadUserInfoSuccess";
		public static const LOAD_USERINFO_FAILED:String = "LoadUserInfoFailed";
		public function GetUserInfoProxy(data:Object = null)
		{
			super(NAME, data);
		}
		/**
		 * 根据用户ID获取用户信息
		 */
		public function getUserInfo(userName:String, password:String, userID:String):void {
			var solarDelegate:SolarDelegate = new SolarDelegate(this);
			solarDelegate.getUserInfo(userName, password, userID);
		}
		public function result(rpcEvent:Object):void {
			setData(XML(rpcEvent.result));
			sendNotification(LOAD_USERINFO_SUCCESS, userInfo);
		}
		public function fault(rpcEvent:Object):void {
			sendNotification(ApplicationFacade.CONNECT_WEBSERVICE_FAILED, "GetUserInfo");
		}
		public function get userInfo():XML {
			return data as XML;
		}
	}
}