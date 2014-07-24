package com.fallmind.solars.model
{
	import com.fallmind.solars.ApplicationFacade;
	import com.fallmind.solars.model.bussiness.ConfigManager;
	import com.fallmind.solars.model.bussiness.SolarDelegate;
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.rpc.IResponder;
	
	import org.puremvc.as3.interfaces.IProxy;
	import com.fallmind.solars.view.systemMediator.CurrentDataMediator;
	import org.puremvc.as3.patterns.proxy.Proxy;
	public class GetErrorCommunicateStatusProxy extends Proxy implements IProxy, IResponder
	{
		public static const NAME:String = "GetErrorCommunicateStatusProxy";
		public static const GET_ERROR_COMMUNICATE_STATUS_SUCCESS:String = "GetErrorCommunicateStatusSuccess";
		private var config:ConfigManager = ConfigManager.getManageManager();
		private var timer:Timer;
		private var delegate:SolarDelegate;
		// 获取通讯状态异常的太阳能系统
		public function GetErrorCommunicateStatusProxy(data:Object = null)
		{
			super(NAME, data);
			timer = new Timer(config.getQueryTime()*1000);
			timer.addEventListener(TimerEvent.TIMER, timerHandler);
			delegate = new SolarDelegate(this);
			timer.start();
		}
		private function timerHandler(e:Event):void {
			delegate.getErrorCommunicateStatus();
		}
		public function getCommunicateStatus():void {
			var delegate:SolarDelegate = new SolarDelegate(this);
			delegate.getErrorCommunicateStatus();
		}
		public function get communicateData():XML {
			return data as XML;
		}
		public function result(e:Object):void {
			setData(XML(e.result));
			if(!communicateData.hasSimpleContent()) {
				sendNotification(CurrentDataMediator.COMMUNICATE_ERROR);
			} else {
				sendNotification(CurrentDataMediator.COMMUNICATE_OK);
			}
			sendNotification(GET_ERROR_COMMUNICATE_STATUS_SUCCESS);
		}
		public function fault(e:Object):void {
			sendNotification(ApplicationFacade.CONNECT_WEBSERVICE_FAILED, "GetErrorCommunicateStatus");
		}
	}
}