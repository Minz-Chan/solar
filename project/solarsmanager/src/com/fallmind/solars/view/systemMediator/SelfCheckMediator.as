package com.fallmind.solars.view.systemMediator
{
	import com.fallmind.solars.ApplicationFacade;
	import com.fallmind.solars.model.CheckProxy.CheckSelfCheckProxy;
	import com.fallmind.solars.model.CurrentDataProxy;
	import com.fallmind.solars.model.LoginProxy;
	import com.fallmind.solars.model.SelfCheckProxy;
	import com.fallmind.solars.model.SendOrderProxy;
	import com.fallmind.solars.view.component.solarSystem.SelfCheckView;
	
	import flash.events.Event;
	
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	import mx.managers.PopUpManager;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class SelfCheckMediator extends Mediator
	{
		public static const NAME:String = "SelfCheckMediator";
		private var selfCheckProxy:SelfCheckProxy;
		private var loginProxy:LoginProxy;
		private var currentDataProxy:CurrentDataProxy;
		private var checkSelfCheckProxy:CheckSelfCheckProxy;
		private var sendOrderProxy:SendOrderProxy;
		
		public function SelfCheckMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);
			
			loginProxy = LoginProxy(facade.retrieveProxy(LoginProxy.NAME));
			currentDataProxy = CurrentDataProxy(facade.retrieveProxy(CurrentDataProxy.NAME));
			selfCheckProxy = SelfCheckProxy(facade.retrieveProxy(SelfCheckProxy.NAME));
			checkSelfCheckProxy = CheckSelfCheckProxy(facade.retrieveProxy(CheckSelfCheckProxy.NAME));
			sendOrderProxy = SendOrderProxy(facade.retrieveProxy(SendOrderProxy.NAME));
			
			selfCheckView.addEventListener(SelfCheckView.CLOSE_SELF_CHECK_VIEW, closeWindow);
			selfCheckView.addEventListener(SelfCheckView.SHOW_SELF_CHECK, showSelfCheck);
			
			selfCheckView.setState(0);
		}
		private function showSelfCheck(e:Event):void {
			selfCheckView.setState(1);
			sendOrderProxy.selfCheck(loginProxy.getUserName(), loginProxy.getUserPassword(),  currentDataProxy.getCurrentSystemID(), currentDataProxy.getARM_ID());
			checkSelfCheckProxy.setSystemInfo(loginProxy.getUserName(), loginProxy.getUserPassword(), currentDataProxy.getCurrentSystemID(), new Date());
			checkSelfCheckProxy.startCheck();
		}
		public function init():void {
			selfCheckView.addEventListener(SelfCheckView.CLOSE_SELF_CHECK_VIEW, closeWindow);
			selfCheckView.addEventListener(SelfCheckView.SHOW_SELF_CHECK, showSelfCheck);
			selfCheckView.setState(0);
		}
		private function closeWindow(e:Event):void {
			//if(checkSelfCheckProxy.isRun()) {
				//checkSelfCheckProxy.stopCheck();
			//}
			currentDataProxy.startQuery();
			PopUpManager.removePopUp(selfCheckView);
			this.setViewComponent(null);
		}
		public function get selfCheckView():SelfCheckView {
			return viewComponent as SelfCheckView;
		}
		public override function listNotificationInterests():Array {
			return [
				ApplicationFacade.SELF_CHECK, 
				SelfCheckProxy.GET_SELF_CHECK_SUCCESS,
				CheckSelfCheckProxy.CHECK_SELF_CHECK_SUCCESS,
				CheckSelfCheckProxy.CHECK_SELF_CHECK_FAILED,
				CheckSelfCheckProxy.CHECK_SELF_CHECK_OVERTIME,
				SendOrderProxy.CONSOLE_STOPED
			];
		}
		public override function handleNotification(notification:INotification):void {
			switch(notification.getName()) {
				case ApplicationFacade.SELF_CHECK:
					selfCheckView.setState(1);
					sendOrderProxy.selfCheck(loginProxy.getUserName(), loginProxy.getUserPassword(),  currentDataProxy.getCurrentSystemID(), currentDataProxy.getARM_ID());
					checkSelfCheckProxy.setSystemInfo(loginProxy.getUserName(), loginProxy.getUserPassword(), currentDataProxy.getCurrentSystemID(), new Date());
					checkSelfCheckProxy.startCheck();
					//selfCheckProxy.selfCheck(loginProxy.getUserName(), loginProxy.getUserPassword(), currentDataProxy.getCurrentSystemID());
					break;
				case CheckSelfCheckProxy.CHECK_SELF_CHECK_SUCCESS:
					//selfCheckProxy.selfCheck(loginProxy.getUserName(), loginProxy.getUserPassword(), currentDataProxy.getCurrentSystemID());
					if(selfCheckView != null) {
						selfCheckView.setState(0);
						selfCheckView.setData(checkSelfCheckProxy.getData().row[0]);
					} else {
						Alert.show("自检成功，是否查看详细信息？", "提示", Alert.YES | Alert.NO, null, showDetail);
					}
					break;
				case CheckSelfCheckProxy.CHECK_SELF_CHECK_FAILED:
					if(selfCheckView != null) {
						selfCheckView.setState(1);
					}
					break;
				case CheckSelfCheckProxy.CHECK_SELF_CHECK_OVERTIME:
					if(selfCheckView != null) {
						selfCheckView.setState(2);
					} else {
						Alert.show("自检指令超时");
					}
					selfCheckProxy.selfCheck(loginProxy.getUserName(), loginProxy.getUserPassword(), currentDataProxy.getCurrentSystemID());
					break;
				case SelfCheckProxy.GET_SELF_CHECK_SUCCESS:
					if(selfCheckView != null) {
						selfCheckView.setData(selfCheckProxy.getData().row[0]);
					}
					break;
			}
		}
		private function showDetail(e:CloseEvent):void {
			switch(e.detail) {
				case Alert.YES:
					sendNotification(ApplicationFacade.SHOW_SELF_CHECK_RESULT);
					break;
				case Alert.NO:
					break;
			}
		}
	}
}