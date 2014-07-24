package com.fallmind.solars.view.systemMediator
{
	import com.fallmind.solars.ApplicationFacade;
	import com.fallmind.solars.model.GetErrorCommunicateStatusProxy;
	import com.fallmind.solars.model.LoginProxy;
	import com.fallmind.solars.view.clientMediator.CommunityData;
	import com.fallmind.solars.view.clientMediator.EditUserInfoMediator;
	import com.fallmind.solars.view.component.solarSystem.CommunicateStatusView;
	import mx.managers.PopUpManager;
	import flash.events.Event;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	public class CommunicateStatusMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "CommunicateStatusMediator";
		private var getDataProxy:GetErrorCommunicateStatusProxy;
		private var systemData:Array;
		private var loginProxy:LoginProxy;
		public function CommunicateStatusMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);
			
			getDataProxy = GetErrorCommunicateStatusProxy(facade.retrieveProxy(GetErrorCommunicateStatusProxy.NAME));
			loginProxy = LoginProxy(facade.retrieveProxy(LoginProxy.NAME));
			
			systemData = EditUserInfoMediator.switchXML2Array(loginProxy.getData().Area);
			
			communicateStatusView.addEventListener(CommunicateStatusView.REFRESH_COMMUNICATE_STATUS, refreshHandler);
			communicateStatusView.addEventListener(CommunicateStatusView.CLOSE_COMMUNICATE_ERROR_VIEW, closeHandler);
		}
		private function closeHandler(e:Event):void {
			PopUpManager.removePopUp(communicateStatusView);
			this.setViewComponent(null);
		}
		public function init():void {
			communicateStatusView.addEventListener(CommunicateStatusView.REFRESH_COMMUNICATE_STATUS, refreshHandler);
			communicateStatusView.addEventListener(CommunicateStatusView.CLOSE_COMMUNICATE_ERROR_VIEW, closeHandler);
		}
		public function get communicateStatusView():CommunicateStatusView {
			return viewComponent as CommunicateStatusView;
		}
		private function refreshHandler(e:Event):void {
			getCommunicateStatus();
		}
		private function getCommunicateStatus():void {
			getDataProxy.getCommunicateStatus();
		}
		public override function listNotificationInterests():Array {
			return [
				GetErrorCommunicateStatusProxy.GET_ERROR_COMMUNICATE_STATUS_SUCCESS,
				ApplicationFacade.GET_ERROR_COMMUNICATE
			];
		}
		public override function handleNotification(notification:INotification):void {
			if(communicateStatusView == null) {
				return;
			}
			if(notification.getName() == GetErrorCommunicateStatusProxy.GET_ERROR_COMMUNICATE_STATUS_SUCCESS) {
				//communicateStatusView.setData(getDataProxy.communicateData);
				for each(var xml:XML in getDataProxy.getData().row) {
					for each(var s:CommunityData in systemData) {
						if(s.id == xml.@BelCommunityID) {
							xml.@Country = s.country;
							xml.@Province = s.province;
							xml.@City = s.city;
							xml.@Community = s.community;
						}
					}
					xml.@WirelessMaster_Normal = xml.@WirelessMaster_Normal == "1" ? "正常" : "失败";
					xml.@WirelessMaster_Alarm = xml.@WirelessMaster_Alarm == "1" ? "正常" : "失败";
					xml.@WirelessSlave = xml.@WirelessSlave == "1" ? "正常" : "失败";
					xml.@ARM = xml.@ARM == "1" ? "正常" : "失败";
					
				}
				communicateStatusView.setData(getDataProxy.communicateData);
			} else {
				getCommunicateStatus();
			}
		}
		

	}
}