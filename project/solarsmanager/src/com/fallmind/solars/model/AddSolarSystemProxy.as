package com.fallmind.solars.model
{
	import com.fallmind.solars.model.bussiness.SolarDelegate;
	
	import mx.rpc.IResponder;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	import com.fallmind.solars.ApplicationFacade;

	
	public class AddSolarSystemProxy extends Proxy implements IProxy, IResponder
	{
		public static const NAME:String = "AddSolarSytemProxy";
		public static const ADD_SOLARSYSTEM_SUCCESS:String = "AddSolarSystemSuccess";
		public static const ADD_SOLARSYSTEM_FAILED:String = "AddSolarSystemFailed";
		private var sendOrderProxy:SendOrderProxy;
		private var installState:Array;
		private var userName:String;
		private var password:String;
		public function AddSolarSystemProxy(data:Object = null)
		{
			super(NAME, data);
			
			sendOrderProxy = SendOrderProxy(facade.retrieveProxy(SendOrderProxy.NAME));
		}
		/**
		 * 添加太阳能系统
		 * @param userName 用户名
		 * @param password 密码
		 * @param systemName 太阳能系统名字
		 * @param manager 管理员名
		 * @param managerPhone 管理员电话
		 * @param belCommunity 所属的小区id
		 * @param armID 主控器ID
		 * @param setupTime 添加小区的时间
		 * @param imageURL 小区图片路径
		 * @param armPassword 主控器密码
		 */
		public function addSolarSystem(userName:String, password:String, systemName:String, manager:String, managerPhone:String, belCommunityID:String, armID:String, setupTime:String, imageURL:String, armPassword:String):void {
			var delegate:SolarDelegate = new SolarDelegate(this);
			delegate.addSolarSystem(userName, password, systemName, manager, managerPhone, belCommunityID, armID, setupTime, imageURL, armPassword);
		}
		public function result(rpcEvent:Object):void {
			sendNotification(ADD_SOLARSYSTEM_SUCCESS, rpcEvent.result);
		}
		public function fault(rpcEvent:Object):void {
			sendNotification(ApplicationFacade.CONNECT_WEBSERVICE_FAILED, "AddSolarSystem");
		}
	}
}