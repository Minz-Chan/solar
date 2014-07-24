package com.fallmind.solars.model
{
	import com.fallmind.solars.model.bussiness.SolarDelegate;
	
	import mx.rpc.IResponder;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	import com.fallmind.solars.ApplicationFacade;
	
	public class GetSystemInstallProxy extends Proxy implements IProxy, IResponder
	{
		public static const NAME:String = "GetSystemInstallProxy";
		public static const GET_SYSTEM_INSTALL_SUCCESS:String = "Get_System_Install_Success";
		public static const GET_SYSTEM_INSTALL_FAILED:String = "Get_System_Install_Failed";
		public function GetSystemInstallProxy(data:Object = null)
		{
			super(NAME, data);
		}
		// 获取系统安装情况
		public function getSystemInstall(userName:String, password:String, systemID:String):void {
			var delegate:SolarDelegate = new SolarDelegate(this);
			delegate.getSystemInstall(userName, password, systemID);
		}
		public function result(rpcEvent:Object):void {
			setData(XML(rpcEvent.result));
			sendNotification(GET_SYSTEM_INSTALL_SUCCESS);
		}
		public  function fault(rpcEvent:Object):void {
			sendNotification(ApplicationFacade.CONNECT_WEBSERVICE_FAILED, "GetSystemInstall");
		}

	}
}