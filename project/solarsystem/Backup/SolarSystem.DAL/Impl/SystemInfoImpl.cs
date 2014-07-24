using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.SqlClient;
using System.Data;
using SolarSystem.DAL.Interface;
using SolarSystem.Utils;

namespace SolarSystem.DAL.Impl
{
    class SystemInfoImpl:ISystemInfo
    {
        public int DeleteSolarSystem(string userName, string password, int SystemID) { 
            IUserInfo userInfo = DALFactory.CreateUserInfo();
            int nowUserType = userInfo.Exist(userName, password);
            if (nowUserType == 0 || nowUserType == 4 || nowUserType == 3) {
                return 0;
            }
            LogManager.SendLog(userName + "删除了系统ID为" + SystemID + "的太阳能系统");

            SqlParameter[] prams = new SqlParameter[] {
                new SqlParameter("@systemID", SqlDbType.Int)
            };
            prams[0].Value = SystemID;
            return DbHelperSQL.ExcuteNonQueryBySqlProc("Delete_SolarSystem", prams);
        }
        public string AddSolarSystem(string userName, string password, string systemName, string manager, string managerPhone, int belCommunityID, string armID, string setupTime, string imageURL, string armPassword) {
            IUserInfo userInfo = DALFactory.CreateUserInfo();
            int nowUserType = userInfo.Exist(userName, password);
            if (nowUserType == 0 || nowUserType == 4)
            {
                return null;
            }
            LogManager.SendLog(userName + "添加了系统名为" + systemName + "的太阳能系统");
         
            SqlParameter output = new SqlParameter("@systemID", SqlDbType.BigInt, 8);
            output.Direction = ParameterDirection.Output;

            SqlParameter[] prams = new SqlParameter[] {
                new SqlParameter("@systemName", SqlDbType.NVarChar, 40),
                new SqlParameter("@manager", SqlDbType.NVarChar, 10),
                new SqlParameter("@managerPhone", SqlDbType.NVarChar, 20),
                new SqlParameter("@belCommunityID", SqlDbType.Int, 4),
                new SqlParameter("@armID", SqlDbType.NVarChar, 10),
                new SqlParameter("@setupTime", SqlDbType.DateTime),
                new SqlParameter("@sysPictureRoute", SqlDbType.NVarChar, 100),
                output,
                new SqlParameter("@armPassword", SqlDbType.NVarChar, 20)
            };
            prams[0].Value = systemName;
            prams[1].Value = manager;
            prams[2].Value = managerPhone;
            prams[3].Value = belCommunityID;
            prams[4].Value = armID;
            prams[5].Value = setupTime;
            prams[6].Value = imageURL;
            prams[8].Value = armPassword;
            

            DbHelperSQL.ExcuteNonQueryBySqlProc("Add_SolarSystem", prams);

            return output.Value.ToString();
        }
        public void EditSolarSystem(string userName, string password, int systemID, string systemName, string manager, string managerPhone, string armID, string setupTime, string imageURL)
        {
            IUserInfo userInfo = DALFactory.CreateUserInfo();
            int nowUserType = userInfo.Exist(userName, password);
            if (nowUserType == 0 || nowUserType == 4)
            {
                return;
            }
            LogManager.SendLog(userName + "修改了系统ID为" + systemID + "的太阳能系统");
            

            SqlParameter[] prams = new SqlParameter[] {
                new SqlParameter("@systemID", SqlDbType.Int, 4),
                new SqlParameter("@systemName", SqlDbType.NVarChar, 40),
                new SqlParameter("@manager", SqlDbType.NVarChar, 10),
                new SqlParameter("@managerPhone", SqlDbType.NVarChar, 20),
                new SqlParameter("@armID", SqlDbType.NVarChar, 10),
                new SqlParameter("@setupTime", SqlDbType.DateTime),
                new SqlParameter("@sysPictureRoute", SqlDbType.NVarChar, 100)
                
            };
            prams[0].Value = systemID;
            prams[1].Value = systemName;
            prams[2].Value = manager;
            prams[3].Value = managerPhone;
            prams[4].Value = armID;
            prams[5].Value = setupTime;
            prams[6].Value = imageURL;
        
            

            DbHelperSQL.ExcuteNonQueryBySqlProc("Update_SolarSystem", prams);
        }

        public string GetCommunity(string userName, string password) {
            IUserInfo userInfo = DALFactory.CreateUserInfo();
            int nowUserType = userInfo.Exist(userName, password);
            //if (nowUserType == 0 || nowUserType == 4)
            if(nowUserType == 0 )
            {
                return null;
            }
            SqlParameter[] prams = new SqlParameter[] {
                new SqlParameter("@userName", SqlDbType.VarChar, 10)
            };
            prams[0].Value = userName;
            string content = "<?xml version=\"1.0\" encoding=\"GB2312\"?><root>";
            content += DbHelperSQL.QueryGetXMLStringByProc("Get_Community", prams);
            content += "</root>";
            return content;
        }
        
        
    }
}
