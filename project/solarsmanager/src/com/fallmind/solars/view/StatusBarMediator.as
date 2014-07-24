package com.fallmind.solars.view
{
	import com.fallmind.solars.ApplicationFacade;
	import com.fallmind.solars.model.CurrentDataProxy;
	import com.fallmind.solars.model.GetWarningProxy;
	import com.fallmind.solars.model.LoginProxy;
	import com.fallmind.solars.view.component.StatusBarView;
	import com.fallmind.solars.view.component.solarSystem.AlarmView;
	import com.fallmind.solars.view.component.solarSystem.CommunicateStatusView;
	import com.fallmind.solars.view.systemMediator.AlarmViewMediator;
	import com.fallmind.solars.view.systemMediator.CommunicateStatusMediator;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import com.fallmind.solars.view.systemMediator.CurrentDataMediator;
	import mx.managers.PopUpManager;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	public class StatusBarMediator extends Mediator
	{
		public static const NAME:String = "StatusBarMediator";
		private var loginProxy:LoginProxy;
		
		private var getWarningProxy:GetWarningProxy;
		
		
		private var firstCreateAlarmView:Boolean = true;
		private var firstCreateFailedOrderView:Boolean = true;

		private var firstCreateCommunicateView:Boolean = true;
		
		private var currentDataProxy:CurrentDataProxy;
		public function StatusBarMediator(viewComponent:Object)
		{
			this.setViewComponent(viewComponent);
			
			loginProxy = LoginProxy(facade.retrieveProxy(LoginProxy.NAME));
			
			currentDataProxy = CurrentDataProxy(facade.retrieveProxy(CurrentDataProxy.NAME));
			getWarningProxy = GetWarningProxy(facade.retrieveProxy(GetWarningProxy.NAME));
			
			
			statusBar.addEventListener(StatusBarView.ALARM_CLICK, alarmClickHandler);
			statusBar.addEventListener(StatusBarView.USER_QUIT, quitHandler);
			statusBar.addEventListener(StatusBarView.SHOW_COMMUNICATE_STATUS, showCommunicateStatus);
			//statusBar.addEventListener(StatusBarView.FAILED_ORDER_CLICK, failedOrderHandler);
			
		}
		private function showCommunicateStatus(e:Event):void {
			/*var u:CommunicateStatusView = CommunicateStatusView(PopUpManager.createPopUp(statusBar.parent, CommunicateStatusView, true));
			PopUpManager.centerPopUp(u);
			u.setData(currentDataProxy.currentData.SystemData.row[0]);*/
			var u:CommunicateStatusView = CommunicateStatusView(PopUpManager.createPopUp(statusBar.parent, CommunicateStatusView, true));
			PopUpManager.centerPopUp(u);
			if(this.firstCreateCommunicateView) {
				facade.registerMediator(new CommunicateStatusMediator(u));
				this.firstCreateCommunicateView = false;
			} else {
				var temp:CommunicateStatusMediator =CommunicateStatusMediator(facade.retrieveMediator(CommunicateStatusMediator.NAME));
				temp.setViewComponent(u);
				temp.init();
			}
			sendNotification(ApplicationFacade.GET_ERROR_COMMUNICATE);
		}
		private function quitHandler(e:Event):void {
			var stage:DisplayObjectContainer = statusBar.parent.parent;
			stage.removeChild(statusBar.parent);
			//statusBar.stage.removeChild(statusBar.parent);
			ApplicationFacade.setInstanceNull();
			var anotherApp:SolarsManager = new SolarsManager();
			anotherApp.width = stage.width;
			anotherApp.height = stage.height;
			stage.addChild(anotherApp);
		}
		
		private function alarmClickHandler(e:Event):void {
			var alarmView:AlarmView = AlarmView(PopUpManager.createPopUp(statusBar.parent, AlarmView, true));
			PopUpManager.centerPopUp(alarmView);
		
			if( firstCreateAlarmView) {
				facade.registerMediator(new AlarmViewMediator(alarmView));
				firstCreateAlarmView = false;
			} else {
				var temp:AlarmViewMediator = facade.retrieveMediator(AlarmViewMediator.NAME) as AlarmViewMediator;
				temp.setViewComponent(alarmView); 
				temp.init();
			}
			//alarmView.alarmData = getWarningProxy.getData().row;
			sendNotification(ApplicationFacade.SHOW_ALARM_VIEW);
		}
		
		public function get statusBar():StatusBarView {
			return viewComponent as StatusBarView;
		}
		
		public override function listNotificationInterests():Array {
			return [
				LoginProxy.LOGIN_SUCCESS,
				GetWarningProxy.GET_WARNING_FAILED,
				GetWarningProxy.GET_WARNING_SUCCESS,
				ApplicationFacade.CHANGE_SYSTEM,
				ApplicationFacade.APP_LOGOUT,
				ApplicationFacade.CLEAR_STATUS_BAR,
				CurrentDataMediator.COMMUNICATE_ERROR,
				CurrentDataMediator.COMMUNICATE_OK
			];
		}
		
		public override function handleNotification(notification:INotification):void {
			switch(notification.getName()) {
				case CurrentDataMediator.COMMUNICATE_ERROR:
					statusBar.setCommunicateIconError();
					break;
				case CurrentDataMediator.COMMUNICATE_OK:
					statusBar.setCommunicateIconOk();
					break;
				case ApplicationFacade.CLEAR_STATUS_BAR:
					statusBar.currentCommunity.text = "";
					statusBar.currentSystem.text = "";
					// 如果切换到软件系统管理，就要把通讯状态图标隐藏
					//statusBar.communicateStatus.visible = false;
					break;
				
				case LoginProxy.LOGIN_SUCCESS:
					//statusBar.showCurrentUser(loginProxy.getData().UserName);
					//statusBar.showLoginTime(new Date());
					statusBar.userText.text = "用户:" + loginProxy.getData().UserName;
					break;
				case GetWarningProxy.GET_WARNING_SUCCESS:
					statusBar.alarmNumText.label = "警告数 " + getWarningProxy.getWarningNum();
					statusBar.timeText.text = "时间:" + new Date().toTimeString();
					break;
				case ApplicationFacade.APP_LOGOUT:
					statusBar.alarmNumText.label = "";
					statusBar.currentCommunity.text = "";
					statusBar.currentSystem.text = "";
					break;
				case ApplicationFacade.CHANGE_SYSTEM:
					var data:XML = loginProxy.getData() as XML;
					var temp:XMLList = data..SystemInfo;
					var d:String = notification.getBody().toString();
					var systemList:XMLList = data..SystemInfo;
					var communityID:String;
					for each(var node:XML in systemList) {
						if(node.@System_ID == notification.getBody().toString()) {
							communityID = node.@BelCommunityID;
							break;
						}
					}
					//var xmllist:XMLList = data..CommunityInfo.(SystemInfo.@System_ID == notification.getBody().toString());
					statusBar.currentCommunity.text = "当前小区：" + data..CommunityInfo.(@id == communityID).@name;
					statusBar.currentSystem.text = "当前系统：" + data..SystemInfo.(@System_ID == notification.getBody().toString()).@System_Name;
					// 当切换到太阳能系统界面时，要把通讯状态栏设置为显示
					statusBar.communicateStatus.visible = true;
					break;
			}
		}
	}
}