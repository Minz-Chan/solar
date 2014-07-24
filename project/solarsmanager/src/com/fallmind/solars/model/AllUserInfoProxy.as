package com.fallmind.solars.model
{
	import com.fallmind.solars.model.bussiness.SolarDelegate;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.IResponder;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	import com.fallmind.solars.ApplicationFacade;
	public class AllUserInfoProxy extends Proxy implements IProxy, IResponder
	{
		public static const NAME:String = "AllInfoProxy";
		public static const LOAD_ALLUSER_SUCCESS:String = "LoadAllUserSuccess";
		public static const LOAD_ALLUSER_FAILED:String = "LoadAllUserFailed";
		public function AllUserInfoProxy(data:Object = null)
		{
			super(NAME, data);
		}
		/**
		 * 获取该用户所管辖的所有用户
		 * @param userName 用户名
		 * @param password 密码
		 * @param communityInfo 该用户所管辖的小区ID的数组
		 */
		public function getAllUserInfo(userName:String, password:String, communityInfo:ArrayCollection):void {
			var solarDelegate:SolarDelegate = new SolarDelegate(this);
			solarDelegate.getAllUserInfo(userName, password, communityInfo);
		}
		public function result(rpcEvent:Object):void {
			setData(XML(rpcEvent.result));
			sendNotification(LOAD_ALLUSER_SUCCESS, allUserInfo);
		}
		public function fault(rpcEvent:Object):void {
			sendNotification(ApplicationFacade.CONNECT_WEBSERVICE_FAILED, "GetAllUserInfo");
		}
		public function get allUserInfo():XML {
			return data as XML;
		}
	}
}