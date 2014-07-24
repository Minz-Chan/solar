package com.fallmind.solars.model
{
	
	import com.fallmind.solars.model.bussiness.SolarDelegate;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.IResponder;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;

	public class GetCompanyListProxy extends Proxy implements IProxy, IResponder
	{
		
		public static const NAME:String = "GetCompanyListProxy";
		public static const LOAD_COMPANYLIST_SUCCESS:String = "LoadCompanyListSuccess";
		public static const LOAD_COMPANYLIST_FAILED:String = "LoadCompanyListFailed";
		public function GetCompanyListProxy(data:Object = null)
		{
			super(NAME, data);
		}
	
		public function getAllCompanyInfo():void {
			var getAllCompanyInfoDelegate:SolarDelegate = new SolarDelegate(this);
			getAllCompanyInfoDelegate.getAllCompanyInfo();
		}
		
		public function result(data:Object):void
		{	
			var xml:XML = XML(data.result);
			var companyList:XMLList = xml.children();
			var list:Array = new Array();
			var companyInfoList:ArrayCollection = new ArrayCollection();
			var i:int;
			
			for(i = 0; i < companyList.length(); i++){
				list.push({label:companyList[i].@CompanyName.toString()
					,data:companyList[i].@CompanyIdentifier.toString()});
			}
			
			setData(list);
			sendNotification(GetCompanyListProxy.LOAD_COMPANYLIST_SUCCESS, "LoadCompanyListSuccess");
		}
		
		public function fault(info:Object):void
		{
			sendNotification(LOAD_COMPANYLIST_FAILED, "GetCompanyList");
		}
		
		public function get companyList():Array
		{
			return data as Array;
		}
		
	}
}