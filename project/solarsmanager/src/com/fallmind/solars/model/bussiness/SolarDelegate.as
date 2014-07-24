package com.fallmind.solars.model.bussiness
{
	import com.fallmind.solars.view.clientMediator.UserDetailData;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	import mx.rpc.soap.mxml.WebService;
	
	/**
	 * 该类的方法与webservice的方法一一对应，程序通过这个类与webservice交互
	 */
	public class SolarDelegate
	{
		private var service:WebService
		private var responder:IResponder;
		public function SolarDelegate(responder:IResponder)
		{
			service = new WebService();
			//service.loadWSDL( "http://localhost:1414/Service1.asmx?WSDL" );
			var config:ConfigManager = ConfigManager.getManageManager();
			service.loadWSDL(config.getWebserviceURL());
			
			this.responder = responder;
		}
		/**
		 * 请求登录
		 * 参数：
		 * userName 用户名
		 * password 密码
		 */
		public function loginService(userName:String, password:String):void {
			var token:AsyncToken = service.Login(userName, password);
			token.addResponder(responder);
		}
		/**
		 * 获取数据库中的自检数据
		 * 参数：
		 * userName 用户名
		 * password 密码
		 * systemID 系统ID
		 */
		public function selfCheck(userName:String, password:String, systemID:String):void {
			var token:AsyncToken = service.SelfCheck(userName, password, systemID);
			token.addResponder(responder);
		}
		/**
		 * 获取显示模式，分为热量和能量两种
		 */
		public function getDisplayMode():void {
			var token:AsyncToken = service.GetDisplayMode();
			token.addResponder(responder);
		}
		/**
		 * 获取登录用户所管辖的太阳能系统信息
		 * 参数：
		 * userName 用户名
		 * password 密码
		 */
		public function getSolarSystem(userName:String, password:String):void {
			var token:AsyncToken = service.OnGetSolarSystem(userName, password);
			token.addResponder(responder);
		}
		/**
		 * 获取当前用户所管辖的所有用户
		 * 参数：
		 * userName 用户名
		 * password 密码
		 * communityInfo 小区ID的数组
		 */
		public function getAllUserInfo(userName:String, password:String, communityInfo:ArrayCollection):void {
			var token:AsyncToken = service.OnGetAllUserInfo(userName, password, communityInfo);
			token.addResponder(responder);
		}
		/**
		 * 删除数据库中的某个报警 条目
		 * 参数：
		 * userName 用户名
		 * password 密码
		 * alarmID 警报ID
		 */
		public function deleteAlarm(userName:String, password:String, alarmID:String):void {
			var token:AsyncToken = service.DeleteAlarm(userName, password, alarmID);
			token.addResponder(responder);
		}
		/** 
		 * 添加小区
		 * 参数：userName 用户名
		 * password 密码
		 * communityInfo 小区信息
		 */
		public function insertCommunityInfo(userName:String, password:String, communityInfo:Object):void {
			var token:AsyncToken = service.InsertCommunityInfo(userName, password, communityInfo);
			token.addResponder(responder);
		}
		/** 
		 * 修改小区数据
		 * 参数：userName 用户名
		 * password 密码
		 * communityInfo 小区信息
		 */
		public function updateCommunityInfo(userName:String, password:String, communityInfo:Object):void {
			var token:AsyncToken = service.UpdateCommunityInfo(userName, password, communityInfo);
			token.addResponder(responder);
		}
		/**
		 * 删除小区
		 * 参数：
		 * userName 用户名
		 * password 密码
		 * communityID 小区ID
		 */
		public function deleteCommunityInfo(userName:String, password:String, communityID:String):void {
			var token:AsyncToken = service.DeleteCommunityInfo(userName, password, communityID);
			token.addResponder(responder);
		}
		/**
		 * 删除用户
		 * 参数：
		 * userName 用户名
		 * userPassword 密码
		 * userID 用户ID
		 */
		public function deteteUser(userName:String, userPassword:String, userID:String):void {
			var token:AsyncToken = service.DeleteUser(userName, userPassword, userID);
			token.addResponder(responder);
		}
		/**
		 * 根据用户ID获取用户详细信息
		 */
		public function getUserInfo(userName:String, password:String, userID:String):void {
			var token:AsyncToken = service.GetUserInfo(userName, password, userID);
			token.addResponder(responder);
		}
		/**
		 * 保存用户详细信息
		 */
		public function saveUserDetail(userName:String, password:String, userDetail:UserDetailData, communityArray:ArrayCollection):void {
			var token:AsyncToken = service.SaveUserDetail(userName, password, userDetail, communityArray);
			token.addResponder(responder);
		}
		/**
		 * 删除一个太阳能系统
		 */
		public function deleteSolarSystem(userName:String, password:String, systemID:String):void {
			var token:AsyncToken = service.DeleteSolarSystem(userName, password, systemID);
			token.addResponder(responder);
		}
		/**
		 * 添加一个太阳能系统
		 */
		public function addSolarSystem(userName:String, password:String, systemName:String, manager:String, managerPhone:String, belCommunityID:String, armID:String, setupTime:String, imageURL:String, armPassword:String):void {
			var token:AsyncToken = service.AddSolarSystem(userName, password, systemName, manager, managerPhone, belCommunityID, armID, setupTime, imageURL, armPassword);
			token.addResponder(responder);
		}
		/**
		 * 修改太阳能系统
		 */
		public function editSolarSystem(userName:String, password:String, systemID:String, systemName:String, manager:String, managerPhone:String, armID:String, setupTime:String, imageURL:String):void {
			var token:AsyncToken = service.EditSolarSystem(userName, password, systemID, systemName, manager, managerPhone, armID, setupTime, imageURL);
			token.addResponder(responder);
		}
		/**
		 * 添加一个区域
		 */
		public function addRegion(userName:String, password:String, regionName:String, regionType:String, belRegionID:String):void {
			var token:AsyncToken = service.AddRegion(userName, password, regionName, regionType, belRegionID);
			token.addResponder(responder);
		}
		/**
		 * 获取所有区域信息
		 */
		public function getRegion(userName:String, password:String):void {
			var token:AsyncToken = service.GetRegion(userName, password);
			token.addResponder(responder);
		}
		/**
		 * 获取所有小区信息
		 */
		public function getCommunity(userName:String, password:String):void {
			var token:AsyncToken = service.GetCommunity(userName, password);
			token.addResponder(responder);
		}
		/**
		 * 根据系统ID，获取系统当前数据
		 */
		public function getCurrentData(userName:String, password:String, systemID:String):void {
			var token:AsyncToken = service.GetCurrentSystemData(userName, password, systemID);
			token.addResponder(responder);
		}
		/**
		 * 根据区域ID，删除一个区域
		 */
		public function deleteRegion(userName:String, password:String, areaID:String):void {
			var token:AsyncToken = service.DeleteRegion(userName, password, areaID);
			token.addResponder(responder);
		}
		/**
		 * 发送指令
		 */
		public function sendOrder(userName:String, password:String, systemID:String, orderText:String, time:String):void {
			var token:AsyncToken = service.SendOrder(userName, password, systemID, orderText, time);
			token.addResponder(responder);
		}
		/**
		 * 获取历史数据，由于是分页获取，所以startTime是开始时间，endTime是结束时间，index是页数，size是每页的数据数目
		 */
		public function getHistoryData(userName:String, password:String, systemID:String, startTime:String, endTime:String, index:String, size:String):void {
			var token:AsyncToken = service.GetHistoryData(userName, password, systemID, startTime, endTime, index, size);
			token.addResponder(responder);
		}
		/**
		 * 获取警报
		 */
		public function getWarning(username:String, password:String):void {
			var token:AsyncToken = service.GetWarning(username, password);
			token.addResponder(responder);
		}
		/**
		 * 获取历史设置数据
		 */
		public function getHistorySetup(userName:String, password:String, systemID:String, startTime:String, endTime:String):void {
			var token:AsyncToken = service.GetHistorySetup(userName, password, systemID, startTime, endTime);
			token.addResponder(responder);
		}
		/**
		 * 获取季节默认设置
		 */
		public function getSeasonDefaultSetup(userName:String, password:String, systemID:String):void {
			var token:AsyncToken = service.GetSeasonDefaultSetup(userName, password, systemID);
			token.addResponder(responder);
		}
		/**
		 * 保存季节默认配置
		 */
		public function saveSeasonDefaultSetup(username:String, password:String, setupID:String, saStartTime:String, saCollector:String, wsStartTime:String, wsCollector:String):void {
			var token:AsyncToken = service.SaveSeasonDefaultSetup(username, password, setupID, saStartTime, saCollector, wsStartTime, wsCollector);
			token.addResponder(responder);
		}
		/**
		 * 获取历史警报数据
		 */
		public function getHistoryAlarm(userName:String, password:String, systemID:String, startTime:String, endTime:String):void {
			var token:AsyncToken = service.GetHistoryAlarm(userName, password, systemID, startTime, endTime);
			token.addResponder(responder);
		}
		/**
		 * 获取太阳能系统当前设置
		 */
		public function getCurrentSetup(userName:String, password:String, systemID:String):void {
			var token:AsyncToken = service.GetCurrentSetup(userName, password, systemID);
			token.addResponder(responder);
		}
		/**
		 * 获取当前太阳能系统的部件安装情况
		 */
		public function getSystemInstall(userName:String, password:String, systemID:String):void {
			var token:AsyncToken = service.GetSystemInstall(userName, password, systemID);
			token.addResponder(responder);
		}
		/**
		 *  检查指令是否成功
		 */
		public function checkOrder(userName:String, password:String, systemID:String, time:String, checkOrder:String):void {
			var token:AsyncToken = service.CheckOrder(userName, password, systemID, time, checkOrder);
			token.addResponder(responder);
		}
		/**
		 * 获取用户详细信息
		 * 参数：
		 * userName 用户名
		 * password 密码
		 */
		public function getUserDetail(userName:String, password:String):void {
			var token:AsyncToken = service.GetUserTreeLogin(userName, password);
			token.addResponder(responder);
		}
		/**
		 * 检测设置系统参数的指令是否执行成功
		 * 参数
		 * userName 用户名
		 * password 密码
		 * systemID 系统ID
		 * sendTime 指令发送时间
		 */
		public function checkSetSetup(userName:String, password:String, systemID:String, sendTime:String):void {
			var token:AsyncToken = service.CheckSetSetup(userName, password, systemID, sendTime);
			token.addResponder(responder);
		}
		/**
		 * 检测设置系统安装情况的指令是否执行成功
		 * 参数
		 * userName 用户名
		 * password 密码
		 * systemID 系统ID
		 * sendTime 指令发送时间
		 */
		public function checkSetInstall(userName:String, password:String, systemID:String, sendTime:String):void {
			var token:AsyncToken = service.CheckInstall(userName, password, systemID, sendTime);
			token.addResponder(responder);
		}
		/**
		 * 检测设置四级默认参数的指令是否执行成功
		 * 参数
		 * userName 用户名
		 * password 密码
		 * systemID 系统ID
		 * sendTime 指令发送时间
		 */
		public function checkSetSeason(userName:String, password:String, systemID:String, sendTime:String):void {
			var token:AsyncToken = service.CheckSetSeason(userName, password, systemID, sendTime);
			token.addResponder(responder);
		}
		/**
		 * 检测自检指令是否执行成功
		 * 参数
		 * username 用户名
		 * password 密码
		 * systemID 系统ID
		 * sendTime 指令发送时间
		 */
		public function checkSelfCheck(username:String, password:String, systemID:String, sendTime:String):void {
			var token:AsyncToken = service.CheckSelfCheck(username, password, systemID, sendTime);
			token.addResponder(responder);
		}
		/**
		 * 获取控制台状态
		 * 参数:
		 * userName 用户名
		 * password 密码
		 * systemID 系统ID
		 */
		public function getConsoleState(username:String, password:String, systemID:String):void {
			var token:AsyncToken = service.GetConsoleState(username, password, systemID);
			token.addResponder(responder);
		}
		/**
		 * 删除所有警报
		 * 参数：
		 * userName 用户名
		 * password 密码
		 * alarm 所有警报ID的数组
		 */
		public function deleteAllAlarm(userName:String, password:String, alarm:ArrayCollection):void {
			var token:AsyncToken = service.DeleteAllAlarm(userName, password, alarm);
			token.addResponder(responder);
		}
		/**
		 * 因为有可能获取天气的网站失效，所以从两个源获取天气，这是第二个
		 */
		public function getWeather2(city:String):void {
			var token:AsyncToken = service.GetWeather(city);
			token.addResponder(responder);
		}
		/**
		 * 获取天气数据，这是第一个源，如果获取失败，就调用第二个
		 */
		public function getWeather(city:String):void {
			var token:AsyncToken = service.GetWeather2(city);
			token.addResponder(responder);
		}
		/**
		 * 获取通讯状态异常的太阳能系统的信息
		 */
		public function getErrorCommunicateStatus():void {
			var token:AsyncToken = service.GetCommunicateError();
			token.addResponder(responder);
		}
		/**
		 * 设置电量系数
		 */
		public function setElecFactor(factor:String, extraFactor:String, Collector_in_line_Fix:String, systemId:String):void {
			var token:AsyncToken = service.SetElecFactor(factor, extraFactor, Collector_in_line_Fix, systemId);
			token.addResponder(responder);
		}
		
		/**
		 * 获取公司(集群)列表信息
		 */
		public function getAllCompanyInfo():void {
			var token:AsyncToken = service.GetAllCompanyInfo();
			token.addResponder(responder);
		}
		
		
		/**
		 * 获取公司(集群)列表信息
		 */
		public function getCompanyInfo(companyIdentifier:String):void {
			var token:AsyncToken = service.GetCompanyInfo(companyIdentifier);
			token.addResponder(responder);
		}
		
		/**
		 * 新增公司(集群)信息
		 */
		public function addCompany(userName:String, password:String, companyName:String, companyIdentifier:String, bg_login:String, bg_logo:String):void {
			var token:AsyncToken = service.AddCompany(userName, password, companyName, companyIdentifier, bg_login, bg_logo);
			token.addResponder(responder);
		}
		
		
		/**
		 * 删除公司(集群)信息
		 */
		public function deleteCompany(userName:String, password:String, companyId:String):void {
			var token:AsyncToken = service.DeleteCompany(userName, password, companyId);
			token.addResponder(responder);
		}
		
		/**
		 * 更新公司(集群)信息
		 */
		public function updateCompany(userName:String, password:String, companyId:String, columnForUpdateStr:String):void {
			var token:AsyncToken = service.UpdateCompany(userName, password, companyId, columnForUpdateStr);
			token.addResponder(responder);
		}
		
		
		/**
		 * 新增燃料信息
		 */
		public function addFuel(userName:String, password:String, fuelName:String, fuelType:String, param1:String, param2:String):void {
			var token:AsyncToken = service.AddFuel(userName, password, fuelType, fuelName, param1, param2);
			token.addResponder(responder);
		}
		
		/**
		 * 删除燃料信息
		 */
		public function deleteFuel(userName:String, password:String, fuelId:String):void {
			var token:AsyncToken = service.DeleteFuel(userName, password, fuelId);
			token.addResponder(responder);
		}
		
		/**
		 * 更新燃料信息
		 */
		public function updateFuelInfo(userName:String, password:String, fuelId:String, columnForUpdateStr:String):void {
			var token:AsyncToken = service.UpdateFuelInfo(userName, password, fuelId, columnForUpdateStr);
			token.addResponder(responder);
		}
		
		
		/**
		 * 获取系统相关计量单元配置项信息
		 */ 
		public function getSystemMeterageUnitConfig(userName:String, password:String, systemId:String):void{
			var token:AsyncToken = service.GetSystemMeterageUnitConfig(userName, password, systemId);
			token.addResponder(responder);
		}
		
		/**
		 * 更新系统相关计量单元配置项信息
		 */ 
		public function saveSystemMeterageUnitConfig(userName:String, password:String, systemId:String, updatedStr:String):void{
			var token:AsyncToken = service.UpdateSystemMeterageUnitConfig(userName, password, systemId, updatedStr);
			token.addResponder(responder);
		}
		
		public function getFuelsByFuelType(userName:String, password:String,fuleType:String):void{
			var token:AsyncToken = service.GetFuelsByFuelType(userName, password, fuleType);
			token.addResponder(responder);
		}
		
		
	}
}