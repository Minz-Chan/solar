package com.fallmind.solars {
	
	import com.fallmind.solars.controller.GetUserInfoCommand;
	import com.fallmind.solars.controller.LoadSolarSystemInfoCommand;
	import com.fallmind.solars.controller.StartupCommand;
	import com.fallmind.solars.model.LoginProxy;
	import com.fallmind.solars.model.bussiness.ConfigManager;
	
	import org.puremvc.as3.patterns.facade.Facade;
	
	/**
	 * ApplicationFacade 应用单例模式，负责初始化核心层（Model,View,Controller)
	 */
	public class ApplicationFacade extends Facade {
		public static const STARTUP:String	= "startup";
	 	public static const APP_LOGOUT:String = "appLogout";
	 	public static const SHOW_MANAGEVIEW:String = "showManageView";
	 	public static const GET_USER_INFO:String = "getUserInfo";
	 	public static const ADD_COMMUNITY_OF_USER:String = "AddCommunityOfUser";
	 	public static const ADD_SOLARSYSTEM:String = "AddSolarSystem";
	 	public static const EDIT_SOLARSYSTEM:String = "EditSolarSystem";
	 	public static const CONFIRM_PASSWORD:String = "ConfirmPassword";
	 	public static const FORMAT_EPPROM:String = "FormatEpprom";
	 	public static const GET_CURRENT_SETUP:String = "GetCurrentSetup";
	 	public static const BROADCAST_TIME:String = "BroadCastTime";
	 	public static const GET_INSTALLATION:String = "GetInstallation";
	 	public static const SHOW_MANUAL_VIEW:String = "ShowManualView";
	 	public static const SHOW_AUXILIARYDEVICEMAINTAINANCE_VIEW:String = "ShowAuxiliaryDeviceMaintainanceView";	// Added by CMZ 2013/02/21 10:41:00
	 	
		public static const MANUAL_OPERATION:String = "ManualOperation";
		public static const SAVE_SEASON_DEFAULT_SETUP:String = "SaveSeasonDefaultSetup";
		public static const SHOW_SEASON_DEFAULT_SETUP_VIEW:String = "ShowSeasonDefaultSetupView";
		public static const CHANGE_SYSTEM:String = "ChangeSystem";
		public static const SHOW_HISTORY_CONTROL_VIEW:String = "ShowHistoryControlView";
		public static const GET_HISTORY_CONTROL:String = "GetHistroyControl";
		
		public static const SHOW_SEARCH_PASSWORD_VIEW:String = "ShowSearchPasswordView";
		public static const SHOW_OFFER_DEFAULT_LOW_LEVEL:String = "ShowOfferDefaultLowLevel";
		public static const RESTART_SYSTEM:String = "RestartSystem";
		public static const GET_SYSTEM_VERSION:String = "GetSystemVersion";
		public static const SET_SYSTEM_TIME:String = "SetSystemTime";
		public static const SET_SYSTEM_PASSWORD:String = "SetSystemPassword";
		public static const SHOW_SYSTEM_INSTALL:String = "ShowSystemInstall";
		public static const SHOW_DATA_MODE:String = "ShowDataMode";		// Added by CMZ 2012/08/04 16:12:00
		public static const SHOW_COMPANY_MANAGEMENT:String = "ShowCompanyManagement";			// 	Added by CMZ 2012/09/15 21:05:00
		public static const SHOW_FUEL_MANAGEMENT:String = "ShowFuelManagement";					// 	Added by CMZ 2012/09/15 21:05:00
		public static const EDIT_CURRENT_SETUP:String = "EditCurrentSetup";
		
		public static const DISABLE_SYSTEM_MENU:String = "Disable_System_Menu";
		public static const ENABLE_SYSTEM_MENU:String = "Enable_System_Menu";
		public static const SELF_CHECK:String = "SelfCheck";
		
		public static const SHOW_SYSTEM_TIME:String = "ShowSystemTime";
		public static const SHOW_PASSWORD:String = "ShowPassword";
		public static const SHOW_VERSION:String = "ShowVersion";
		
		public static const READ_CONFIG_SUCCESS:String = "ReadConfigSuccess";
		
		// 获取通讯失败的系统数据
		public static const GET_ERROR_COMMUNICATE:String = "GetErrorCommunicate";
		
		// 当密码验证成功后，通知系统显示相应的视图
		public static const SET_SEASON_SETUP:String = "SetSeasonSetup";
		public static const SHOW_EDIT_SYSTEM_SETUP_VIEW:String = "ShowEditSystemSetupView";
		public static const SET_SYSTEM_INSTALL:String = "SetSystemInstall";
		public static const SET_DATA_MODE:String = "SetDataMode";
		public static const COMPANY_MANAGEMENT:String = "CompanyManagement";			// 集群管理 	Added by CMZ 2012/09/15 21:05:00
		public static const FUEL_MANAGEMENT:String = "FuelManagement";					// 原料管理 	Added by CMZ 2012/09/15 21:05:00
		
		public static const CHECK_FACTORY_PASSWORD:String = "CheckFactoryPassword";
		public static const CHECK_FACTORY_PASSWORD_FAILED:String = "CheckFactoryPasswordFailed";
		
		// 当点击状态栏的警告按钮时，会发送该事件。由AlarmViewMediator处理该事件
		public static const SHOW_ALARM_VIEW:String = "ShowAlarmView";
		
		// 权限
		public static const HIGH_RIGHT:String = "3";
		public static const MEDIUM_RIGHT:String = "2";
		public static const LOW_RIGHT:String = "1";
		
		// 给状态栏设置指令发送状态
		public static const SET_ORDER_STATE:String = "SetOrderState";
		
		public static const GET_SYSTEM_TIME:String = "GetSystemTime";
		
		// 表示未取得系统数据
		public static const CLEAR_CURRENT_DATA_VIEW:String = "ClearCurrentDataView";
		
		// 当设置失败时，用户要求显示详细设置情况时，发送的事件，显示详细信息
		public static const SHOW_SETUP_WRONG_DETAIL:String = "ShowSetupWrongDetail";
		// 当设置系统安装情况失败时，用户要求显示详细设置情况时，发送的事件，显示详细信息
		public static const SHOW_INSTALL_WRONG_DETAIL:String = "ShowInstallWrongDetail";
		public static const SHOW_SEASON_WRONG_DETAIL:String = "ShowSeasonWrongDetail";
		public static const SHOW_TIME_WRONG_DETAIL:String = "ShowTimeWrongDetail";
		public static const SHOW_PASSWORD_WRONG_DETAIL:String = "ShowPasswordWrongDetail";
		public static const SHOW_ADD_SYSTEM_PASSWORD_WRONG_DETAIL:String = "ShowAddSystemPasswordWrongDetail";
		public static const SHOW_ADD_SYSTEM_INSTALL:String = "ShowAddSystemInstall";
		
		// 改变显示状态
		public static const SWITCH_DATA_MODE:String = "SwitchDataMOde";
		public static const SWITCH_GRAPHICS_MODE:String = "SwitchGraphicsMode";
		
		// 显示自检结果
		public static const SHOW_SELF_CHECK_RESULT:String = "ShowSelfCheckResult";
		
		// 执行WEBSERVICE失败
		public static const CONNECT_WEBSERVICE_FAILED:String = "ConnectWebserviceFailed";
		
		// 当用户长时间没有操作，发送自动退出事件
		public static const AUTO_LOGOUT:String = "AutoLogout";
		
		// 未选中某个太阳能系统（包括退出太阳能系统切换到其他界面时），状态栏中“当前系统”设置为空。
		public static const CLEAR_STATUS_BAR:String = "CLearStatusBar";
		
		public static var consoleStarted:Boolean = false;
		//public static var orderIsGetCurrentData = true;
		public static var getCurrentData:int;
		
		public static function setInstanceNull():void {
			instance = null;
		}
		static public function getInstance():ApplicationFacade {
			if(instance == null) {
				instance = new ApplicationFacade();
			}
			return instance as ApplicationFacade;
		}
		override protected function initializeController():void {
			super.initializeController();
			
			var config:ConfigManager = ConfigManager.getManageManager();
			
			registerCommand(STARTUP, StartupCommand);	// 把字符串和Command进行绑定，sendNotification()会根据绑定的字符串调用相应的command;
			registerCommand(LoginProxy.LOGIN_SUCCESS, LoadSolarSystemInfoCommand);
			registerCommand(GET_USER_INFO, GetUserInfoCommand);

		}
		public function startup(app:SolarsManager):void {
			this.sendNotification(STARTUP, app);
		}
	}
}