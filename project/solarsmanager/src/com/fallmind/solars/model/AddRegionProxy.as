package com.fallmind.solars.model
{
	import com.fallmind.solars.model.bussiness.SolarDelegate;
	
	import mx.rpc.IResponder;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;

	import com.fallmind.solars.ApplicationFacade;
	public class AddRegionProxy extends Proxy implements IProxy, IResponder
	{
		public static const NAME:String = "AddRegionProxy";
		public static const ADD_REGION_SUCCESS:String = "AddRegionSuccess";
		public static const ADD_REGION_FAILED:String = "AddRegionFailed";
		
		public function AddRegionProxy(data:Object = null)
		{
			super(NAME, data);
		}
		/**
		 * 添加一个地域
		 * @param userName 用户名
		 * @param 密码
		 * @param regionName 地域名称
		 * @param regionType 地域类型ID，比如国家就是1，省份就是2，市区就是3
		 * @param belRegionID 所属于的地域ID
		 */
		public function addRegion(userName:String, password:String, regionName:String, regionType:String, belRegionID:String):void {
			var delegate:SolarDelegate = new SolarDelegate(this);
			delegate.addRegion(userName, password, regionName, regionType, belRegionID);
		}
		public function result(rpcEvent:Object):void {
			sendNotification(ADD_REGION_SUCCESS, rpcEvent.result);
		}
		public function fault(rpcEvent:Object):void {
			sendNotification(ApplicationFacade.CONNECT_WEBSERVICE_FAILED, "AddArea");
		}
	}
}