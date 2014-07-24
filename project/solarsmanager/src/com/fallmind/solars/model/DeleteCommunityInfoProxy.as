package com.fallmind.solars.model
{
	import com.fallmind.solars.model.bussiness.SolarDelegate;
	
	import mx.rpc.IResponder;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	import com.fallmind.solars.ApplicationFacade;
	
	public class DeleteCommunityInfoProxy extends Proxy implements IProxy, IResponder
	{
		public static const NAME:String = "DeleteCommunityInfoProxy";
		public static const DELETE_COMMUNITY_SUCCESS:String = "DeleteCommunitySuccess";
		public static const DELETE_COMMUNITY_FAILED:String = "DeleteCommunityFailed";
		
		public function DeleteCommunityInfoProxy(data:Object = null)
		{
			super(NAME, data);
		}
		
		public function result(rpcEvent:Object):void {
			sendNotification(DELETE_COMMUNITY_SUCCESS, rpcEvent.result);
		}
		public function fault(rpcEvent:Object):void {
			sendNotification(ApplicationFacade.CONNECT_WEBSERVICE_FAILED, "DeleteCommunityInfo");
		}
		/**
		 * 删除小区
		 * @param userName 用户名
		 * @param password 密码
		 * @param communityID 要删除的小区ID
		 */
		public function deleteCommunityInfo(userName:String, password:String, communityID:String):void {
			var solarDelegate:SolarDelegate = new SolarDelegate(this);
			solarDelegate.deleteCommunityInfo(userName, password, communityID);
		}
	}
}