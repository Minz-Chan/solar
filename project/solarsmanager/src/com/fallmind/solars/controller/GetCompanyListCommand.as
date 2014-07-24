package com.fallmind.solars.controller
{
	import com.fallmind.solars.model.GetCompanyListProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	
	
	import com.fallmind.solars.model.GetCompanyListProxy;
	
	import org.puremvc.as3.patterns.mediator.Mediator;

	public class GetCompanyListCommand extends SimpleCommand
	{
		private var getCompanyListProxy:GetCompanyListProxy;
		
		override public function execute(notification:INotification):void
		{
			// 通知加载Company List
			//sendNotification(GetCompanyListProxy.LOAD_COMPANYLIST_SUCCESS, "LoadCompanyListSuccess");
			getCompanyListProxy = GetCompanyListProxy(facade.retrieveProxy(GetCompanyListProxy.NAME));
			getCompanyListProxy.getAllCompanyInfo();
		}
		
	
	}
}