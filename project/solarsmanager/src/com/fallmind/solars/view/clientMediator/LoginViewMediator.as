// ActionScript file
package com.fallmind.solars.view.clientMediator
{
	import com.fallmind.solars.ApplicationFacade;
	import com.fallmind.solars.model.LoginProxy;
	import com.fallmind.solars.view.component.LoginView;
	
	import flash.events.Event;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	/**
	 * 登录模块的视图管理类，接受用户登录事件，交给model层去处理
	 */
	public class LoginViewMediator extends Mediator
	{
		public static const NAME:String = "LoginViewMediator";
		private var loginProxy:LoginProxy;
		public function LoginViewMediator(note:Object)
		{
			//trace("的  " == "的  ");
			super(NAME, note);
			// 侦听所管理的视图类的事件
			loginView.addEventListener(LoginView.APP_LOGIN, loginHandle);
			
			loginProxy = LoginProxy(facade.retrieveProxy(LoginProxy.NAME));
			
		}
		
		/**
		 * 这里列出了该类所侦听的所有事件。只要是他关心的事件都要列在这里
		 */
		override public function listNotificationInterests():Array {
			return [ ApplicationFacade.APP_LOGOUT ];
		}
		
		/**
		 * 这里是对事件的处理
		 */
		override public function handleNotification(notification:INotification):void {
			switch(notification.getName()) {
				case LoginProxy.LOGGED_OUT:
					loginView.reset();
					break;
			}
		}
		protected function get loginView():LoginView {
			return viewComponent as LoginView;
		}
		
		private function loginHandle(e:Event):void {
			loginProxy.login(loginView.userName.text,loginView.password.text);
		}
	}
}