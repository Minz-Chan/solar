package com.fallmind.solars.model
{
	import com.fallmind.solars.ApplicationFacade;
	import com.fallmind.solars.model.bussiness.SolarDelegate;
	
	import mx.rpc.IResponder;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class LoginProxy extends Proxy implements IProxy, IResponder
	{
		public static const NAME:String = "LoginProxy";
		public static const LOGIN_SUCCESS:String = "loginSuccess";
		public static const LOGGED_OUT:String = "loggedOut";
		public static const LOGIN_FAILED:String = "loginFailed";
		
		private var anotherLogin:GetUserDetailProxy;
		
		public function LoginProxy(data:Object = null)
		{
			super(NAME, data);
			
			anotherLogin = GetUserDetailProxy(facade.retrieveProxy(GetUserDetailProxy.NAME));
		}
		public function login(userName:String, password:String):void {
			var loginDelegate:SolarDelegate = new SolarDelegate(this);
			loginDelegate.loginService(userName, password);
			
			
		}
		public function logout():void {
			setData(null);
			sendNotification(LOGGED_OUT);
		}
		public function result(rpcEvent:Object):void {
			setData(XML(rpcEvent.result));
			userName = getUserName();
			password = getUserPassword();
			// 如果账号密码错误就不返回值，rpcEvent.result就为空
			if(rpcEvent.result != null) {
				sendNotification(LOGIN_SUCCESS, userInfo);
				// 获取界面中地域树的数据源
				anotherLogin.getUserDetail(userName, password);
			}
			else {
				sendNotification(LOGIN_FAILED, "账号或密码错误");
			}
		}
		public function fault(rpcEvent:Object):void {
			sendNotification(ApplicationFacade.CONNECT_WEBSERVICE_FAILED, "Login");
		}
		public function refresh():void {
			login(userName, password);
			
		}
		public function get userInfo():XML {
			return data as XML;
		}
		/**
		 * 返回该用户所管辖地域的数组
		 */
		public function getAreaInfo():XMLList {
			//var area:XML = userInfo.Area[0];
			//delete area.Area.(Area
			//trace(userInfo.Area);
			return userInfo.Area;
		}
		public function getUserName():String {
			return userInfo.UserName;
		}
		public function getUserPassword():String {
			return userInfo.UserPassword;
		}
		public function getProvinceData():XMLList {
			return userInfo.Area.Area;
		}
		
		public function getCityData():XMLList {
			return userInfo.Area.Area.Area;
		}
		public function getCommunityData():XMLList {
			return userInfo..CommunityInfo;
		}
		public function getUserType():String {
			return userInfo.UserType;
		}
		public var userName:String;
		public var password:String;
		public function setUserName(s:String):void {
			userName = s;
		}
		public function setUserPassword(s:String):void {
			password = s;
		}
	}
}