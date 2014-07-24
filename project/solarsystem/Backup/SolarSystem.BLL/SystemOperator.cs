using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using SolarSystem.DAL;
using SolarSystem.DAL.Interface;

namespace SolarSystem.BLL
{
    public class SystemOperator
    {
        private ISystemOperation systemOperator = DALFactory.CreateSystemOperator();

        public string GetHandControl(string userName, string password, string systemID) {
            return systemOperator.GetHandControl(userName, password, systemID);
        }
        public string CheckOrder(string userName, string password, string systemID, string time, string checkOrder) {
            return systemOperator.CheckOrder(userName, password, systemID, time, checkOrder);
        }
        public string CheckCurrentSetup(string userName, string password, string systemID, string time) {
            return systemOperator.CheckCurrentSetup(userName, password, systemID, time);
        }
        public string GetSystemInstall(string userName, string password, string systemID) {
            return systemOperator.GetSystemInstall(userName, password, systemID);
        }
        public string GetCurrentSetup(string userName, string password, string systemID) {
            return systemOperator.GetCurrentSetup(userName, password, systemID);
        }
        public string GetCurrentSystemData(string userName, string password, int systemID) {
            return systemOperator.GetCurrentSystemData(userName, password, systemID);
        }
        public string SendOrder(string userName, string password, string systemID, string orderText, string time) {
            return systemOperator.SendOrder(userName, password, systemID, orderText, time);
        }
        public string GetHistoryData(string userName, string password, string systemID, string startTime, string endTime, string index, string size) {
            return systemOperator.GetHistoryData(userName, password, systemID, startTime, endTime, index, size);
        }
        public string GetWarning(string userName, string password) {
            return systemOperator.GetWarning(userName, password);
        }
        public void DeleteAlarm(string userName, string password, string id) {
            systemOperator.DeleteAlarm(userName, password, id);
        }
        public string GetHistorySetup(string userName, string password, string systemID, string startTime, string endTime) {
            return systemOperator.GetHistorySetup(userName, password, systemID, startTime, endTime);
        }
        public string GetSeasonDefaultSetup(string userName, string password, string systemID) {
            return systemOperator.GetSeasonDefaultSetup(userName, password, systemID);
        }
        public void SaveSeasonDefaultSetup(string userName, string password, string setupID, string saStartTime, string saCollector, string wsStartTime, string wsCollector) {
            systemOperator.SaveSeasonDefaultSetup(userName, password, setupID, saStartTime, saCollector, wsStartTime, wsCollector);
        }
        public string GetHistoryControl(string username, string password, string communityID, string time, string content) {
            return systemOperator.GetHistoryControl(username, password, communityID, time, content);
        }
        public string GetHistoryAlarm(string username, string password, string systemID, string startTime, string endTime) {
            return systemOperator.GetHistoryAlarm(username, password, systemID, startTime, endTime);
        }
        public string SelfCheck(string username, string password, string systemID) {
            return systemOperator.SelfCheck(username, password, systemID);
        }
        public string CheckSetSetup(string userName, string password, string systemID, string time) {
            return systemOperator.CheckSetSetup(userName, password, systemID, time);
        }
        public string CheckInstall(string userName, string password, string systemID, string time) {
            return systemOperator.CheckInstall(userName, password, systemID, time);
        }
        public string CheckSetSeason(string userName, string password, string systemID, string time) {
            return systemOperator.CheckSetSeason(userName, password, systemID, time);
        }
        public string CheckSelfCheck(string userName, string password, string systemID, string time) {
            return systemOperator.CheckSelfCheck(userName, password, systemID, time);
        }
        public string GetConsoleState(string userName, string password, string systemID) {
            return systemOperator.GetConsoleState(userName, password, systemID);
        }
        public void DeleteAllAlarm(string userName, string password, List<string> alarm) {
            systemOperator.DeleteAllAlarm(userName, password, alarm);
        }
        public string GetWeather(string city) {
            return systemOperator.GetWeather(city);
        }
        public string GetWeather2(string city) {
            return systemOperator.GetWeather2(city);
        }
        public string GetCommunicateError()
        {
            return systemOperator.GetCommunicateError();
        }
        public string GetMonthEndItem(string startTime, string endTime, string systemID)
        {
            return systemOperator.GetMonthEndItem(startTime, endTime, systemID);
        }
        public string GetDisplayMode() {
            return systemOperator.GetDisplayMode();
        }
        public void SetElecFactor(string factor, string extraFactor, string collector, string systemId)
        {
            systemOperator.SetElecFactor(factor, extraFactor, collector, systemId);
        }
    }
}
