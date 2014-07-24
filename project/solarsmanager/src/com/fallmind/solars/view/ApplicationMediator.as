package com.fallmind.solars.view
{
	import com.fallmind.solars.ApplicationFacade;
	import com.fallmind.solars.model.LoginProxy;
	import com.fallmind.solars.view.clientMediator.CommunityInfoMediator;
	import com.fallmind.solars.view.clientMediator.LoginViewMediator;
	import com.fallmind.solars.view.clientMediator.RegionInfoMediator;
	import com.fallmind.solars.view.clientMediator.SolarInfoViewMediator;
	import com.fallmind.solars.view.clientMediator.UserInfoViewMediator;
	import com.fallmind.solars.view.systemMediator.CurrentDataMediator;
	import com.fallmind.solars.view.clientMediator.PortalMediator;
	import com.fallmind.solars.view.systemMediator.SolarSystemManageMediator;
	
	import mx.controls.Alert;
	import mx.controls.LinkButton;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	/**
	 * 这个类绑定了视图类和视图管理类
	 * Mediator 类有个 viewComponent 属性，
	 * 这个 viewComponent 保存了视图类的引用，可以通过这个引用调用视图类的方法
	 * 当前类的 viewComponent 属性的值是文档类的对象（就是flex程序的入口，也就是GuestBook.mxml这个文件）
	 * 文档类里面的 guestbookView 属性，对应着 GuestbookView.mxml 这个类，看GuestBook.mxml 就可以明白了
	 */
	public class ApplicationMediator extends Mediator
	{
		public static const LOGIN_VIEW:Number = 0;
		public static const MANAGE_VIEW:Number = 1;
		public static const NAME:String = "ApplicationMediator";
		// 如果已经发生过webservice错误，就不弹出错误窗口。
		private var hasWebserviceError:Boolean = false;
		public function ApplicationMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);
			// 绑定了视图类和视图管理类
			// app.guestbookView 就是界面设计，如文本框，文本输入框，按钮的集合
			facade.registerMediator(new PortalMediator({portalView:app.portalView, loginView:app.loginView, menuBarView:app.menuBarView, solarsManager:viewComponent}));	// Portal
			facade.registerMediator(new LoginViewMediator(app.loginView));   
			facade.registerMediator(new MenuMediator(app.menuBarView));
			facade.registerMediator(new CommunityInfoMediator(app.menuBarView.communityInfoView));
			facade.registerMediator(new SolarInfoViewMediator(app.menuBarView.solarInfoManageView));
			facade.registerMediator(new UserInfoViewMediator(app.menuBarView.userInfoManageView));
			facade.registerMediator(new RegionInfoMediator(app.menuBarView.regionInfoManageView));
			facade.registerMediator(new CurrentDataMediator(app.menuBarView.solarSystemManageView.currentDataView));
			facade.registerMediator(new SolarSystemManageMediator(app.menuBarView.solarSystemManageView));
			facade.registerMediator(new StatusBarMediator(app.statusBar));
			
		}
		
		override public function listNotificationInterests():Array {
			return [
				ApplicationFacade.APP_LOGOUT,
				LoginProxy.LOGIN_SUCCESS,
				LoginProxy.LOGIN_FAILED,
				ApplicationFacade.CONNECT_WEBSERVICE_FAILED,
				ApplicationFacade.AUTO_LOGOUT
			];
		}
		override public function handleNotification(notification:INotification):void {
			switch(notification.getName()) {
				case ApplicationFacade.APP_LOGOUT:
					//app.viewstack.selectedIndex = LOGIN_VIEW;
					app.loginView.visible = true;
					app.menuBarView.visible = false;
					//app.statusBar.quit.enabled = false;
					app.statusBar.alarmNumText.enabled = false;
					
					LinkButton(app.menuBarView.linkBarMenu.getChildAt(2)).enabled = true;
					LinkButton(app.menuBarView.linkBarMenu.getChildAt(3)).enabled = true;
					app.loginView.reset();
					break;
				case ApplicationFacade.CONNECT_WEBSERVICE_FAILED:
					if(!hasWebserviceError) {		
						Alert.show("执行webservice失败，失败模块：" + notification.getBody() + "，请重新刷新页面");
						hasWebserviceError = true;
					}
					break;
				case LoginProxy.LOGIN_SUCCESS:
					app.menuBarView.visible = true;
					app.loginView.visible = false;
					app.statusBar.visible = true;
					app.statusBar.alarmNumText.enabled = true;
					//app.test();
					break;
				case LoginProxy.LOGIN_FAILED:
					Alert.show(notification.getBody().toString());
					break;
				case ApplicationFacade.AUTO_LOGOUT:
					app.menuBarView.visible = false;
					app.loginView.visible = false;
					app.statusBar.visible = false;
					break;
			}
		}
		protected function get app():SolarsManager {
			return viewComponent as SolarsManager;
		}
	}
}