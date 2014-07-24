package com.fallmind.solars.controller
{
	import com.fallmind.solars.model.AllUserInfoProxy;
	import com.fallmind.solars.model.CurrentDataProxy;
	import com.fallmind.solars.model.GetCommunityProxy;
	import com.fallmind.solars.model.GetDisplayModeProxy;
	import com.fallmind.solars.model.GetRegionProxy;
	import com.fallmind.solars.model.GetWarningProxy;
	import com.fallmind.solars.model.LoginProxy;
	import com.fallmind.solars.model.SolarInfoProxy;
	
	import mx.collections.ArrayCollection;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class LoadSolarSystemInfoCommand extends SimpleCommand
	{
		private var solarInfoProxy:SolarInfoProxy;
		private var loginInfoProxy:LoginProxy;
		private var allUserInfoProxy:AllUserInfoProxy;
		private var getRegionProxy:GetRegionProxy;
		private var currentDataProxy:CurrentDataProxy;
		private var getWarningProxy:GetWarningProxy;
		private var getCommunityProxy:GetCommunityProxy;
		private var getDisplayModeProxy:GetDisplayModeProxy;
		/**
		 * 响应"LoginSuccess"这个消息，当登录成功时，会触发该消息，
		 * 功能是得到当前用户所管辖地域，小区，太阳能系统，警告，管理员的数据
		 */
		override public function execute( note:INotification ) :void    
        {
            loginInfoProxy = LoginProxy(facade.retrieveProxy(LoginProxy.NAME));
            allUserInfoProxy = AllUserInfoProxy(facade.retrieveProxy(AllUserInfoProxy.NAME));
            solarInfoProxy = SolarInfoProxy(facade.retrieveProxy(SolarInfoProxy.NAME));
            getRegionProxy = GetRegionProxy(facade.retrieveProxy(GetRegionProxy.NAME));
            currentDataProxy = CurrentDataProxy(facade.retrieveProxy(CurrentDataProxy.NAME));
            getWarningProxy = GetWarningProxy(facade.retrieveProxy(GetWarningProxy.NAME));
            getCommunityProxy = GetCommunityProxy(facade.retrieveProxy(GetCommunityProxy.NAME));
            getDisplayModeProxy = GetDisplayModeProxy(facade.retrieveProxy(GetDisplayModeProxy.NAME));
            
            var userData:XML = loginInfoProxy.getData() as XML;
            var userName:String = userData.UserName;
            var userPassword:String = userData.UserPassword;
            
            var userIdArray:ArrayCollection = new ArrayCollection();
            
            // 得到所有用户的资料
            for each(var item:XML in userData..CommunityInfo) {
            	userIdArray.addItem(item.@id);
            }
            allUserInfoProxy.getAllUserInfo(userName, userPassword, userIdArray);
            
            // 得到所有地域信息
            getRegionProxy.getRegion(userName, userPassword);
            
            // 初始化currentDataProxy
            currentDataProxy.setUsername(userName);
            currentDataProxy.setPassword(userPassword);
            
            // 获取警报的计时器开始计时
            getWarningProxy.startQuery(userName, userPassword);
            
            getDisplayModeProxy.getDisplayMode();
        }
	}
}