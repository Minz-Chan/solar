using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.SqlClient;
using SolarSystem.DAL.Interface;
using SolarSystem.Utils;
using System.Xml;
namespace SolarSystem.DAL.Impl
{
    class RegionInfoImpl:IRegionInfo 
    {
        public void AddRegion(string userName, string password, string regionName, int regionType, int belRegionID) {
            IUserInfo userInfo = DALFactory.CreateUserInfo();
            int nowUserType = userInfo.Exist(userName, password);
            if (nowUserType == 0 || nowUserType == 4 || nowUserType == 3)
            {
                return;
            }
            LogManager.SendLog(userName + "添加了地域" + regionName);

            SqlParameter[] prams = new SqlParameter[] {
                new SqlParameter("@areaName", SqlDbType.NVarChar, 20),
                new SqlParameter("@areaType", SqlDbType.Int, 4),
                new SqlParameter("@belRegionID", SqlDbType.Int, 4)
            };
            prams[0].Value = regionName;
            prams[1].Value = regionType;
            prams[2].Value = belRegionID;
            DbHelperSQL.ExcuteNonQueryBySqlProc("Add_Area", prams);
        }
        public string GetRegion(string userName, string password) {
            IUserInfo userInfo = DALFactory.CreateUserInfo();
            int nowUserType = userInfo.Exist(userName, password);
            if (nowUserType == 0)
            {
                return null;
            }
            string content = DbHelperSQL.QueryGetXMLStringByProc("Get_AreaInfo", null);
            XmlDocument xml = new XmlDocument();
            xml.LoadXml("<?xml version=\"1.0\" encoding=\"GB2312\"?><root>" + content + "</root>");
            return xml.InnerXml;
        }
        public void DeleteRegion(string userName, string password, int areaID) {
            IUserInfo userInfo = DALFactory.CreateUserInfo();
            int nowUserType = userInfo.Exist(userName, password);
            if (nowUserType == 0 || nowUserType == 4 || nowUserType == 3)
            {
                return;
            }
            SqlParameter[] prams = new SqlParameter[] {
                new SqlParameter("@areaID", SqlDbType.Int, 4)
            };
            prams[0].Value = areaID;
            DbHelperSQL.QueryBySqlProc("Delete_Area", prams);
        }
    }
}
