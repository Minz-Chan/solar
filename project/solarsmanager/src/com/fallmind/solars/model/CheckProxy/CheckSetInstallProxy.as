// ActionScript file
// ActionScript file
package com.fallmind.solars.model.CheckProxy {
	import com.fallmind.solars.model.bussiness.SolarDelegate;
	
	import flash.events.TimerEvent;
	/**
	 * 检测设置当前系统安装情况的指令是否成功
	 */
	public class CheckSetInstallProxy extends CheckSetProxy {
		public static const NAME:String = "CheckSetInstallProxy";
		public static const CHECK_SET_INSTALL_OVERTIME:String = "CheckSetInstallOvertime";// 指令超时发送的事件
		public static const CHECK_SET_INSTALL_FAILED:String = "CheckSetInstallFailed";	// 指令正在发送的事件
 		public static const CHECK_SET_INSTALL_SUCCESS:String = "CheckSetInstallSuccess";// 指令执行成功发送的事件
		public static const CHECK_SET_INSTALL_WRONG:String = "CheckSetInstallWrong";	// 当设置不成功时发送的事件
		
		public function CheckSetInstallProxy(data:Object = null) {
			super(NAME, data);
			
			
			successStr = CHECK_SET_INSTALL_SUCCESS;
			failedStr = CHECK_SET_INSTALL_FAILED;
			overTimeStr = CHECK_SET_INSTALL_OVERTIME;
			wrongStr = CHECK_SET_INSTALL_WRONG;
		}
		public function get installData():InstallData {
			return data as InstallData;
		}
		
		protected override function timerHandler(e:TimerEvent):void {
			var delegate:SolarDelegate = new SolarDelegate(this);
			delegate.checkSetInstall(userName, password, systemID, sendTime);
		}
		protected override function completeHandler(e:TimerEvent):void {
			return;
		}
		/**
		 * 判断返回的设置值与用户希望的设置值是否相同
		 */
		protected override function check(result:XML):Boolean {
			var airHeat_COP:String;
			var elecHeat_Efficient:String;
			var elecHeat_Value:String;
			if(String(result.row[0].@AirHeat_Fix).charAt(0) == "0") {
				airHeat_COP = "";
			} else {
				airHeat_COP = Number(result.row[0].@AirHeat_COP).toFixed(2);
			}
			if(String(result.row[0].@ElecHeat_Fix).charAt(0) == "0") {
				elecHeat_Efficient = "";
				elecHeat_Value = "";
			} else {
				elecHeat_Efficient = result.row[0].@ElecHeat_Efficient;
				elecHeat_Value = result.row[0].@ElecHeat_Value;
			}
			if(installData.AirHeat_COP != airHeat_COP ||
				installData.airPumpConnect != int(String(result.row[0].@AirHeat_Fix).charAt(4)) || 
				installData.airPumpState != int(String(result.row[0].@AirHeat_Fix).charAt(0)) ||
				installData.airStart != int(String(result.row[0].@AirHeat_Fix).charAt(2)) ||
				installData.circleConnect != int(result.row[0].@CycleHose_ConnectObj) ||
				installData.coldPumpConnect != int(String(result.row[0].@ColdHose_Fix).charAt(2)) ||
				installData.coldPumpState != int(String(result.row[0].@ColdHose_Fix).charAt(0)) ||
				installData.Collector_Cubage != result.row[0].@Collector_Cubage ||
				installData.ElecHeat_Efficient != elecHeat_Efficient ||
				installData.ElecHeat_Value != elecHeat_Value ||
				installData.elecPumpConnect != int(String(result.row[0].@ElecHeat_Fix).charAt(4)) ||
				installData.elecPumpState != int(String(result.row[0].@ElecHeat_Fix).charAt(0)) ||
				installData.elecStart != int(String(result.row[0].@ElecHeat_Fix).charAt(2)) ||
				installData.j1State != int(result.row[0].@Collector1_Fix) ||
				installData.j2State != int(result.row[0].@Collector2_Fix) ||
				installData.j3State != int(result.row[0].@Collector3_Fix) ||
				installData.jConnect != int(result.row[0].@OutHose_ConnectObj) ||
				installData.OfferBox_Cubage != result.row[0].@OfferBox_Cubage ||
				installData.OfferBox_height != (Number(result.row[0].@OfferBox_height) / 10).toString() ||
				installData.OLSensorRange != (Number(result.row[0].@OLSensorRange) / 10).toString() ||
				installData.PLSensorRange != (Number(result.row[0].@PLSensorRange) / 10).toString() ||
				installData.ProductBox_Cubage != result.row[0].@ProductBox_Cubage ||
				installData.ProductBox_height != (Number(result.row[0].@ProductBox_height) / 10).toString() ) {
				return false;
			} else {
				return true;
			}
		}
	}
	
}