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
	
	public class CheckSetProxy extends Proxy implements IProxy, IResponder
	{
		protected var timer:Timer;
		protected var successStr:String;	// 指令发送成功的事件字符串，由子类赋值
		protected var failedStr:String;		// 指令正在发送的事件字符串，由子类赋值
		protected var overTimeStr:String;	// 指令发送超时的事件字符串，由子类赋值
		protected var wrongStr:String;		// 指令返回值与设置值不同的事件字符串，由子类赋值
		
		public static const CONNECT_FAILED:String = "ConnectFailed";
		
		
		protected var userName:String;
		protected var password:String;
		protected var systemID:String;
		protected var sendTime:String;
		
		private var config:ConfigManager;
		private var overTime:int;
		private var checkTime:int;
		
		private var hasChecked:Boolean = false;
		
		public function CheckSetProxy(name:String, data:Object = null)
		{
			super(name, data);
			config = ConfigManager.getManageManager();
			overTime = config.getOverTime();
			checkTime = config.getCheckTime();
		}
		// 检测指令发送情况的函数，由子类实现
		protected function timerHandler(e:TimerEvent):void {
			return;
		}
		protected function completeHandler(e:TimerEvent):void {
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
		// 计时器开始计时
		public function startCheck():void {
			if(isRun()) {
				timer.stop();
			}
			if(!ApplicationFacade.consoleStarted) {
				return;
			}
			timer = new Timer(checkTime, int(overTime / checkTime));
			timer.addEventListener(TimerEvent.TIMER, timerHandler);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, completeHandler);

			timer.start();
		}
		public function stopCheck():void {
			if(isRun()) {
				timer.stop();
			}
		}
		public function result(rpcEvent:Object):void {
			// 只有指令被执行了，才会有返回值，如果返回值为空，说明指令正在发送中。
			if(rpcEvent.result != null) {
				timer.stop();
				// 调用子类的check函数，判断返回值与设置值是否一致，如果一致就发送指令发送成功的事件，否则就发送发送指令失败的指令
				if(check(XML(rpcEvent.result)) == false) {
					sendNotification(wrongStr);
				} else {
					sendNotification(successStr);
				}
			} else {
				// 判断是否超时
				if(timer.currentCount == int(overTime / checkTime)) {
					sendNotification(overTimeStr);
					return;
				}
				sendNotification(failedStr);
			}
		}
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
		// 判断返回值是否与设置值相同，因为每个类的判断方法不同，所以由子类实现
		protected function check(data:XML):Boolean {
			return true;
		}

	}
}