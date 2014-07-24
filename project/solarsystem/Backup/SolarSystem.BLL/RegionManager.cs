using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using SolarSystem.DAL.Interface;
using SolarSystem.DAL;
namespace SolarSystem.BLL
{
    public class RegionManager
    {
        private IRegionInfo regionInfo = DALFactory.CreateRegionInfo();
        public void AddRegion(string userName, string password, string regionName, int regionType, int belRegionID) {
            regionInfo.AddRegion(userName, password, regionName, regionType, belRegionID);
        }
        public string GetRegion(string userName, string password) {
            return regionInfo.GetRegion(userName, password);
        }
        public void DeleteRegion(string userName, string password, int areaID) {
            regionInfo.DeleteRegion(userName, password, areaID);
        }
    }
}
