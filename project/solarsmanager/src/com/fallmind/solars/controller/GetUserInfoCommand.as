package com.fallmind.solars.controller
{
	import com.fallmind.solars.model.GetUserInfoProxy;
	import com.fallmind.solars.model.LoginProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	/**
	 * 响应"GetUserInfo"这个消息，当点击用户信息管理的“详细信息”按钮时，会触发该消息
	 */
	public class GetUserInfoCommand extends SimpleCommand
	{
		private var getUserInfoProxy:GetUserInfoProxy;
		private var loginProxy:LoginProxy;
		// 对消息的处理
		override public function execute(note:INotification ) :void    
        {
            loginProxy = LoginProxy(facade.retrieveProxy(LoginProxy.NAME));
            getUserInfoProxy = GetUserInfoProxy(facade.retrieveProxy(GetUserInfoProxy.NAME));
            
            var userName:String = loginProxy.getData().UserName;
            var userPassword:String = loginProxy.getData().UserPassword;
            
            // 调用获取用户信息的proxy，获取用户信息
            getUserInfoProxy.getUserInfo(userName, userPassword, note.getBody().toString());
        }
	}
}