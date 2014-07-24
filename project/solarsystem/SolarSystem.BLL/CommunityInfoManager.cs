using SolarSystem.DAL;
using SolarSystem.DAL.Impl;
using SolarSystem.DAL.Interface;
using System.Xml;
using System.Collections.Generic;
using SolarSystem.Model;
namespace SolarSystem.BLL
{
    public class CommunityInfoManager
    {
        private ICommunityInfo communityInfo = DALFactory.CreateCommunityInfo();
        public string GetCommunityInfo(string userName, string password) {
            return communityInfo.GetCommunityInfo(userName, password);
        }
        public string InsertCommunityInfo(string userName, string password,CommunityInfo data) {
            return communityInfo.InsertCommunityInfo(userName, password, data);
            
            //return null;
        }
        public void UpdateCommunityInfo(string userName, string password, CommunityInfo data)
        {
            communityInfo.UpdateCommunityInfo(userName, password, data);

            //return null;
        }
        public void DeleteCommunityInfo(string userName, string password, string communityID) {
            communityInfo.DeleteCommunityInfo(userName, password, communityID);
        }
        public List<int> CommunityNotAllocated(string userName, string password, List<int> source) {
            return communityInfo.CommunityNotAllocated(userName, password, source);
        }
    }
}
