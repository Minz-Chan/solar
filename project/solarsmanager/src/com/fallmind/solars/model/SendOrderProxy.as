package com.fallmind.solars.model
{
	import com.fallmind.solars.ApplicationFacade;
	import com.fallmind.solars.model.bussiness.SolarDelegate;
	
	import mx.controls.Alert;
	import mx.formatters.DateFormatter;
	import mx.rpc.IResponder;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	/**
	 * 发送指令的类
	 */
	public class SendOrderProxy extends Proxy implements IProxy, IResponder
	{
		public static const NAME:String = "SendOrderProxy";
		public static const SEND_ORDER_SUCCESS:String = "SendOrderSuccess";
		public static const SEND_ORDER_FAILED:String = "SendOrderFailed";
		public static const CONSOLE_STOPED:String = "ConsoleStoped";
		
		public function SendOrderProxy(data:Object = null) 
		{
			super(NAME, data);
		}
		// 格式化主控器
		public function formatEpprom(userName:String, password:String, systemID:String, armID:String):void {
			var orderText:String;
		
			orderText = getOrder(int(armID).toString(16), "16", "0", "");
			
			var timeString:String = getCurrentTime();
			
			var delegate:SolarDelegate = new SolarDelegate(this);
			delegate.sendOrder(userName, password, systemID, orderText, timeString);
			trace("格式化Eprom, ARM_ID：" + armID + "指令：" + orderText);
 		}
 		// 时间广播
 		public function broadCastTime(userName:String, password:String, systemID:String, timeTxt:String, armID:String):void {
 			var orderText:String = getOrder(int(armID).toString(16), "15", "6", timeTxt);

			var timeString:String = getCurrentTime();
			
			var delegate:SolarDelegate = new SolarDelegate(this);
			delegate.sendOrder(userName, password, systemID, orderText, timeString);
			trace("时间广播, ARM_ID：" + armID + "时间字符串：" + timeTxt + "指令：" + orderText);
 		}
 		// 手动加水
 		public function manualAddWater(userName:String, password:String, systemID:String, maxWater:String, armID:String):void {
 			
 			var orderText:String = getOrder(int(armID).toString(16), "10", "1", int(maxWater).toString(16));
 			
 			
			var timeString:String = getCurrentTime();
			
			var delegate:SolarDelegate = new SolarDelegate(this);
			delegate.sendOrder(userName, password, systemID, orderText, timeString);
			
			trace("手动加水, ARM_ID:" + armID + "加水最大值:" + maxWater + "指令:" + orderText);
 		}
 		// 手动加热
 		public function manualAddTemp(userName:String, password:String, systemID:String, maxTemp:String, startElec:Boolean, armID:String):void {
 			var data:String = "";
 			if(!startElec) {
 				data += "00";
 			} else {
 				data += "01";
 			}
 			data += fillZero(1, (int(maxTemp) + 55).toString(16));
 			
 			var orderText:String = getOrder(int(armID).toString(16), "11", "2", data);
 			
			var timeString:String = getCurrentTime();
			
			var delegate:SolarDelegate = new SolarDelegate(this);
			delegate.sendOrder(userName, password, systemID, orderText, timeString);
			trace("手动加热，ARM_ID:" + armID + "温度最大值:" + maxTemp + "指令：" + orderText);
 		}
 		
 		// 设置系统部件安装情况，installState里面全是16进制
 		public function setInstallState(userName:String, password:String, systemID:String, installState:Array, armID:String):void {
 			var orderText:String;
 			
 			var data:String = "";
 			
 			for(var i:int = 0; i < installState.length; i++) {
 				if(i < 4 || i == 8 || i == 9) {
 					data += inverseData(fillZero(2, installState[i]));
 				} else if( i == 4 || i == 5 || i == 6 || i == 7 || i == 10) {
 					data += inverseData(fillZero(1, installState[i]));
 				}
 			}
 			
 			orderText = getOrder(int(armID).toString(16), "09", int("17").toString(16), data);
 			
 			
 			var timeString:String = getCurrentTime();
 			
 			var delegate:SolarDelegate = new SolarDelegate(this);
			delegate.sendOrder(userName, password, systemID, orderText, timeString);
			trace("设置系统部件安装情况，ARM_ID:" + armID + "指令：" + orderText);
 		}
 		// 获取系统部件安装情况
 		public function getSystemState(userName:String, password:String, systemID:String, armID:String):void {
 			
 			var orderText:String = getOrder(int(armID).toString(16), "08", "0", "");
 			
 			
			var timeString:String = getCurrentTime();
			
			var delegate:SolarDelegate = new SolarDelegate(this);
			delegate.sendOrder(userName, password, systemID, orderText, timeString);
			trace("查询系统部件安装情况, ARM_ID:" + armID + "指令：" + orderText);
 		}
 		// 获取系统当前数据
 		public function getCurrentSystemData(userName:String, password:String, systemID:String, armID:String):void {
 			var orderText:String = getOrder(int(armID).toString(16), "01", "0", "");
 
 			
			var timeString:String = getCurrentTime();
			
			var delegate:SolarDelegate = new SolarDelegate(this);
			delegate.sendOrder(userName, password, systemID, orderText, timeString);
			trace("查询系统当前数据, ARM_ID:" + armID + "指令：" + orderText);
 		}
 		// 获取系统当前设置
 		public function getCurrentSetup(userName:String, password:String, systemID:String, armID:String):void {
 			
 			var orderText:String = getOrder(int(armID).toString(16), "03", "0", "");
 			
 			
			var timeString:String = getCurrentTime();
			
			var delegate:SolarDelegate = new SolarDelegate(this);
			delegate.sendOrder(userName, password, systemID, orderText, timeString);
			trace("查询系统参数, ARM_ID:" + armID + "指令:" + orderText);
			
			
			
 		}
 		
 		/**
 		 * 查询輔助设备加热时间段值
 		 * 参  数：
 		 * userName, 用户名
 		 * password, 密码
 		 * systemID, 系统ID
 		 * armID, 	 主控制器ARM_ID
 		 */
 		public function getCurrentSetupAuxiliaryDeviceWork(userName:String, password:String, systemID:String, armID:String):void {
 			var orderText:String = getOrder(int(armID).toString(16), "25", "0", "");
 			
 			
			var timeString:String = getCurrentTime();
			
			var delegate:SolarDelegate = new SolarDelegate(this);
			delegate.sendOrder(userName, password, systemID, orderText, timeString);
			trace("查询輔助设备加热时间段值, ARM_ID:" + armID + "指令:" + orderText);
 		} 
 		
 		
 		// 设置系统参数，setupData是十进制数组，按协议中排列,其中24个小时供热水箱水位，这个是十六进制字符串
 		public function setSystemSetupOld(userName:String, password:String, systemID:String, setupData:Array, armID:String):void {
 			var setupText:String = "01";
 			for(var i:int = 0; i < setupData.length; i++) {
 				if( i <= 11 ) {			// 都是10进制，需要转换
 					
 					setupText += fillZero(1, int(setupData[i]).toString(16));
 				}
 				else if(i == 13) {
 				
 					setupText += inverseData(fillZero(2, int(setupData[i]).toString(16)));
 				}
 				else if( i == 12 ) {		// 供热水箱单位时段最低 水位和产供最低水位配比,已经是组好的16进制数
 					setupText += setupData[i].toString();
 				} else if( i == 14) {
 					setupText += inverseData(fillZero(3, int(setupData[i]).toString(16)));
 				}
 				
 			}
 			var orderText:String = getOrder(int(armID).toString(16), "05", int("42").toString(16), setupText);
 			
 			
			var timeString:String = getCurrentTime();
			
			var delegate:SolarDelegate = new SolarDelegate(this);
			delegate.sendOrder(userName, password, systemID, orderText, timeString);
			trace("设置系统参数, ARM_ID:" + armID + "指令:" + orderText);
 		}
 		
 		
 		/**
 		 * 设置系统控制参数(12 byte)、恒热水箱分时间段水位(6*3 byte)、中央热水系统供热时间段水位(6*2 byte)
 		 * 参  数：
 		 *   setupData, setupData是字符串数组，按协议中排列
 		 * 返回值：
 		 *   空
 		 */ 
 		public function setSystemSetup(userName:String, password:String, systemID:String, setupData:Array, armID:String):void {
 			var setupText:String = "01";
 			for(var i:int = 0; i < setupData.length; i++) {
 				if( i <= 11 ) {			// 12项配置参数，都是10进制，需要转换
 					
 					setupText += fillZero(1, int(setupData[i]).toString(16));
 				}
 				else if(i == 13) { // 产供水箱最低水位配对比
 					setupText += inverseData(fillZero(2, int(setupData[i]).toString(16)));
 				}
 				else if( i == 12 ) {		// 恒热水箱分时间段水位值，6*3 byte，已是组好的十六进制数
 					setupText += setupData[i].toString();
 				} else if( i == 14) { // 中央热水系统供热时间段增压泵阀开启状态，6*2 byte ，已是组好的16进制数
 					//setupText += inverseData(fillZero(3, int(setupData[i]).toString(16)));
 					setupText += setupData[i].toString();
 				}
 				
 			}
 			
 			// 数据长度由原来的42 -> 46
 			var orderText:String = getOrder(int(armID).toString(16), "05", int("45").toString(16), setupText);
 			
 			
			var timeString:String = getCurrentTime();
			
			// 指令下发:控制参数、恒热水箱分时间段水位、中央热水系统供热时间段水位设置   Added By Minz.chan 2013.01.27
			var delegate:SolarDelegate = new SolarDelegate(this);
			delegate.sendOrder(userName, password, systemID, orderText, timeString);
			trace("设置系统参数, ARM_ID:" + armID + "指令:" + orderText);
			
			// 指令下发:辅助设备加热时间段
			setAuxiliaryHeat(userName, password, systemID, setupData[15], armID);
			
 		}
 		
 		/**
 		 * 设置辅助设备加热时间段
 		 * 参  数：
 		 *   setupData, 辅助设备时间段值字符串(12 byte)，如02535B90FFFF8CABB4EBFFFF
 		 * 返回值：
 		 *   空
 		 */ 
 		public function setAuxiliaryHeat(userName:String, password:String, systemID:String, setupData:String, armID:String):void {
 			var setupText:String = "01";
 			
 			// 辅助设备加热时间段设置值，6*2 byte
 			setupText += setupData;		
 			
 			var orderText:String = getOrder(int(armID).toString(16), "26", int("13").toString(16), setupText);
 			
 			
			var timeString:String = getCurrentTime();
			
			// 指令下发: 辅助设备加热时间段设置  Added By Minz.chan 2013.01.27
			var delegate:SolarDelegate = new SolarDelegate(this);
			delegate.sendOrder(userName, password, systemID, orderText, timeString);
			trace("设置辅助设备加热时间段, ARM_ID:" + armID + "指令:" + orderText);		
 		}
 		
 		// 获取四级默认参数
 		public function getSeasonDefaultSetup(userName:String, password:String, systemID:String, armID:String):void {
 			var orderText:String = getOrder(int(armID).toString(16), "06", "0", "");
 			
 			
			var timeString:String = getCurrentTime();
			
			var delegate:SolarDelegate = new SolarDelegate(this);
			delegate.sendOrder(userName, password, systemID, orderText, timeString);
			trace("查询四季默认参数，ARM_ID:" + armID + "指令：" + orderText);
 		}
 		// 重启系统
 		public function restartSystem(userName:String, password:String, systemID:String, armID:String):void {
 			
 			var orderText:String = getOrder(int(armID).toString(16), "14", "0", "");
 			
 			
			var timeString:String = getCurrentTime();
			
			var delegate:SolarDelegate = new SolarDelegate(this);
			delegate.sendOrder(userName, password, systemID, orderText, timeString);
			trace("主控器重启，ARM_ID:" + armID + "指令：" + orderText);
 		}
 		// 获取系统版本
 		public function getSystemVersion(userName:String, password:String, systemID:String, armID:String):void {
 			var orderText:String = getOrder(int(armID).toString(16), "17", "0", "");
 			
 			
			var timeString:String = getCurrentTime();
			
			var delegate:SolarDelegate = new SolarDelegate(this);
			delegate.sendOrder(userName, password, systemID, orderText, timeString);
			trace("查询系统版本，ARM_ID:" + armID + "指令：" + orderText);
 		}
 		// 设置系统时间
 		public function setSystemTime(userName:String, password:String, systemID:String, timeTxt:String, armID:String):void {
 			var orderText:String = getOrder(int(armID).toString(16), "21", "6", timeTxt);
 			
 			
			var timeString:String = getCurrentTime();
			
			var delegate:SolarDelegate = new SolarDelegate(this);
			delegate.sendOrder(userName, password, systemID, orderText, timeString);
			trace("设置系统时间，ARM_ID:" + armID + "时间字符串：" + timeTxt + "指令：" + orderText);
 		}
 		// 获取系统时间
 		public function getSystemTime(userName:String, password:String, systemID:String, armID:String):void {
 			var orderText:String = getOrder(int(armID).toString(16), "20", "0", "");
 			
 		
			var timeString:String = getCurrentTime();
			
			var delegate:SolarDelegate = new SolarDelegate(this);
			delegate.sendOrder(userName, password, systemID, orderText, timeString);
			trace("查询系统时间，ARM_ID:" + armID + "指令：" + orderText);
 		}
 		// 设置四级默认配置
 		public function setSeasonDefaultSetup(userName:String, password:String, systemID:String, summerTime:String, summerData:String, winterTime:String, winterData:String, armID:String):void {
 			summerData = fillZero(1, summerData);
 			summerTime = fillZero(2, summerTime);
 			
 			winterData = fillZero(1, winterData);
 			winterTime = fillZero(2, winterTime);
 			
 			var totalData:String = summerTime + summerData + winterTime + winterData;
 			
 			var orderText:String = getOrder(int(armID).toString(16), "07", "6", totalData);
 			
 			
			var timeString:String = getCurrentTime();
			
			var delegate:SolarDelegate = new SolarDelegate(this);
			delegate.sendOrder(userName, password, systemID, orderText, timeString);
			trace("设置四季默认参数，ARM_ID：" + armID + "夏季时间：" + summerTime + "夏季参数：" + summerData + "冬季时间:" + winterTime + "冬季参数：" + winterData + "指令：" + orderText);
 		}
 		// 获取系统密码
 		public function getSystemPassword(userName:String, password:String, systemID:String, armID:String):void {
 			var orderText:String = getOrder(int(armID).toString(16), "18", "0", "");
 			
 			
			var timeString:String = getCurrentTime();
			
			var delegate:SolarDelegate = new SolarDelegate(this);
			delegate.sendOrder(userName, password, systemID, orderText, timeString);
			trace("查询系统密码，ARM_ID:" + armID + "指令：" + orderText);
 		}
 		// 设置系统密码
 		public function setSystemPassword(userName:String, password:String, systemID:String, systemPassword:String, armID:String):void {
 			var convertPassword:String = "";
 			for(var i:int = 0; i < systemPassword.length; i++) {
 				//convertPassword += "3" + systemPassword.charAt(i);
 				convertPassword += fillZero(1, int(systemPassword.charCodeAt(i)).toString(16));
 				//convertPassword += fillZero(1, int(systemPassword.charCodeAt(i)).toString());
 			}
 			
 			var orderText:String = getOrder(int(armID).toString(16), "19", "6", convertPassword);
 			
 			
			var timeString:String = getCurrentTime();
			
			var delegate:SolarDelegate = new SolarDelegate(this);
			delegate.sendOrder(userName, password, systemID, orderText, timeString);
			trace("设置系统密码, ARM_ID:" + armID + "密码:" + systemPassword + "指令:" + orderText);
 		}
 		// 系统自检
 		public function selfCheck(userName:String, password:String, systemID:String, armID:String):void {
 			var orderText:String = getOrder(int(armID).toString(16), "13", "0", "");
 			
			var timeString:String = getCurrentTime();
			
			var delegate:SolarDelegate = new SolarDelegate(this);
			delegate.sendOrder(userName, password, systemID, orderText, timeString);
			
			trace("系统自检，ARM_ID:" + armID + "指令：" + orderText);
 		}
 		/**
 		 *  如果数据转换成16进制以后，位数不够，要在数据前面补0。
 		 * byte 转换以后的字节数
 		 * sourceStr 源数据
 		 */
 		public static function fillZero(byte:int, sourceStr:String):String {		// sourceStr是16进制
 			var outputStr:String = "";
 			for(var j:int = 0; j < 2 * byte - sourceStr.length; j++) {
 				outputStr += "0";
 			}
 			outputStr += sourceStr;
 			return outputStr;
 		}
 		/**
 		 * 计算指令码
 		 * armID 主控器ID
 		 * functionCode 功能码
 		 * dataLength 数据长度
 		 * data 数据
 		 */
 		private function getOrder(armID:String, functionCode:String, dataLength:String, data:String):String {
 			var checkout:int = 0xEA;
 			var orderWithoutCheckout:String = fillZero(1, armID) + fillZero(1, functionCode) + fillZero(1, dataLength) + fillZero(int(dataLength), data);
 			for(var i:int = 0; i <= orderWithoutCheckout.length - 2; i += 2) {
 				var a:int = parseInt(orderWithoutCheckout.substr(i, 2), 16);
 				checkout = checkout ^ parseInt(orderWithoutCheckout.substr(i, 2), 16);
 			}
 			
 			if(functionCode == "01" && ApplicationFacade.getCurrentData != 1) {
 				ApplicationFacade.getCurrentData = 0;
 			} else if(functionCode != "01") {
 				ApplicationFacade.getCurrentData = 2;
 			}
 			return "EFEF" + fillZero(1, checkout.toString(16)).toUpperCase() + orderWithoutCheckout.toUpperCase();
 		}
 		// 把数据高地位颠倒,参数是正常的十六进制字符串
 		private function inverseData(data:String):String {
 			var result:String = "";
 			
 			for(var i:int = data.length - 1; i >= 1; i -= 2) {
 				result += data.charAt(i-1) + data.charAt(i);
 			}
 			return result;
 		}
 		// 计算发送指令的时间
 		private function getCurrentTime():String {
 			var time:Date = new Date();
			var fr:DateFormatter = new DateFormatter();
			fr.formatString = "YYYY-MM-DD JJ:NN:SS";
			return fr.format(time);
 		}
 		public function result(rpcEvent:Object):void {
 			var alarmContent:String = null;
 			if(rpcEvent.result == "0") {
 				alarmContent = "控制台软件未开启或控制台软件串口未打开，指令无法发送！";
 			} else if(rpcEvent.result == "1") {
 				alarmContent = "该太阳能系统的通讯异常，无法发送指令！";
 			}
 			// "0"表示控制台未开启，"1"表示通讯异常
 			if(rpcEvent.result == "0" || rpcEvent.result == "1") {
 				ApplicationFacade.consoleStarted = false; 
 				sendNotification(CONSOLE_STOPED);
 				// 下面一系列判断是为了防止因为频繁发送查询当前数据的指令，而导致错误提示窗口一直弹出
 				if(ApplicationFacade.getCurrentData == 0) {// 表示当前指令为01指令，并且是第一次检测控制台和太阳能系统通讯情况。正常显示错误提示
 					Alert.show(alarmContent);
 					ApplicationFacade.getCurrentData = 1;
 				} else if(ApplicationFacade.getCurrentData == 1) {// 表示当前指令为01指令，并且已经检测过控制台和太阳能系统通讯情况。
 					return;
 				} else if(ApplicationFacade.getCurrentData == 2) {// getCurrentData为2，意思是所发送指令不是01指令。就正常显示错误提示
 					Alert.show(alarmContent);
 				}
 			} else {   // 如果控制台已开启，并且通讯正常
 				ApplicationFacade.consoleStarted = true;
 				sendNotification(SEND_ORDER_SUCCESS, rpcEvent.result);
 			}
 		}
 		public function fault(rpcEvent:Object):void {
 			sendNotification(SEND_ORDER_FAILED);
 		}
	}
}