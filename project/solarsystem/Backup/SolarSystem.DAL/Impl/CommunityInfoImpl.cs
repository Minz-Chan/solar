using SolarSystem.Utils;
using SolarSystem.DAL.Interface;
using System.Data.SqlClient;
using System.Data;
using System.Collections.Generic;
using System.Xml;
using SolarSystem.Model;
namespace SolarSystem.DAL.Impl
{
    public class CommunityInfoImpl:ICommunityInfo
    {
        public string GetCommunityInfo(string userName, string password) {
            IUserInfo userInfo = DALFactory.CreateUserInfo();
            if (userInfo.Exist(userName, password) == 0) {
                return null;
            }
            
            SqlParameter[] prams = new SqlParameter[] { 
                new SqlParameter("@userName",SqlDbType.NVarChar,10)
            };
            prams[0].Value = userName;

            string content = "<?xml version=\"1.0\" encoding=\"GB2312\"?><root>";
            content += DbHelperSQL.QueryGetXMLStringByProc("Get_AllSolarSystem", prams);
            content += "</root>";
            return content;
        }
        // 如果小区名已存在，就不添加，并返回0。如果已存在，就添加，并返回1。FLEX端判断返回值，如果是0，就要提示用户小区名已存在
        public string InsertCommunityInfo(string userName, string password, CommunityInfo data) {
            IUserInfo userInfo = DALFactory.CreateUserInfo();
            int nowUserType = userInfo.Exist(userName, password);
            if (nowUserType == 0 || nowUserType == 4 || nowUserType == 3)
            {
                return "2";
            }
            LogManager.SendLog(userName + "添加了小区" + data.communityName);

            SqlParameter output = new SqlParameter("@returnValue", SqlDbType.Int, 4);
            output.Direction = ParameterDirection.Output;
            SqlParameter[] prams = new SqlParameter[] {
                new SqlParameter( "@belongAreaID", SqlDbType.Int, 4),
	            new SqlParameter( "@communityName", SqlDbType.NVarChar, 20),
	            new SqlParameter( "@communityPassword", SqlDbType.NVarChar, 20),
	            new SqlParameter( "@communityAddress", SqlDbType.NVarChar, 30),
	            new SqlParameter( "@communityPhone", SqlDbType.NVarChar, 20),
	            new SqlParameter( "@manageUnit", SqlDbType.NVarChar, 20),
	            new SqlParameter( "@managerPhone", SqlDbType.NVarChar, 20),
	            new SqlParameter( "@manager" , SqlDbType.NVarChar, 10),
	            new SqlParameter( "@pictureRoute", SqlDbType.NVarChar, 100),
                new SqlParameter( "@communityID", SqlDbType.Int, 4),
                output
            };
            prams[0].Value = int.Parse(data.belongAreaID);
            prams[1].Value = data.communityName;
            prams[2].Value = data.communityPassword;
            prams[3].Value = data.communityAddress;
            prams[4].Value = data.communityPhone;
            prams[5].Value = data.manageUnit;
            prams[6].Value = data.managerPhone;
            prams[7].Value = data.manager;
            prams[8].Value = data.pictureRoute;
            prams[9].Value = int.Parse(data.communityID);

            DbHelperSQL.ExcuteQueryWithOutputParam("Insert_Community", new SqlCommand(), prams);
            if (output.Value.ToString() == "0") {
                return "0";
            }

            /**
             * 在communityPerview 中添加数据，如果是超级管理员或企业管理员，默认的权限是厂家权限，
             * 如果是小区管理员默认权限是主控权限，如果是普通管理员，默认是查询权限，注意这里是和ID挂钩的，也就是说数据库中
             * 超级管理员ID一定是1，企业管理员ID一定是2。。。并且厂家权限ID必定是3，主控权限ID必定是2。。。
             */
            int userRightID = 1;
            if (int.Parse(data.userTypeID) == 1 || int.Parse(data.userTypeID) == 2) {
                userRightID = 3;
            }
            else if (int.Parse(data.userTypeID) == 3) {
                userRightID = 2;
            }
            else if (int.Parse(data.userTypeID) == 4) {
                userRightID = 1;
            }
            DbHelperSQL.QueryBySqlProc("Insert_CommunityPurview", new SqlParameter[] {
                new SqlParameter( "@UserID", int.Parse(data.userID) ),
                new SqlParameter( "@UserRight_ID", userRightID),
                new SqlParameter( "@CommunityID", int.Parse(output.Value.ToString()))
            });

            return "1";
        }
        public void UpdateCommunityInfo(string userName, string password, CommunityInfo data) {
            IUserInfo userInfo = DALFactory.CreateUserInfo();
            int nowUserType = userInfo.Exist(userName, password);
            if (nowUserType == 0 || nowUserType == 4 || nowUserType == 3)
            {
                return;
            }
            LogManager.SendLog(userName + "修改了小区" + data.communityName);
            SqlParameter[] prams = new SqlParameter[] {
                new SqlParameter( "@belongAreaID", SqlDbType.Int, 4),
	            new SqlParameter( "@communityName", SqlDbType.NVarChar, 20),
	            new SqlParameter( "@communityPassword", SqlDbType.NVarChar, 20),
	            new SqlParameter( "@communityAddress", SqlDbType.NVarChar, 30),
	            new SqlParameter( "@communityPhone", SqlDbType.NVarChar, 20),
	            new SqlParameter( "@manageUnit", SqlDbType.NVarChar, 20),
	            new SqlParameter( "@managerPhone", SqlDbType.NVarChar, 20),
	            new SqlParameter( "@manager" , SqlDbType.NVarChar, 10),
	            new SqlParameter( "@pictureRoute", SqlDbType.NVarChar, 100),
                new SqlParameter( "@communityID", SqlDbType.Int, 4),
            };
            prams[0].Value = int.Parse(data.belongAreaID);
            prams[1].Value = data.communityName;
            prams[2].Value = data.communityPassword;
            prams[3].Value = data.communityAddress;
            prams[4].Value = data.communityPhone;
            prams[5].Value = data.manageUnit;
            prams[6].Value = data.managerPhone;
            prams[7].Value = data.manager;
            prams[8].Value = data.pictureRoute;
            prams[9].Value = int.Parse(data.communityID);
            DbHelperSQL.QueryBySqlProc("Update_Community", prams);
        }
        public void DeleteCommunityInfo(string userName, string password, string communityID) {
            SqlParameter[] prams = new SqlParameter[] {
                new SqlParameter( "@communityID", SqlDbType.Int, 4)
            };
            LogManager.SendLog(userName + "删除了小区ID为" + communityID + "的小区");
 
            prams[0].Value = int.Parse(communityID);
            DbHelperSQL.ExcuteNonQueryBySqlProc("Delete_Community", prams);
        }
        public List<int> CommunityNotAllocated(string userName, string password, List<int> source) {
            IUserInfo userInfo = DALFactory.CreateUserInfo();
            if (userInfo.Exist(userName, password) == 0)
            {
                return null;
            }
            List<int> result = new List<int>();

            SqlParameter output = new SqlParameter("@count", SqlDbType.Int, 4);
            output.Direction = ParameterDirection.Output;

            SqlParameter [] prams = new SqlParameter[] {
                new SqlParameter("@communityID", SqlDbType.Int, 4),
                output
            };
           
            SqlCommand cmd = new SqlCommand();
           
            for( int i = 0; i < source.Count; i++) {
                prams[0].Value = source[i];
                DbHelperSQL.ExcuteNonQueryBySqlProcWithOutputPram("Community_Be_Allocated", cmd, prams);
                if(int.Parse(output.Value.ToString()) == 0) {
                    result.Add(source[i]);
                }
            }
            return result;
        }
    }
}
