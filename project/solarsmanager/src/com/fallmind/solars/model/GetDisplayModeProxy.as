// ActionScript file
package com.fallmind.solars.model
{
	import com.fallmind.solars.ApplicationFacade;
	import com.fallmind.solars.model.bussiness.SolarDelegate;
	
	import mx.rpc.IResponder;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class GetDisplayModeProxy extends Proxy implements IProxy, IResponder
	{
		public static const NAME:String = "GetDisplayModeProxy";
		public static const GET_DISPLAYMODE_SUCCESS:String = "GetDisplayModeSuccess";
		public static const GET_DISPLAYMODE_FAILED:String = "GetDisplayModeFailed";
		public function GetDisplayModeProxy(data:Object = null)
		{
			super(NAME, data);
		}
		/**
		 * 获取显示模式，分为热量和能量两种
		 */
		public function getDisplayMode():void {
			var solarDelegate:SolarDelegate = new SolarDelegate(this);
			solarDelegate.getDisplayMode();
		}
		public function result(rpcEvent:Object):void {
			_displayMode = XML(rpcEvent.result).row.@DisplayMode;
			sendNotification(GET_DISPLAYMODE_SUCCESS);
		}
		public function fault(rpcEvent:Object):void {
			sendNotification(ApplicationFacade.CONNECT_WEBSERVICE_FAILED, "GetDisplayModeFail");
		}
		
		private var _displayMode:String;
		public function get displayMode():String {
			return _displayMode;
		}
	}
}