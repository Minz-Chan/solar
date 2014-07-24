package com.fallmind.solars.view.systemMediator
{
	import com.fallmind.solars.ApplicationFacade;
	import com.fallmind.solars.model.CheckProxy.CheckARMRestartProxy;
	import com.fallmind.solars.model.CheckProxy.CheckCurrentSetupProxy;
	import com.fallmind.solars.model.CheckProxy.CheckFormatEPRomProxy;
	import com.fallmind.solars.model.CheckProxy.CheckPasswordProxy;
	import com.fallmind.solars.model.CheckProxy.CheckSeasonSetupProxy;
	import com.fallmind.solars.model.CheckProxy.CheckSelfCheckProxy;
	import com.fallmind.solars.model.CheckProxy.CheckSetInstallProxy;
	import com.fallmind.solars.model.CheckProxy.CheckSetSetupProxy;
	import com.fallmind.solars.model.CheckProxy.CheckSetTimeProxy;
	import com.fallmind.solars.model.CurrentDataProxy;
	import com.fallmind.solars.model.GetCurrentSetupProxy;
	import com.fallmind.solars.model.GetHistoryDataProxy;
	import com.fallmind.solars.model.GetSystemInstallProxy;
	import com.fallmind.solars.model.LoginProxy;
	import com.fallmind.solars.model.SeasonDefaultSetupProxy;
	import com.fallmind.solars.model.SendOrderProxy;
	import com.fallmind.solars.model.SolarInfoProxy;
	import com.fallmind.solars.model.bussiness.ConfigManager;
	import com.fallmind.solars.view.component.solarSystem.AuxiliaryDeviceMaintainanceView;
	import com.fallmind.solars.view.component.solarSystem.CompanyManagementView;
	import com.fallmind.solars.view.component.solarSystem.CurrentSetupOldView;
	import com.fallmind.solars.view.component.solarSystem.CurrentSetupView;
	import com.fallmind.solars.view.component.solarSystem.EditSystemSetupOldView;
	import com.fallmind.solars.view.component.solarSystem.EditSystemSetupView;
	import com.fallmind.solars.view.component.solarSystem.FormatEpromView;
	import com.fallmind.solars.view.component.solarSystem.FuelManagementView;
	import com.fallmind.solars.view.component.solarSystem.HistoryAlarmView;
	import com.fallmind.solars.view.component.solarSystem.HistoryDataView;
	import com.fallmind.solars.view.component.solarSystem.HistorySetupView;
	import com.fallmind.solars.view.component.solarSystem.InputPasswordView;
	import com.fallmind.solars.view.component.solarSystem.ManualOperationView;
	import com.fallmind.solars.view.component.solarSystem.RestartSystemView;
	import com.fallmind.solars.view.component.solarSystem.SeasonDefaultSetupView;
	import com.fallmind.solars.view.component.solarSystem.SelfCheckView;
	import com.fallmind.solars.view.component.solarSystem.SetSystemPasswordView;
	import com.fallmind.solars.view.component.solarSystem.SetTimeView;
	import com.fallmind.solars.view.component.solarSystem.ShowPasswordView;
	import com.fallmind.solars.view.component.solarSystem.ShowSystemTimeView;
	import com.fallmind.solars.view.component.solarSystem.ShowVersionView;
	import com.fallmind.solars.view.component.solarSystem.SolarSystemManageView;
	import com.fallmind.solars.view.component.solarSystem.SystemDataModeView;
	import com.fallmind.solars.view.component.solarSystem.SystemInstallationView;
	
	import flash.events.Event;
	
	import mx.containers.TitleWindow;
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	import mx.managers.PopUpManager;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class SolarSystemManageMediator extends Mediator
	{
		public static const NAME:String = "SolarSystemManageMediator";
		private var currentSystemInfo:CurrentDataProxy;
		private var sendOrderProxy:SendOrderProxy;
		private var getHistoryDataProxy:GetHistoryDataProxy;
		private var checkCurrentSetupProxy:CheckCurrentSetupProxy;
		private var checkFormatEPRomProxy:CheckFormatEPRomProxy;
		private var checkARMRestartProxy:CheckARMRestartProxy;
		private var loginProxy:LoginProxy;
		private var solarInfoProxy:SolarInfoProxy;
		
		private var getCurrentSetupProxy:GetCurrentSetupProxy;// 用来获取当前设置数据
		private var checkSetSetupProxy:CheckSetSetupProxy;// 保存了用户的设置数据
		private var checkSeasonProxy:CheckSeasonSetupProxy;
		private var checkSetTimeProxy:CheckSetTimeProxy;
		private var checkPasswordProxy:CheckPasswordProxy;
		
		private var getInstallProxy:GetSystemInstallProxy;// 用来获取当前系统安装情况
		private var checkSetInstallProxy:CheckSetInstallProxy;// 保存了用户设置的系统安装情况
		private var getSeasonProxy:SeasonDefaultSetupProxy;
		private var checkSelfCheckProxy:CheckSelfCheckProxy;	// 获取自检结果
		
		private var userName:String;
		private var password:String;
		
		private var hasInputPassword:Boolean = false;
		
		private var configManager:ConfigManager;
		private var factoryPassword:String;
		
		private var firstCreateWindow:Boolean = true;
		private var firstCreateHistoryDataView:Boolean = true;
		private var firstCreateCurrentSetupView:Boolean = true;
		private var firstCreateHistorySetupView:Boolean = true;
		private var firstCreateInstallationView:Boolean = true;
		private var firstCreateManualView:Boolean = true;
		private var firstCreateSearchPasswordView:Boolean = true;
		private var firstCreateSeasonSetupView:Boolean = true;
		private var firstCreateHistoryControlView:Boolean = true;
		private var firstCreateHistoryAlarmView:Boolean = true;
		private var firstCreateOfferDefaultView:Boolean = true;
		private var firstCreateSetTimeView:Boolean = true;
		private var firstCreateBroadCastTimeView:Boolean = true;
		private var firstCreateSetPasswordView:Boolean = true;
		private var firstCreateSelfCheckView:Boolean = true;
		private var firstCreateSetSystemSetupView:Boolean = true;
		private var firstCreateSetSeasonSetupView:Boolean = true;
		// 因为在添加系统时，有可能会创建系统安装情况界面，需要从外部访问这个变量，所以设置成静态公共变量
		public static var firstCreateSetSystemInstallView:Boolean = true;
		private var firstCreateSetSystemDataModeView:Boolean = true;	// Added by CMZ 2012/08/04 16:16:00
		private var firstCreateShowCompanyManagementView:Boolean = true;	// Added by CMZ 2012/09/15 20:40:00
		private var firstCreateShowFuelManagementView:Boolean = true;		// Added by CMZ 2012/09/15 20:40:00
		private var firstCreateShowSystemTimeView:Boolean = true;
		private var firstCreateShowPasswordView:Boolean = true;
		private var firstCreateShowVersionView:Boolean = true;
		private var firstCreateFormatEpromView:Boolean = true;
		private var firstCreateRestartSystemView:Boolean = true;
		public var firstAuxiliaryDeviceMaintainanceView:Boolean = true;	// Added by CMZ 2013/02/21 15:12:00
		
		
		private var firstCreateCheckFactoryPasswordView:Boolean = true;
		
		public function SolarSystemManageMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);
			
			// 获取配置类的实例
			configManager = ConfigManager.getManageManager();
			// 获取厂家密码
			factoryPassword = configManager.getFactoryPassword();
			
			// 获取每个proxy的实例
			currentSystemInfo = CurrentDataProxy(facade.retrieveProxy(CurrentDataProxy.NAME));
			loginProxy = LoginProxy(facade.retrieveProxy(LoginProxy.NAME));
			sendOrderProxy = SendOrderProxy(facade.retrieveProxy(SendOrderProxy.NAME));
			getHistoryDataProxy = GetHistoryDataProxy(facade.retrieveProxy(GetHistoryDataProxy.NAME));
			checkCurrentSetupProxy = CheckCurrentSetupProxy(facade.retrieveProxy(CheckCurrentSetupProxy.NAME));
			solarInfoProxy = SolarInfoProxy(facade.retrieveProxy(SolarInfoProxy.NAME));
			checkFormatEPRomProxy = CheckFormatEPRomProxy(facade.retrieveProxy(CheckFormatEPRomProxy.NAME));
			checkARMRestartProxy = CheckARMRestartProxy(facade.retrieveProxy(CheckARMRestartProxy.NAME));
			
			getCurrentSetupProxy = GetCurrentSetupProxy(facade.retrieveProxy(GetCurrentSetupProxy.NAME));
			checkSetSetupProxy = CheckSetSetupProxy(facade.retrieveProxy(CheckSetSetupProxy.NAME));
			checkSeasonProxy = CheckSeasonSetupProxy(facade.retrieveProxy(CheckSeasonSetupProxy.NAME));
			checkSetTimeProxy = CheckSetTimeProxy(facade.retrieveProxy(CheckSetTimeProxy.NAME));
			checkPasswordProxy = CheckPasswordProxy(facade.retrieveProxy(CheckPasswordProxy.NAME));
			
			getInstallProxy = GetSystemInstallProxy(facade.retrieveProxy(GetSystemInstallProxy.NAME));
			checkSetInstallProxy = CheckSetInstallProxy(facade.retrieveProxy(CheckSetInstallProxy.NAME));
			getSeasonProxy = SeasonDefaultSetupProxy(facade.retrieveProxy(SeasonDefaultSetupProxy.NAME));
			checkSelfCheckProxy = CheckSelfCheckProxy(facade.retrieveProxy(CheckSelfCheckProxy.NAME));
			
			// 添加侦听器，当用户点击某个功能时，进行响应
			solarSystemManageView.addEventListener(SolarSystemManageView.FORMAT_EPPROM, formatEppromHandler);
			solarSystemManageView.addEventListener(SolarSystemManageView.GET_HISORYDATA, getHistoryDataHandler);
			solarSystemManageView.addEventListener(SolarSystemManageView.GET_HISTORY_SETUP, getHistorySetupHandler);
			solarSystemManageView.addEventListener(SolarSystemManageView.SHOW_HISTORY_ALARM, showHistoryAlarm);	
			solarSystemManageView.addEventListener(SolarSystemManageView.GET_CURRENT_SETUP, getCurrentSetupHandler);
			solarSystemManageView.addEventListener(SolarSystemManageView.GET_SEASON_SETUP, showSeasonDefaultSetupView);
			solarSystemManageView.addEventListener(SolarSystemManageView.BROADCAST_TIME, broadCastTimeHandler);
			solarSystemManageView.addEventListener(SolarSystemManageView.MANUAL_OPERATION, manualOperationHandler);
			
			// Added by CMZ 2013/02/21 10:10:00
			solarSystemManageView.addEventListener(SolarSystemManageView.SHOW_AUXILIARYDEVICEMAINTAINANCE_VIEW, auxiliaryDeviceMaintainanceHandler);		
			
			solarSystemManageView.addEventListener(SolarSystemManageView.RESTART_SYSTEM, restartSystem);
			solarSystemManageView.addEventListener(SolarSystemManageView.GET_SYSTEM_VERSION, getSystemVersion);
			solarSystemManageView.addEventListener(SolarSystemManageView.SET_SYSTEM_TIME, setSystemTime);
			solarSystemManageView.addEventListener(SolarSystemManageView.GET_SYSTEM_TIME, getSystemTime);
			solarSystemManageView.addEventListener(SolarSystemManageView.SET_SYSTEM_PASSWORD, setSystemPassword);
			solarSystemManageView.addEventListener(SolarSystemManageView.SELF_CHECK, selfCheck);
			solarSystemManageView.addEventListener(SolarSystemManageView.SET_SYSTEM_SETUP, setSystemSetup);
			solarSystemManageView.addEventListener(SolarSystemManageView.SET_SEASON_SETUP, setSeasonSetup);
			solarSystemManageView.addEventListener(SolarSystemManageView.SHOW_INSTALL_STATE, showInstallState);
			solarSystemManageView.addEventListener(SolarSystemManageView.SHOW_SYSTEM_PASSWORD, showSystemPassword);
			solarSystemManageView.addEventListener(SolarSystemManageView.SWITCH_DATA_MODE, switchDataMode);
			solarSystemManageView.addEventListener(SolarSystemManageView.SWITCH_GRAPHICS_MODE, switchGraphicsMode);
			
			// Added by CMZ 2012/08/04 15:48:00
			solarSystemManageView.addEventListener(SolarSystemManageView.SHOW_DATA_MODE, showDataMode);
			
			// Added by CMZ 2012/09/15 20:15:00
			solarSystemManageView.addEventListener(SolarSystemManageView.SHOW_COMPANY_MANAGEMENT, showCompanyManagement);
			solarSystemManageView.addEventListener(SolarSystemManageView.SHOW_FUEL_MANAGEMENT, showFuelManagement);
			
		}
		private function switchDataMode(e:Event):void {
			this.sendNotification(ApplicationFacade.SWITCH_DATA_MODE);
		}
		private function switchGraphicsMode(e:Event):void {
			this.sendNotification(ApplicationFacade.SWITCH_GRAPHICS_MODE);
		}
		private function showSystemPassword(e:Event):void {
			var u:ShowPasswordView = ShowPasswordView(PopUpManager.createPopUp(solarSystemManageView.parent.parent.parent, ShowPasswordView , true));
			//u.x = solarSystemManageView.stage.width / 2 - u.width / 2;
			//u.y = solarSystemManageView.stage.height / 2 - u.height / 2;
			PopUpManager.centerPopUp(u);
			if( firstCreateShowPasswordView) {
				facade.registerMediator(new ShowPasswordMediator(u));
				firstCreateShowPasswordView = false;
			} else {
				var temp:ShowPasswordMediator = ShowPasswordMediator(facade.retrieveMediator(ShowPasswordMediator.NAME));
				temp.setViewComponent(u); 
				temp.init();
			}
			currentSystemInfo.stopQuery();
			sendNotification(ApplicationFacade.SHOW_PASSWORD);
		}
		private function createSetInstallState():void {
			var u:SystemInstallationView = SystemInstallationView(PopUpManager.createPopUp(solarSystemManageView.parent.parent.parent, SystemInstallationView, true));
			//u.x = solarSystemManageView.stage.width / 2 - u.width / 2;
			//u.y = solarSystemManageView.stage.height / 2 - u.height / 2;
			PopUpManager.centerPopUp(u);
			if( firstCreateSetSystemInstallView) {
				facade.registerMediator(new SystemInstallationMediator(u));
				firstCreateSetSystemInstallView = false;
			} else {
				var temp:SystemInstallationMediator = facade.retrieveMediator(SystemInstallationMediator.NAME) as SystemInstallationMediator;
				temp.setViewComponent(u); 
				temp.init();
			}
			currentSystemInfo.stopQuery();
			sendNotification(ApplicationFacade.SHOW_SYSTEM_INSTALL);
		}
		
		/**
		 *  系统安装情况
		 */
		private function showInstallState(e:Event):void {
			if( solarInfoProxy.getUserRightID(currentSystemInfo.getCurrentSystemID()) == ApplicationFacade.LOW_RIGHT || 
				solarInfoProxy.getUserRightID(currentSystemInfo.getCurrentSystemID()) == ApplicationFacade.MEDIUM_RIGHT ) {
					Alert.show("很抱歉！您没有系统操作权限！");
					return;
			}
			createCheckFactoryPasswordView();
			sendNotification(ApplicationFacade.CHECK_FACTORY_PASSWORD, ApplicationFacade.SET_SYSTEM_INSTALL);
		}
		
		/**
		 *  系统安装情况(未进行身份验证)
		 */
		public function showInstallStateWithoutAuthority():void {
			sendNotification(ApplicationFacade.SET_SYSTEM_INSTALL);
		}
		/**
		 *  数据模式设置
		 */
		private function showDataMode(e:Event):void {
			if( solarInfoProxy.getUserRightID(currentSystemInfo.getCurrentSystemID()) == ApplicationFacade.LOW_RIGHT || 
				solarInfoProxy.getUserRightID(currentSystemInfo.getCurrentSystemID()) == ApplicationFacade.MEDIUM_RIGHT ) {
					Alert.show("很抱歉！您没有系统操作权限！");
					return;
			}
			createCheckFactoryPasswordView();
			sendNotification(ApplicationFacade.CHECK_FACTORY_PASSWORD, ApplicationFacade.SET_DATA_MODE);
		}
		
		/**
		 *  数据模式设置(未进行身份验证)
		 */
		public function showDataModeWithoutAuthority():void {
			sendNotification(ApplicationFacade.SET_DATA_MODE);
		}
		
		/**
		 * 创建数据模式设置视图，并与Mediator进行绑定
		 */
		private function createSetDataMode():void {
			if(isNewVersion()) {
				var u:SystemDataModeView = SystemDataModeView(PopUpManager.createPopUp(solarSystemManageView.parent.parent.parent, SystemDataModeView, true));
				//u.x = solarSystemManageView.stage.width / 2 - u.width / 2;
				//u.y = solarSystemManageView.stage.height / 2 - u.height / 2;
				PopUpManager.centerPopUp(u);
				if( firstCreateSetSystemDataModeView) {
					facade.registerMediator(new SystemDataModeViewMediator(u));
					firstCreateSetSystemDataModeView = false;
				} else {
					var tmpView:SystemDataModeViewMediator = facade.retrieveMediator(SystemDataModeViewMediator.NAME) as SystemDataModeViewMediator;
					tmpView.setViewComponent(u); 
					tmpView.initEventListener();
				}
				currentSystemInfo.stopQuery();
				sendNotification(ApplicationFacade.SHOW_DATA_MODE);
			} else {
				Alert.show("系统硬件版本过低，不支持此项功能！");
			}
			
		}
		
		/**
		 * 集群管理
		 */		
		public function showCompanyManagement(e:Event):void {
			if( solarInfoProxy.getUserRightID(currentSystemInfo.getCurrentSystemID()) == ApplicationFacade.LOW_RIGHT || 
				solarInfoProxy.getUserRightID(currentSystemInfo.getCurrentSystemID()) == ApplicationFacade.MEDIUM_RIGHT ) {
					Alert.show("很抱歉！您没有系统操作权限！");
					return;
			}
			createCheckFactoryPasswordView();
			sendNotification(ApplicationFacade.CHECK_FACTORY_PASSWORD, ApplicationFacade.COMPANY_MANAGEMENT);
		}
		
		/**
		 * 创建集群管理视图，并与Mediator进行绑定
		 */
		private function createCompanyManagement():void {
			if(isNewVersion()) {
				var u:CompanyManagementView = CompanyManagementView(PopUpManager.createPopUp(solarSystemManageView.parent.parent.parent, CompanyManagementView, true));
				PopUpManager.centerPopUp(u);
				if( firstCreateShowCompanyManagementView) {
					facade.registerMediator(new CompanyManagementMediator(u));
					firstCreateShowCompanyManagementView = false;
				} else {
					var tmpView:CompanyManagementMediator = facade.retrieveMediator(CompanyManagementMediator.NAME) as CompanyManagementMediator;
					tmpView.setViewComponent(u); 
					tmpView.initEventListener();
				}
				currentSystemInfo.stopQuery();
				sendNotification(ApplicationFacade.SHOW_COMPANY_MANAGEMENT);
			} else {
				Alert.show("系统硬件版本过低，不支持此项功能！");
			}
				
		}
		
		/**
		 * 原料管理
		 */		
		public function showFuelManagement(e:Event):void {
			if( solarInfoProxy.getUserRightID(currentSystemInfo.getCurrentSystemID()) == ApplicationFacade.LOW_RIGHT || 
				solarInfoProxy.getUserRightID(currentSystemInfo.getCurrentSystemID()) == ApplicationFacade.MEDIUM_RIGHT ) {
					Alert.show("很抱歉！您没有系统操作权限！");
					return;
			}
			createCheckFactoryPasswordView();
			sendNotification(ApplicationFacade.CHECK_FACTORY_PASSWORD, ApplicationFacade.FUEL_MANAGEMENT);
		}
		
		/**
		 * 创建原料管理视图，并与Mediator进行绑定
		 */
		private function createFuelManagement():void {
			if(isNewVersion()) {
				var u:FuelManagementView = FuelManagementView(PopUpManager.createPopUp(solarSystemManageView.parent.parent.parent, FuelManagementView, true));
				PopUpManager.centerPopUp(u);
				if( firstCreateShowFuelManagementView) {
					facade.registerMediator(new FuelManagementMediator(u));
					firstCreateShowFuelManagementView = false;
				} else {
					var tmpView:FuelManagementMediator = facade.retrieveMediator(FuelManagementMediator.NAME) as FuelManagementMediator;
					tmpView.setViewComponent(u); 
					tmpView.initEventListener();
				}
				currentSystemInfo.stopQuery();
				sendNotification(ApplicationFacade.SHOW_FUEL_MANAGEMENT);
			} else {
				Alert.show("系统硬件版本过低，不支持此项功能！");
			}
			
		}
		
		
		private function createCheckFactoryPasswordView():void {
			var u:InputPasswordView = InputPasswordView(PopUpManager.createPopUp(solarSystemManageView.parent.parent.parent, InputPasswordView, true));
			//u.x = solarSystemManageView.stage.width / 2 - u.width / 2;
			//u.y = solarSystemManageView.stage.height / 2 - u.height / 2;
			PopUpManager.centerPopUp(u);
			if(firstCreateCheckFactoryPasswordView) {
				facade.registerMediator(new CheckFactoryPasswordMediator(u));
				firstCreateCheckFactoryPasswordView = false;
			} else {
				var temp:CheckFactoryPasswordMediator = facade.retrieveMediator(CheckFactoryPasswordMediator.NAME) as CheckFactoryPasswordMediator;
				temp.setViewComponent(u); 
				temp.init();
			}
			
		}
		
		private function createSeasonSetupView():void {
			var u:SeasonDefaultSetupView = SeasonDefaultSetupView(PopUpManager.createPopUp(solarSystemManageView.parent.parent.parent, SeasonDefaultSetupView, true));
			//u.x = solarSystemManageView.stage.width / 2 - u.width / 2;
			//u.y = solarSystemManageView.stage.height / 2 - u.height / 2;
			PopUpManager.centerPopUp(u);
			if( firstCreateSetSeasonSetupView) {
				facade.registerMediator(new SetSeasonDefaultSetupMediator(u));
				firstCreateSetSeasonSetupView = false;
			} else {
				var temp:SetSeasonDefaultSetupMediator = facade.retrieveMediator(SetSeasonDefaultSetupMediator.NAME) as SetSeasonDefaultSetupMediator ;
				temp.setViewComponent(u); 
				temp.init();
			}
			currentSystemInfo.stopQuery();
			sendNotification(ApplicationFacade.SHOW_SEASON_DEFAULT_SETUP_VIEW);
		}
		private function setSeasonSetup(e:Event):void {
			if( solarInfoProxy.getUserRightID(currentSystemInfo.getCurrentSystemID()) == ApplicationFacade.LOW_RIGHT ) {
					Alert.show("很抱歉！您没有系统操作权限！");
					return;
			}
			createSeasonSetupView();
		}
		private function createSetSystemSetupView():void {
			var u:TitleWindow = null;
			//u.x = solarSystemManageView.stage.width / 2 - u.width / 2;
			//u.y = solarSystemManageView.stage.height / 2 - u.height / 2;
			
			
			if(isNewVersion()){
				// 新版
				u = EditSystemSetupView(PopUpManager.createPopUp(solarSystemManageView.parent.parent.parent, EditSystemSetupView, true));
				PopUpManager.centerPopUp(u);
				if( firstCreateSetSystemSetupView) {
					facade.registerMediator(new EditSystemSetupMediator(u));
					firstCreateSetSystemSetupView = false;
				} else {
					var temp:EditSystemSetupMediator = facade.retrieveMediator(EditSystemSetupMediator.NAME) as EditSystemSetupMediator;
					temp.setViewComponent(u); 
					temp.init();
				}
			} else {
				// 旧版
				u = EditSystemSetupOldView(PopUpManager.createPopUp(solarSystemManageView.parent.parent.parent, EditSystemSetupOldView, true));
				PopUpManager.centerPopUp(u);
				if( firstCreateSetSystemSetupView) {
					facade.registerMediator(new EditSystemSetupMediator(u));
					firstCreateSetSystemSetupView = false;
				} else {
					var temp1:EditSystemSetupMediator = facade.retrieveMediator(EditSystemSetupMediator.NAME) as EditSystemSetupMediator;
					temp1.setViewComponent(u); 
					temp1.initOld();
				}
			}
			
			currentSystemInfo.stopQuery();
			sendNotification(ApplicationFacade.EDIT_CURRENT_SETUP);
		}
		private function setSystemSetup(e:Event):void {
			if( solarInfoProxy.getUserRightID(currentSystemInfo.getCurrentSystemID()) == ApplicationFacade.LOW_RIGHT ) {
					Alert.show("很抱歉！您没有系统操作权限！");
					return;
			}
			//getCurrentSetupProxy.getCurrentSetup(userName, password, currentDataProxy.getCurrentSystemID());
			createSetSystemSetupView();
		}
		private function selfCheck(e:Event):void {
			if( solarInfoProxy.getUserRightID(currentSystemInfo.getCurrentSystemID()) == ApplicationFacade.LOW_RIGHT ) {
				Alert.show("很抱歉！您没有系统操作权限！");
				return;
			}
			
			var u:SelfCheckView = SelfCheckView(PopUpManager.createPopUp(solarSystemManageView.parent.parent.parent, SelfCheckView, true));
			//u.x = solarSystemManageView.stage.width / 2 - u.width / 2;
			//u.y = solarSystemManageView.stage.height / 2 - u.height / 2;
			PopUpManager.centerPopUp(u);
			if(firstCreateSelfCheckView) {
				facade.registerMediator(new SelfCheckMediator(u));
				firstCreateSelfCheckView = false;
			} else {
				var temp:SelfCheckMediator = SelfCheckMediator(facade.retrieveMediator(SelfCheckMediator.NAME));
				temp.setViewComponent(u);
				temp.init();
			}
			currentSystemInfo.stopQuery();
			sendNotification(ApplicationFacade.SELF_CHECK);
		}
		private function setSystemPassword(e:Event):void {
			if( solarInfoProxy.getUserRightID(currentSystemInfo.getCurrentSystemID()) == ApplicationFacade.LOW_RIGHT ) {
					Alert.show("很抱歉！您没有系统操作权限！");
					return;
			}
		
			createSetPasswordView();
		}
		private function getSystemTime(e:Event):void {
			var u:ShowSystemTimeView = ShowSystemTimeView(PopUpManager.createPopUp(solarSystemManageView.parent.parent.parent, ShowSystemTimeView, true));
			//u.x = solarSystemManageView.stage.width / 2 - u.width / 2;
			//u.y = solarSystemManageView.stage.height / 2 - u.height / 2;
			PopUpManager.centerPopUp(u);
			if( firstCreateShowSystemTimeView) {
				facade.registerMediator(new ShowSystemTimeMediator(u));
				firstCreateShowSystemTimeView = false;
			} else {
				var temp:ShowSystemTimeMediator = facade.retrieveMediator(ShowSystemTimeMediator.NAME) as ShowSystemTimeMediator;
				temp.setViewComponent(u); 
				temp.init();
			}
			currentSystemInfo.stopQuery();
			sendNotification(ApplicationFacade.SHOW_SYSTEM_TIME);
		}
		private function setSystemTime(e:Event):void {
			if( solarInfoProxy.getUserRightID(currentSystemInfo.getCurrentSystemID()) == ApplicationFacade.LOW_RIGHT) {
					Alert.show("很抱歉！您没有系统操作权限！");
					return;
			}
			
			createSetSystemTimeView();
			
		}
		
		private function getSystemVersion(e:Event):void {
			var u:ShowVersionView = ShowVersionView(PopUpManager.createPopUp(solarSystemManageView.parent.parent.parent, ShowVersionView, true));
			//u.x = solarSystemManageView.stage.width / 2 - u.width / 2;
			//u.y = solarSystemManageView.stage.height / 2 - u.height / 2;
			PopUpManager.centerPopUp(u);
			if( firstCreateShowVersionView) {
				facade.registerMediator(new ShowVersionMediator(u));
				firstCreateShowVersionView = false;
			} else {
				var temp:ShowVersionMediator = facade.retrieveMediator(ShowVersionMediator.NAME) as ShowVersionMediator;
				temp.setViewComponent(u); 
				temp.init();
			}
			currentSystemInfo.stopQuery();
			sendNotification(ApplicationFacade.SHOW_VERSION);
		}
		private function restartSystem(e:Event):void {
			if( solarInfoProxy.getUserRightID(currentSystemInfo.getCurrentSystemID()) == ApplicationFacade.LOW_RIGHT) {
					Alert.show("很抱歉！您没有系统操作权限！");
					return;
			}
			
			createRestartSystemView();
		}
		
		private function showHistoryAlarm(e:Event):void {
			var u:HistoryAlarmView = HistoryAlarmView(PopUpManager.createPopUp(solarSystemManageView.parent.parent.parent, HistoryAlarmView, true));
			//u.x = solarSystemManageView.stage.width / 2 - u.width / 2;
			//u.y = solarSystemManageView.stage.height / 2 - u.height / 2;
			PopUpManager.centerPopUp(u);
			if(firstCreateHistoryAlarmView) {
				facade.registerMediator(new HistoryAlarmMediator(u));
				firstCreateHistoryAlarmView = false;
			} else {
				var temp:HistoryAlarmMediator = HistoryAlarmMediator(facade.retrieveMediator(HistoryAlarmMediator.NAME));
				temp.setViewComponent(u);
				temp.init();
			}
		}
		
		private function showSeasonDefaultSetupView(e:Event):void {
			var u:SeasonDefaultSetupView = SeasonDefaultSetupView(PopUpManager.createPopUp(solarSystemManageView.parent.parent.parent, SeasonDefaultSetupView, true));
			//u.x = solarSystemManageView.stage.width / 2 - u.width / 2;
			//u.y = solarSystemManageView.stage.height / 2 - u.height / 2;
			PopUpManager.centerPopUp(u);
			if( firstCreateSeasonSetupView) {
				facade.registerMediator(new SeasonDefaultSetupMediator(u));
				firstCreateSeasonSetupView = false;
			} else {
				var temp:SeasonDefaultSetupMediator = facade.retrieveMediator(SeasonDefaultSetupMediator.NAME) as SeasonDefaultSetupMediator ;
				temp.setViewComponent(u); 
				temp.init();
			}
			currentSystemInfo.stopQuery();
			sendNotification(ApplicationFacade.SHOW_SEASON_DEFAULT_SETUP_VIEW);
		}	
		
		
		private function manualOperationHandler(e:Event):void {
			if( solarInfoProxy.getUserRightID(currentSystemInfo.getCurrentSystemID()) == ApplicationFacade.LOW_RIGHT ) {
					Alert.show("很抱歉！您没有系统操作权限！");
					return;
			}
			
			showManualOperationView();
		}
		private function showManualOperationView():void {
			var u:ManualOperationView = ManualOperationView(PopUpManager.createPopUp(solarSystemManageView.parent.parent.parent, ManualOperationView, true));
			//u.x = solarSystemManageView.stage.width / 2 - u.width / 2;
			//u.y = solarSystemManageView.stage.height / 2 - u.height / 2;
			PopUpManager.centerPopUp(u);
			if( firstCreateManualView) {
				facade.registerMediator(new ManualOperationMediator(u));
				firstCreateManualView = false;
			} else {
				var temp:ManualOperationMediator = facade.retrieveMediator(ManualOperationMediator.NAME) as ManualOperationMediator;
				temp.setViewComponent(u); 
				temp.init();
			}
			currentSystemInfo.stopQuery();
			sendNotification(ApplicationFacade.SHOW_MANUAL_VIEW);
		}
		
		/**
		 * 辅助设备维护
		 */ 
		private function auxiliaryDeviceMaintainanceHandler(e:Event):void {
			if( solarInfoProxy.getUserRightID(currentSystemInfo.getCurrentSystemID()) == ApplicationFacade.LOW_RIGHT ) {
					Alert.show("很抱歉！您没有系统操作权限！");
					return;
			}
			
			if(isNewVersion()) {
				showAuxiliaryDeviceMaintainanceView();
			} else {
				Alert.show("系统硬件版本过低，不支持此项功能！");
			}
			
		}
		
		/**
		 * 创建辅助设备维护视图，并与Mediator进行绑定
		 */ 
		private function showAuxiliaryDeviceMaintainanceView():void {
			var u:AuxiliaryDeviceMaintainanceView = AuxiliaryDeviceMaintainanceView(PopUpManager.createPopUp(solarSystemManageView.parent.parent.parent, AuxiliaryDeviceMaintainanceView, true));

			PopUpManager.centerPopUp(u);
			if( firstAuxiliaryDeviceMaintainanceView) {
				facade.registerMediator(new AuxiliaryDeviceMaintainanceMediator(u));
				firstAuxiliaryDeviceMaintainanceView = false;
			} else {
				var temp:AuxiliaryDeviceMaintainanceMediator = facade.retrieveMediator(AuxiliaryDeviceMaintainanceMediator.NAME) as AuxiliaryDeviceMaintainanceMediator;
				temp.setViewComponent(u); 
				temp.init();
			}
			currentSystemInfo.stopQuery();
			sendNotification(ApplicationFacade.SHOW_AUXILIARYDEVICEMAINTAINANCE_VIEW);
		}
		
		
		
		private function broadCastTimeHandler(e:Event):void {
			if(solarInfoProxy.getUserRightID(currentSystemInfo.getCurrentSystemID()) == ApplicationFacade.LOW_RIGHT ) {
					Alert.show("很抱歉！您没有系统操作权限！");
					return;
			}
			
			createBroadCastTimeView();
		}
		
		private function getSeasonSetupHandler(e:Event):void {
			
		}
		
		public function get solarSystemManageView():SolarSystemManageView {
			return viewComponent as SolarSystemManageView;
		}
		
		private function getCurrentSetupHandler(e:Event):void {
			var u:TitleWindow = null;
			if(isNewVersion()) {
				u = CurrentSetupView(PopUpManager.createPopUp(solarSystemManageView.parent.parent.parent, CurrentSetupView, true));
				PopUpManager.centerPopUp(u);
				if( firstCreateCurrentSetupView) {
					facade.registerMediator(new CurrentSetupMediator(u));
					firstCreateCurrentSetupView = false;
				} else {
					var temp:CurrentSetupMediator = facade.retrieveMediator(CurrentSetupMediator.NAME) as CurrentSetupMediator;
					temp.setViewComponent(u); 
					temp.init();
				}
			} else {
				u = CurrentSetupOldView(PopUpManager.createPopUp(solarSystemManageView.parent.parent.parent, CurrentSetupOldView, true));
				PopUpManager.centerPopUp(u);
				if( firstCreateCurrentSetupView) {
					facade.registerMediator(new CurrentSetupMediator(u));
					firstCreateCurrentSetupView = false;
				} else {
					var temp1:CurrentSetupMediator = facade.retrieveMediator(CurrentSetupMediator.NAME) as CurrentSetupMediator;
					temp1.setViewComponent(u); 
					temp1.initOld()();
				}
			}
			
			
			currentSystemInfo.stopQuery();
			sendNotification(ApplicationFacade.GET_CURRENT_SETUP);
		}
		
		private function getHistoryDataHandler(e:Event):void {
			var u:TitleWindow = HistoryDataView(PopUpManager.createPopUp(solarSystemManageView.parent.parent.parent, HistoryDataView, true));
			//u.x = solarSystemManageView.stage.width / 2 - u.width / 2;
			//u.y = solarSystemManageView.stage.height / 2 - u.height / 2;
			PopUpManager.centerPopUp(u);
			if( firstCreateHistoryDataView) {
				facade.registerMediator(new HistoryDataMediator(u));
				firstCreateHistoryDataView = false;
			} else {
				var temp:HistoryDataMediator = facade.retrieveMediator(HistoryDataMediator.NAME) as HistoryDataMediator;
				temp.setViewComponent(u); 
				temp.init();
			}
			
		}
		
		private function getHistorySetupHandler(e:Event):void {
			var u:HistorySetupView = HistorySetupView(PopUpManager.createPopUp(solarSystemManageView.parent.parent.parent, HistorySetupView, true));
			//u.x = solarSystemManageView.stage.width / 2 - u.width / 2;
			//u.y = solarSystemManageView.stage.height / 2 - u.height / 2;
			PopUpManager.centerPopUp(u);
			if( firstCreateHistorySetupView) {
				facade.registerMediator(new HistorySetupMediator(u));
				firstCreateHistorySetupView = false;
			} else {
				var temp:HistorySetupMediator = facade.retrieveMediator(HistorySetupMediator.NAME) as HistorySetupMediator;
				temp.setViewComponent(u); 
				temp.init();
			}
		}
		
		private function createWin():void {
			var u:TitleWindow = InputPasswordView(PopUpManager.createPopUp(solarSystemManageView.parent.parent.parent, InputPasswordView, true));
			//u.x = solarSystemManageView.stage.width / 2 - u.width / 2;
			//u.y = solarSystemManageView.stage.height / 2 - u.height / 2;
			PopUpManager.centerPopUp(u);
			if( firstCreateWindow) {
				facade.registerMediator(new InputPasswordMediator(u));
				firstCreateWindow = false;
			} else {
				var temp:InputPasswordMediator = facade.retrieveMediator(InputPasswordMediator.NAME) as InputPasswordMediator;
				temp.setViewComponent(u); 
				temp.init();
			}
			currentSystemInfo.stopQuery();
		}
		private function createSetSystemTimeView():void {
			var u:SetTimeView = SetTimeView(PopUpManager.createPopUp(solarSystemManageView.parent.parent.parent, SetTimeView, true));
			PopUpManager.centerPopUp(u);
			if(firstCreateSetTimeView) {
				facade.registerMediator(new SetTimeMediator(u));
				firstCreateSetTimeView = false;
			} else {
				var temp:SetTimeMediator = SetTimeMediator(facade.retrieveMediator(SetTimeMediator.NAME));
				temp.setViewComponent(u);
				temp.init();
			}
			currentSystemInfo.stopQuery();
			sendNotification(ApplicationFacade.GET_SYSTEM_TIME);
		}
		private function createBroadCastTimeView():void {
			var u:SetTimeView = SetTimeView(PopUpManager.createPopUp(solarSystemManageView.parent.parent.parent, SetTimeView, true));
			u.stateText.visible = false;
			PopUpManager.centerPopUp(u);
			if(firstCreateBroadCastTimeView) {
				facade.registerMediator(new BroadcastTimeMediator(u));
				firstCreateBroadCastTimeView = false;
			} else {
				var temp:BroadcastTimeMediator = BroadcastTimeMediator(facade.retrieveMediator(BroadcastTimeMediator.NAME));
				temp.setViewComponent(u);
				temp.init();
			}
			currentSystemInfo.stopQuery();
		}
		private function createSetPasswordView():void {
			var u:SetSystemPasswordView = SetSystemPasswordView(PopUpManager.createPopUp(solarSystemManageView.parent.parent.parent, SetSystemPasswordView, true));
			PopUpManager.centerPopUp(u);
			u.stateText.text = "";
			if(firstCreateSetPasswordView) {
				facade.registerMediator(new SetSystemPasswordMediator(u));
				firstCreateSetPasswordView = false;
			} else {
				var temp:SetSystemPasswordMediator = SetSystemPasswordMediator(facade.retrieveMediator(SetSystemPasswordMediator.NAME));
				temp.setViewComponent(u);
				temp.init();
			}
			currentSystemInfo.stopQuery();
		}
		private function formatEppromHandler(e:Event):void {
			if( solarInfoProxy.getUserRightID(currentSystemInfo.getCurrentSystemID()) == ApplicationFacade.LOW_RIGHT || 
				solarInfoProxy.getUserRightID(currentSystemInfo.getCurrentSystemID()) == ApplicationFacade.MEDIUM_RIGHT ) {
					Alert.show("很抱歉！您没有系统操作权限！");
					return;
			}
			createCheckFactoryPasswordView();
			sendNotification(ApplicationFacade.CHECK_FACTORY_PASSWORD, ApplicationFacade.FORMAT_EPPROM);
		}
		
		public override function listNotificationInterests():Array {
			return [
				ApplicationFacade.FORMAT_EPPROM,
				LoginProxy.LOGIN_SUCCESS,
				InputPasswordMediator.PASSWORD_WRONG,
				ApplicationFacade.BROADCAST_TIME,
				CurrentDataProxy.GET_CURRENT_DATA_SUCCESS,
				ApplicationFacade.DISABLE_SYSTEM_MENU,
				ApplicationFacade.ENABLE_SYSTEM_MENU,
				ApplicationFacade.RESTART_SYSTEM,
				ApplicationFacade.GET_SYSTEM_VERSION,
				ApplicationFacade.SET_SYSTEM_TIME,
				ApplicationFacade.SET_SYSTEM_PASSWORD,
				CurrentDataProxy.GET_CURRENT_DATA_OVERTIME,
				ApplicationFacade.MANUAL_OPERATION,
				//ApplicationFacade.SHOW_AUXILIARYDEVICEMAINTAINANCE_VIEW,
				ApplicationFacade.SET_SEASON_SETUP,
				ApplicationFacade.SHOW_EDIT_SYSTEM_SETUP_VIEW,
				ApplicationFacade.SET_SYSTEM_INSTALL,
				ApplicationFacade.SET_DATA_MODE,
				ApplicationFacade.COMPANY_MANAGEMENT,
				ApplicationFacade.FUEL_MANAGEMENT,
				CheckFormatEPRomProxy.CHECK_FORMAT_EPROM_FAILED,
				CheckFormatEPRomProxy.CHECK_FORMAT_EPROM_OVERTIME,
				CheckFormatEPRomProxy.CHECK_FORMAT_EPROM_SUCCESS,
				CheckARMRestartProxy.CHECK_ARM_RESTART_FAILED,
				CheckARMRestartProxy.CHECK_ARM_RESTART_OVERTIME,
				CheckARMRestartProxy.CHECK_ARM_RESTART_SUCCESS,
				ApplicationFacade.CLEAR_CURRENT_DATA_VIEW,
				ApplicationFacade.SHOW_SETUP_WRONG_DETAIL,
				ApplicationFacade.SHOW_INSTALL_WRONG_DETAIL,
				ApplicationFacade.SHOW_SEASON_WRONG_DETAIL,
				ApplicationFacade.SHOW_TIME_WRONG_DETAIL,
				ApplicationFacade.SHOW_PASSWORD_WRONG_DETAIL,
				ApplicationFacade.SHOW_SELF_CHECK_RESULT
			];
		}
		
		
		public override function handleNotification(notification:INotification):void {
			switch(notification.getName()) {
				case ApplicationFacade.SHOW_SELF_CHECK_RESULT:
					createSelfCheckResult();
					break;
				case ApplicationFacade.SHOW_PASSWORD_WRONG_DETAIL:
					createWrongPasswordView();
					break;
				case ApplicationFacade.SHOW_TIME_WRONG_DETAIL:
					createWrongTimeView();
					break;
				case ApplicationFacade.SHOW_SEASON_WRONG_DETAIL:
					createWrongSeasonView();
					break;
				case ApplicationFacade.SHOW_AUXILIARYDEVICEMAINTAINANCE_VIEW:	// Added by CMZ 2013/02/21 10:50:00
				
					break;
				case ApplicationFacade.SHOW_INSTALL_WRONG_DETAIL: // 当用户需要查看哪些系统安装参数设置错误时，弹出窗口进行查看
					createWrongInstallView();
					break;
				case ApplicationFacade.SHOW_SETUP_WRONG_DETAIL:   // 当用户需要查看哪些设置值设置错误时，弹出窗口进行查看
					createWrongSetupView();
					break;
				case ApplicationFacade.SET_SYSTEM_INSTALL:
					createSetInstallState();
					break;
				case ApplicationFacade.SET_DATA_MODE:	// Added by CMZ 2012/08/04 16:10:00
					createSetDataMode();
					break;
				case ApplicationFacade.COMPANY_MANAGEMENT:	// Added by CMZ 2012/09/15 20:23:00
					createCompanyManagement();
					break;
				case ApplicationFacade.FUEL_MANAGEMENT:	// Added by CMZ 2012/09/15 20:23:00
					createFuelManagement();
					break;
				case ApplicationFacade.FORMAT_EPPROM:
					createFormatEpromView();
					break;
				case LoginProxy.LOGIN_SUCCESS:
					userName = loginProxy.getUserName();
					password = loginProxy.getUserPassword();
					break;
				case InputPasswordMediator.PASSWORD_WRONG:
					Alert.show("密码错误");
					break;
			
				case ApplicationFacade.DISABLE_SYSTEM_MENU:
					solarSystemManageView.myMenuBar.enabled = false;
					break;
				case ApplicationFacade.ENABLE_SYSTEM_MENU:
					solarSystemManageView.myMenuBar.enabled = true;
					break;
				case ApplicationFacade.CLEAR_CURRENT_DATA_VIEW:
					solarSystemManageView.myMenuBar.enabled = false;
					break;
			}
		}
		private function createSelfCheckResult():void {
			var u:SelfCheckView = SelfCheckView(PopUpManager.createPopUp(solarSystemManageView.parent.parent.parent, SelfCheckView, true));
			//u.x = solarSystemManageView.stage.width / 2 - u.width / 2;
			//u.y = solarSystemManageView.stage.height / 2 - u.height / 2;
			PopUpManager.centerPopUp(u);
			if(firstCreateSelfCheckView) {
				facade.registerMediator(new SelfCheckMediator(u));
				firstCreateSelfCheckView = false;
			} else {
				var temp:SelfCheckMediator = SelfCheckMediator(facade.retrieveMediator(SelfCheckMediator.NAME));
				temp.setViewComponent(u);
				temp.init();
			}
			u.setData(XML(checkSelfCheckProxy.getData().row[0]));
			currentSystemInfo.stopQuery();
		}
		private function createFormatEpromView():void {
			var u:FormatEpromView = FormatEpromView(PopUpManager.createPopUp(solarSystemManageView.parent.parent.parent, FormatEpromView, true));
			u.stateText.text = "确定要格式化EPROM？"
			//u.x = solarSystemManageView.stage.width / 2 - u.width / 2;
			//u.y = solarSystemManageView.stage.height / 2 - u.height / 2;
			PopUpManager.centerPopUp(u);
			if( firstCreateFormatEpromView) {
				facade.registerMediator(new FormatEpromMediator(u));
				firstCreateFormatEpromView = false;
			} else {
				var temp:FormatEpromMediator = facade.retrieveMediator(FormatEpromMediator.NAME) as FormatEpromMediator;
				temp.setViewComponent(u); 
				temp.init();
			}
			currentSystemInfo.stopQuery();
		}
		private function createRestartSystemView():void {
			var u:RestartSystemView = RestartSystemView(PopUpManager.createPopUp(solarSystemManageView.parent.parent.parent, RestartSystemView, true));
			u.stateText.text = "确定要重启太阳能系统？";
			//u.x = solarSystemManageView.stage.width / 2 - u.width / 2;
			//u.y = solarSystemManageView.stage.height / 2 - u.height / 2;
			PopUpManager.centerPopUp(u);
			if( firstCreateRestartSystemView) {
				facade.registerMediator(new RestartSystemMediator(u));
				firstCreateRestartSystemView = false;
			} else {
				var temp:RestartSystemMediator = facade.retrieveMediator(RestartSystemMediator.NAME) as RestartSystemMediator;
				temp.setViewComponent(u); 
				temp.init();
			}
			currentSystemInfo.stopQuery();
		}
		
		private function confirmRestartSystem(e:CloseEvent):void {
			switch(e.detail) {
				case Alert.OK:
					sendNotification(ApplicationFacade.SET_ORDER_STATE, "正在重启");
					sendOrderProxy.restartSystem(userName, password, currentSystemInfo.getCurrentSystemID(), currentSystemInfo.getARM_ID());
					checkARMRestartProxy.setSystemInfo(userName, password, currentSystemInfo.getCurrentSystemID(), new Date());
					checkARMRestartProxy.startCheck();
					break;
				case Alert.NO:
					break;
			}
		}
		private function createWrongSetupView():void {
			var u:EditSystemSetupView = EditSystemSetupView(PopUpManager.createPopUp(solarSystemManageView.parent.parent.parent, EditSystemSetupView, true));
			//u.x = solarSystemManageView.stage.width / 2 - u.width / 2;
			//u.y = solarSystemManageView.stage.height / 2 - u.height / 2;
			PopUpManager.centerPopUp(u);
			if( firstCreateSetSystemSetupView) {
				facade.registerMediator(new EditSystemSetupMediator(u));
				firstCreateSetSystemSetupView = false;
			} else {
				var temp:EditSystemSetupMediator = facade.retrieveMediator(EditSystemSetupMediator.NAME) as EditSystemSetupMediator;
				temp.setViewComponent(u); 
				temp.init();
			}
			u.setDataFromSetupData(checkSetSetupProxy.setupData);
			u.checkReturnData(XML(getCurrentSetupProxy.getData()));
			currentSystemInfo.stopQuery();
		}
		private function createWrongInstallView():void {
			var u:SystemInstallationView = SystemInstallationView(PopUpManager.createPopUp(solarSystemManageView.parent.parent.parent, SystemInstallationView, true));
			//u.x = solarSystemManageView.stage.width / 2 - u.width / 2;
			//u.y = solarSystemManageView.stage.height / 2 - u.height / 2;
			PopUpManager.centerPopUp(u);
			if( firstCreateSetSystemInstallView) {
				facade.registerMediator(new SystemInstallationMediator(u));
				firstCreateSetSystemInstallView = false;
			} else {
				var temp:SystemInstallationMediator = facade.retrieveMediator(SystemInstallationMediator.NAME) as SystemInstallationMediator;
				temp.setViewComponent(u); 
				temp.init();
			}
			currentSystemInfo.stopQuery();
			u.setFromInstallData(checkSetInstallProxy.installData);
			u.checkReturnData(XML(getInstallProxy.getData().row[0]));
			//sendNotification(ApplicationFacade.SHOW_SYSTEM_INSTALL);
		}
		private function createWrongSeasonView() {
			var u:SeasonDefaultSetupView = SeasonDefaultSetupView(PopUpManager.createPopUp(solarSystemManageView.parent.parent.parent, SeasonDefaultSetupView, true));
			//u.x = solarSystemManageView.stage.width / 2 - u.width / 2;
			//u.y = solarSystemManageView.stage.height / 2 - u.height / 2;
			PopUpManager.centerPopUp(u);
			if( firstCreateSetSeasonSetupView) {
				facade.registerMediator(new SetSeasonDefaultSetupMediator(u));
				firstCreateSetSeasonSetupView = false;
			} else {
				var temp:SetSeasonDefaultSetupMediator = facade.retrieveMediator(SetSeasonDefaultSetupMediator.NAME) as SetSeasonDefaultSetupMediator ;
				temp.setViewComponent(u); 
				temp.init();
			}
			u.setFromSeasonData(checkSeasonProxy.seasonData);
			u.checkReturnData(XML(getSeasonProxy.getData().row[0]));
			currentSystemInfo.stopQuery();
			//sendNotification(ApplicationFacade.SHOW_SEASON_DEFAULT_SETUP_VIEW);
		}
		private function createWrongTimeView():void {
			var u:SetTimeView = SetTimeView(PopUpManager.createPopUp(solarSystemManageView.parent.parent.parent, SetTimeView, true));
			PopUpManager.centerPopUp(u);
			if(firstCreateSetTimeView) {
				facade.registerMediator(new SetTimeMediator(u));
				firstCreateSetTimeView = false;
			} else {
				var temp:SetTimeMediator = SetTimeMediator(facade.retrieveMediator(SetTimeMediator.NAME));
				temp.setViewComponent(u);
				temp.init();
			}
			currentSystemInfo.stopQuery();
			u.setFromTimeData(checkSetTimeProxy.timeData);
			u.checkData(getCurrentSetupProxy.getData().SystemSetup.row.@ARM_Time);
			//sendNotification(ApplicationFacade.GET_SYSTEM_TIME);
		}
		private function createWrongPasswordView():void {
			var u:SetSystemPasswordView = SetSystemPasswordView(PopUpManager.createPopUp(solarSystemManageView.parent.parent.parent, SetSystemPasswordView, true));
			PopUpManager.centerPopUp(u);
			u.stateText.text = "";
			if(firstCreateSetPasswordView) {
				facade.registerMediator(new SetSystemPasswordMediator(u));
				firstCreateSetPasswordView = false;
			} else {
				var temp:SetSystemPasswordMediator = SetSystemPasswordMediator(facade.retrieveMediator(SetSystemPasswordMediator.NAME));
				temp.setViewComponent(u);
				temp.init();
			}
			u.setData(checkPasswordProxy.passwordData);
			u.checkData(getCurrentSetupProxy.getData().SystemSetup.row.@ARM_Password);
			currentSystemInfo.stopQuery();
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
			var currentVersion:String = currentSystemInfo.getARM_Version();
			
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