package com.fallmind.solars.view.systemMediator
{
	import com.fallmind.solars.model.CurrentDataProxy;
	import com.fallmind.solars.model.HistoryAlarmProxy;
	import com.fallmind.solars.model.LoginProxy;
	import com.fallmind.solars.view.component.solarSystem.HistoryAlarmView;
	
	import flash.events.Event;
	
	import mx.formatters.DateFormatter;
	import mx.managers.PopUpManager;
	import mx.controls.Alert;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;

	public class HistoryAlarmMediator extends Mediator
	{
		public static const NAME:String = "HistoryAlarmMediator";
		private var loginProxy:LoginProxy;
		private var currentDataProxy:CurrentDataProxy;
		private var historyAlarmProxy:HistoryAlarmProxy;
		public function HistoryAlarmMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);
			loginProxy = LoginProxy(facade.retrieveProxy(LoginProxy.NAME));
			currentDataProxy = CurrentDataProxy(facade.retrieveProxy(CurrentDataProxy.NAME));
			historyAlarmProxy = HistoryAlarmProxy(facade.retrieveProxy(HistoryAlarmProxy.NAME));
			
			historyAlarmView.addEventListener(HistoryAlarmView.CONFIRM_HISTORY_ALARM_VIEW, getHistoryAlarm);
			historyAlarmView.addEventListener(HistoryAlarmView.CLOSE_HISTORY_ALARM_VIEW, closeWindow);
			
		}
		public function init():void {
			historyAlarmView.addEventListener(HistoryAlarmView.CONFIRM_HISTORY_ALARM_VIEW, getHistoryAlarm);
			historyAlarmView.addEventListener(HistoryAlarmView.CLOSE_HISTORY_ALARM_VIEW, closeWindow);
		}
		private function getHistoryAlarm(e:Event):void {
			/*var fr:DateFormatter = new DateFormatter();
			fr.formatString = "YYYY-MM-DD JJ:NN:SS";
			//var timeString:String = fr.format(historyControlView.date);
			var startTime:String = fr.format(historyAlarmView.startTime);
			var endTime:String = fr.format(historyAlarmView.endTime); */
			var startTime:String = historyAlarmView.startYear.selectedItem.data + "-" + historyAlarmView.startMonth.selectedItem.data + "-" +
				historyAlarmView.startDay.selectedItem.data + " " + historyAlarmView.startHour.selectedItem.data + ":00";
			var endTime:String = historyAlarmView.endYear.selectedItem.data + "-" + historyAlarmView.endMonth.selectedItem.data + "-" +
				historyAlarmView.endDay.selectedItem.data + " " + historyAlarmView.endHour.selectedItem.data + ":00";
			historyAlarmProxy.getHistoryAlarm(loginProxy.getData().UserName, loginProxy.getData().UserPassword,
				currentDataProxy.getCurrentSystemID(), startTime, endTime);
		}
		public function get historyAlarmView():HistoryAlarmView {
			return viewComponent as HistoryAlarmView;
		}
		private function closeWindow(e:Event):void {
			PopUpManager.removePopUp(historyAlarmView);
			this.setViewComponent(null);
		}
		
		public override function listNotificationInterests():Array {
			return [
				HistoryAlarmProxy.GET_HISTORY_ALARM_SUCCESS
			];
		}
		public override function handleNotification(notification:INotification):void {
			switch(notification.getName()) {
				case HistoryAlarmProxy.GET_HISTORY_ALARM_SUCCESS:
					if(historyAlarmProxy.getData().row == undefined) {
						Alert.show("无数据");
						historyAlarmView.historyAlarmData = null;
						break;
					}
					historyAlarmView.historyAlarmData = historyAlarmProxy.getData().row;
					break;
				case HistoryAlarmProxy.GET_HISTORY_ALARM_SUCCESS:
					Alert.show("获取历史警告信息失败");
					break;
			}
		}
		
	}
}