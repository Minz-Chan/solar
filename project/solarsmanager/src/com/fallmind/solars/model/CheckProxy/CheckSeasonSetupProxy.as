package com.fallmind.solars.model.CheckProxy
{
	import com.fallmind.solars.model.bussiness.SolarDelegate;
	
	import flash.events.TimerEvent;
	/**
	 * 判断设置季节默认配置指令是否设置成功
	 */
	public class CheckSeasonSetupProxy extends CheckSetProxy
	{
		public static const NAME:String = "CheckSeasonSetupProxy";
		public static const CHECK_SEASON_SETUP_SUCCESS:String = "CheckSeasonSetupSuccess";
		public static const CHECK_SEASON_SETUP_FAILED:String = "CheckSeasonSetupFailed";
		public static const CHECK_SEASON_SETUP_OVERTIME:String = "CheckSeasonSetupOverTime";
		public static const CHECK_SEASON_SETUP_WRONG:String = "CheckSeasonSetupWrong";
		
		public function CheckSeasonSetupProxy(data:Object = null)
		{
			super(NAME, data);
			
			successStr = CHECK_SEASON_SETUP_SUCCESS;
			failedStr = CHECK_SEASON_SETUP_FAILED;
			overTimeStr = CHECK_SEASON_SETUP_OVERTIME;
			wrongStr = CHECK_SEASON_SETUP_WRONG;
		}
		protected override function timerHandler(e:TimerEvent):void {
			var delegate:SolarDelegate = new SolarDelegate(this);
			delegate.checkSetSeason(userName, password, systemID, sendTime);
		}
		public function get seasonData():SeasonData {
			return data as SeasonData;
		}
		protected override function check(data:XML):Boolean {
			var saSourceText:String = data.row[0].@SA_StartTime;
			var wsSourceText:String = data.row[0].@WS_StartTime;
				
			if( seasonData.SA_StartTime_Month != int(saSourceText.substr(0, 2)).toString() ||
				seasonData.SA_StartTime_Day != int(saSourceText.substr(2, 2)).toString() ||
				seasonData.WS_StartTime_Month != int(wsSourceText.substr(0, 2)).toString() ||
				seasonData.WS_StartTime_Day != int(wsSourceText.substr(2, 2)).toString() ||
				seasonData.SA_Collector_T_H != data.row[0].@SA_Collector_T_H ||
				seasonData.WS_Collector_T_H != data.row[0].@WS_Collector_T_H ) {
				return false;	
			} else {
				return true;
			}

		}
		
	}
}