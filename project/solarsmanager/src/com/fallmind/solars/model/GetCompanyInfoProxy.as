package com.fallmind.solars.model
{
	import com.fallmind.solars.ApplicationFacade;
	import com.fallmind.solars.model.bussiness.SolarDelegate;
	
	import mx.rpc.IResponder;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;

	public class GetCompanyInfoProxy extends Proxy implements IProxy, IResponder
	{
		public static const NAME:String = "GetCompanyInfo";
		public static const GET_COMPANYINFO_SUCCESS:String = "GetCompanyInfoSuccess";
		public static const GET_COMPANYINFO_FAILED:String = "GetCompanyInfoFailed";
		
		public var isGetAll:Boolean = false;			// 是否取得所有
		
		public function GetCompanyInfoProxy(data:Object=null)
		{
			super(NAME, data);
		}
		
		public function result(data:Object):void {
			this.setData(XML(data.result));
			var xml:XML = XML(data.result);
			var companyList:XMLList = xml.children();
			sendNotification(GET_COMPANYINFO_SUCCESS, companyList[0]);
		}
		public function fault(data:Object):void {
			sendNotification(ApplicationFacade.CONNECT_WEBSERVICE_FAILED, "GetCompanyInfo");
		}
		
		// 根据唯一标识获取公司信息
		public function getCompanyInfo(companyIdentifier:String):void {
			
			isGetAll = false;
			
			var solarDelegate:SolarDelegate = new SolarDelegate(this);
			if(companyIdentifier == null){
				companyIdentifier = new String("");
			}
			solarDelegate.getCompanyInfo(companyIdentifier);
		}
		
		// 获取所有公司信息
		public function getAllCompanyInfo():void {
			
			isGetAll = true;
			
			var solarDelegate:SolarDelegate = new SolarDelegate(this);
			solarDelegate.getAllCompanyInfo();
		}
		
		public function get companyDetail():XML {
			return data as XML;
		}
		
	}
}