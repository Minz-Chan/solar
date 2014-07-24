package com.fallmind.solars.model
{
	import com.fallmind.solars.model.bussiness.ConfigManager;
	import com.fallmind.solars.model.bussiness.SolarDelegate;
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.rpc.IResponder;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	import com.fallmind.solars.ApplicationFacade;
	
	/**
	 * 获取警告
	 */
	public class GetWarningProxy extends Proxy implements IProxy, IResponder
	{
		public static const GET_WARNING_SUCCESS:String = "GetWarningSuccess";
		public static const GET_WARNING_FAILED:String = "GetWarningFailed";
		public static const NAME:String = "GetWarningProxy";
		
		public static const OFFER_BOX_WL_ALARM:String = "OfferBoxWLAlarm";// 供热水箱水位警报事件
		public static const PRODUCT_BOX_WL_ALARM:String = "ProductBoxWLAlarm";// 产热水箱水位报警事件
		public static const OFFER_BOX_T_ALARM:String = "OfferBoxTAlarm";	// 供热水箱水温报警事件
		public static const PRODUCT_BOX_T_ALARM:String = "ProductBoxTAlarm";	// 产热水箱水温报警事件

		private var timer:Timer;
		private var userName:String;
		private var password:String;
		
		
		public function GetWarningProxy(data:Object = null)
		{
			super(NAME, data);
			
			var config:ConfigManager = ConfigManager.getManageManager();
			
			timer = new Timer(config.getQueryTime()*1000);	// 初始化获取警报的定时器
			timer.addEventListener(TimerEvent.TIMER, getWarningHandler);
		}
		// 定时器启动
		public function startQuery(userName:String, password:String):void {
			this.userName = userName;
			this.password = password;
			timer.start();
		}
		
		public function stopQuery():void {
			timer.stop();
		}
		// 通过delegate类提供的方法获取警报
		private function getWarningHandler(e:TimerEvent):void {
			var delegate:SolarDelegate = new SolarDelegate(this);
			delegate.getWarning(userName, password);
		}
		public function getWarningNum():int {
			return data.row.length();
		}
		// 对结果的分析
		public function result(rpcEvent:Object):void {
			setData(XML(rpcEvent.result));
			sendNotification(GET_WARNING_SUCCESS);
			
			for each(var xml:XML in alarmContent.row ) {
				var alarmEvent:String = xml.@AlarmEvent;
				var singleAlarm:String = "";
				for(var i:int = 0; i < alarmEvent.length; i++) {
					// 因为数据库中的警报是用逗号分隔开的，所以要把警报拆分出来，放在singleAlarm中，然后案的singleAlarm的值
					if(alarmEvent.charAt(i) != ",") {
						singleAlarm += alarmEvent.charAt(i);
					} 
					if(alarmEvent.charAt(i) == "," || i == alarmEvent.length - 1) {
						switch(singleAlarm) {
							// 如果供热水箱水位有警报，就发送事件，把当前数据的相应部分变红色
							case "供热水箱水位过低":
							case "供热水箱水位过高":
								sendNotification(OFFER_BOX_WL_ALARM, xml.@System_ID);	
								break;
							// 如果产热水箱水位有警报，就发送事件，把当前数据的相应部分变红色
							case "产热水箱水位过高":
							case "产热水箱水位过低":
								sendNotification(PRODUCT_BOX_WL_ALARM, xml.@System_ID);
								break;
							// 如果供热水箱水温有警报，就发送事件，把当前数据的相应部分变红色
							case "供热水箱水温过高":
							case "供热水箱水温过低":
								sendNotification(OFFER_BOX_T_ALARM, xml.@System_ID);
								break;
							// 如果产热水箱水温有警报，就发送事件，把当前数据的相应部分变红色
							case "产热水箱水温过低":
							case "产热水箱水温过高":
								sendNotification(PRODUCT_BOX_T_ALARM, xml.@System_ID);
								break;
						}
						singleAlarm = "";
					}
				}
			}
			
			//analyseProxy.analyse(XML(rpcEvent.result));
		}
		public function fault(rpcEvent:Object):void {
			sendNotification(ApplicationFacade.CONNECT_WEBSERVICE_FAILED, "GetWarning");
		}
		public function get alarmContent():XML {
			return data as XML;
		}
	}
}