package com.fallmind.solars.view.systemMediator
{
	import com.fallmind.solars.model.CurrentDataProxy;
	import com.fallmind.solars.model.LoginProxy;
	import com.fallmind.solars.model.SendOrderProxy;
	import com.fallmind.solars.view.component.solarSystem.SetTimeView;
	import mx.managers.PopUpManager;
	
	import flash.events.Event;
	
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class BroadcastTimeMediator extends Mediator
	{
		public static const NAME:String = "BroadcastTimeMediator";
		
		private var sendOrderProxy:SendOrderProxy;
		private var currentDataProxy:CurrentDataProxy;
		private var loginProxy:LoginProxy;
		
		
		public function BroadcastTimeMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);
			
			loginProxy = LoginProxy(facade.retrieveProxy(LoginProxy.NAME));
			currentDataProxy = CurrentDataProxy(facade.retrieveProxy(CurrentDataProxy.NAME));
			sendOrderProxy = SendOrderProxy(facade.retrieveProxy(SendOrderProxy.NAME));
			
			setTimeView.addEventListener(SetTimeView.CLOSE_SET_TIME_VIEW, closeWindow);
			setTimeView.addEventListener(SetTimeView.SAVE_TIME, saveTime);	
			
			currentDataProxy.stopQuery();
		}
		
		private function saveTime(e:Event):void {
			var timeTxt:String = "";
			for(var j:int = 0; j < 2 - int(setTimeView.yearText.text.substr(2, 2)).toString(16).length; j++) {
 				timeTxt += "0";
 			}
 			timeTxt += int(setTimeView.yearText.text.substr(2,2)).toString(16);
 			for(var j:int = 0; j < 2 - int(setTimeView.monthText.text).toString(16).length; j++) {
 				timeTxt += "0";
 			}
 			timeTxt += int(setTimeView.monthText.text).toString(16);
 			for(var j:int = 0; j < 2 - int(setTimeView.dayText.text).toString(16).length; j++) {
 				timeTxt += "0";
 			}
 			timeTxt += int(setTimeView.dayText.text).toString(16);
 			for(var j:int = 0; j < 2 - int(setTimeView.hourText.text).toString(16).length; j++) {
 				timeTxt += "0";
 			}
 			timeTxt += int(setTimeView.hourText.text).toString(16);
 			for(var j:int = 0; j < 2 - int(setTimeView.minuteText.text).toString(16).length; j++) {
 				timeTxt += "0";
 			}
 			timeTxt += int(setTimeView.minuteText.text).toString(16);
 			for(var j:int = 0; j < 2 - int(setTimeView.secondText.text).toString(16).length; j++) {
 				timeTxt += "0";
 			}
 			timeTxt += int(setTimeView.secondText.text).toString(16);
 			
 			sendOrderProxy.broadCastTime(loginProxy.getUserName(), loginProxy.getUserPassword(), currentDataProxy.getCurrentSystemID(), timeTxt, currentDataProxy.getARM_ID());
		}
		private function closeWindow(e:Event):void {
			PopUpManager.removePopUp(setTimeView);
			this.setViewComponent(null);
			
			currentDataProxy.startQuery();
		}
		public function init():void {
			setTimeView.addEventListener(SetTimeView.CLOSE_SET_TIME_VIEW, closeWindow);
			setTimeView.addEventListener(SetTimeView.SAVE_TIME, saveTime);	
		}
		public function get setTimeView():SetTimeView {
			return viewComponent as SetTimeView;
		}

	}
}