package com.fallmind.solars.model
{
	import com.fallmind.solars.ApplicationFacade;
	import com.fallmind.solars.model.bussiness.SolarDelegate;
	
	import mx.rpc.IResponder;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class SaveCommunityInfoProxy extends Proxy implements IProxy, IResponder
	{
		public static const NAME:String = "SaveCommunityInfoProxy";
		public static const SAVE_SOLARSYSTEM_SUCCESS:String = "SaveSolarSystemSuccess";
		public static const SAVE_SOLARSYSTEM_FAILED:String = "SaveSolarSystemFailed";
		public static const COMMUNITY_NAME_EXIST:String = "CommunityNameExist";
		
		public function SaveCommunityInfoProxy(data:Object = null)
		{
			super(NAME, data);
		}
		
		public function result(rpcEvent:Object):void {
			if(rpcEvent.result == "0") {
				sendNotification(COMMUNITY_NAME_EXIST);
			} else {
				sendNotification(SAVE_SOLARSYSTEM_SUCCESS, rpcEvent.result);
			}
		}
		public function fault(rpcEvent:Object):void {
			sendNotification(ApplicationFacade.CONNECT_WEBSERVICE_FAILED, "SaveCommunityInfo");
		}
		// 添加小区信息
		public function insertCommunityInfo(userName:String, password:String, ob:Object):void {
			var solarDelegate:SolarDelegate = new SolarDelegate(this);
			solarDelegate.insertCommunityInfo(userName, password, ob);
		}
		// 修改小区信息
		public function updateCommunityInfo(userName:String, password:String, ob:Object):void {
			var solarDelegate:SolarDelegate = new SolarDelegate(this);
			solarDelegate.updateCommunityInfo(userName, password, ob);
		}
	}
}