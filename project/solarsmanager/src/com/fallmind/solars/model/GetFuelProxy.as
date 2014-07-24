package com.fallmind.solars.model
{
	import com.fallmind.solars.model.bussiness.SolarDelegate;
	
	import mx.rpc.IResponder;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;

	public class GetFuelProxy extends Proxy implements IProxy, IResponder
	{
		
		public static const NAME:String = "GetFuelProxy";
		public static const GET_FUEL_SUCCESS:String = "GetFuelProxySuccess";
		public static const GET_FUEL_FAILURE:String = "GetFuelProxyFailure";
		
		private var rtnData:Array;
		//private var oilData:Array;
		//private var gasData:Array;
		private var typeDataMap:Array;	// [燃料类型-燃料列表]  燃料列表:Array(FuelName, id)  
		//private var type:int;
		public var type:String;			// 最次一次查找的类型
		
		public function GetFuelProxy(data:Object=null)
		{
			super(NAME, data);
			typeDataMap = new Array();
		}
		
		public function getFuelsByFuelType(userName:String, password:String, fuelType:String):void{
			
			//type = Number(fuelType);
			
			/* if(typeDataMap[fuelType] == null){
				typeDataMap[fuelType] = new Array();
			}else{
				var i:int;			
				var tmp:Array = typeDataMap[fuelType];
				for(i = 0; i < tmp.length; i++){
					tmp.pop();
				}
			} */
			
			type = fuelType;
			
			var delegate:SolarDelegate = new SolarDelegate(this);
			delegate.getFuelsByFuelType(userName, password, fuelType);
		}
		
		public function result(data:Object):void
		{
			setData(XML(data.result));
			var xmllist:XMLList = XMLList((XML(data.result)).children());
			//var tmp:Array;
			var i:int;
			//var type:String;
			
			if(typeDataMap.length != 0){
				var tmp:int = typeDataMap.length; 
				for(i = 0; i < tmp; i++){
					typeDataMap.pop();
				}
			}
			
			if(xmllist[0] != null){
				//type = xmllist[0].@FuelType.toString();
				//tmp = typeDataMap[type] as Array;
			
				// 向数据填充 <燃料名称-ID>值对
				for(i = 0; i < xmllist.length(); i++){
					var type:String = xmllist[i].@FuelType.toString();
					if(typeDataMap[type] == null){
						typeDataMap[type] = new Array();
					}
					typeDataMap[type].push({label:xmllist[i].@FuelName.toString()
						,data:xmllist[i].@id.toString()});
				}
			} 
			
			//setData(typeDataMap);
			sendNotification(GetFuelProxy.GET_FUEL_SUCCESS);
		}
		
		public function fault(info:Object):void
		{
			sendNotification(GetFuelProxy.GET_FUEL_FAILURE);
		}
		
		public function getFuelsByType(type:String):Array{
			return typeDataMap[type];
		}
		
		public function get fuelsDetail():XML {
			return data as XML;
		}
		
		
	}
}