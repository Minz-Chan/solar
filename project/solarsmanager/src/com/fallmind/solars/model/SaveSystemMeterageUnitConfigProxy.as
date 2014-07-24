package com.fallmind.solars.model
{
	import com.fallmind.solars.model.bussiness.SolarDelegate;
	
	import mx.rpc.IResponder;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;

	public class SaveSystemMeterageUnitConfigProxy extends Proxy implements IProxy, IResponder
	{
		
		public static const NAME:String = "SaveSystemMeterageUnitConfigProxy";
		public static const SAVE_SYSTEM_METERAGEUNIT_SUCCESS:String = "SaveSystemMeterageUnitConfigSuccess";
		public static const SAVE_SYSTEM_METERAGEUNIT_FAILURE:String = "SaveSystemMeterageUnitConfigFailure";
		
		public function SaveSystemMeterageUnitConfigProxy(data:Object=null)
		{
			super(NAME, data);
		}
		
		public function saveSystemMeterageUnitConfig(userName:String, password:String, systemId:String, updatedStr:String):void{
			var delegate:SolarDelegate = new SolarDelegate(this);
			delegate.saveSystemMeterageUnitConfig(userName, password, systemId, updatedStr);
		}
		
		
		public function result(data:Object):void
		{
			var rtnCode:String = String(data.result);
			
			if(rtnCode == "1"){
				sendNotification(SaveSystemMeterageUnitConfigProxy.SAVE_SYSTEM_METERAGEUNIT_SUCCESS);
			}else{
				sendNotification(SaveSystemMeterageUnitConfigProxy.SAVE_SYSTEM_METERAGEUNIT_FAILURE);
			}
			
			setData(data);
			
		}
		
		public function fault(info:Object):void
		{
			sendNotification(SaveSystemMeterageUnitConfigProxy.SAVE_SYSTEM_METERAGEUNIT_FAILURE);
		}
		
	}
}