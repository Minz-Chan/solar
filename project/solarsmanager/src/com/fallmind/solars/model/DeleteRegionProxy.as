package com.fallmind.solars.model
{
	import com.fallmind.solars.model.bussiness.SolarDelegate;
	
	import mx.rpc.IResponder;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	import com.fallmind.solars.ApplicationFacade;
	
	public class DeleteRegionProxy extends Proxy implements IProxy, IResponder
	{
		public static const NAME:String = "DeleteRegionProxy";
		public static const DELETE_REGION_SUCCESS:String = "DeleteRegionSuccess";
		public static const DELETE_REGION_FAILED:String = "DeleteRegionFailed";
		public function DeleteRegionProxy(data:Object = null)
		{
			super(NAME, data);
		}
		/**
		 * 删除地域
		 * @param userName 用户名
		 * @param password 密码
		 * @param regionID 要删除的地域ID
		 */
		public function deleteRegion(userName:String, password:String, regionID:String):void {
			var delegate:SolarDelegate = new SolarDelegate(this);
			delegate.deleteRegion(userName, password, regionID);
		}
		public function result(rpcEvent:Object):void {
			sendNotification(DELETE_REGION_SUCCESS, rpcEvent.result);
		}
		public function fault(rpcEvent:Object):void {
			sendNotification(ApplicationFacade.CONNECT_WEBSERVICE_FAILED, "DeleteArea");
		}
	}
}