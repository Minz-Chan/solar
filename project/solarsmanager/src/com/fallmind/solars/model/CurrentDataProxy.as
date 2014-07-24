package com.fallmind.solars.model
{
	import com.fallmind.solars.model.bussiness.ConfigManager;
	import com.fallmind.solars.model.bussiness.SolarDelegate;
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.controls.Alert;
	import mx.formatters.DateFormatter;
	import mx.rpc.IResponder;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	import com.fallmind.solars.ApplicationFacade;
	
	public class CurrentDataProxy extends Proxy implements IProxy, IResponder
	{
		public static const NAME:String = "CurrentDataProxy";
		public static const GET_CURRENT_DATA_SUCCESS:String = "GetCurrentDataSuccess";
		public static const GET_CURRENT_DATA_FAILED:String = "GetCurrentDataFailed";
		public static const GET_CURRENT_DATA_OVERTIME:String = "GetCurrentDataOverTime";
		private var systemID:String;
		private var timer:Timer;
		private var userName:String;
		private var password:String;
		
		private var sendOrderProxy:SendOrderProxy;
		
		private var overTime:int;
		private var lastTime:int;
		
		private var flag:Boolean = false;
		
		public function CurrentDataProxy(data:Object = null)
		{
			super(NAME, data);
			
			var config:ConfigManager = ConfigManager.getManageManager();
			overTime = config.getOverTime();
			
			
			sendOrderProxy = SendOrderProxy(facade.retrieveProxy(SendOrderProxy.NAME));
			
			timer = new Timer(config.getQueryTime()*1000);
			timer.addEventListener(TimerEvent.TIMER, getCurrentDataHandler);
		}
		
		/**
		 * 获取当前数据的计时器启动
		 */
		public function startQuery():void {
			var delegate:SolarDelegate = new SolarDelegate(this);
			delegate.getCurrentData(userName, password, systemID);
			timer.start();
		}
		/**
		 * 获取当前数据的计时器停止
		 */
		public function stopQuery():void {
			timer.stop();
		}
		/**
		 * 获取当前数据
		 */
		private function getCurrentDataHandler(e:TimerEvent):void {
			var delegate:SolarDelegate = new SolarDelegate(this);
			delegate.getCurrentData(userName, password, systemID);
		}
		public function setPassword(password:String):void {
			this.password = password;
		}
		public function setSystemID(id:String):void {
			this.systemID = id;
		}
		
		public function setUsername(name:String):void {
			this.userName = name;
		}
		/**
		 * 获取当前数据成功以后，判断是否有数据，以及数据是否为最新，根据情况发送相应的事件
		 * @param rpcEvent 当前系统数据
		 */
		public function result(rpcEvent:Object):void {
			setData(XML(rpcEvent.result));
			
			// 发送获取系统数据的指令
			sendOrderProxy.getCurrentSystemData(userName, password, systemID, currentData.SystemData.row.@ARM_ID);
			
			var reDataTime:String = currentData.SystemData.row.@ReDataTime;
			var myPattern:RegExp = /T/;
			reDataTime = reDataTime.replace(myPattern, " ");
			var lastTime:Date = Convert.convertToDate(reDataTime);
			// 如果获取的主控器ID为空，说明数据库中无数据，发送事件提示用户
			if(lastTime == null && currentData.SystemData.row.@ARM_ID != undefined) {
				sendNotification(ApplicationFacade.SET_ORDER_STATE, "无数据");// 提示用户无数据
				sendNotification(ApplicationFacade.CLEAR_CURRENT_DATA_VIEW);// 清空当前系统数据界面中的数据
				sendNotification(ApplicationFacade.ENABLE_SYSTEM_MENU);	// 把系统操作菜单变为不可用，因为没有数据，所以不能进行系统操作
				return;
			}
			
			if(currentData.SystemData.row.@ARM_ID == undefined) {
				sendNotification(ApplicationFacade.SET_ORDER_STATE, "无数据");
				sendNotification(ApplicationFacade.CLEAR_CURRENT_DATA_VIEW);
				return;
			}
			// 如果数据库中的最新数据时间减去当前时间，发送超时事件，否则发送成功事件
			if(new Date().getTime() - lastTime.getTime() >= overTime * 1000) {
				sendNotification(GET_CURRENT_DATA_OVERTIME);
			} else {
				sendNotification(GET_CURRENT_DATA_SUCCESS);
			}
			// 在未获取到系统ARM_ID的情况下，要把菜单栏变为不可用，否则发送指令会出错，一旦得到了ARM_ID就启用菜单栏
			sendNotification(ApplicationFacade.SET_ORDER_STATE, "");
			sendNotification(ApplicationFacade.ENABLE_SYSTEM_MENU);
		}
		public function fault(rpcEvent:Object):void {
			sendNotification(GET_CURRENT_DATA_FAILED);
		}
		public function get currentData():XML {
			return data as XML;
		}
		public function getCurrentSystemID():String {
			return systemID;
		}
		public function getARM_ID():String {
			return currentData.SystemData.row.@ARM_ID;
		}
		public function getARM_Version():String {
			return currentData.SystemData.row.@ARM_Version;
		}
		public function getCurrentCommunityID():String {
			return currentData.SystemSetup.row.@BelCommunityID;
		}
	}
}
import mx.formatters.DateFormatter;
	
class Convert extends DateFormatter{
    public static function convertToDate(str:String):Date{
       	return DateFormatter.parseDateString(str);
    }
}

