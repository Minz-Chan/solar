package com.fallmind.solars.model
{
	import com.fallmind.solars.model.bussiness.SolarDelegate;
	
	import mx.rpc.IResponder;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;

	public class FuelManagementProxy extends Proxy implements IProxy, IResponder
	{
		
		public static const NAME:String = "FuelManagementProxy";
		
		public function FuelManagementProxy(data:Object=null)
		{
			super(NAME, data);
		}
		
		public function addFuel(userName:String, password:String, fuelName:String, fuelType:String, param1:String, param2:String):void {
			var delegate:SolarDelegate = new SolarDelegate(this);
			delegate.addFuel(userName, password, fuelName, fuelType, param1, param2);
		}
		
		public function deleteFuel(userName:String, password:String, fuelId:String):void {			
			var delegate:SolarDelegate = new SolarDelegate(this);
			delegate.deleteFuel(userName, password, fuelId);
		}
		
		public function updateFuel(userName:String, password:String, fuelId:String, columnForUpdateStr:String):void {			
			var delegate:SolarDelegate = new SolarDelegate(this);
			delegate.updateFuelInfo(userName, password, fuelId, columnForUpdateStr);
		}
		

		public function result(data:Object):void
		{
			var xml:XML = XML(data.result);
			setData(XML(data.result));
		}
		
		public function fault(info:Object):void
		{
		}
		
	}
}