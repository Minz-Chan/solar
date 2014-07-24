package com.fallmind.solars.view.systemMediator
{
	import com.fallmind.solars.ApplicationFacade;
	import com.fallmind.solars.model.CheckProxy.CheckGetSeasonSetupProxy;
	import com.fallmind.solars.model.CurrentDataProxy;
	import com.fallmind.solars.model.LoginProxy;
	import com.fallmind.solars.model.SaveSeasonDefaultSetupProxy;
	import com.fallmind.solars.model.SeasonDefaultSetupProxy;
	import com.fallmind.solars.model.SendOrderProxy;
	import com.fallmind.solars.view.component.solarSystem.SeasonDefaultSetupView;
	
	import flash.events.Event;
	
	import mx.managers.PopUpManager;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class SeasonDefaultSetupMediator extends Mediator
	{
		public static const NAME:String = "SeasonDefaultSetupMediator";
		public static const CHECK_GET_SEASON_SETUP:String = "CheckGetSeasonSetup";
		private var loginProxy:LoginProxy;
		private var currentDataProxy:CurrentDataProxy;
		private var saveSeasonDefaultSetupProxy:SaveSeasonDefaultSetupProxy;
		private var seasonDefaultSetupProxy:SeasonDefaultSetupProxy;
		
		private var sendOrderProxy:SendOrderProxy;
		
		private var checkGetSeasonSetupProxy:CheckGetSeasonSetupProxy;
		public function SeasonDefaultSetupMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);
			loginProxy = LoginProxy(facade.retrieveProxy(LoginProxy.NAME));
			currentDataProxy = CurrentDataProxy(facade.retrieveProxy(CurrentDataProxy.NAME));
			seasonDefaultSetupProxy = SeasonDefaultSetupProxy(facade.retrieveProxy(SeasonDefaultSetupProxy.NAME));
			sendOrderProxy = SendOrderProxy(facade.retrieveProxy(SendOrderProxy.NAME));
			
			checkGetSeasonSetupProxy = CheckGetSeasonSetupProxy(facade.retrieveProxy(CheckGetSeasonSetupProxy.NAME));
			
			seasonDefaultSetupView.addEventListener(SeasonDefaultSetupView.CLOSE_SEASON_DEFAULT_SETUP_VIEW, closeWindow);
			seasonDefaultSetupView.addEventListener(SeasonDefaultSetupView.SHOW_SEASON_SETUP, showSeasonSetup);
			
			
		}
		
		private function showSeasonSetup(e:Event):void {
			seasonDefaultSetupView.setState(4);
			seasonDefaultSetupView.textInputEnable(false);
			sendOrderProxy.getSeasonDefaultSetup(loginProxy.getData().UserName, loginProxy.getData().UserPassword, currentDataProxy.getCurrentSystemID(),currentDataProxy.getARM_ID());
			checkGetSeasonSetupProxy.setSystemInfo(loginProxy.getUserName(), loginProxy.getUserPassword(), currentDataProxy.getCurrentSystemID(), new Date());
			checkGetSeasonSetupProxy.startCheck();
		}
		
		private function closeWindow(e:Event):void {
			if(checkGetSeasonSetupProxy.isRun()) {
				checkGetSeasonSetupProxy.stopCheck();
			}
			seasonDefaultSetupView.saveButton.visible = true;
			currentDataProxy.startQuery();
			PopUpManager.removePopUp(seasonDefaultSetupView);
			this.setViewComponent(null);
		}
		
		public function init():void {
			seasonDefaultSetupView.addEventListener(SeasonDefaultSetupView.CLOSE_SEASON_DEFAULT_SETUP_VIEW, closeWindow);
			seasonDefaultSetupView.addEventListener(SeasonDefaultSetupView.SHOW_SEASON_SETUP, showSeasonSetup);
			
		}
		
		public override function listNotificationInterests():Array {
			return [
				ApplicationFacade.SHOW_SEASON_DEFAULT_SETUP_VIEW,
				CheckGetSeasonSetupProxy.CHECK_GET_SEASON_SETUP_SUCCESS,
				SeasonDefaultSetupProxy.GET_SEASON_DEFAULT_SETUP_SUCCESS,
				CheckGetSeasonSetupProxy.CHECK_GET_SEASON_SETUP_FAILED,
				CheckGetSeasonSetupProxy.CHECK_GET_SEASON_SETUP_OVERTIME,
				SendOrderProxy.CONSOLE_STOPED
			];
		}
		
		public function get seasonDefaultSetupView():SeasonDefaultSetupView {
			return viewComponent as SeasonDefaultSetupView;
		}
		
		public override function handleNotification(notification:INotification):void {
			if(seasonDefaultSetupView == null) {
				return;
			}
			switch(notification.getName()) {
				case SendOrderProxy.CONSOLE_STOPED:
					//checkSeasonSetupProxy.stopCheck();
					seasonDefaultSetupView.setState(0);
					seasonDefaultSetupProxy.getSeasonDefaultSetup(loginProxy.getData().UserName, loginProxy.getData().UserPassword, currentDataProxy.getCurrentSystemID());
					break;
				case ApplicationFacade.SHOW_SEASON_DEFAULT_SETUP_VIEW:
					seasonDefaultSetupView.saveButton.visible = false;
					
					seasonDefaultSetupView.setState(6);
					seasonDefaultSetupView.textInputEnable(false);
					//seasonDefaultSetupView.saveDisable();
					seasonDefaultSetupProxy.getSeasonDefaultSetup(loginProxy.getData().UserName, loginProxy.getData().UserPassword, currentDataProxy.getCurrentSystemID());
					//sendOrderProxy.getSeasonDefaultSetup(loginProxy.getData().UserName, loginProxy.getData().UserPassword, currentDataProxy.getCurrentSystemID(), currentDataProxy.getARM_ID());
					//checkSeasonSetupProxy.setSystemInfo(loginProxy.getUserName(), loginProxy.getUserPassword(), currentDataProxy.getCurrentSystemID(), new Date());
					//checkSeasonSetupProxy.startCheck();
					break;
				case CheckGetSeasonSetupProxy.CHECK_GET_SEASON_SETUP_SUCCESS:
					seasonDefaultSetupView.setState(3);
					seasonDefaultSetupProxy.getSeasonDefaultSetup(loginProxy.getData().UserName, loginProxy.getData().UserPassword, currentDataProxy.getCurrentSystemID());
					break;
				case SeasonDefaultSetupProxy.GET_SEASON_DEFAULT_SETUP_SUCCESS:
					if(seasonDefaultSetupView != null) {
						
						seasonDefaultSetupView.textInputEnable(false);
						seasonDefaultSetupView.setData(seasonDefaultSetupProxy.getData().row[0]);
					}
					break;
				case CheckGetSeasonSetupProxy.CHECK_GET_SEASON_SETUP_FAILED:
					seasonDefaultSetupView.setState(4);
					seasonDefaultSetupView.textInputEnable(false);
					break;
				case CheckGetSeasonSetupProxy.CHECK_GET_SEASON_SETUP_OVERTIME:
					seasonDefaultSetupView.setState(5);
					seasonDefaultSetupView.textInputEnable(false);
					seasonDefaultSetupProxy.getSeasonDefaultSetup(loginProxy.getData().UserName, loginProxy.getData().UserPassword, currentDataProxy.getCurrentSystemID());
					break;
			}
		}

	}
}