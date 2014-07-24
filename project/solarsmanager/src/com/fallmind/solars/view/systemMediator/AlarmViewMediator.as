package com.fallmind.solars.view.systemMediator
{
	import com.fallmind.solars.ApplicationFacade;
	import com.fallmind.solars.model.DeleteAlarmProxy;
	import com.fallmind.solars.model.GetWarningProxy;
	import com.fallmind.solars.model.LoginProxy;
	import com.fallmind.solars.model.SendOrderProxy;
	import com.fallmind.solars.view.clientMediator.CommunityData;
	import com.fallmind.solars.view.clientMediator.EditUserInfoMediator;
	import com.fallmind.solars.view.component.solarSystem.AlarmView;
	import com.fallmind.solars.model.DeleteAllAlarmProxy;
	import mx.controls.Alert;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.managers.PopUpManager;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class AlarmViewMediator extends Mediator
	{
		public static const NAME:String = "AlarmViewMediator";
		private var sendOrderProxy:SendOrderProxy;
		private var loginProxy:LoginProxy;
		private var getAlarmProxy:GetWarningProxy;
		private var systemData:Array;
		private var alarmData:Array;
		private var deleteAlarmProxy:DeleteAlarmProxy;
		private var deleteAllAlarmProxy:DeleteAllAlarmProxy;
		// 记录删除的警告ID，在按下已查阅按钮后删除之
		private var deleteAlarmID:String = null;
		
		public function AlarmViewMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);
			sendOrderProxy = SendOrderProxy(facade.retrieveProxy(SendOrderProxy.NAME));
			loginProxy = LoginProxy(facade.retrieveProxy(LoginProxy.NAME));
			getAlarmProxy = GetWarningProxy(facade.retrieveProxy(GetWarningProxy.NAME));
			deleteAlarmProxy = DeleteAlarmProxy(facade.retrieveProxy(DeleteAlarmProxy.NAME));
			deleteAllAlarmProxy = DeleteAllAlarmProxy(facade.retrieveProxy(DeleteAllAlarmProxy.NAME));
			
			systemData = EditUserInfoMediator.switchXML2Array(loginProxy.getData().Area);
			
			
			alarmView.addEventListener(AlarmView.CLOSE_ALARM_VIEW, closeAlarmViewHandler);
			alarmView.addEventListener(AlarmView.DELETE_ALARM, deleteAlarmHandler);
			alarmView.addEventListener(AlarmView.DELETE_ALL_ALARM, deleteAllAlarm);
		}
		// 删除所有警报
		private function deleteAllAlarm(e:Event):void {
			if(loginProxy.getUserType() == "普通操作员" ) {
				Alert.show("抱歉，您没有删除警报的权限");
				return;
			}
			var array:ArrayCollection = new ArrayCollection;
			for each(var item:CommunityData in alarmView.alarmData) {
				array.addItem(item.alarmID);
			}
			deleteAllAlarmProxy.deleteAllAlarm(loginProxy.getUserName(), loginProxy.getUserPassword(), array);
		}
		/**
		 * 点击已查阅按钮后删除相应的警告条目
		 */
		private function deleteAlarmHandler(e:Event):void {
			deleteAlarmID = alarmView.alarmDataGrid.selectedItem.alarmID;
			deleteAlarmProxy.deleteAlarm(loginProxy.getUserName(), loginProxy.getUserPassword(), alarmView.alarmDataGrid.selectedItem.alarmID);
		}
		
		private function closeAlarmViewHandler(e:Event):void {
			/*var idArray:ArrayCollection = new ArrayCollection();
			for(var i:int = 0; i < alarmData.length; i++) {
				idArray.addItem(alarmData[i].alarmID);
			}
			deleteAlarmProxy.deleteAlarm(loginProxy.getUserName(), loginProxy.getUserPassword(), idArray);*/
			
			PopUpManager.removePopUp(alarmView);
			this.setViewComponent(null);
		}
		public function init():void {
			alarmView.addEventListener(AlarmView.CLOSE_ALARM_VIEW, closeAlarmViewHandler);
			alarmView.addEventListener(AlarmView.DELETE_ALARM, deleteAlarmHandler);
			alarmView.addEventListener(AlarmView.DELETE_ALL_ALARM, deleteAllAlarm);
		}
		
		public function get alarmView():AlarmView {
			return viewComponent as AlarmView;
		}
		public override function listNotificationInterests():Array {
			return [
				GetWarningProxy.GET_WARNING_SUCCESS,
				ApplicationFacade.APP_LOGOUT,
				ApplicationFacade.SHOW_ALARM_VIEW,
				DeleteAlarmProxy.DELETE_ALARM_SUCCESS,
				DeleteAllAlarmProxy.DELETE_ALL_ALARM_SUCCESS
			];
		}
		public override function handleNotification(notification:INotification):void {
			if(alarmView == null) {
				return;
			}
			switch(notification.getName()) {
				case DeleteAllAlarmProxy.DELETE_ALL_ALARM_SUCCESS:
					alarmView.alarmData = new Array;
					alarmView.alarmDataGrid.invalidateList();
					break;
				case DeleteAlarmProxy.DELETE_ALARM_SUCCESS:
					for(var i:int = 0; i < alarmView.alarmData.length; i++) {
						if(alarmView.alarmData[i].alarmID == deleteAlarmID) {
							alarmView.alarmData.splice(i, 1);
						}
					}
					alarmView.alarmDataGrid.invalidateList();
					deleteAlarmID = null;
					break;
				case ApplicationFacade.SHOW_ALARM_VIEW:
					alarmData = new Array;
					for each(var xml:XML in getAlarmProxy.getData().row) {
						for each(var s:CommunityData in systemData) {
							if(s.id == xml.@BelCommunityID) {
								var temp:CommunityData = new CommunityData();
								temp.country = s.country;
								temp.province = s.province;
								temp.city = s.city;
								temp.community = s.community;
								temp.systemName = s.systemName;
								
								temp.alarmID = xml.@ALM_ID;
								temp.alarmName = xml.@AlarmEvent;
								temp.alarmTime = xml.@Alarm_Time;
								temp.systemName = xml.@System_Name;
								alarmData.push(temp);
							}
						}
					}
					alarmView.alarmData = alarmData;
					alarmView.alarmDataGrid.invalidateList();
					break;
			}
		}
	}
}