// ActionScript file
package com.fallmind.solars.model {
	import com.fallmind.solars.ApplicationFacade;
	import com.fallmind.solars.model.bussiness.SolarDelegate;
	
	import mx.rpc.IResponder;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class GetWeatherProxy extends Proxy implements IProxy, IResponder {
		public static const NAME:String = "GetWeatherProxy";
		public static const GET_WEATHER_SUCCESS:String = "GetWeatherSuccess";
		public var sourceNum:int = 0;
		private var m_city:String = null;
		public function GetWeatherProxy(data:Object = null) {
			super(NAME, data);
		}
		// 获取天气数据
		public function getWeather(city:String) {
			var delegate:SolarDelegate = new SolarDelegate(this);
			delegate.getWeather(city);
			
			m_city = city;
		}
		public function result(e:Object):void {
			setData(int(e.result));
			sendNotification(GET_WEATHER_SUCCESS);
		}
		// 错误处理
		public function fault(e:Object):void {
			// 如果是第一个天气源失效，就执行另外一个函数，从其他源获取天气，如果两种方法都失效，就发送获取天气失败的事件
			if(sourceNum == 0) {	
				sourceNum++;
				var delegate:SolarDelegate = new SolarDelegate(this);
				delegate.getWeather2(m_city);
			} else {
				sendNotification(ApplicationFacade.CONNECT_WEBSERVICE_FAILED, "GetWeather");
				sourceNum = 0;
			}
		}
	}
}