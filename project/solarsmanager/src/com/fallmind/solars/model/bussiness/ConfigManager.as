package com.fallmind.solars.model.bussiness
{
	import com.fallmind.solars.ApplicationFacade;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class ConfigManager extends EventDispatcher
	{
		private static var configManager:ConfigManager = null;
		public var webserviceURL:String;
		public var queryTime:int;
		//private var sendNum:int;
		public var systemID:int;
		public var imageUploadURL:String;
		public var imageURL:String;
		public var overTime:String;
		public var checkTime:String;
		public var defaultARMPassword:String;
		public var factoryPassword:String;
		public var lowestTemp:int;
		public var lowestLevel:int;
		public var highestTemp:int;
		public var highestLevel:int;
		public var portalBackground:String;
		public var bannerBackground:String;
		public var loginBackground:String;
		public var newVersion:String;
		
		private var autoLogoutTime:int;
		
		public var urlLoader:URLLoader;
		
		public function ConfigManager()
		{
			var url:String = "Config.xml";
			url += "?rtp=" + String(Math.random() * 65535);
			urlLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, handleURLLoaderCompleted);
			urlLoader.load(new URLRequest(url));
		
		}
		/**
		 * 获取参数要读取文件的内容。FLEX读取文件是异步的，
		 * 当读取完毕会执行这个函数，把读取的内容储存起来
		 */
		private function handleURLLoaderCompleted(event:Event):void {
        	var loader:URLLoader = event.target as URLLoader;
        	var xml:XML = XML(loader.data);
        	
        	webserviceURL = xml.WebserviceURL;	// webservice地址
			queryTime = xml.QueryTime;	// 获取当前数据的间隔时间，以秒为单位
			imageUploadURL = xml.ImageUploadURL;	// 图片上传程序的地址
			imageURL = xml.ImageURL;	// 图片上传的地址
			overTime = xml.OverTime;	// 超时时间，以毫秒为单位
			checkTime = xml.CheckTime;	// 检测指令是否发送成功的定时器的时间间隔，以毫秒为单位
			defaultARMPassword = xml.DefaultARMPassword;	// 主控器默认密码
			factoryPassword = xml.FactoryPassword;	// 厂家默认密码
			lowestLevel = xml.LowestLevel;	// 最低水位限制，设置值不能低于该水位
			lowestTemp = xml.LowestTemp;	// 最低温度限制，设置温度不能低于该温度
			highestLevel = xml.HighestLevel;// 最高水位限制，设置值不能高于该水位
			highestTemp = xml.HighestTemp;	// 最高温度限制，设置值不能高于该温度
			autoLogoutTime = int(xml.AutoLogoutTime);	// 自动退出时间，如果用户长时间没有操作系统，就会自动退出
			newVersion = xml.NewVersion;	// 新旧版本区分界线版本
			if(!(bannerBackground != null && bannerBackground.length > 0))
				bannerBackground = xml.BannerBackground;
			if(!(loginBackground != null && loginBackground.length > 0))
				loginBackground = xml.LoginBackground;
			if(!(portalBackground != null && portalBackground.length > 0))
				portalBackground = xml.PortalBackground;
			this.dispatchEvent(new Event(ApplicationFacade.READ_CONFIG_SUCCESS, true));
    	}
		public static function getManageManager():ConfigManager {
			if(configManager == null) {
				configManager = new ConfigManager();
			}
			return configManager;
		}
		

		
		/**
		 * 返回值：程序自动退出时间
		 * 当用户停止操作一段时间，程序会自动退出，
		 * 这个函数的功能就是获取配置表中的这段时间的设置
		 */
		public function getAutoLogoutTime():int {
			return autoLogoutTime;
		}
		/**
		 * 返回值：检查指令是否成功执行的时间间隔
		 */
		public function getCheckTime():int {
			return int(checkTime);
		}
		/**
		 * 返回值：webservice地址
		 */
		public function getWebserviceURL():String {
			return webserviceURL;
		}
		/**
		 * 返回值：获取厂家密码
		 */
		public function getFactoryPassword():String {
			return factoryPassword;
		}
		/** 
		 * 返回值：默认主控器密码
		 */
		public function getDefaultARMPassword():String {
			return defaultARMPassword;
		}
		/**
		 * 返回值：取得当前数据的时间间隔
		 */
		public function getQueryTime():int {
			return int(queryTime);
		}
		/**
		 * 返回值：指令发送超时时间
		 */
		public function getOverTime():int {
			return int(overTime);
		}
		
		/**
		 * 
		 */
		public function getNewVersion():String {
			return newVersion;
		} 
	}
}