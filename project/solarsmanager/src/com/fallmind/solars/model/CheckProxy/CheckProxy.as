package com.fallmind.solars.model.CheckProxy
{
	import com.fallmind.solars.model.bussiness.ConfigManager;
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.formatters.DateFormatter;
	import mx.rpc.IResponder;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	import com.fallmind.solars.ApplicationFacade;
	/**
	 * 这个类是一系列读取太阳能系统数据的基类，用于检测各种读取指令是否发送成功，
	 * 而设置指令的检测的基类是另外一个类CheckSetProxy，因为检测的方法相同，
	 * 为了避免读取和设置的事件字符串相同，所以写了两个基类。
	 */
	public class CheckProxy extends Proxy implements IProxy, IResponder
	{
		protected var timer:Timer;
		protected var successStr:String;	// 指令发送成功要发送的事件字符串，由子类赋值，每个子类的成功字符串不同
		protected var failedStr:String;		// 指令正在发送的事件字符串，由子类赋值，每个子类的发送字符串不同
		protected var overTimeStr:String;	// 指令发送超时要发送的事件字符串，由子类赋值，每个子类的超时字符串不同
		
		// 如果连接失败，就发送一个消息，下面是消息内容
		public static const CONNECT_FAILED:String = "ConnectFailed";
		
		// 下面的字符串是数据库中存储结构的名字，检查哪个指令，就执行相应的存储结构
		public static const CHECK_CURRENT_SETUP:String = "Check_CurrentSetup";
		public static const CHECK_SEASON_SETUP:String = "Check_SeasonSetup";
		public static const CHECK_MANUAL_ADD_WATER:String = "Check_Manual_Add_Water";
		public static const CHECK_MANUAL_ADD_TEMP:String = "Check_Manual_Add_Temp"
		public static const CHECK_ARM_RESTART:String = "Check_ARMRestart";
		public static const CHECK_FORMAT_EPROM:String = "Check_FormatEprom";
		public static const CHECK_SELF_CHECK:String = "Check_SelfCheck";
		
		
		protected var userName:String;
		protected var password:String;
		protected var systemID:String;
		protected var sendTime:String;
		
		protected var config:ConfigManager;
		protected var overTime:int;
		protected var checkTime:int;
		
		protected var hasChecked:Boolean = false;
		
		public function CheckProxy(name:String, data:Object = null)
		{
			super(name, data);
			config = ConfigManager.getManageManager();
			overTime = config.getOverTime();// 获取超时时间，和检测间隔时间
			checkTime = config.getCheckTime();
		}
		// 由子类实现
		public function timerHandler(e:TimerEvent):void {
			return;
		}
		// 由子类实现
		public function completeHandler(e:TimerEvent):void {
			return;
		}
		// 设置要检测的系统的数据。systemID是要检测系统的ID号，sendTime是指令发送的时间
		public function setSystemInfo(userName:String, password:String, systemID:String, sendTime:Date):void {
			this.userName = userName;
			this.password = password;
			this.systemID = systemID;
			
			var time:String;
			var fr:DateFormatter = new DateFormatter();
			fr.formatString = "YYYY-MM-DD JJ:NN:SS";
			this.sendTime = fr.format(sendTime);
		}
		// 启动定时器，并调用子类中的检测函数，检测指令是否发送成功
		public function startCheck():void {
			if(isRun()) {
				timer.stop();
			}
			if(!ApplicationFacade.consoleStarted) {
				return;
			}
			timer = new Timer(checkTime, int(overTime / checkTime));// 初始化定时器
			timer.addEventListener(TimerEvent.TIMER, timerHandler);// timerHandler是检测函数，在子类中实现
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, completeHandler);
			//timer.reset();
			timer.start();
		}
		public function stopCheck():void {
			if(isRun()) {
				timer.stop();
			}
		}
		// 检测的结果处理
		public function result(rpcEvent:Object):void {
			if(rpcEvent.result == "1") {// webservice返回值是1，说明检测成功
				timer.stop();
				sendNotification(successStr);
			} else {
				// 表示发送的时间超时，发送超时事件
				if(timer.currentCount == int(overTime / checkTime)) {
					sendNotification(overTimeStr);
					return;
				}
				// 如果没有超时，说明指令正在发送，发送正在发送事件
				sendNotification(failedStr);
			}
		}
		// 连接webservice失败，发送CONNECT_FAILED指令
		public function fault(rpcEvent:Object):void {
			sendNotification(CONNECT_FAILED);
		}
		// 如果定时器为空，或者停止，返回false。反之返回true
		public function isRun():Boolean {
			if(timer == null) {
				return false;
			} else {
				return timer.running;
			}
		}

	}
}