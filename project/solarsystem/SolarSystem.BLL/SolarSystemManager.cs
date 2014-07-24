using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using SolarSystem.DAL.Interface;
using SolarSystem.DAL;

namespace SolarSystem.BLL
{
    public class SolarSystemManager
    {
        private ISystemInfo systemInfo = DALFactory.CreateSystemInfo();
        public void DeleteSolarSystem(string userName, string password, int systemID) {
            systemInfo.DeleteSolarSystem(userName, password, systemID);
        }
        public string AddSolarSystem(string userName, string password, string systemName, string manager, string managerPhone, int belCommunityID, string armID, string setupTime, string imageURL, string armPassword) {
            return systemInfo.AddSolarSystem(userName, password, systemName, manager, managerPhone, belCommunityID, armID, setupTime, imageURL, armPassword);
        }
        public void EditSolarSystem(string userName, string password, int systemID, string systemName, string manager, string managerPhone, string armID, string setupTime, string imageURL) {
            systemInfo.EditSolarSystem(userName, password, systemID, systemName, manager, managerPhone, armID, setupTime, imageURL);
        }
        public string GetCommunity(string userName, string password) {
            return systemInfo.GetCommunity(userName, password);
        }
    }
}
