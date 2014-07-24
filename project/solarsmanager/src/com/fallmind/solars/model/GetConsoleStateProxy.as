package com.fallmind.solars.model
{
	import com.fallmind.solars.model.bussiness.SolarDelegate;
	
	import mx.rpc.IResponder;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	import com.fallmind.solars.ApplicationFacade;
	
	public class GetConsoleStateProxy extends Proxy implements IProxy, IResponder
	{
		public static const NAME:String = "GetConsoleStateProxy";
		
		public static const CONSOLE_IS_OPEN:String = "ConsoleIsOpen";
		public static const CONSOLE_IS_CLOSE:String = "ConsoleIsClose";
		public static const CONNECT_FAILED:String = "ConnectFailed";
		public function GetConsoleStateProxy(data:Object = null)
		{
			super(NAME, data);
		}
		// 判断控制台是否开启
		public function getConsoleState(userName:String, password:String, systemID:String):void {
			var delegate:SolarDelegate = new SolarDelegate(this);
			delegate.getConsoleState(userName, password, systemID);
		}
		public function result(rpcEvent:Object):void {
			if(rpcEvent.result == "1") {
				sendNotification(CONSOLE_IS_OPEN);
			} else {
				sendNotification(CONSOLE_IS_CLOSE);
			}
		}
		public function fault(rpcEvent:Object):void {
			sendNotification(ApplicationFacade.CONNECT_WEBSERVICE_FAILED, "GetConsoleState");
		}

	}
}