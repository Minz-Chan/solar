package com.fallmind.solars.model
{
	import com.fallmind.solars.model.bussiness.SolarDelegate;
	
	import mx.rpc.IResponder;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	import com.fallmind.solars.ApplicationFacade;
	
	public class GetCommunityProxy extends Proxy implements IProxy, IResponder
	{
		public static const NAME:String = "GetCommunityProxy";
		public static const GET_COMMUNITY_SUCCESS:String = "GetCommunitySuccess";
		public static const GET_COMMUNITY_FAILED:String = "GetCommunityFailed";
		public function GetCommunityProxy(data:Object = null)
		{
			super(NAME, data);
		}
		// 获取小区信息
		public function getCommunity(userName:String, password:String):void {
			var solarDelegate:SolarDelegate = new SolarDelegate(this);
			solarDelegate.getCommunity(userName, password);
		}
		public function result(rpcEvent:Object):void {
			setData(XML(rpcEvent.result));
			sendNotification(GET_COMMUNITY_SUCCESS);
		}
		public function fault(rpcEvent:Object):void {
			sendNotification(ApplicationFacade.CONNECT_WEBSERVICE_FAILED, "GetCommunity");
		}
		public function getUserRightID(id:String):String {
			return communityInfo.row.(@CommunityID == id).@UserRight_ID;
		}
		public function get communityInfo():XML {
			return data as XML;
		}
	}
}