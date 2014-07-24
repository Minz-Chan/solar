package com.fallmind.solars.view.systemMediator
{
	import com.fallmind.solars.ApplicationFacade;
	import com.fallmind.solars.model.CurrentDataProxy;
	import com.fallmind.solars.model.GetDisplayModeProxy;
	import com.fallmind.solars.model.GetFuelProxy;
	import com.fallmind.solars.model.GetSystemMeterageUnitConfigProxy;
	import com.fallmind.solars.model.GetWarningProxy;
	import com.fallmind.solars.model.GetWeatherProxy;
	import com.fallmind.solars.model.LoginProxy;
	import com.fallmind.solars.model.SendOrderProxy;
	import com.fallmind.solars.model.bussiness.ConfigManager;
	import com.fallmind.solars.view.component.solarSystem.CurrentDataView;
	
	import flash.external.*;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.core.mx_internal;
	import mx.events.FlexEvent;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	use namespace mx_internal;
	public class CurrentDataMediator extends Mediator
	{
		public static const NAME:String = "CurrentDataMediator";
		public static const COMMUNICATE_ERROR:String = "CommunicateError";
		public static const COMMUNICATE_OK:String = "CommunicateOK";
		private var currentDataProxy:CurrentDataProxy;
		private var failedNum:int = 0;
		private var config:ConfigManager;
		private var getWeatherProxy:GetWeatherProxy;
		private var displayModeProxy:GetDisplayModeProxy;
		private var displayMode:String;
		private var userType:String;
		private var loginProxy:LoginProxy;
		private var getSystemMeterageUnitConfigProxy:GetSystemMeterageUnitConfigProxy;
		private var getFuelProxy:GetFuelProxy;
		
		public function CurrentDataMediator(view:Object)
		{
			super(NAME, view);
			
			config = ConfigManager.getManageManager();
			
			currentDataProxy = CurrentDataProxy(facade.retrieveProxy(CurrentDataProxy.NAME));
			
			currentDataView.systemManager.addEventListener(FlexEvent.IDLE, userIdle);
			
			getWeatherProxy = GetWeatherProxy(facade.retrieveProxy(GetWeatherProxy.NAME));
			displayModeProxy = GetDisplayModeProxy(facade.retrieveProxy(GetDisplayModeProxy.NAME));
			loginProxy = LoginProxy(facade.retrieveProxy(LoginProxy.NAME));
			getSystemMeterageUnitConfigProxy = GetSystemMeterageUnitConfigProxy(facade
						.retrieveProxy(GetSystemMeterageUnitConfigProxy.NAME));
			getFuelProxy = GetFuelProxy(facade.retrieveProxy(GetFuelProxy.NAME));
			
		}
		// 如果鼠标没有动一段时间，自动退出,可以在配置表中设置自动退出时间，600是一分钟
		private function userIdle(e:FlexEvent):void {
			if(e.currentTarget.mx_internal::idleCounter >= config.getAutoLogoutTime()){
				//Alert.show("由于您长时间没有操作，系统已自动退出，要再次登录请刷新网页");
				currentDataProxy.stopQuery();
				//sendNotification(ApplicationFacade.AUTO_LOGOUT);
				currentDataView.systemManager.removeEventListener(FlexEvent.IDLE, userIdle);
				ExternalInterface.call("refresh");
			}
			
		}
		public override function listNotificationInterests():Array {
			return [
				CurrentDataProxy.GET_CURRENT_DATA_FAILED,
				CurrentDataProxy.GET_CURRENT_DATA_SUCCESS,
				CurrentDataProxy.GET_CURRENT_DATA_OVERTIME,
				ApplicationFacade.APP_LOGOUT,
				GetWarningProxy.OFFER_BOX_T_ALARM,
				GetWarningProxy.OFFER_BOX_WL_ALARM,
				GetWarningProxy.PRODUCT_BOX_T_ALARM,
				GetWarningProxy.PRODUCT_BOX_WL_ALARM,
				ApplicationFacade.CLEAR_CURRENT_DATA_VIEW,
				SendOrderProxy.CONSOLE_STOPED,
				GetWarningProxy.GET_WARNING_SUCCESS,
				ApplicationFacade.SWITCH_DATA_MODE,
				ApplicationFacade.SWITCH_GRAPHICS_MODE,
				GetWeatherProxy.GET_WEATHER_SUCCESS,
				GetDisplayModeProxy.GET_DISPLAYMODE_SUCCESS,
				LoginProxy.LOGIN_SUCCESS,
				GetSystemMeterageUnitConfigProxy.GET_SYSTEM_METERAGEUNIT_SUCCESS,
				GetFuelProxy.GET_FUEL_SUCCESS
			];
		}
		public override function handleNotification(notification:INotification):void {
			switch(notification.getName()) {
				case GetDisplayModeProxy.GET_DISPLAYMODE_SUCCESS:
					displayMode = displayModeProxy.displayMode;
					currentDataView.setDisplayMode(displayMode);
					break;
				case LoginProxy.LOGIN_SUCCESS:
					userType = loginProxy.getUserType();
					currentDataView.setUserType(userType);
					getFuelProxy.getFuelsByFuelType(loginProxy.getUserName()
						, loginProxy.getUserPassword(), "all");	// 获取最瓣能源系数信息  Added by 陈明珍 2013.02.27
					break;
				case GetWeatherProxy.GET_WEATHER_SUCCESS:	// 成功获取天气数据
					currentDataView.setWeather(int(getWeatherProxy.getData()));
					break;
				case GetSystemMeterageUnitConfigProxy.GET_SYSTEM_METERAGEUNIT_SUCCESS:
					currentDataView.setConfig(getSystemMeterageUnitConfigProxy.getConfig());	// 版本控制
					break;
				case ApplicationFacade.SWITCH_DATA_MODE://显示模式切换为数据模式
					getSystemMeterageUnitConfigProxy.getSystemMeterageUnitConfig(loginProxy.getUserName()
						, loginProxy.getUserPassword(), currentDataProxy.getCurrentSystemID());
					currentDataView.setData(currentDataProxy.currentData, isNewVersion());
					currentDataView.switch2DataMode(isNewVersion());
					break;
				case ApplicationFacade.SWITCH_GRAPHICS_MODE://显示模式切换为图形模式
					currentDataView.switch2GraphicsMode(isNewVersion());
					break;
				// 每次获取到警告，就把当前数据的警告项颜色变成黑色。如果出现了某个数据项的 警告，就把那个警告变红。这样就不需要判断哪个警告项是正常的了。
				case GetWarningProxy.GET_WARNING_SUCCESS:
					currentDataView.warningClear();
					break;
				case ApplicationFacade.CLEAR_CURRENT_DATA_VIEW:
					currentDataView.clear();
					break;
				case CurrentDataProxy.GET_CURRENT_DATA_SUCCESS:
					currentDataView.setData(currentDataProxy.currentData, isNewVersion());
					currentDataView.setConfig(getSystemMeterageUnitConfigProxy.getConfig());
					//analysiseCommunicateStatus(currentDataProxy.currentData);
					break;
				case CurrentDataProxy.GET_CURRENT_DATA_FAILED:
					failedNum++;
					if(failedNum > 5) {
						Alert.show("获取数据失败");
					    currentDataProxy.stopQuery();
					    failedNum = 0;
					}
					break;
				case CurrentDataProxy.GET_CURRENT_DATA_OVERTIME:
					currentDataView.setData(currentDataProxy.currentData, isNewVersion());
					//analysiseCommunicateStatus(currentDataProxy.currentData);
					break;
				case ApplicationFacade.APP_LOGOUT:
					currentDataProxy.stopQuery();
					break;
				case GetWarningProxy.OFFER_BOX_T_ALARM:
					if(notification.getBody() == currentDataProxy.getCurrentSystemID()) {
						//currentDataView.OfferBox_T.setStyle("color", "0xFF0000");
					}
					break;
				case GetWarningProxy.OFFER_BOX_WL_ALARM:
					if(notification.getBody() == currentDataProxy.getCurrentSystemID()) {
						//currentDataView.OfferBox_WL.setStyle("color", "0xFF0000");
					}
					break;
				case GetWarningProxy.PRODUCT_BOX_T_ALARM:
					if(notification.getBody() == currentDataProxy.getCurrentSystemID()) {
						//currentDataView.ProductBox_T.setStyle("color", "0xFF0000");
					}
					break;
				case GetWarningProxy.PRODUCT_BOX_WL_ALARM:
					if(notification.getBody() == currentDataProxy.getCurrentSystemID()) {
						//currentDataView.ProductBox_WL.setStyle("color", "0xFF0000");
					}
					break;
				case GetFuelProxy.GET_FUEL_SUCCESS:	// 获取能源信息成功   Added by 陈明珍 2013.02.27
					setFuelsInfoList(getFuelProxy.fuelsDetail);
					break;
			}
		}
		
		
		/**
		 * 填充能源信息
		 * 参    数：
		 *   data, 从WebService拿到的能源XML信息
		 * 返回值：
		 *   无
		 */ 
		public function setFuelsInfoList(data:XML):void {
			var fuelList:XMLList = data.children();
			var fuelInfoList:ArrayCollection = new ArrayCollection();
			var i:int;
			
			for(i = 0; i < fuelList.length(); i++){
				fuelInfoList.addItem({"id":fuelList[i].@id.toString()
						,"fuelName":fuelList[i].@FuelName.toString()
						, "fuelType":fuelList[i].@FuelType.toString()
						, "param1":fuelList[i].@param1.toString()
						, "param2":fuelList[i].@param2.toString()
						, "status":"initial"});

			}
			
			currentDataView.fuelInfoList = fuelInfoList;
	
		}
		
		
		
		public function get currentDataView():CurrentDataView {
			return viewComponent as CurrentDataView;
		}
		
		/**
		 * 检测是否是新版系统
		 * 参  数：
		 *   无
		 * 返回值：
		 *   true, 新版系统
		 *   false, 旧版系统
		 */ 
		private function isNewVersion():Boolean {
			var config:ConfigManager = ConfigManager.getManageManager();
			var newVersion:String = config.getNewVersion();
			var currentVersion:String = currentDataProxy.getARM_Version();
			
			if(currentVersion != null && currentVersion != ""
			  && currentVersion >= newVersion ) {
			  	// 新版
				return true;
			} else {
				// 旧版
				return false;
			}
		}
		
		
	}
}