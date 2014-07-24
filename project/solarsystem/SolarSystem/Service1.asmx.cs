using System;
using System.Collections;
using System.ComponentModel;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Xml.Linq;
using SolarSystem.BLL;
using System.Collections.Generic;
using SolarSystem.DAL.Impl;
using System.Text;
using SolarSystem.Model;
using SolarSystem.Utils;
namespace SolarSystem
{
    /// <summary>
    /// Service1 的摘要说明
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [ToolboxItem(false)]
    // 若要允许使用 ASP.NET AJAX 从脚本中调用此 Web 服务，请取消对下行的注释。
    // [System.Web.Script.Services.ScriptService]
    public class Service1 : System.Web.Services.WebService
    {

        
        [WebMethod]
        public string Login(string userName, string password)
        {
            UserManager userManager = new UserManager();
            return userManager.Login(userName, password);
        }
        [WebMethod]
        public string OnGetSolarSystem(string userName, string password)
        {
            CommunityInfoManager communityInfoManager = new CommunityInfoManager();
            return communityInfoManager.GetCommunityInfo(userName, password);
        }
        [WebMethod]
        public string OnGetAllUserInfo(string userName, string password, List<int> communityInfo)
        {
            //List<int> communityInfo = new List<int>();
            //communityInfo.Add(2);
            UserManager userManager = new UserManager();
            return userManager.GetAllUserInfo(userName, password, communityInfo);
        }
        [WebMethod]
        public string InsertCommunityInfo(string userName, string password, CommunityInfo data) {
            CommunityInfoManager communityInfoManager = new CommunityInfoManager();
            return communityInfoManager.InsertCommunityInfo(userName, password, data);
        }
        [WebMethod]
        public void UpdateCommunityInfo(string userName, string password, CommunityInfo data)
        {
            CommunityInfoManager communityInfoManager = new CommunityInfoManager();
            communityInfoManager.UpdateCommunityInfo(userName, password, data);
        }
        [WebMethod]
        public void DeleteCommunityInfo(string userName, string password, string communityID) {
            CommunityInfoManager communityInfoManager = new CommunityInfoManager();
            communityInfoManager.DeleteCommunityInfo(userName, password, communityID);
        }
        [WebMethod]
        public string GetUserInfo(string userName, string password, string userID) {
            UserManager userManager = new UserManager();
            return userManager.GetUserInfo(userName, password, int.Parse(userID));
        }
        [WebMethod]
        public string GetUserTreeLogin(string n, string pwd)
        {
            UserManager userManager = new UserManager();
            return userManager.GetUserTreeLogin(n, pwd);
        }
        [WebMethod]
        public List<int> CommunityNotAllocated( string userName, string password, List<int> source) {
            CommunityInfoManager communityInfoManager = new CommunityInfoManager();
            return communityInfoManager.CommunityNotAllocated(userName, password, source);
        }
        [WebMethod]
        public string SaveUserDetail(string userName, string password, UserDetailData userDetail, List<IdAndRight> communityArray)
        {
         
            UserManager userManager = new UserManager();
            return userManager.SaveUserDetail(userName, password, userDetail, communityArray);
        }
        [WebMethod]
        public void DeleteUser(string userName, string password, string userID) {
            UserManager userManager = new UserManager();
            userManager.DeleteUserInfo(userName, password, userID);
        }
        [WebMethod]
        public void DeleteSolarSystem(string userName, string password, string systemID) {
            SolarSystemManager solarManager = new SolarSystemManager();
            solarManager.DeleteSolarSystem(userName, password, int.Parse(systemID));
        }
        [WebMethod]
        public string AddSolarSystem(string userName, string password, string systemName, string manager, string managerPhone, string belCommunityID, string armID, string setupTime, string imageURL, string armPassword) {
            SolarSystemManager solarManager = new SolarSystemManager();
            return solarManager.AddSolarSystem(userName, password, systemName, manager, managerPhone, int.Parse(belCommunityID), armID, setupTime, imageURL, armPassword);
        }
        [WebMethod]
        public void EditSolarSystem(string userName, string password, string systemID, string systemName, string manager, string managerPhone, string armID, string setupTime, string imageURL) {
            SolarSystemManager solarManager = new SolarSystemManager();
            solarManager.EditSolarSystem(userName, password, int.Parse(systemID), systemName, manager, managerPhone, armID, setupTime, imageURL);
        }
        [WebMethod]
        public string GetCommunity(string userName, string password) {
            SolarSystemManager solarManager = new SolarSystemManager();
            return solarManager.GetCommunity(userName, password);
        }
        [WebMethod]
        public void AddRegion(string userName, string password, string regionName, string regionType, string belRegionID) {
            RegionManager regionManager = new RegionManager();
            regionManager.AddRegion(userName, password, regionName, int.Parse(regionType), int.Parse(belRegionID));
        }
        [WebMethod]
        public string GetRegion(string userName, string password) {
            RegionManager regionManager = new RegionManager();
            return regionManager.GetRegion(userName, password);
        }
        [WebMethod]
        public string GetCurrentSystemData(string userName, string password, string systemID) {
            SystemOperator systemOperator = new SystemOperator();
            return systemOperator.GetCurrentSystemData(userName, password, int.Parse(systemID));
        }
        [WebMethod]
        public string GetCurrentSetup(string userName, string password, string systemID) {
            SystemOperator systemOperator = new SystemOperator();
            return systemOperator.GetCurrentSetup(userName, password, systemID);
        }
        [WebMethod]
        public void DeleteRegion(string userName, string password, string areaID) {
            RegionManager regionManager = new RegionManager();
            regionManager.DeleteRegion(userName, password, int.Parse(areaID));
        }
        [WebMethod]
        public string SendOrder(string userName, string password, string systemID, string orderText, string time) {
            SystemOperator systemOperator = new SystemOperator();
            return systemOperator.SendOrder(userName, password, systemID, orderText, time);
        }
        [WebMethod]
        public string GetHistoryData(string userName, string password, string systemID, string startTime, string endTime, string index, string size) {
            SystemOperator systemOperator = new SystemOperator();
            return systemOperator.GetHistoryData(userName, password, systemID, startTime, endTime, index, size);
        }
        [WebMethod]
        public string GetHistoryAlarm(string userName, string password, string systemID, string startTime, string endTime) {
            SystemOperator systemOperator = new SystemOperator();
            return systemOperator.GetHistoryAlarm(userName, password, systemID, startTime, endTime);
        }
        [WebMethod]
        public string GetHandControl(string userName, string password, string systemID) { 
            SystemOperator systemOperator = new SystemOperator();
            return systemOperator.GetHandControl(userName, password, systemID);
        }
        [WebMethod]
        public string GetWarning(string userName, string password) {
            SystemOperator systemOperator = new SystemOperator();
            return systemOperator.GetWarning(userName, password);
        }
        [WebMethod]
        public string SelfCheck(string userName, string password, string systemID) {
            SystemOperator systemOperator = new SystemOperator();
            return systemOperator.SelfCheck(userName, password, systemID);
        }
        [WebMethod]
        public string GetHistorySetup(string userName, string password, string systemID, string startTime, string endTime) {
            SystemOperator systemOperator = new SystemOperator();
            return systemOperator.GetHistorySetup(userName, password, systemID, startTime, endTime);
        }
        [WebMethod]
        public string GetSeasonDefaultSetup(string userName, string password, string systemID) {
            SystemOperator systemOperator = new SystemOperator();
            return systemOperator.GetSeasonDefaultSetup(userName, password, systemID);
        }
        [WebMethod]
        public void SaveSeasonDefaultSetup(string userName, string password, string setupID, string saStartTime, string saCollector, string wsStartTime, string wsCollector) {
            SystemOperator systemOperator = new SystemOperator();
            systemOperator.SaveSeasonDefaultSetup(userName, password, setupID, saStartTime, saCollector, wsStartTime, wsCollector);
        }
        [WebMethod]
        public void UserQuit(string userName, string password) {
            UserManager userManager = new UserManager();
            userManager.UserQuit(userName, password);
        }
        [WebMethod]
        public string GetHistoryControl(string userName, string password, string communityID, string time, string content) {
            SystemOperator systemOperator = new SystemOperator();
            return systemOperator.GetHistoryControl(userName, password, communityID, time, content);
        }
        [WebMethod]
        public string CheckOrder(string userName, string password, string systemID, string time, string checkOrder) {
            SystemOperator systemOperator = new SystemOperator();
            return systemOperator.CheckOrder(userName, password, systemID, time, checkOrder);
        }
        [WebMethod]
        public string CheckCurrentSetup(string userName, string password, string systemID, string time) {
            SystemOperator systemOperator = new SystemOperator();
            return systemOperator.CheckCurrentSetup(userName, password, systemID, time);
        }
        [WebMethod]
        public string GetSystemInstall(string userName, string password, string systemID)
        {
            SystemOperator systemOperator = new SystemOperator();
            return systemOperator.GetSystemInstall(userName, password, systemID);
        }
        [WebMethod]
        public void DeleteAlarm(string userName, string password, string id)
        {
            SystemOperator systemOperator = new SystemOperator();
            systemOperator.DeleteAlarm(userName, password, id);
        }
        [WebMethod]
        public string CheckSetSetup(string userName, string password, string systemID, string time) {
            SystemOperator systemOperator = new SystemOperator();
            return systemOperator.CheckSetSetup(userName, password, systemID, time);
        }
        [WebMethod]
        public string CheckInstall(string userName, string password, string systemID, string time) {
            SystemOperator systemOperator = new SystemOperator();
            return systemOperator.CheckInstall(userName, password, systemID, time);
        }
        [WebMethod]
        public string CheckSetSeason(string userName, string password, string systemID, string time) {
            SystemOperator systemOperator = new SystemOperator();
            return systemOperator.CheckSetSeason(userName, password, systemID, time);
        }
        [WebMethod]
        public string CheckSelfCheck(string userName, string password, string systemID, string time) {
            SystemOperator systemOperator = new SystemOperator();
            return systemOperator.CheckSelfCheck(userName, password, systemID, time);
        }
        [WebMethod]
        public string GetConsoleState(string username, string password, string systemID) { 
            SystemOperator systemOperator = new SystemOperator();
            return systemOperator.GetConsoleState(username, password, systemID);
        }
        [WebMethod]
        public string Encrypt(string source) {
            return DESEncrypt.Encrypt(source);
        }
        [WebMethod]
        public string Decrypt(string result) {
            return DESEncrypt.Decrypt(result);
        }
        [WebMethod]
        public void DeleteAllAlarm(string userName, string password, List<string> alarm) {
            SystemOperator systemOperator = new SystemOperator();
            systemOperator.DeleteAllAlarm(userName, password, alarm);
        }
        [WebMethod]
        public string GetWeather(string city) {
            SystemOperator systemOperatr = new SystemOperator();
            return systemOperatr.GetWeather(city);
        }
        [WebMethod]
        public string GetWeather2(string city) {
            SystemOperator systemOperatr = new SystemOperator();
            return systemOperatr.GetWeather2(city);
        }
        [WebMethod]
        public string GetCommunicateError() {
            SystemOperator systemOperator = new SystemOperator();
            return systemOperator.GetCommunicateError();
        }
        [WebMethod]
        public string GetMonthEndItem(string startTime, string endTime, string systemId)
        {
            SystemOperator systemOperator = new SystemOperator();
            return systemOperator.GetMonthEndItem(startTime, endTime, systemId);
        }
        [WebMethod]
        public string GetDisplayMode() {
            SystemOperator systemOperator = new SystemOperator();
            return systemOperator.GetDisplayMode();
        }
        [WebMethod]
        public void SetElecFactor(string factor, string extraFactor, string collector, string systemId) {
            SystemOperator systemOperator = new SystemOperator();
            systemOperator.SetElecFactor(factor, extraFactor, collector, systemId);
        }

        [WebMethod]
        public string GetAllCompanyInfo() {
            CompanyManager companyManager = new CompanyManager();
            return companyManager.GetAllCompanyInfoList();
        }

        [WebMethod]
        public string GetCompanyInfo(string companyIdentifier)
        {
            CompanyManager companyManager = new CompanyManager();
            return companyManager.GetCompanyInfo(companyIdentifier);
        }

    }
}
