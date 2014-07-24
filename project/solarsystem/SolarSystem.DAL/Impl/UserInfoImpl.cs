using SolarSystem.Utils;
using SolarSystem.DAL.Interface;
using System.Data.SqlClient;
using System.Data;
using System.Collections.Generic;
using System.Xml;
using SolarSystem.Model;
using System.Data.SqlTypes;
namespace SolarSystem.DAL.Impl
{
    public class UserInfoImpl : IUserInfo
    {
        //private XmlDocument userInfo;

        public int Exist(string userName, string pwd)
        {
           
            //userInfo = null;

            //string sqlText = "select count(*) from UserInfo where UserName=@userName and UserPassword=@pwd";
            SqlParameter output = new SqlParameter("@userTypeID", SqlDbType.Int, 4);
            output.Direction = ParameterDirection.Output;

            SqlParameter[] prams = new SqlParameter[] { 
                new SqlParameter("@userName",SqlDbType.NVarChar,10),
                //new SqlParameter("@userPassword",SqlDbType.NVarChar,50),
                output
            };
            prams[0].Value = userName;
            // 把密码加密以后再和数据库中的数据对比
            //prams[1].Value = DESEncrypt.Encrypt(pwd);

            DbHelperSQL.ExcuteNonQueryBySqlProc("Exist_UserInfo", prams);
            return int.Parse(output.Value.ToString());
            

        }
        public string Login(string userName, string password) {
            /*if (Exist(userName, password) == 0)
            {
                return null;
            }*/
            SqlParameter output = new SqlParameter("@output", SqlDbType.Int, 4);
            output.Direction = ParameterDirection.Output;
            SqlParameter[] prams = new SqlParameter[] {
                new SqlParameter("@username", SqlDbType.NVarChar, 10),
                new SqlParameter("@password", SqlDbType.NVarChar, 50),
                output
            };
            prams[0].Value = userName;
            prams[1].Value = DESEncrypt.Encrypt(password);
            DbHelperSQL.ExcuteNonQueryBySqlProc("User_Login", prams);
            if (output.Value.ToString() == "0") {
                return null;
            }
            LogManager.SendLog("用户" + userName + "登录");
            return GetUserInfo(userName, password);
        }
        public void UserQuit(string userName, string password) {
            if (Exist(userName, password) == 0)
            {
                return;
            }
            LogManager.SendLog("用户" + userName + "退出");
        }
        /**
         * 返回用户数据的函数
         */
        public string GetUserInfo(string userName, string password)
        {
            if (Exist(userName, password) == 0) {
                return null;
            }
            SqlParameter[] prams = new SqlParameter[] {
                new SqlParameter("@userName", SqlDbType.NVarChar, 10),
                new SqlParameter("@userPassword", SqlDbType.NVarChar, 50)
            };
            prams[0].Value = userName;
            // 将加密后的密码传给"Get_UserID", 获取用户ID
            prams[1].Value = DESEncrypt.Encrypt(password);
            SqlParameter output = new SqlParameter("@userID", SqlDbType.Int, 4);
            output.Direction = ParameterDirection.Output; 

            SqlCommand cmd = new SqlCommand();
            cmd.Parameters.Add(output);
            DbHelperSQL.ExcuteNonQueryBySqlProcWithOutputPram("Get_UserID", cmd, prams);

            return GetUserInfoByID(userName, password, int.Parse(output.Value.ToString()));
        }
        public string GetUserInfoByID(string n, string pwd, int id)
        {
            if (Exist(n, pwd) == 0)
            {
                return null;
            }
            XmlDocument userInfo = new XmlDocument();
            //建立Xml的定义声明
            XmlDeclaration dec = userInfo.CreateXmlDeclaration("1.0", "GB2312", null);
            userInfo.AppendChild(dec);
            //创建根节点
            XmlElement root = userInfo.CreateElement("UserInfo");
            userInfo.AppendChild(root);

            SqlParameter[] p = new SqlParameter[] {
                new SqlParameter("@userID", SqlDbType.Int, 4)
            };
            p[0].Value = id;
            DataTable userData = DbHelperSQL.QueryBySqlProc("Get_UserInfo_ByID", p);
            string userName = userData.Rows[0]["UserName"].ToString();
            string password = userData.Rows[0]["UserPassword"].ToString();
            string pictureRoute = userData.Rows[0]["UserPictureRoute"].ToString();

            /*----------------------------------------------------------------------------
             *           添加节点 UserName, UserPassword 和 AreaInfo
             *----------------------------------------------------------------------------*/

            XmlElement name = userInfo.CreateElement("UserName");
            name.InnerText = userName;
            root.AppendChild(name);
            XmlElement userPassword = userInfo.CreateElement("UserPassword");
            // 把密码解密
            userPassword.InnerText = DESEncrypt.Decrypt(password);
            root.AppendChild(userPassword);
            XmlElement userPictureRoute = userInfo.CreateElement("UserPictureRoute");
            userPictureRoute.InnerText = pictureRoute;
            root.AppendChild(userPictureRoute);
            XmlElement areaInfo = userInfo.CreateElement("Area");

            root.AppendChild(areaInfo);


            /*----------------------------------------------------------------------------
             *          构造数据库查询的参数
             *----------------------------------------------------------------------------*/
            SqlParameter[] prams = new SqlParameter[] {
                new SqlParameter("@userName", SqlDbType.NVarChar, 10),
                new SqlParameter("@userID", SqlDbType.Int, 4),
                new SqlParameter("@userTypeID", SqlDbType.Int, 4)
            };
            prams[0].Value = userName;
            prams[1].Value = 1;
            prams[2].Value = 1;


            /*----------------------------------------------------------------------------
             *          向XML中添加电话和用户类型
             *----------------------------------------------------------------------------*/
            DataTable user = DbHelperSQL.QueryBySqlText("select * from UserInfo where UserName=@userName", prams); // 根据用户名在用户表中查找到用户，记录用户电话
            XmlElement userPhone = userInfo.CreateElement("UserPhone");     // 把电话添加到XML里面
            userPhone.InnerText = user.Rows[0]["UserPhone"].ToString();
            root.AppendChild(userPhone);

            prams[2].Value = user.Rows[0]["UserType_ID"]; // 设置参数的值，使得userTypeID 为查找到的用户类型ID

            XmlElement userType = userInfo.CreateElement("UserType");     // 把电话添加到XML里面
            userType.InnerText = DbHelperSQL.GetSingle("select UserType from UserType where UserType_ID=@userTypeID", prams).ToString();  // 记录用户类型，添加到XML中
            root.AppendChild(userType);

            XmlElement eUserID = userInfo.CreateElement("UserID");
            eUserID.InnerText = user.Rows[0]["UserID"].ToString();
            root.AppendChild(eUserID);

            XmlElement userTypeID = userInfo.CreateElement("UserTypeID");
            userTypeID.InnerText = user.Rows[0]["UserType_ID"].ToString();
            root.AppendChild(userTypeID);

            /*----------------------------------------------------------------------------
            *          获取CommunityPerview表中的数据
            *----------------------------------------------------------------------------*/
            string s3 = "select * from CommunityPurview where UserID=@userID";  // 查找与用户关联的小区信息
            prams[1].Value = user.Rows[0]["UserID"].ToString();  // 设置用户ID为查找到的用户ID
            DataTable communityPerview = DbHelperSQL.QueryBySqlText(s3, prams);


            /*----------------------------------------------------------------------------
            *          遍历用户所管辖小区的数据，将查找到的数据储存起来  
            *----------------------------------------------------------------------------*/
            foreach (DataRow dr in communityPerview.Rows)
            {
                int rightID = int.Parse(dr["UserRight_ID"].ToString());
                int communityID = int.Parse(dr["CommunityID"].ToString());
                int userID = int.Parse(dr["UserID"].ToString());
                SqlParameter[] innerPrams = new SqlParameter[] {
                    new SqlParameter("@userID", SqlDbType.Int, 4),
                    new SqlParameter("@rightID", SqlDbType.Int, 4),
                    new SqlParameter("@communityID", SqlDbType.Int, 4),
                    new SqlParameter("@belongAreaID", SqlDbType.Int, 4),
                    new SqlParameter("@typeID", SqlDbType.Int, 4)
                };
                innerPrams[0].Value = userID;
                innerPrams[1].Value = rightID;
                innerPrams[2].Value = communityID;
                innerPrams[3].Value = 1;
                innerPrams[4].Value = 1;


                /*----------------------------------------------------------------------------
                 *           获取一条小区数据，储存在communityInfo这个节点中
                 *----------------------------------------------------------------------------*/
                XmlElement communityInfo = userInfo.CreateElement("CommunityInfo");

                communityInfo.SetAttribute("CommunityRight", DbHelperSQL.GetSingle("select UserRight from UserRight where UserRight_ID=@rightID", innerPrams).ToString());

                DataTable community = DbHelperSQL.QueryBySqlText("select * from Community where CommunityID=@communityID", innerPrams);
                communityInfo.SetAttribute("belongAreaID", community.Rows[0]["BelongAreaID"].ToString());
                communityInfo.SetAttribute("id", community.Rows[0]["CommunityID"].ToString());
                communityInfo.SetAttribute("userRightID", rightID.ToString());
                communityInfo.SetAttribute("name", community.Rows[0]["CommunityName"].ToString());
                communityInfo.SetAttribute("communityAddress", community.Rows[0]["CommunityAddress"].ToString());
                communityInfo.SetAttribute("communityPassword", community.Rows[0]["CommunityPassword"].ToString());
                communityInfo.SetAttribute("communityPhone", community.Rows[0]["CommunityPhone"].ToString());
                communityInfo.SetAttribute("manager", community.Rows[0]["Manager"].ToString());
                communityInfo.SetAttribute("managerPhone", community.Rows[0]["ManagerPhone"].ToString());
                communityInfo.SetAttribute("manageUnit", community.Rows[0]["ManageUnit"].ToString());
                communityInfo.SetAttribute("pictureRoute", community.Rows[0]["PictureRoute"].ToString());

                SqlParameter[] myprams = new SqlParameter[] {
                    new SqlParameter("@communityID", SqlDbType.Int, 4)
                };
                myprams[0].Value = communityID;
                DataTable systemInfo = DbHelperSQL.QueryBySqlProc("Get_SolarSystem", myprams);
                foreach (DataRow mdr in systemInfo.Rows)
                {
                    XmlElement xe = userInfo.CreateElement("SystemInfo");
                    xe.SetAttribute("name", mdr["System_Name"].ToString());
                    xe.SetAttribute("System_ID", mdr["System_ID"].ToString());
                    xe.SetAttribute("ARM_ID", mdr["ARM_ID"].ToString());
                    xe.SetAttribute("System_Name", mdr["System_Name"].ToString());
                    xe.SetAttribute("BelCommunityID", mdr["BelCommunityID"].ToString());
                    xe.SetAttribute("ARM_Password", mdr["ARM_Password"].ToString());
                   
                    communityInfo.AppendChild(xe);
                }


                /*----------------------------------------------------------------------------
                *          访问数据库，把小区所在区域依次入栈
                *----------------------------------------------------------------------------*/
                //Stack<string> areaStack = new Stack<string>();
                Stack<NameAndType> areaStack = new Stack<NameAndType>();
                NameAndType nameAndType = new NameAndType();

                innerPrams[3].Value = int.Parse(community.Rows[0]["BelongAreaID"].ToString());
                DataTable s = DbHelperSQL.QueryBySqlText("select * from Area where AreaID=@belongAreaID", innerPrams);

                //根据地域ID查找地域类型
                innerPrams[4].Value = int.Parse(s.Rows[0]["A_TypeID"].ToString());
                nameAndType.id = s.Rows[0]["AreaID"].ToString();
                nameAndType.name = s.Rows[0]["AreaName"].ToString();
                //nameAndType.typeID = s.Rows[0]["A_TypeID"].ToString();
                nameAndType.typeID = DbHelperSQL.GetSingle("select TypeLevel from AreaType where A_TypeID=@typeID", innerPrams).ToString();
                nameAndType.type = DbHelperSQL.GetSingle("select TypeName from AreaType where A_TypeID=@typeID", innerPrams).ToString();

                //areaStack.Push(s.Rows[0]["AreaName"].ToString());
                areaStack.Push(nameAndType);
                while (s.Rows[0]["BelongRel"].ToString() != "-1")
                {
                    innerPrams[3].Value = int.Parse(s.Rows[0]["BelongRel"].ToString());
                    s = DbHelperSQL.QueryBySqlText("select * from Area where AreaID=@belongAreaID", innerPrams);

                    nameAndType = new NameAndType();
                    innerPrams[4].Value = int.Parse(s.Rows[0]["A_TypeID"].ToString());

                    nameAndType.id = s.Rows[0]["AreaID"].ToString();
                    nameAndType.name = s.Rows[0]["AreaName"].ToString();
                    //nameAndType.typeID = s.Rows[0]["A_TypeID"].ToString();
                    nameAndType.typeID = DbHelperSQL.GetSingle("select TypeLevel from AreaType where A_TypeID = @typeID", innerPrams).ToString();
                    nameAndType.type = DbHelperSQL.GetSingle("select TypeName from AreaType where A_TypeID=@typeID", innerPrams).ToString();

                    areaStack.Push(nameAndType);
                    //areaStack.Push(s.Rows[0]["AreaName"].ToString());
                }

                /*----------------------------------------------------------------------------
                 *         构造XML，使得小区区域信息具有层次结构，比如
                 *         <Area name="中国" type="国家">
                 *            <Area name="福建" type="省份">
                 *                <Area name="福州" type="市区">
                 *                   <CommunityInfo name="福建师范大学"/>
                 *                </Area>
                 *            </Area>
                 *         </Area>
                 *----------------------------------------------------------------------------*/

                XmlNode areaNode = root.SelectSingleNode("Area");
                bool find = false;
                while (areaStack.Count != 0)
                {
                    //string iarea = areaStack.Pop();
                    NameAndType iarea = areaStack.Pop();
                    if (areaNode.HasChildNodes)
                    {
                        foreach (XmlNode xn in areaNode.ChildNodes)
                        {
                            XmlElement xe = (XmlElement)xn;
                            if (xe.GetAttribute("name") == iarea.name)
                            {
                                areaNode = (XmlNode)xe;
                                find = true;
                                break;
                            }
                        }
                        if (find)
                        {
                            find = false;
                            continue;
                        }
                    }

                    XmlElement e = userInfo.CreateElement("Area");
                    e.SetAttribute("id", iarea.id);
                    e.SetAttribute("name", iarea.name);
                    e.SetAttribute("type", iarea.type);
                    e.SetAttribute("typeID", iarea.typeID);
                    areaNode.AppendChild(e);
                    areaNode = (XmlNode)e;
                }
                areaNode.AppendChild(communityInfo);
            }
            return userInfo.InnerXml;
        }
        public string GetUserTreeLogin(string userName, string password) {
            if (Exist(userName, password) == 0)
            {
                return null;
            }
            SqlParameter[] prams = new SqlParameter[] {
                new SqlParameter("@userName", SqlDbType.NVarChar, 10),
                new SqlParameter("@userPassword", SqlDbType.NVarChar, 50)
            };
            prams[0].Value = userName;
            // 将加密后的密码传给"Get_UserID", 获取用户ID
            prams[1].Value = DESEncrypt.Encrypt(password);
            SqlParameter output = new SqlParameter("@userID", SqlDbType.Int, 4);
            output.Direction = ParameterDirection.Output;

            SqlCommand cmd = new SqlCommand();
            cmd.Parameters.Add(output);
            DbHelperSQL.ExcuteNonQueryBySqlProcWithOutputPram("Get_UserID", cmd, prams);

            return GetUserTree(userName, password, int.Parse(output.Value.ToString()));
        }
        public string GetUserTree(string n, string pwd, int id) {
            if (Exist(n, pwd) == 0)
            {
                return null;
            }
            XmlDocument userInfo = new XmlDocument();
            //建立Xml的定义声明
            XmlDeclaration dec = userInfo.CreateXmlDeclaration("1.0", "GB2312", null);
            userInfo.AppendChild(dec);
            //创建根节点
            XmlElement root = userInfo.CreateElement("UserInfo");
            userInfo.AppendChild(root);

            SqlParameter[] p = new SqlParameter[] {
                new SqlParameter("@userID", SqlDbType.Int, 4)
            };
            p[0].Value = id;
            DataTable userData = DbHelperSQL.QueryBySqlProc("Get_UserInfo_ByID", p);
            string userName = userData.Rows[0]["UserName"].ToString();
            string password = userData.Rows[0]["UserPassword"].ToString();
            string pictureRoute = userData.Rows[0]["UserPictureRoute"].ToString();

            /*----------------------------------------------------------------------------
             *           添加节点 UserName, UserPassword 和 AreaInfo
             *----------------------------------------------------------------------------*/

            XmlElement name = userInfo.CreateElement("UserName");
            name.InnerText = userName;
            root.AppendChild(name);
            XmlElement userPassword = userInfo.CreateElement("UserPassword");
            userPassword.InnerText = password;
            root.AppendChild(userPassword);
            XmlElement userPictureRoute = userInfo.CreateElement("UserPictureRoute");
            userPictureRoute.InnerText = pictureRoute;
            root.AppendChild(userPictureRoute);
            XmlElement areaInfo = userInfo.CreateElement("Area");

            root.AppendChild(areaInfo);


            /*----------------------------------------------------------------------------
             *          构造数据库查询的参数
             *----------------------------------------------------------------------------*/
            SqlParameter[] prams = new SqlParameter[] {
                new SqlParameter("@userName", SqlDbType.NVarChar, 10),
                new SqlParameter("@userID", SqlDbType.Int, 4),
                new SqlParameter("@userTypeID", SqlDbType.Int, 4)
            };
            prams[0].Value = userName;
            prams[1].Value = 1;
            prams[2].Value = 1;


            /*----------------------------------------------------------------------------
             *          向XML中添加电话和用户类型
             *----------------------------------------------------------------------------*/
            DataTable user = DbHelperSQL.QueryBySqlText("select * from UserInfo where UserName=@userName", prams); // 根据用户名在用户表中查找到用户，记录用户电话
            XmlElement userPhone = userInfo.CreateElement("UserPhone");     // 把电话添加到XML里面
            userPhone.InnerText = user.Rows[0]["UserPhone"].ToString();
            root.AppendChild(userPhone);

            prams[2].Value = user.Rows[0]["UserType_ID"]; // 设置参数的值，使得userTypeID 为查找到的用户类型ID

            XmlElement userType = userInfo.CreateElement("UserType");     // 把电话添加到XML里面
            userType.InnerText = DbHelperSQL.GetSingle("select UserType from UserType where UserType_ID=@userTypeID", prams).ToString();  // 记录用户类型，添加到XML中
            root.AppendChild(userType);

            XmlElement eUserID = userInfo.CreateElement("UserID");
            eUserID.InnerText = user.Rows[0]["UserID"].ToString();
            root.AppendChild(eUserID);

            XmlElement userTypeID = userInfo.CreateElement("UserTypeID");
            userTypeID.InnerText = user.Rows[0]["UserType_ID"].ToString();
            root.AppendChild(userTypeID);

            /*----------------------------------------------------------------------------
            *          获取CommunityPerview表中的数据
            *----------------------------------------------------------------------------*/
            //string s3 = "select * from CommunityPurview where UserID=@userID";  // 查找与用户关联的小区信息
            prams[1].Value = user.Rows[0]["UserID"].ToString();  // 设置用户ID为查找到的用户ID
            //DataTable communityPerview = DbHelperSQL.QueryBySqlText(s3, prams);

            SqlParameter[] getCommunityWithSolarPrams = new SqlParameter[] {
                new SqlParameter("@userID", SqlDbType.BigInt, 8)
            };
            getCommunityWithSolarPrams[0].Value = user.Rows[0]["UserID"].ToString();
            DataTable communityPerview = DbHelperSQL.QueryBySqlProc("Get_CommunityWithSolar", getCommunityWithSolarPrams);


            /*----------------------------------------------------------------------------
            *          遍历用户所管辖小区的数据，将查找到的数据储存起来  
            *----------------------------------------------------------------------------*/
            foreach (DataRow dr in communityPerview.Rows)
            {
                int rightID = int.Parse(dr["UserRight_ID"].ToString());
                int communityID = int.Parse(dr["CommunityID"].ToString());
                int userID = int.Parse(dr["UserID"].ToString());
                SqlParameter[] innerPrams = new SqlParameter[] {
                    new SqlParameter("@userID", SqlDbType.Int, 4),
                    new SqlParameter("@rightID", SqlDbType.Int, 4),
                    new SqlParameter("@communityID", SqlDbType.Int, 4),
                    new SqlParameter("@belongAreaID", SqlDbType.Int, 4),
                    new SqlParameter("@typeID", SqlDbType.Int, 4)
                };
                innerPrams[0].Value = userID;
                innerPrams[1].Value = rightID;
                innerPrams[2].Value = communityID;
                innerPrams[3].Value = 1;
                innerPrams[4].Value = 1;


                /*----------------------------------------------------------------------------
                 *           获取一条小区数据，储存在communityInfo这个节点中
                 *----------------------------------------------------------------------------*/
                XmlElement communityInfo = userInfo.CreateElement("CommunityInfo");

                communityInfo.SetAttribute("CommunityRight", DbHelperSQL.GetSingle("select UserRight from UserRight where UserRight_ID=@rightID", innerPrams).ToString());

                DataTable community = DbHelperSQL.QueryBySqlText("select * from Community where CommunityID=@communityID", innerPrams);
                communityInfo.SetAttribute("belongAreaID", community.Rows[0]["BelongAreaID"].ToString());
                communityInfo.SetAttribute("id", community.Rows[0]["CommunityID"].ToString());
                communityInfo.SetAttribute("userRightID", rightID.ToString());
                communityInfo.SetAttribute("name", community.Rows[0]["CommunityName"].ToString());
                communityInfo.SetAttribute("communityAddress", community.Rows[0]["CommunityAddress"].ToString());
                communityInfo.SetAttribute("communityPassword", community.Rows[0]["CommunityPassword"].ToString());
                communityInfo.SetAttribute("communityPhone", community.Rows[0]["CommunityPhone"].ToString());
                communityInfo.SetAttribute("manager", community.Rows[0]["Manager"].ToString());
                communityInfo.SetAttribute("managerPhone", community.Rows[0]["ManagerPhone"].ToString());
                communityInfo.SetAttribute("manageUnit", community.Rows[0]["ManageUnit"].ToString());
                communityInfo.SetAttribute("pictureRoute", community.Rows[0]["PictureRoute"].ToString());

                SqlParameter[] myprams = new SqlParameter[] {
                    new SqlParameter("@communityID", SqlDbType.Int, 4)
                };
                myprams[0].Value = communityID;
                DataTable systemInfo = DbHelperSQL.QueryBySqlProc("Get_SolarSystem", myprams);
                foreach (DataRow mdr in systemInfo.Rows)
                {
                    XmlElement xe = userInfo.CreateElement("SystemInfo");
                    xe.SetAttribute("name", mdr["System_Name"].ToString());
                    xe.SetAttribute("System_ID", mdr["System_ID"].ToString());
                    xe.SetAttribute("ARM_ID", mdr["ARM_ID"].ToString());
                    xe.SetAttribute("System_Name", mdr["System_Name"].ToString());
                    xe.SetAttribute("BelCommunityID", mdr["BelCommunityID"].ToString());
                    xe.SetAttribute("ARM_Password", mdr["ARM_Password"].ToString());
                    xe.SetAttribute("BelongCityName", mdr["AreaName"].ToString());
                    communityInfo.AppendChild(xe);
                }


                /*----------------------------------------------------------------------------
                *          访问数据库，把小区所在区域依次入栈
                *----------------------------------------------------------------------------*/
                //Stack<string> areaStack = new Stack<string>();
                Stack<NameAndType> areaStack = new Stack<NameAndType>();
                NameAndType nameAndType = new NameAndType();

                innerPrams[3].Value = int.Parse(community.Rows[0]["BelongAreaID"].ToString());
                DataTable s = DbHelperSQL.QueryBySqlText("select * from Area where AreaID=@belongAreaID", innerPrams);

                //根据地域ID查找地域类型
                innerPrams[4].Value = int.Parse(s.Rows[0]["A_TypeID"].ToString());
                nameAndType.id = s.Rows[0]["AreaID"].ToString();
                nameAndType.name = s.Rows[0]["AreaName"].ToString();
                //nameAndType.typeID = s.Rows[0]["A_TypeID"].ToString();
                nameAndType.typeID = DbHelperSQL.GetSingle("select TypeLevel from AreaType where A_TypeID=@typeID", innerPrams).ToString();
                nameAndType.type = DbHelperSQL.GetSingle("select TypeName from AreaType where A_TypeID=@typeID", innerPrams).ToString();

                //areaStack.Push(s.Rows[0]["AreaName"].ToString());
                areaStack.Push(nameAndType);
                while (s.Rows[0]["BelongRel"].ToString() != "-1")
                {
                    innerPrams[3].Value = int.Parse(s.Rows[0]["BelongRel"].ToString());
                    s = DbHelperSQL.QueryBySqlText("select * from Area where AreaID=@belongAreaID", innerPrams);

                    nameAndType = new NameAndType();
                    innerPrams[4].Value = int.Parse(s.Rows[0]["A_TypeID"].ToString());

                    nameAndType.id = s.Rows[0]["AreaID"].ToString();
                    nameAndType.name = s.Rows[0]["AreaName"].ToString();
                    //nameAndType.typeID = s.Rows[0]["A_TypeID"].ToString();
                    nameAndType.typeID = DbHelperSQL.GetSingle("select TypeLevel from AreaType where A_TypeID = @typeID", innerPrams).ToString();
                    nameAndType.type = DbHelperSQL.GetSingle("select TypeName from AreaType where A_TypeID=@typeID", innerPrams).ToString();

                    areaStack.Push(nameAndType);
                    //areaStack.Push(s.Rows[0]["AreaName"].ToString());
                }

                /*----------------------------------------------------------------------------
                 *         构造XML，使得小区区域信息具有层次结构，比如
                 *         <Area name="中国" type="国家">
                 *            <Area name="福建" type="省份">
                 *                <Area name="福州" type="市区">
                 *                   <CommunityInfo name="福建师范大学"/>
                 *                </Area>
                 *            </Area>
                 *         </Area>
                 *----------------------------------------------------------------------------*/

                XmlNode areaNode = root.SelectSingleNode("Area");
                bool find = false;
                while (areaStack.Count != 0)
                {
                    //string iarea = areaStack.Pop();
                    NameAndType iarea = areaStack.Pop();
                    if (areaNode.HasChildNodes)
                    {
                        foreach (XmlNode xn in areaNode.ChildNodes)
                        {
                            XmlElement xe = (XmlElement)xn;
                            if (xe.GetAttribute("name") == iarea.name)
                            {
                                areaNode = (XmlNode)xe;
                                find = true;
                                break;
                            }
                        }
                        if (find)
                        {
                            find = false;
                            continue;
                        }
                    }

                    XmlElement e = userInfo.CreateElement("Area");
                    e.SetAttribute("id", iarea.id);
                    e.SetAttribute("name", iarea.name);
                    e.SetAttribute("type", iarea.type);
                    e.SetAttribute("typeID", iarea.typeID);
                    areaNode.AppendChild(e);
                    areaNode = (XmlNode)e;
                }
                areaNode.AppendChild(communityInfo);
            }
            return userInfo.InnerXml;
        }
        public string GetAllUserInfo(string userName, string password, List<int> communityID)
        {
            if (Exist(userName, password) == 0)
            {
                return null;
            }
            int userTypeID = int.Parse(DbHelperSQL.GetSingle("select UserType_ID from UserInfo where UserName=@userName and UserPassword=@password", new SqlParameter[] {
                new SqlParameter("@userName", userName),
                new SqlParameter("@password", DESEncrypt.Encrypt(password))
            }).ToString());

            int currentUserID = int.Parse(DbHelperSQL.GetSingle("select UserID from UserInfo where UserName=@userName and UserPassword=@password", new SqlParameter[] {
                new SqlParameter("@userName", userName),
                new SqlParameter("@password", DESEncrypt.Encrypt(password))
            }).ToString());


            string content = "";

            SqlParameter[] prams = new SqlParameter[] {
                new SqlParameter("@userID", SqlDbType.Int, 4),
                new SqlParameter("@userTypeID", SqlDbType.Int, 4),
                new SqlParameter("@communityID", SqlDbType.Int, 4)
            };

            prams[0].Value = currentUserID;
            prams[1].Value = userTypeID;
            
            foreach (int id in communityID)
            {
                prams[2].Value = id;

                content += DbHelperSQL.QueryGetXMLStringByProc("Get_UserInfo_ByCommunityID", prams);
            }
            XmlDocument xml = new XmlDocument();
            xml.LoadXml("<?xml version=\"1.0\" encoding=\"GB2312\"?><root>" + content + "</root>");
            return xml.InnerXml;
            
        }
        public string SaveUserDetail(string userName, string userPassword, UserDetailData userDetail, List<IdAndRight> communityArray) { 
            int nowUserTypeID = Exist(userName, userPassword);
            if(nowUserTypeID == 0 || nowUserTypeID == 4) {
                return null;
            }

            SqlParameter userExist = new SqlParameter("@userExist", SqlDbType.Int, 4);
            userExist.Direction = ParameterDirection.Output;

            SqlParameter[] prams = new SqlParameter[] {
                new SqlParameter("@userName", SqlDbType.NVarChar, 10 ),
                new SqlParameter("@userPassword", SqlDbType.NVarChar, 50),
                new SqlParameter("@userPhone", SqlDbType.NVarChar, 20),
                new SqlParameter("@userTypeID", SqlDbType.Int, 4),
                new SqlParameter("@userID", SqlDbType.Int, 4),
                userExist,
                new SqlParameter("@userPictureRoute", SqlDbType.NVarChar, 100)
            };
            prams[0].Value = userDetail.userName;
            // 将密码加密以后存数据库
            prams[1].Value = DESEncrypt.Encrypt(userDetail.userPassword);
            prams[2].Value = userDetail.userPhone;
            prams[3].Value = int.Parse(userDetail.userTypeID);
            prams[4].Value = int.Parse(userDetail.userID);
            prams[6].Value = userDetail.userPictureRoute;
            DbHelperSQL.ExcuteNonQueryBySqlProc("Update_UserInfo", prams);

            SqlParameter[] prams2 = new SqlParameter[] {
                new SqlParameter("@userID", SqlDbType.Int, 4 ),
                new SqlParameter("@communityID", SqlDbType.Int, 4),
                new SqlParameter("@userRight_ID", SqlDbType.Int, 4)
            };
            if (int.Parse(userExist.Value.ToString()) == 0) {
                SqlParameter[] temp = new SqlParameter[] {
                        new SqlParameter("@userID", SqlDbType.BigInt, 8)
                    };
                temp[0].Value = userDetail.userID;
                DbHelperSQL.ExcuteNonQueryBySqlProc("Delete_CommunityPurview", temp);
            }
            foreach (IdAndRight child in communityArray) {
                if (int.Parse(userExist.Value.ToString()) == 0)
                {
                    //prams2[0].Value = int.Parse(userExist.Value.ToString());
                    prams2[0].Value = int.Parse(userDetail.userID.ToString());
       
                    LogManager.SendLog(userName + "修改了用户" + userDetail.userName);
                }
                else {
                    prams2[0].Value = int.Parse(userExist.Value.ToString());
                    LogManager.SendLog(userName + "添加了用户" + userDetail.userName);
                }
                prams2[1].Value = int.Parse(child.communityID);
                prams2[2].Value = int.Parse(child.rightID);
                DbHelperSQL.ExcuteNonQueryBySqlProc("Insert_CommunityPurview", prams2);
            }
            return userDetail.userID;
        }
        public void DeleteUser(string userName, string password, string userID) {
            int nowUserTypeID = Exist(userName, password);
            if (nowUserTypeID == 0 || nowUserTypeID == 4)
            {
                return;
            }
            LogManager.SendLog(userName + "删除了用户ID为" + userID + "的用户");
 
            SqlParameter[] prams = new SqlParameter[] {
                new SqlParameter("@userID", SqlDbType.Int, 4)
            };
            prams[0].Value = int.Parse(userID);
            DbHelperSQL.ExcuteNonQueryBySqlProc("Delete_UserInfo", prams);
        }
    }
    public class NameAndType
    {
        public string name;
        public string type;
        public string typeID;
        public string id;
    }
}