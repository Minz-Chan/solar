using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using SolarSystem.Model;
namespace SolarSystem.DAL.Interface
{
    public interface ICommunityInfo
    {
        string GetCommunityInfo(string userName, string password);
        string InsertCommunityInfo(string userName, string password, CommunityInfo communityInfo);
        void UpdateCommunityInfo(string userName, string password, CommunityInfo communityInfo);
        void DeleteCommunityInfo(string userName, string password, string communityID);
        List<int> CommunityNotAllocated(string userName, string password, List<int> source);   // 判断一个小区是否被分配
    }
}
