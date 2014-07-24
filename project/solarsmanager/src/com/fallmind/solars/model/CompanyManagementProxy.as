package com.fallmind.solars.model
{
	import com.fallmind.solars.model.bussiness.SolarDelegate;
	
	import mx.rpc.IResponder;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;

	public class CompanyManagementProxy extends Proxy implements IProxy, IResponder
	{
		public static const NAME:String = "CompanyManagementProxy";
		
		public function CompanyManagementProxy(data:Object=null)
		{
			
			super(NAME, data);
		}
		

		public function addCompany(userName:String, password:String, companyName:String, companyIdentifier:String, bg_login:String, bg_logo:String):void {
			var delegate:SolarDelegate = new SolarDelegate(this);
			delegate.addCompany(userName, password, companyName, companyIdentifier, bg_login, bg_logo);
		}
		
		public function deleteCompany(userName:String, password:String, companyId:String):void {
			var delegate:SolarDelegate = new SolarDelegate(this);
			delegate.deleteCompany(userName, password, companyId);
		}
		
		public function updateCompany(userName:String, password:String, companyId:String, columnForUpdateStr:String):void {
			var delegate:SolarDelegate = new SolarDelegate(this);
			delegate.updateCompany(userName, password, companyId, columnForUpdateStr);
		}
		
		
		public function result(data:Object):void
		{
			
		}
		
		public function fault(info:Object):void
		{

		}
		
	}
}