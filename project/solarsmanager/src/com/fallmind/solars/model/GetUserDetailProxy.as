package com.fallmind.solars.model
{
	import com.fallmind.solars.model.bussiness.SolarDelegate;
	
	import mx.rpc.IResponder;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	import com.fallmind.solars.ApplicationFacade;
	
	public class GetUserDetailProxy extends Proxy implements IProxy, IResponder
	{
		public static const NAME:String = "GetUserDetailProxy";
		public static const GET_USER_DETAIL_SUCCESS:String = "GetUserDetailSuccess";
		public static const GET_USER_DETAIL_FAILED:String = "GetUserDetailFailed";
		public function GetUserDetailProxy(data:Object = null)
		{
			super(NAME, data);
		}
		/**
		 * 获取只包含小区的地域的信息，并不是完整的地域信息。返回结果是一棵树，作为地域树界面的数据源,
		 * 在登录成功后获取
		 */
		public function getUserDetail(userName:String, password:String):void {
			var delegate:SolarDelegate = new SolarDelegate(this);
			delegate.getUserDetail(userName, password);
		}
		public function result(rpcEvent:Object):void {
			setData(XML(rpcEvent.result));
			sendNotification(GET_USER_DETAIL_SUCCESS);
		}
		public function fault(rpcEvent:Object):void {
			sendNotification(ApplicationFacade.CONNECT_WEBSERVICE_FAILED, "GetUserDetail");
		}
	}
}