using System.Xml;
using System.Collections.Generic;
using SolarSystem.Model;
namespace SolarSystem.DAL.Interface
{
    public interface IUserInfo
    {
        int Exist(string userName, string password);
        string GetUserInfo(string userName, string password);
        string GetAllUserInfo(string userName, string password, List<int> communityInfo);
        string GetUserInfoByID(string userName, string password, int userID);
        string SaveUserDetail(string userName, string password, UserDetailData userDetail, List<IdAndRight> communityArray);
        void DeleteUser(string userName, string password, string userID);
        void UserQuit(string userName, string password);
        string Login(string userName, string password);
        string GetUserTreeLogin(string userName, string password);
    }
}
