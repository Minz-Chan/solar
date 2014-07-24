// ActionScript file
package com.fallmind.solars.model.CheckProxy {
	import com.fallmind.solars.ApplicationFacade;
	import com.fallmind.solars.model.bussiness.ConfigManager;
	import com.fallmind.solars.model.bussiness.SolarDelegate;
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.formatters.DateFormatter;
	/**
	 * 判断设置系统参数的指令是否发送成功
	 */
	public class CheckSetSetupProxy extends CheckSetProxy {
		public static const NAME:String = "CheckSetSetupProxy";
		public static const CHECK_SET_SETUP_OVERTIME:String = "CheckSetSetupOvertime";// 指令超时发送的事件
		public static const CHECK_SET_SETUP_FAILED:String = "CheckSetSetupFailed";	// 指令正在发送的事件
 		public static const CHECK_SET_SETUP_SUCCESS:String = "CheckSetSetupSuccess";// 指令执行成功发送的事件
		public static const CHECK_SET_SETUP_WRONG:String = "CheckSetSetupWrong";	// 当设置不成功时发送的事件
		
		public function CheckSetSetupProxy(data:Object = null) {
			super(NAME, data);
			
			successStr = CHECK_SET_SETUP_SUCCESS;
			failedStr = CHECK_SET_SETUP_FAILED;
			overTimeStr = CHECK_SET_SETUP_OVERTIME;
			wrongStr = CHECK_SET_SETUP_WRONG;
		}
		public function get setupData():SetupData {
			return data as SetupData;
		}
		
		protected override function timerHandler(e:TimerEvent):void {
			var delegate:SolarDelegate = new SolarDelegate(this);
			delegate.checkSetSetup(userName, password, systemID, sendTime);
		}
		protected override function completeHandler(e:TimerEvent):void {
			return;
		}
		/**
		 * 判断返回的设置值与用户希望的设置值是否相同
		 */
		protected override function check(result:XML):Boolean {
			if(setupData.Collector_Box_T != result.SystemSetup.row.@Collector_Box_T ||
				setupData.Collector_T_H != result.SystemSetup.row.@Collector_T_H ||
				setupData.Collector_T_L != result.SystemSetup.row.@Collector_T_L ||
				setupData.OfferBox_Def_WL_L != result.SystemSetup.row.@OfferBox_Def_WL_L ||
				setupData.OfferBox_T_H != result.SystemSetup.row.@OfferBox_T_H ||
				setupData.OfferBox_T_L != result.SystemSetup.row.@OfferBox_T_L ||
				setupData.OfferBox_WL_H != result.SystemSetup.row.@OfferBox_WL_H ||
				setupData.Product_Offer_T != result.SystemSetup.row.@Product_Offer_T ||
				setupData.ProductBox_T_H != result.SystemSetup.row.@ProductBox_T_H ||
				setupData.ProductBox_T_L != result.SystemSetup.row.@ProductBox_T_L ||
				setupData.ProductBox_WL_H != result.SystemSetup.row.@ProductBox_WL_H ||
				setupData.ReturnPipe_T_L != result.SystemSetup.row.@ReturnPipe_T_L ||
				setupData.TwoBox_WL_Scale != Number(result.SystemSetup.row.@TwoBox_WL_Scale).toFixed(2) ) {
				return false;
			}
			else {
				return true;
			}
		}
	}
}