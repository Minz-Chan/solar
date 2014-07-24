using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace SolarSystem.DAL.Interface
{
    public interface ISystemInfo
    {
        int DeleteSolarSystem(string userName, string password, int systemID);
        void EditSolarSystem(string userName, string password, int systemID, string systemName, string manager, string managerPhone, string armID, string setupTIme, string imageURL);
        string AddSolarSystem(string userName, string password, string systemName, string manager, string managerPhone, int belCommunityID, string armID, string setupTime, string imageURL, string armPassword);
        string GetCommunity(string userName, string password);
    }
}
