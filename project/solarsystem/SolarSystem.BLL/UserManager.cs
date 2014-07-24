using SolarSystem.DAL.Interface;
using SolarSystem.DAL.Impl;
using SolarSystem.DAL;
using System.Xml;
using System.Collections.Generic;
using SolarSystem.Model;
namespace SolarSystem.BLL
{
    public class UserManager
    {
        private IUserInfo userInfoImpl = DALFactory.CreateUserInfo();
        public string Login(string userName, string pwd)
        {
            //return userInfoImpl.GetUserInfo(userName, pwd);
            return userInfoImpl.Login(userName, pwd);
        }
        public string GetUserTreeLogin(string userName, string pwd) { 
            return userInfoImpl.GetUserTreeLogin(userName, pwd);
        }
       
        public string GetAllUserInfo(string userName, string pwd, List<int> communityInfo) {
            return userInfoImpl.GetAllUserInfo(userName, pwd, communityInfo);
        }
        public string GetUserInfo(string userName, string password, int userID) {
            return userInfoImpl.GetUserInfoByID(userName, password, userID);
        }
        public string SaveUserDetail(string userName, string password, UserDetailData userDetail, List<IdAndRight> communityArray) {
            return userInfoImpl.SaveUserDetail(userName, password, userDetail, communityArray);
        }
        public void DeleteUserInfo(string userName, string password, string userID) {
            userInfoImpl.DeleteUser(userName, password, userID);
        }
        public void UserQuit(string userName, string password) {
            userInfoImpl.UserQuit(userName, password);
        }
    }
}
