package com.fallmind.solars.model
{
	import com.fallmind.solars.model.bussiness.SolarDelegate;
	
	import mx.rpc.IResponder;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	import com.fallmind.solars.ApplicationFacade;
	
	public class DeleteUserProxy extends Proxy implements IProxy, IResponder
	{
		public static const NAME:String = "DeleteUserProxy";
		public static const DELETE_USER_SUCCESS:String = "DeleteUserSuccess";
		public static const DELETE_USER_FAILED:String = "DeleteUserFailed";
		public function DeleteUserProxy(data:Object = null)
		{
			super(NAME, data);
		}
		
		public function result(rpcEvent:Object):void {
			sendNotification(DELETE_USER_SUCCESS, rpcEvent.result);
		}
		public function fault(rpcEvent:Object):void {
			sendNotification(ApplicationFacade.CONNECT_WEBSERVICE_FAILED, "DeleteUser");
		}
		/**
		 * 根据用户ID，删除用户
		 */
		public function deleteCommunityInfo(userName:String, userPassword:String, userID:String):void {
			var solarDelegate:SolarDelegate = new SolarDelegate(this);
			solarDelegate.deteteUser(userName, userPassword, userID);
		}
	}
}