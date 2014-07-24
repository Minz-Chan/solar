package com.fallmind.solars.model
{
	import com.fallmind.solars.model.bussiness.SolarDelegate;
	import com.fallmind.solars.view.clientMediator.UserDetailData;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.IResponder;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	import com.fallmind.solars.ApplicationFacade;
	
	public class SaveUserDetailProxy extends Proxy implements IProxy, IResponder
	{
		public static const NAME:String = "SaveUserDetailProxy";
		public static const SAVE_USER_DETAIL_SUCCESS:String = "SaveUserDetailSuccess";
		public static const SAVE_USER_DETAIL_FAILED:String = "SaveUserDetailFailed";
		
		public function SaveUserDetailProxy(data:Object = null)
		{
			super(NAME, data);
		}
		
		public function result(rpcEvent:Object):void {
			sendNotification(SAVE_USER_DETAIL_SUCCESS, communityArray.getItemAt(0));
		}
		public function fault(rpcEvent:Object):void {
			sendNotification(ApplicationFacade.CONNECT_WEBSERVICE_FAILED, "SaveUserDetail");
		}
		// 保存用户详细信息
		public function saveUserDetail(userName:String, password:String, userDetail:UserDetailData, array:ArrayCollection):void {
			setData(array);
			var solarDelegate:SolarDelegate = new SolarDelegate(this);
			solarDelegate.saveUserDetail(userName, password, userDetail, array);
		}
		
		public function get communityArray():ArrayCollection {
			return data as ArrayCollection;
		}

	}
}