package com.fallmind.solars.view.systemMediator
{
	import com.fallmind.solars.model.GetHistorySetupProxy;
	import com.fallmind.solars.view.component.solarSystem.HistorySetupDisplayView;
	
	import flash.events.Event;
	
	import mx.managers.PopUpManager;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class HistorySetupDisplayMediator extends Mediator
	{
		public static const NAME:String = "HistorySetupDisplayMediator";
		private var getHistorySetupProxy:GetHistorySetupProxy;
		public function HistorySetupDisplayMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);	
			getHistorySetupProxy = GetHistorySetupProxy(facade.retrieveProxy(GetHistorySetupProxy.NAME));
			
			historySetupDisplayView.addEventListener(HistorySetupDisplayView.CLOSW_HISTORYSETUP_DISPLAY_VIEW, closeWindow);
		}
		
		public function init():void {
			historySetupDisplayView.addEventListener(HistorySetupDisplayView.CLOSW_HISTORYSETUP_DISPLAY_VIEW, closeWindow);
		}
		
		private function closeWindow(e:Event):void {
			PopUpManager.removePopUp(historySetupDisplayView);
			this.setViewComponent(null);
		}
		
		public function get historySetupDisplayView():HistorySetupDisplayView {
			return viewComponent as HistorySetupDisplayView;
		}
		
		public function setData(data:XML):void {
			historySetupDisplayView.setData(data);
		}
	}
}