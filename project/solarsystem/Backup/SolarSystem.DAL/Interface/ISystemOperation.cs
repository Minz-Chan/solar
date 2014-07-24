using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace SolarSystem.DAL.Interface
{
    public interface ISystemOperation
    {
        string CheckOrder(string userName, string password, string systemID, string time, string checkOrder);
        
        string CheckCurrentSetup(string userName, string password, string systemID, string time);
        string GetSystemInstall(string userName, string password, string systemID);
        string GetCurrentSetup(string userName, string password, string systemID);
        string GetCurrentSystemData(string userName, string password, int systemID);
        string SendOrder(string userName, string password, string systemID, string orderText, string time);
        string GetHistoryData(string userName, string password, string systemId, string startTime, string endTime, string index, string size);
        string GetWarning(string userName, string password);
        void DeleteAlarm(string userName, string password, string id);
        string GetHistorySetup(string userName, string password, string systemID, string startTime, string endTime);
        string GetHandControl(string userName, string password, string systemID);

        string GetSeasonDefaultSetup(string username, string passwrd, string systemID);
        string SelfCheck(string userName, string password, string systemID);
        string GetHistoryAlarm(string username, string password, string systemID, string startTime, string endTime);
        string GetHistoryControl(string username, string password, string communityID, string time, string content);
        void SaveSeasonDefaultSetup(string userName, string password, string setupID, string saStartTime, string saCollector, string wsStartTime, string wsCollector);
        string CheckSetSetup(string userName, string password, string systemID, string time);
        string CheckInstall(string userName, string password, string systemID, string time);
        string CheckSetSeason(string userName, string password, string systemID, string time);
        string CheckSelfCheck(string userName, string password, string systemID, string time);
        string GetConsoleState(string userName, string password, string systemID);
        void DeleteAllAlarm(string userName, string password, List<string> alarm);
        string GetCommunicateError();
        string GetWeather2(string city);

        string GetWeather(string city);
        string GetMonthEndItem(string startTime, string endTime, string systemID);
        string GetDisplayMode();
        void SetElecFactor(string factor, string extraFactor, string collector, string systemID);
    }
}
