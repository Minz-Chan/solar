package com.fallmind.solars.view.systemMediator
{
	import com.fallmind.solars.model.CurrentDataProxy;
	import com.fallmind.solars.model.GetHistorySetupProxy;
	import com.fallmind.solars.model.LoginProxy;
	import com.fallmind.solars.view.component.solarSystem.HistorySetupDisplayView;
	import com.fallmind.solars.view.component.solarSystem.HistorySetupView;
	
	import flash.events.Event;
	
	import mx.controls.Alert;
	import mx.managers.PopUpManager;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;

	public class HistorySetupMediator extends Mediator
	{
		public static const NAME:String = "HistorySetupMediator";
		private var historySetupProxy:GetHistorySetupProxy;
		private var loginProxy:LoginProxy;
		private var currentSystemDataProxy:CurrentDataProxy;
		private var userName:String;
		private var password:String;
		
		private var firstCreate:Boolean = true;
		
		public function HistorySetupMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);
			historySetupProxy = GetHistorySetupProxy(facade.retrieveProxy(GetHistorySetupProxy.NAME));
			currentSystemDataProxy = CurrentDataProxy(facade.retrieveProxy(CurrentDataProxy.NAME));
			loginProxy = LoginProxy(facade.retrieveProxy(LoginProxy.NAME));
			
			historySetupView.addEventListener(HistorySetupView.HISTORYSETUP_VIEW_CONFIRM, getHistorySetupHandler);
			historySetupView.addEventListener(HistorySetupView.CLOSE_HISTORY_SETUP_VIEW, closeWindow);
			historySetupView.addEventListener(HistorySetupView.SHOW_HISTORY_SETUP_DETAIL, showHistorySetupDetail);
			userName = loginProxy.getData().UserName;
			password = loginProxy.getData().UserPassword;
		}
		private function showHistorySetupDetail(e:Event):void {
			createDisplayView(XML(historySetupView.historySetupDataGrid.selectedItem))
		}
		private function closeWindow(e:Event):void {
			PopUpManager.removePopUp(historySetupView);
			this.setViewComponent(null);
		}
		
		public function init():void {
			historySetupView.addEventListener(HistorySetupView.HISTORYSETUP_VIEW_CONFIRM, getHistorySetupHandler);
			historySetupView.addEventListener(HistorySetupView.CLOSE_HISTORY_SETUP_VIEW, closeWindow);
		}
		
		public function get historySetupView():HistorySetupView {
			return viewComponent as HistorySetupView;
		}
		
		public override function listNotificationInterests():Array {
			return [
				GetHistorySetupProxy.GET_HISTORYSETUP_SUCCESS
			];
		}
		public override function handleNotification(notification:INotification):void {
			switch(notification.getName()) {
				case GetHistorySetupProxy.GET_HISTORYSETUP_SUCCESS:	
					if(XMLList(historySetupProxy.getData().row).length() == 0) {
						Alert.show("无数据");
						historySetupView.historySetupData = null;
						return;
					} else {
						//createDisplayView(historySetupProxy.getData().row);
						historySetupView.historySetupData = historySetupProxy.getData().row;
					}
			}
		}
		
		private function createDisplayView(data:XML):void {
			var u:HistorySetupDisplayView = HistorySetupDisplayView(PopUpManager.createPopUp(historySetupView.parent, HistorySetupDisplayView, true));
			//u.x = historySetupView.stage.width / 2 - u.width / 2;
			//u.y = historySetupView.stage.height / 2 - u.height / 2;
			PopUpManager.centerPopUp(u);
			if( firstCreate) {
				var temp:HistorySetupDisplayMediator = new HistorySetupDisplayMediator(u);
				facade.registerMediator(new HistorySetupDisplayMediator(u));
				firstCreate = false;
				temp.setData(data);
			} else {
				var temp:HistorySetupDisplayMediator = facade.retrieveMediator(HistorySetupDisplayMediator.NAME) as HistorySetupDisplayMediator;
				temp.setViewComponent(u); 
				temp.init();
				temp.setData(data);
			}
		}
		
		private function getHistorySetupHandler(e:Event):void {
			var startTime:String = historySetupView.startYear.selectedItem.data + "-" + historySetupView.startMonth.selectedItem.data + "-" +
				historySetupView.startDay.selectedItem.data + " " + historySetupView.startHour.selectedItem.data + ":" + historySetupView.startMinute.selectedItem.data;
			var endTime:String = historySetupView.endYear.selectedItem.data + "-" + historySetupView.endMonth.selectedItem.data + "-" +
				historySetupView.endDay.selectedItem.data + " " + historySetupView.endHour.selectedItem.data + ":" + historySetupView.endMinute.selectedItem.data;
			
			historySetupProxy.GetHistorySetup(userName, password, currentSystemDataProxy.getCurrentSystemID(), startTime, endTime);
		}
	}
}