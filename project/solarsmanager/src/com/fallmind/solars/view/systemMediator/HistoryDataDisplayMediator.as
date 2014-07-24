package com.fallmind.solars.view.systemMediator
{
	import com.fallmind.solars.model.GetHistoryDataProxy;
	import com.fallmind.solars.model.LoginProxy;
	import com.fallmind.solars.view.component.solarSystem.HistoryDataDisplayView;
	
	import flash.events.Event;
	
	import mx.managers.PopUpManager;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class HistoryDataDisplayMediator extends Mediator
	{
		public static const NAME:String = "HistoryDataDisplayMediator";
		private var getHistoryDataProxy:GetHistoryDataProxy;
		private var loginProxy:LoginProxy;
		public var startTime:String;
		public var endTime:String;
		public var systemID:String;
		
		public function HistoryDataDisplayMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);	
			getHistoryDataProxy = GetHistoryDataProxy(facade.retrieveProxy(GetHistoryDataProxy.NAME));
			loginProxy = LoginProxy(facade.retrieveProxy(LoginProxy.NAME));
			
			historyDataDisplayView.addEventListener(HistoryDataDisplayView.CLOSW_HISTORYDATA_DISPLAY_VIEW, closeWindow);
			historyDataDisplayView.addEventListener(HistoryDataDisplayView.NEXT_PAGE, nextPageHandler);
		}
		private function nextPageHandler(e:Event):void {
			getHistoryDataProxy.GetHistoryData(loginProxy.getUserName(), loginProxy.getUserPassword(), systemID, 
				startTime, endTime, (int(historyDataDisplayView.pageIndex) + 1).toString(), historyDataDisplayView.pageSize);
		}
		
		public function init():void {
			historyDataDisplayView.addEventListener(HistoryDataDisplayView.CLOSW_HISTORYDATA_DISPLAY_VIEW, closeWindow);
			historyDataDisplayView.addEventListener(HistoryDataDisplayView.NEXT_PAGE, nextPageHandler);
		}
		
		private function closeWindow(e:Event):void {
			PopUpManager.removePopUp(historyDataDisplayView);
			HistoryDataMediator(facade.retrieveMediator(HistoryDataMediator.NAME)).historyDisplayViewIsShowed = false;
			this.setViewComponent(null);
		}
		
		public function get historyDataDisplayView():HistoryDataDisplayView {
			return viewComponent as HistoryDataDisplayView;
		}
		public override function listNotificationInterests():Array {
			return [
				GetHistoryDataProxy.GET_HISTORYDATA_SUCCESS
			];
		}
		public override function handleNotification(notification:INotification):void {
			switch(notification.getName()) {
				case GetHistoryDataProxy.GET_HISTORYDATA_SUCCESS:	
					historyDataDisplayView.setData(getHistoryDataProxy.getData().Data[0]);
					break;
			}
		}
		
	}
}