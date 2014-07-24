package com.fallmind.solars.controller
{
	import com.fallmind.solars.model.AddRegionProxy;
	import com.fallmind.solars.model.AddSolarSystemProxy;
	import com.fallmind.solars.model.AllUserInfoProxy;
	import com.fallmind.solars.model.CheckProxy.CheckARMRestartProxy;
	import com.fallmind.solars.model.CheckProxy.CheckCurrentSetupProxy;
	import com.fallmind.solars.model.CheckProxy.CheckFormatEPRomProxy;
	import com.fallmind.solars.model.CheckProxy.CheckGetInstallProxy;
	import com.fallmind.solars.model.CheckProxy.CheckGetPasswordProxy;
	import com.fallmind.solars.model.CheckProxy.CheckGetSeasonSetupProxy;
	import com.fallmind.solars.model.CheckProxy.CheckManualAddTempProxy;
	import com.fallmind.solars.model.CheckProxy.CheckManualAddWaterProxy;
	import com.fallmind.solars.model.CheckProxy.CheckPassword2Proxy;
	import com.fallmind.solars.model.CheckProxy.CheckPasswordProxy;
	import com.fallmind.solars.model.CheckProxy.CheckSeasonSetupProxy;
	import com.fallmind.solars.model.CheckProxy.CheckSelfCheckProxy;
	import com.fallmind.solars.model.CheckProxy.CheckSetInstallProxy;
	import com.fallmind.solars.model.CheckProxy.CheckSetSetupProxy;
	import com.fallmind.solars.model.CheckProxy.CheckSetTimeProxy;
	import com.fallmind.solars.model.CommunityInfoProxy;
	import com.fallmind.solars.model.CompanyManagementProxy;
	import com.fallmind.solars.model.CurrentDataProxy;
	import com.fallmind.solars.model.DeleteAlarmProxy;
	import com.fallmind.solars.model.DeleteAllAlarmProxy;
	import com.fallmind.solars.model.DeleteCommunityInfoProxy;
	import com.fallmind.solars.model.DeleteRegionProxy;
	import com.fallmind.solars.model.DeleteSolarSystemProxy;
	import com.fallmind.solars.model.DeleteUserProxy;
	import com.fallmind.solars.model.EditSolarSystemProxy;
	import com.fallmind.solars.model.FuelManagementProxy;
	import com.fallmind.solars.model.GetCommunityProxy;
	import com.fallmind.solars.model.GetCompanyInfoProxy;
	import com.fallmind.solars.model.GetCompanyListProxy;
	import com.fallmind.solars.model.GetConsoleStateProxy;
	import com.fallmind.solars.model.GetCurrentSetupProxy;
	import com.fallmind.solars.model.GetDisplayModeProxy;
	import com.fallmind.solars.model.GetErrorCommunicateStatusProxy;
	import com.fallmind.solars.model.GetFuelProxy;
	import com.fallmind.solars.model.GetHistoryDataProxy;
	import com.fallmind.solars.model.GetHistorySetupProxy;
	import com.fallmind.solars.model.GetRegionProxy;
	import com.fallmind.solars.model.GetSystemInstallProxy;
	import com.fallmind.solars.model.GetSystemMeterageUnitConfigProxy;
	import com.fallmind.solars.model.GetUserDetailProxy;
	import com.fallmind.solars.model.GetUserInfoProxy;
	import com.fallmind.solars.model.GetWarningProxy;
	import com.fallmind.solars.model.GetWeatherProxy;
	import com.fallmind.solars.model.HistoryAlarmProxy;
	import com.fallmind.solars.model.LoginProxy;
	import com.fallmind.solars.model.SaveCommunityInfoProxy;
	import com.fallmind.solars.model.SaveSeasonDefaultSetupProxy;
	import com.fallmind.solars.model.SaveSystemMeterageUnitConfigProxy;
	import com.fallmind.solars.model.SaveUserDetailProxy;
	import com.fallmind.solars.model.SeasonDefaultSetupProxy;
	import com.fallmind.solars.model.SelfCheckProxy;
	import com.fallmind.solars.model.SendOrderProxy;
	import com.fallmind.solars.model.SetElecFactorProxy;
	import com.fallmind.solars.model.SolarInfoProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	/**
	 * 业务逻辑的工厂，在这里实例化执行业务逻辑的类
	 * */
	public class ModelPrepCommand extends SimpleCommand
	{
		override public function execute( note:INotification ) :void    
        {
        	facade.registerProxy(new GetUserDetailProxy());
            facade.registerProxy(new LoginProxy());
            facade.registerProxy(new SendOrderProxy());

            facade.registerProxy(new SolarInfoProxy());
            facade.registerProxy(new AllUserInfoProxy());
            facade.registerProxy(new CommunityInfoProxy());
            facade.registerProxy(new SaveCommunityInfoProxy());
            facade.registerProxy(new DeleteCommunityInfoProxy());
            facade.registerProxy(new DeleteUserProxy());
            facade.registerProxy(new GetUserInfoProxy());
            facade.registerProxy(new GetCompanyListProxy());			// 获取公司(集群)列表
            facade.registerProxy(new GetCompanyInfoProxy());			// 获取公司(集群)详细信息
            facade.registerProxy(new CompanyManagementProxy());			// 用于公司(集群)信息增删改
            facade.registerProxy(new FuelManagementProxy());			// 秀于原料信息增删改		

            facade.registerProxy(new SaveUserDetailProxy());
            facade.registerProxy(new DeleteSolarSystemProxy());
            facade.registerProxy(new AddSolarSystemProxy());
            facade.registerProxy(new EditSolarSystemProxy());
            facade.registerProxy(new AddRegionProxy());
            facade.registerProxy(new GetRegionProxy());
            facade.registerProxy(new CurrentDataProxy());
            facade.registerProxy(new DeleteRegionProxy());
            
            facade.registerProxy(new GetHistoryDataProxy());
            facade.registerProxy(new GetWarningProxy());
            facade.registerProxy(new GetHistorySetupProxy());
       
            facade.registerProxy(new SeasonDefaultSetupProxy());
            facade.registerProxy(new SaveSeasonDefaultSetupProxy());

            facade.registerProxy(new HistoryAlarmProxy());
            facade.registerProxy(new SelfCheckProxy());
            facade.registerProxy(new GetCurrentSetupProxy());
            facade.registerProxy(new GetSystemMeterageUnitConfigProxy());// 获取系统相关计量配置项信息
            facade.registerProxy(new GetFuelProxy());					 // 获取燃料类型对应的燃料列表
            facade.registerProxy(new SaveSystemMeterageUnitConfigProxy());	// 保存系统相关计量配置项
         
      
           	facade.registerProxy(new GetSystemInstallProxy());
           	facade.registerProxy(new CheckCurrentSetupProxy());
           	facade.registerProxy(new CheckSeasonSetupProxy());
           	facade.registerProxy(new CheckPasswordProxy());
           	facade.registerProxy(new GetCommunityProxy());
           	facade.registerProxy(new CheckSelfCheckProxy());
           	facade.registerProxy(new CheckManualAddTempProxy());
           	facade.registerProxy(new CheckManualAddWaterProxy());
           	facade.registerProxy(new CheckFormatEPRomProxy());
           	facade.registerProxy(new CheckARMRestartProxy());
           	facade.registerProxy(new DeleteAlarmProxy());
           	facade.registerProxy(new CheckSetSetupProxy());
           	facade.registerProxy(new CheckSetInstallProxy());
            facade.registerProxy(new CheckSetTimeProxy());
            facade.registerProxy(new CheckPassword2Proxy());
            facade.registerProxy(new GetConsoleStateProxy());
            facade.registerProxy(new CheckGetSeasonSetupProxy());
            facade.registerProxy(new CheckGetPasswordProxy());
            facade.registerProxy(new DeleteAllAlarmProxy());
            facade.registerProxy(new CheckGetInstallProxy());
            facade.registerProxy(new GetWeatherProxy());
            facade.registerProxy(new GetErrorCommunicateStatusProxy());
            facade.registerProxy(new GetDisplayModeProxy());
            facade.registerProxy(new SetElecFactorProxy());
        }
	}
}