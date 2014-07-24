using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace SolarSystem.DAL.Interface
{
    public interface IRegionInfo
    {
        void AddRegion(string userName, string password, string regionName, int regionType, int belRegionID);
        string GetRegion(string userName, string password);
        void DeleteRegion(string userName, string password, int regionID);
    }
}
