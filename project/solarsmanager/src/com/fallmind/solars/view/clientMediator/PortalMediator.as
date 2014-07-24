package com.fallmind.solars.view.clientMediator
{
	import com.fallmind.solars.model.GetCompanyInfoProxy;
	import com.fallmind.solars.model.GetCompanyListProxy;
	import com.fallmind.solars.model.bussiness.ConfigManager;
	import com.fallmind.solars.view.component.LoginView;
	import com.fallmind.solars.view.component.MenuBarView;
	import com.fallmind.solars.view.component.PortalView;
	
	import flash.events.Event;
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;

	public class PortalMediator extends Mediator
	{
		public static const NAME:String = "PortalMediator";
		public static const PORTAL_SHOW:String = "PortalShow";
		public static const PORTAL_REDIRECT:String = "PortalRedirect";
		public static const PORTAL_SELECTION:String = "PortalSelection";
		
		private var getCompanyListProxy:GetCompanyListProxy;
		private var getCompanyInfoProxy:GetCompanyInfoProxy;
		
		public function PortalMediator(note:Object = null)
		{
			super(NAME, note);
			
			solarsManager.addEventListener(solarsManager.PORTAL_REDIRECT, redirect2Portal);
			portalView.addEventListener(portalView.PORTAL_SELECTION, navigator2Portal);
			
			getCompanyListProxy = GetCompanyListProxy(facade.retrieveProxy(GetCompanyListProxy.NAME));	
			getCompanyInfoProxy = GetCompanyInfoProxy(facade.retrieveProxy(GetCompanyInfoProxy.NAME));
		}
		
		
		override public function listNotificationInterests():Array
		{
			return [ GetCompanyListProxy.LOAD_COMPANYLIST_SUCCESS
				,GetCompanyInfoProxy.GET_COMPANYINFO_SUCCESS
				,PortalMediator.PORTAL_REDIRECT
				,PortalMediator.PORTAL_SELECTION ];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName()) {
				case GetCompanyListProxy.LOAD_COMPANYLIST_SUCCESS:	// 成功获取公司列表
					portalView.companys = getCompanyListProxy.companyList;
					break;
				case GetCompanyInfoProxy.GET_COMPANYINFO_SUCCESS:	// 成功获取公司详细信息
					if(getCompanyInfoProxy.isGetAll){	// 获取所有公司列表
						return;
					}
					
					var config:ConfigManager = ConfigManager.getManageManager();
					var company:XMLList = XMLList(notification.getBody());
					if(company.length() > 0){
						trace(company.hasOwnProperty("CompanyId"));
						config.loginBackground = company.@Bg_login.toString();
						config.bannerBackground = company.@Bg_logo.toString();
					}
					
					loginView.backgroundImage.source = config.loginBackground;
					menuBarView.bannerImage.source = config.bannerBackground;
					// 更新loginView的loginBackground和menuBarView的bannerBackgroup
					loginView.backgroundImage.validateNow();
					menuBarView.bannerImage.validateNow();
					
					break;
				case PortalMediator.PORTAL_REDIRECT:	// 判断是否有sn结尾
					var obj:Object = notification.getBody();
					if(obj == null){	// 没有使用sn参数形式
						getCompanyInfoProxy.getCompanyInfo(null);
						//portalView.visible = true;
						//loginView.visible = false;
					}else{	// 以sn参数形式登录
						getCompanyInfoProxy.getCompanyInfo(String(obj));
						portalView.visible = false;
						loginView.visible = true;
					}

					break;
				case PortalMediator.PORTAL_SELECTION:	// 选择欲登录的集群
					var obj1:Object = notification.getBody();
					var sn:String = String("");
					if(obj1 == null){
						sn = ""
					}else{
						sn = String(obj1);
					}
					var query:String = ExternalInterface.call("window.location.href.toString", 1);
					var url:String  = query.substr(0, query.indexOf("?", 0) + 1) + "?sn=" + sn;
					navigateToURL(new URLRequest(url), "_self");
					break;
			}
		}
		
		
		/**
		 * 根据提供的公司标识重定向至公司页面
		 */		
		public function redirect2Portal(e:Event):void
		{
			var args:Object = getParams();
			sendNotification(PortalMediator.PORTAL_REDIRECT, args.sn);
		}
		
		/**
		 * 用户选择集群后，登录至指定集群页画
		 */	
		public function navigator2Portal(e:Event):void
		{
			sendNotification(PortalMediator.PORTAL_SELECTION, portalView.companyList.selectedItem.data);
		}
		
		/**
		 * 返回值：Object (如参数name可用getParams.name形式访问)
		 * 获取URL参数
		 */
		private function getParams():Object {
             var params:Object = {};
             var query:String = ExternalInterface.call("window.location.search.substring", 1);

             if(query) {
                 var pairs:Array = query.split("&");
                 for(var i:uint=0; i < pairs.length; i++) {
                     var pos:int = pairs[i].indexOf("=");
                     if(pos != -1) {
                      	 var argname:String = pairs[i].substring(0, pos);
                         var value:String = pairs[i].substring(pos+1);
                         params[argname] = value;
                     }
                 }
             }
             return params;
         } 
		
		protected function get portalView():PortalView
		{	
			return viewComponent.portalView as PortalView;
		}
		
		protected function get loginView():LoginView
		{
			return viewComponent.loginView as LoginView;
		}
		
		protected function get menuBarView():MenuBarView
		{
			return viewComponent.menuBarView as MenuBarView; 
		}
		
		protected function get solarsManager():SolarsManager
		{
			return viewComponent.solarsManager as SolarsManager; 
		}
		
		
	}
}