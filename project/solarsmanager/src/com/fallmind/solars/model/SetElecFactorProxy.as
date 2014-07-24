package com.fallmind.solars.model
{
	import com.fallmind.solars.model.bussiness.SolarDelegate;
	
	import mx.rpc.IResponder;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class SetElecFactorProxy extends Proxy implements IProxy, IResponder
	{
		public static const SET_ELEC_FACTOR_SUCCESS:String = "SetElecFactorSuccess";
		public static const SET_ELEC_FACTOR_FAILED:String = "SetElecFactorFailed";
		public static const NAME:String = "SetElecFactorProxy";
		public function SetElecFactorProxy(data:Object = null)
		{
			super(NAME, data);
		}
		public function SetElecFactor(factor:String, extraFactor:String, Collector_in_line_Fix:String, systemId:String):void {
			var delegate:SolarDelegate = new SolarDelegate(this);
			delegate.setElecFactor(factor, extraFactor, Collector_in_line_Fix, systemId);
		}
		public function result(rpcEvent:Object):void {
		}
		public function fault(rpcEvent:Object):void {
		}

		
	}
}