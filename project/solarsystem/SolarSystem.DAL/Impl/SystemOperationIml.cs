using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using SolarSystem.DAL.Interface;
using System.Data.SqlClient;
using System.Data;
using System.Xml;
using SolarSystem.Utils;
using System.Net;
using System.IO;

namespace SolarSystem.DAL.Impl
{
    public class SystemOperationIml:ISystemOperation
    {
        public string GetSystemInstall(string userName, string password, string systemID) {
            IUserInfo userInfo = DALFactory.CreateUserInfo();
            if (userInfo.Exist(userName, password) == 0)
            {
                return null;
            }
            SqlParameter[] pram = new SqlParameter[] {
                new SqlParameter("@systemID", SqlDbType.BigInt, 8)
            };
            pram[0].Value = int.Parse(systemID);

            string content = "<?xml version=\"1.0\" encoding=\"GB2312\"?><root>";
            content += DbHelperSQL.QueryGetXMLStringByProc("Get_SystemInstall", pram);
            content += "</root>";
            return content;
        }
        public string CheckCurrentSetup(string userName, string password, string systemID, string time) {
            IUserInfo userInfo = DALFactory.CreateUserInfo();
            if (userInfo.Exist(userName, password) == 0)
            {
                return null;
            }
            SqlParameter output = new SqlParameter("@result", SqlDbType.Int, 4);
            output.Direction = ParameterDirection.Output;
            SqlParameter[] prams = new SqlParameter[] {
                new SqlParameter("@systemID", SqlDbType.BigInt, 8), 
                new SqlParameter("@time", SqlDbType.DateTime),
                output
            };
            prams[0].Value = int.Parse(systemID);
            prams[1].Value = time;

            DbHelperSQL.ExcuteNonQueryBySqlProc("Check_CurrentSetup", prams);
            return output.Value.ToString();
        }
        public string CheckSeasonSetup(string userName, string password, string systemID, string time) {
            IUserInfo userInfo = DALFactory.CreateUserInfo();
            if (userInfo.Exist(userName, password) == 0)
            {
                return null;
            }
            SqlParameter output = new SqlParameter("@result", SqlDbType.Int, 4);
            output.Direction = ParameterDirection.Output;
            SqlParameter[] prams = new SqlParameter[] {
                new SqlParameter("@systemID", SqlDbType.BigInt, 8), 
                new SqlParameter("@time", SqlDbType.DateTime),
                output
            };
            prams[0].Value = int.Parse(systemID);
            prams[1].Value = time;

            DbHelperSQL.ExcuteNonQueryBySqlProc("Check_SeasonSetup", prams);
            return output.Value.ToString();
        }
        public string GetCurrentSetup(string userName, string password, string systemID) { 
            IUserInfo userInfo = DALFactory.CreateUserInfo();
            if (userInfo.Exist(userName, password) == 0)
            {
                return null;
            }
            SqlParameter[] pram = new SqlParameter[] {
                new SqlParameter("@systemID", SqlDbType.BigInt, 8)
            };
            pram[0].Value = int.Parse(systemID);

            string content = "<?xml version=\"1.0\" encoding=\"GB2312\"?><root>";
            content += "<SystemSetup>" + DbHelperSQL.QueryGetXMLStringByProc("Get_SystemSetup", pram) + "</SystemSetup>";
            content += "</root>";
            return content;
        }
        public string GetCurrentSystemData(string userName, string password, int systemID) {
            IUserInfo userInfo = DALFactory.CreateUserInfo();
            if (userInfo.Exist(userName, password) == 0)
            {
                return null;
            }
            SqlParameter[] prams = new SqlParameter[] {
                new SqlParameter("@systemID", SqlDbType.Int)
            };
            prams[0].Value = systemID;
           

            string content = "<?xml version=\"1.0\" encoding=\"GB2312\"?><root>";
            content += "<SystemData>" + DbHelperSQL.QueryGetXMLStringByProc("Get_CurrentSystemData", prams) + "</SystemData>";
            //content += "<SystemSetup>" + DbHelperSQL.QueryGetXMLStringByProc("Get_SystemSetup", prams) + "</SystemSetup>";
            //content += "<AlarmData>" + DbHelperSQL.QueryGetXMLStringByProc("Get_AlarmData", prams) + "</AlarmData>";
            content += "</root>";


            XmlDocument doc = new XmlDocument();
            doc.LoadXml(content);
            return doc.InnerXml;
        }

        public string SendOrder(string userName, string password, string systemID, string orderText, string time)
        {
            IUserInfo userInfo = DALFactory.CreateUserInfo();
            int nowUserTypeID = userInfo.Exist(userName, password);
            if (nowUserTypeID == 0)
            {
                return null;
            }
            LogManager.SendLog(userName + "向系统ID为" + systemID + "的系统发送了" + orderText + "的指令");

            SqlParameter output = new SqlParameter("@orderID", SqlDbType.BigInt, 8);
            output.Direction = ParameterDirection.Output;
            SqlParameter[] prams = new SqlParameter[] {
                new SqlParameter("@systemID", SqlDbType.Int, 4),
                new SqlParameter("@orderText", SqlDbType.NVarChar, 255),
                new SqlParameter("@time", SqlDbType.DateTime),
                new SqlParameter("@userName", SqlDbType.VarChar, 10),
                output
            };
            prams[0].Value = systemID;
            prams[1].Value = orderText;
            prams[2].Value = time;
            prams[3].Value = userName;

            DbHelperSQL.ExcuteNonQueryBySqlProc("Send_Order", prams);
            return output.Value.ToString();
        }

        public string GetHistoryData(string userName, string password, string systemID, string startTime, string endTime, string startIndex, string size) {
            IUserInfo userInfo = DALFactory.CreateUserInfo();
            if (userInfo.Exist(userName, password) == 0)
            {
                return null;
            }
            string content = "<?xml version=\"1.0\" encoding=\"GB2312\"?><root><Data>";
        
            DateTime startDateTime = DateTime.Parse(startTime);
            DateTime endDateTime = DateTime.Parse(endTime);

            SqlParameter output = new SqlParameter("@totalNum", SqlDbType.BigInt, 8);
            output.Direction = ParameterDirection.Output;

            SqlParameter[] sizePrams = new SqlParameter[] {
                new SqlParameter("@systemID", SqlDbType.Int, 4),
                new SqlParameter("@startTime", SqlDbType.DateTime),
                new SqlParameter("@endTime", SqlDbType.DateTime),
                output
            };
            sizePrams[0].Value = int.Parse(systemID);
            sizePrams[1].Value = startTime;
            sizePrams[2].Value = endTime;
            DbHelperSQL.ExcuteNonQueryBySqlProc("Get_HistoryDataSize", sizePrams);

            SqlParameter[] dataPrams = new SqlParameter[] {
                new SqlParameter("@startTime", SqlDbType.DateTime),
                new SqlParameter("@endTime", SqlDbType.DateTime),
                new SqlParameter("@startIndex", SqlDbType.BigInt, 8),
                new SqlParameter("@size", SqlDbType.Int, 4),
                new SqlParameter("@systemID", SqlDbType.Int, 4)
            };
            dataPrams[0].Value = startTime;
            dataPrams[1].Value = endTime;
            dataPrams[2].Value = int.Parse(startIndex);
            dataPrams[3].Value = int.Parse(size);
            dataPrams[4].Value = int.Parse(systemID);
            content += DbHelperSQL.QueryGetXMLStringByProc("Get_HistoryData", dataPrams);

            content += "</Data><TotalSize>" + output.Value.ToString() +"</TotalSize></root>";

            return content;
        }
        private string MakeTableName(string sourceTableName, int year, int month) {
            string tableName = sourceTableName + "_" + year.ToString();
            if (month < 10) {
                tableName += "0";
            }
            tableName += month.ToString();
            return tableName;
        }
        public string GetHistorySetup(string userName, string password, string systemID, string startTime, string endTime) {
            IUserInfo userInfo = DALFactory.CreateUserInfo();
            if (userInfo.Exist(userName, password) == 0)
            {
                return null;
            }
            string content = "<?xml version=\"1.0\" encoding=\"GB2312\"?><root>";

            DateTime startDateTime = DateTime.Parse(startTime);
            DateTime endDateTime = DateTime.Parse(endTime);

            int startYear = startDateTime.Year,
                endYear = endDateTime.Year,
                startMonth = startDateTime.Month,
                endMonth = endDateTime.Month;
            for (int year = startYear; year <= endYear; year++)
            {
                if (year != endYear && year == startYear)
                {
                    for (int month = startMonth; month <= 12; month++)
                    {
                        string tableName = MakeTableName("HistoryCFG", year, month);
                        SqlParameter isExist = new SqlParameter("@isExist", SqlDbType.Int, 4);
                        isExist.Direction = ParameterDirection.Output;
                        SqlParameter[] tableTest = new SqlParameter[] {
                            new SqlParameter("@tableName", SqlDbType.NVarChar, 50),
                            isExist
                        };
                        tableTest[0].Value = tableName;
                        DbHelperSQL.ExcuteNonQueryBySqlProc("Table_Exist", tableTest);
                        if (isExist.Value.ToString() == "0")
                        {
                            continue;
                        }

                        SqlParameter[] prams = new SqlParameter[] {
                            new SqlParameter("@systemID",SqlDbType.Int, 4),
                            new SqlParameter("@tableName", SqlDbType.NVarChar, 50),
                            new SqlParameter("@startTime", SqlDbType.DateTime),
                            new SqlParameter("@endTime", SqlDbType.DateTime)
                        };
                        prams[0].Value = systemID;
                        prams[1].Value = tableName;
                        prams[2].Value = startTime;
                        prams[3].Value = endTime;
                        content += DbHelperSQL.QueryGetXMLStringByProc("Get_HistorySetup", prams);
                    }
                }
                else if (year != endYear && year != startYear)
                {
                    for (int month = 1; month <= 12; month++)
                    {
                        string tableName = MakeTableName("HistoryCFG", year, month);
                        SqlParameter isExist = new SqlParameter("@isExist", SqlDbType.Int, 4);
                        isExist.Direction = ParameterDirection.Output;
                        SqlParameter[] tableTest = new SqlParameter[] {
                            new SqlParameter("@tableName", SqlDbType.NVarChar, 50),
                            isExist
                        };
                        tableTest[0].Value = tableName;
                        DbHelperSQL.ExcuteNonQueryBySqlProc("Table_Exist", tableTest);
                        if (isExist.Value.ToString() == "0")
                        {
                            continue;
                        }
                        SqlParameter[] prams = new SqlParameter[] {
                            new SqlParameter("@systemID",SqlDbType.Int, 4),
                            new SqlParameter("@tableName", SqlDbType.NVarChar, 50),
                            new SqlParameter("@startTime", SqlDbType.DateTime),
                            new SqlParameter("@endTime", SqlDbType.DateTime)
                        };
                        prams[0].Value = systemID;
                        prams[1].Value = tableName;
                        prams[2].Value = startTime;
                        prams[3].Value = endTime;
                        content += DbHelperSQL.QueryGetXMLStringByProc("Get_HistorySetup", prams);
                    }
                }
                else
                {
                    for (int month = startMonth; month <= endMonth; month++)
                    {
                        string tableName = MakeTableName("HistoryCFG", year, month);
                        SqlParameter isExist = new SqlParameter("@isExist", SqlDbType.Int, 4);
                        isExist.Direction = ParameterDirection.Output;
                        SqlParameter[] tableTest = new SqlParameter[] {
                            new SqlParameter("@tableName", SqlDbType.NVarChar, 50),
                            isExist
                        };
                        tableTest[0].Value = tableName;
                        DbHelperSQL.ExcuteNonQueryBySqlProc("Table_Exist", tableTest);
                        if (isExist.Value.ToString() == "0")
                        {
                            continue;
                        }
                        SqlParameter[] prams = new SqlParameter[] {
                            new SqlParameter("@systemID",SqlDbType.Int, 4),
                            new SqlParameter("@tableName", SqlDbType.NVarChar, 50),
                            new SqlParameter("@startTime", SqlDbType.DateTime),
                            new SqlParameter("@endTime", SqlDbType.DateTime)
                        };
                        prams[0].Value = systemID;
                        prams[1].Value = tableName;
                        prams[2].Value = startTime;
                        prams[3].Value = endTime;
                        content += DbHelperSQL.QueryGetXMLStringByProc("Get_HistorySetup", prams);
                    }
                }
            }

            content += "</root>";

            return content;
        }
        public string GetWarning(string userName, string password) {
            IUserInfo userInfo = DALFactory.CreateUserInfo();
            if (userInfo.Exist(userName, password) == 0)
            {
                return null;
            }
            SqlParameter[] prams = new SqlParameter[] {
                new SqlParameter("@userName", SqlDbType.NVarChar, 10),
                new SqlParameter("@password", SqlDbType.NVarChar, 50)
            };
            prams[0].Value = userName;
            prams[1].Value = DESEncrypt.Encrypt(password);

            SqlParameter alarmEventOutput = new SqlParameter("@alarmEvent", SqlDbType.NVarChar, 100);
            alarmEventOutput.Direction = ParameterDirection.Output;

            SqlParameter[] alarmPrams = new SqlParameter[] {
                new SqlParameter("@alarmID", SqlDbType.Int, 4),
                alarmEventOutput
            };

            XmlDocument alarmData = new XmlDocument();
            XmlDeclaration dec = alarmData.CreateXmlDeclaration("1.0", "GB2312", null);
            alarmData.AppendChild(dec);
            //创建根节点
            XmlElement root = alarmData.CreateElement("root");
            alarmData.AppendChild(root);


            DataTable dt = DbHelperSQL.QueryBySqlProc("Get_AlarmData", prams);
            foreach (DataRow dr in dt.Rows) {
                XmlElement node = alarmData.CreateElement("row");
                string alarmEvent = dr["AlarmEvent_ID"].ToString();
                string singleAlarm = "";
                string totalAlarm = "";
                for (int i = 0; i < alarmEvent.Length; i++) {
                    if (alarmEvent[i] != ',') {
                        singleAlarm += alarmEvent[i];
                    }
                    if (alarmEvent[i] == ',' || i == alarmEvent.Length - 1) { 
                        alarmPrams[0].Value = int.Parse(singleAlarm);
                        DbHelperSQL.ExcuteNonQueryBySqlProc("Get_AlarmEvent", alarmPrams);
                        if (i == alarmEvent.Length - 1)
                        {
                            totalAlarm += alarmEventOutput.Value.ToString();
                        }
                        else {
                            totalAlarm += alarmEventOutput.Value.ToString() + ",";
                        }
                       
                        //node.SetAttribute("AlarmEvent", alarmEventOutput.Value.ToString());
                        singleAlarm = "";
                    }
                }
                node.SetAttribute("AlarmEvent", totalAlarm);
                node.SetAttribute("Alarm_Time", dr["Alarm_Time"].ToString());
                node.SetAttribute("ALM_ID", dr["ALM_ID"].ToString());
                node.SetAttribute("System_ID", dr["System_ID"].ToString());
                node.SetAttribute("BelCommunityID", dr["BelCommunityID"].ToString());
                node.SetAttribute("System_Name", dr["System_Name"].ToString());
                root.AppendChild(node);
            }
            //string content = "<?xml version=\"1.0\" encoding=\"GB2312\"?><root>";
            //content += DbHelperSQL.QueryGetXMLStringByProc("Get_AlarmData", prams);
            //content += "</root>";

            return alarmData.InnerXml;
        }

        public void DeleteAlarm(string userName, string password, string alarmID) {
            SqlParameter[] prams = new SqlParameter[] {
                new SqlParameter("@alarmID", SqlDbType.Int, 4)
            };
            
            prams[0].Value = int.Parse(alarmID);
            DbHelperSQL.ExcuteNonQueryBySqlProc("Delete_Alarm", prams);
        }

        public string GetSeasonDefaultSetup(string userName, string password, string systemID) {
            IUserInfo userInfo = DALFactory.CreateUserInfo();
            if (userInfo.Exist(userName, password) == 0)
            {
                return null;
            }
            SqlParameter[] prams = new SqlParameter[] {
                new SqlParameter("@systemID", SqlDbType.Int, 4)
            };
            prams[0].Value = int.Parse(systemID);

            string content = "<?xml version=\"1.0\" encoding=\"GB2312\"?><root>";
            content += DbHelperSQL.QueryGetXMLStringByProc("Get_SeasonDefaultSetup", prams);
            content += "</root>";

            return content;
        }
        public void SaveSeasonDefaultSetup(string userName, string password, string setupID, string saStartTime, string saCollector, string wsStartTime, string wsCollector) {
            IUserInfo userInfo = DALFactory.CreateUserInfo();
            int nowUserType = userInfo.Exist(userName, password);
            if (nowUserType == 0 || nowUserType == 4)
            {
                return;
            }
            LogManager.SendLog(userName + "修改了ID为" + setupID + "的四级默认参数");
            
            SqlParameter[] prams = new SqlParameter[] {
                new SqlParameter("@setupID", SqlDbType.Int, 4),
                new SqlParameter("@saStartTime", SqlDbType.VarChar, 10),
                new SqlParameter("@saCollector", SqlDbType.Int, 4),
                new SqlParameter("@wsStartTime", SqlDbType.VarChar, 10),
                new SqlParameter("@wsCollector", SqlDbType.Int, 4)
            };
            prams[0].Value = int.Parse(setupID);
            prams[1].Value = saStartTime;
            prams[2].Value = int.Parse(saCollector);
            prams[3].Value = wsStartTime;
            prams[4].Value = int.Parse(wsCollector);

            DbHelperSQL.ExcuteNonQueryBySqlProc("Save_SeasonDefaultSetup", prams);
        }
        public string GetHistoryAlarm(string userName, string password, string systemID, string startTime, string endTime) {
            IUserInfo userInfo = DALFactory.CreateUserInfo();
            if (userInfo.Exist(userName, password) == 0)
            {
                return null;
            }
            XmlDocument alarmData = new XmlDocument();
            XmlDeclaration dec = alarmData.CreateXmlDeclaration("1.0", "GB2312", null);
            alarmData.AppendChild(dec);
            //创建根节点
            XmlElement root = alarmData.CreateElement("root");
            alarmData.AppendChild(root);

            DateTime startDateTime = DateTime.Parse(startTime);
            DateTime endDateTime = DateTime.Parse(endTime);

            int startYear = startDateTime.Year,
                endYear = endDateTime.Year,
                startMonth = startDateTime.Month,
                endMonth = endDateTime.Month;
            for (int year = startYear; year <= endYear; year++)
            {
                if (year != endYear && year == startYear)
                {
                    for (int month = startMonth; month <= 12; month++)
                    {
                        string tableName = MakeTableName("HistoryAlarmData", year, month);
                        SqlParameter isExist = new SqlParameter("@isExist", SqlDbType.Int, 4);
                        isExist.Direction = ParameterDirection.Output;
                        SqlParameter[] tableTest = new SqlParameter[] {
                            new SqlParameter("@tableName", SqlDbType.NVarChar, 50),
                            isExist
                        };
                        tableTest[0].Value = tableName;
                        DbHelperSQL.ExcuteNonQueryBySqlProc("Table_Exist", tableTest);
                        if (isExist.Value.ToString() == "0")
                        {
                            continue;
                        }

                        SqlParameter[] prams = new SqlParameter[] {
                            new SqlParameter("@systemID", SqlDbType.BigInt, 8),
                            new SqlParameter("@startTime", SqlDbType.DateTime),
                            new SqlParameter("@endTime", SqlDbType.DateTime),
                            new SqlParameter("@tableName", SqlDbType.NVarChar, 50)
                        };
                        prams[0].Value = systemID;
                        prams[1].Value = startTime;
                        prams[2].Value = endTime;
                        prams[3].Value = tableName;

                        SqlParameter alarmEventOutput = new SqlParameter("@alarmEvent", SqlDbType.NVarChar, 100);
                        alarmEventOutput.Direction = ParameterDirection.Output;

                        SqlParameter[] alarmPrams = new SqlParameter[] {
                            new SqlParameter("@alarmID", SqlDbType.Int, 4),
                            alarmEventOutput
                        };

                        DataTable dt = DbHelperSQL.QueryBySqlProc("Get_HistoryAlarm", prams);
                        foreach (DataRow dr in dt.Rows)
                        {
                            XmlElement node = alarmData.CreateElement("row");
                            string alarmEvent = dr["AlarmEvent_ID"].ToString();
                            string singleAlarm = "";
                            string totalAlarm = "";
                            for (int i = 0; i < alarmEvent.Length; i++)
                            {
                                if (alarmEvent[i] != ',')
                                {
                                    singleAlarm += alarmEvent[i];
                                }
                                if (alarmEvent[i] == ',' || i == alarmEvent.Length - 1)
                                {
                                    alarmPrams[0].Value = int.Parse(singleAlarm);
                                    DbHelperSQL.ExcuteNonQueryBySqlProc("Get_AlarmEvent", alarmPrams);
                                    if (i == alarmEvent.Length - 1)
                                    {
                                        totalAlarm += alarmEventOutput.Value.ToString();
                                    }
                                    else
                                    {
                                        totalAlarm += alarmEventOutput.Value.ToString() + ",";
                                    }

                                    //node.SetAttribute("AlarmEvent", alarmEventOutput.Value.ToString());
                                    singleAlarm = "";
                                }
                            }
                            node.SetAttribute("AlarmEvent", totalAlarm);
                            node.SetAttribute("Alarm_Time", dr["Alarm_Time"].ToString());
                            node.SetAttribute("System_ID", dr["System_ID"].ToString());

                            root.AppendChild(node);
                        }
                    }
                }
                else if (year != endYear && year != startYear)
                {
                    for (int month = 1; month <= 12; month++)
                    {
                        string tableName = MakeTableName("HistoryAlarmData", year, month);
                        SqlParameter isExist = new SqlParameter("@isExist", SqlDbType.Int, 4);
                        isExist.Direction = ParameterDirection.Output;
                        SqlParameter[] tableTest = new SqlParameter[] {
                            new SqlParameter("@tableName", SqlDbType.NVarChar, 50),
                            isExist
                        };
                        tableTest[0].Value = tableName;
                        DbHelperSQL.ExcuteNonQueryBySqlProc("Table_Exist", tableTest);
                        if (isExist.Value.ToString() == "0")
                        {
                            continue;
                        }
                        SqlParameter[] prams = new SqlParameter[] {
                            new SqlParameter("@systemID", SqlDbType.BigInt, 8),
                            new SqlParameter("@startTime", SqlDbType.DateTime),
                            new SqlParameter("@endTime", SqlDbType.DateTime),
                            new SqlParameter("@tableName", SqlDbType.NVarChar, 50)
                        };
                        prams[0].Value = systemID;
                        prams[1].Value = startTime;
                        prams[2].Value = endTime;
                        prams[3].Value = tableName;

                        SqlParameter alarmEventOutput = new SqlParameter("@alarmEvent", SqlDbType.NVarChar, 100);
                        alarmEventOutput.Direction = ParameterDirection.Output;

                        SqlParameter[] alarmPrams = new SqlParameter[] {
                            new SqlParameter("@alarmID", SqlDbType.Int, 4),
                            alarmEventOutput
                        };

                        DataTable dt = DbHelperSQL.QueryBySqlProc("Get_HistoryAlarm", prams);
                        foreach (DataRow dr in dt.Rows)
                        {
                            XmlElement node = alarmData.CreateElement("row");
                            string alarmEvent = dr["AlarmEvent_ID"].ToString();
                            string singleAlarm = "";
                            string totalAlarm = "";
                            for (int i = 0; i < alarmEvent.Length; i++)
                            {
                                if (alarmEvent[i] != ',')
                                {
                                    singleAlarm += alarmEvent[i];
                                }
                                if (alarmEvent[i] == ',' || i == alarmEvent.Length - 1)
                                {
                                    alarmPrams[0].Value = int.Parse(singleAlarm);
                                    DbHelperSQL.ExcuteNonQueryBySqlProc("Get_AlarmEvent", alarmPrams);
                                    if (i == alarmEvent.Length - 1)
                                    {
                                        totalAlarm += alarmEventOutput.Value.ToString();
                                    }
                                    else
                                    {
                                        totalAlarm += alarmEventOutput.Value.ToString() + ",";
                                    }

                                    //node.SetAttribute("AlarmEvent", alarmEventOutput.Value.ToString());
                                    singleAlarm = "";
                                }
                            }
                            node.SetAttribute("AlarmEvent", totalAlarm);
                            node.SetAttribute("Alarm_Time", dr["Alarm_Time"].ToString());
                            node.SetAttribute("System_ID", dr["System_ID"].ToString());

                            root.AppendChild(node);
                        }
                    }
                }
                else
                {
                    for (int month = startMonth; month <= endMonth; month++)
                    {
                        string tableName = MakeTableName("HistoryAlarmData", year, month);
                        SqlParameter isExist = new SqlParameter("@isExist", SqlDbType.Int, 4);
                        isExist.Direction = ParameterDirection.Output;
                        SqlParameter[] tableTest = new SqlParameter[] {
                            new SqlParameter("@tableName", SqlDbType.NVarChar, 50),
                            isExist
                        };
                        tableTest[0].Value = tableName;
                        DbHelperSQL.ExcuteNonQueryBySqlProc("Table_Exist", tableTest);
                        if (isExist.Value.ToString() == "0")
                        {
                            continue;
                        }
                        SqlParameter[] prams = new SqlParameter[] {
                            new SqlParameter("@systemID", SqlDbType.BigInt, 8),
                            new SqlParameter("@startTime", SqlDbType.DateTime),
                            new SqlParameter("@endTime", SqlDbType.DateTime),
                            new SqlParameter("@tableName", SqlDbType.NVarChar, 50)
                        };
                        prams[0].Value = systemID;
                        prams[1].Value = startTime;
                        prams[2].Value = endTime;
                        prams[3].Value = tableName;

                        SqlParameter alarmEventOutput = new SqlParameter("@alarmEvent", SqlDbType.NVarChar, 100);
                        alarmEventOutput.Direction = ParameterDirection.Output;

                        SqlParameter[] alarmPrams = new SqlParameter[] {
                            new SqlParameter("@alarmID", SqlDbType.Int, 4),
                            alarmEventOutput
                        };

                        DataTable dt = DbHelperSQL.QueryBySqlProc("Get_HistoryAlarm", prams);
                        foreach (DataRow dr in dt.Rows)
                        {
                            XmlElement node = alarmData.CreateElement("row");
                            string alarmEvent = dr["AlarmEvent_ID"].ToString();
                            string singleAlarm = "";
                            string totalAlarm = "";
                            for (int i = 0; i < alarmEvent.Length; i++)
                            {
                                if (alarmEvent[i] != ',')
                                {
                                    singleAlarm += alarmEvent[i];
                                }
                                if (alarmEvent[i] == ',' || i == alarmEvent.Length - 1)
                                {
                                    alarmPrams[0].Value = int.Parse(singleAlarm);
                                    DbHelperSQL.ExcuteNonQueryBySqlProc("Get_AlarmEvent", alarmPrams);
                                    if (i == alarmEvent.Length - 1)
                                    {
                                        totalAlarm += alarmEventOutput.Value.ToString();
                                    }
                                    else
                                    {
                                        totalAlarm += alarmEventOutput.Value.ToString() + ",";
                                    }

                                    //node.SetAttribute("AlarmEvent", alarmEventOutput.Value.ToString());
                                    singleAlarm = "";
                                }
                            }
                            node.SetAttribute("AlarmEvent", totalAlarm);
                            node.SetAttribute("Alarm_Time", dr["Alarm_Time"].ToString());
                            node.SetAttribute("System_ID", dr["System_ID"].ToString());

                            root.AppendChild(node);
                        }
                    }
                }
            }

            return alarmData.InnerXml;
        }
        public string GetHistoryControl(string userName, string password, string communityID, string time, string orderContent) {
            IUserInfo userInfo = DALFactory.CreateUserInfo();
            int nowUserType = userInfo.Exist(userName, password);
            if (nowUserType == 0)
            {
                return null;
            }
            SqlParameter[] prams = new SqlParameter[] {
                new SqlParameter("@communityID", SqlDbType.BigInt, 8),
                new SqlParameter("@time", SqlDbType.DateTime),
                new SqlParameter("@content", SqlDbType.VarChar, 255)
            };
            prams[0].Value = communityID;
            prams[1].Value = time;
            prams[2].Value = orderContent;
            string content = "<?xml version=\"1.0\" encoding=\"GB2312\"?><root>";
            content += DbHelperSQL.QueryGetXMLStringByProc("Get_HistoryControl", prams);
            content += "</root>";
            return content;
        }
        public string SelfCheck(string userName, string password, string systemID) {
            IUserInfo userInfo = DALFactory.CreateUserInfo();
            int nowUserType = userInfo.Exist(userName, password);
            if (nowUserType == 0)
            {
                return null;
            }
            SqlParameter[] prams = new SqlParameter[] {
                new SqlParameter("@systemID", SqlDbType.BigInt, 8)
            };
            prams[0].Value = systemID;
            string content = "<?xml version=\"1.0\" encoding=\"GB2312\"?><root>";
            content += DbHelperSQL.QueryGetXMLStringByProc("Get_CommunicateStatus", prams);
            content += "</root>";
            return content;
        }
        public string CheckOrder(string userName, string password, string systemID, string time, string checkOrder) {
            IUserInfo userInfo = DALFactory.CreateUserInfo();
            int nowUserType = userInfo.Exist(userName, password);
            if (nowUserType == 0)
            {
                return null;
            }
            SqlParameter output = new SqlParameter("@result", SqlDbType.Int, 4);
            output.Direction = ParameterDirection.Output;
            SqlParameter[] prams = new SqlParameter[] {
                new SqlParameter("@systemID", SqlDbType.BigInt, 8),
                new SqlParameter("@time", SqlDbType.DateTime),
                output
            };
            prams[0].Value = int.Parse(systemID);
            prams[1].Value = time;
            DbHelperSQL.ExcuteNonQueryBySqlProc(checkOrder, prams);
            return output.Value.ToString();
        }
        public string GetHandControl(string userName, string password, string systemID) {
            IUserInfo userInfo = DALFactory.CreateUserInfo();
            int nowUserType = userInfo.Exist(userName, password);
            if (nowUserType == 0)
            {
                return null;
            }
            SqlParameter[] prams = new SqlParameter[] {
                new SqlParameter("@systemID", SqlDbType.BigInt, 8)
            };
            prams[0].Value = systemID;
            string content = "<?xml version=\"1.0\" encoding=\"GB2312\"?><root>";
            content += DbHelperSQL.QueryGetXMLStringByProc("Get_HandControl", prams);
            content += "</root>";
            return content;
        }
        // 当设置系统参数时，检查指令是否发送成功，如果指令发送成功，则返回设置值
        public string CheckSetSetup(string userName, string password, string systemID, string time)
        {
            if (CheckOrder(userName, password, systemID, time, "Check_CurrentSetup") == "1")
            {
                return GetCurrentSetup(userName, password, systemID);
            }
            else {
                return null;
            }
        }
        // 当设置系统安装情况时，检查指令是否发送成功，如果指令发送成功，则返回安装情况
        public string CheckInstall(string userName, string password, string systemID, string time) {
            if (CheckOrder(userName, password, systemID, time, "Check_CurrentSetup") == "1")
            {
                return GetSystemInstall(userName, password, systemID);
            }
            else {
                return null;
            }
        }
        public string CheckSetSeason(string userName, string password, string systemID, string time)
        {
            if (CheckOrder(userName, password, systemID, time, "Check_SeasonSetup") == "1")
            {
                return GetSeasonDefaultSetup(userName, password, systemID);
            }
            else
            {
                return null;
            }
        }
        public string CheckSelfCheck(string userName, string password, string systemID, string time) {
            if (CheckOrder(userName, password, systemID, time, "Check_SelfCheck") == "1")
            {
                return SelfCheck(userName, password, systemID);
            }
            else {
                return null;
            }
        }
        // 检测控制台是否开启
        public string GetConsoleState(string userName, string password, string systemID) {
            SqlParameter output = new SqlParameter("@state", SqlDbType.SmallInt);
            output.Direction = ParameterDirection.Output;

            SqlParameter[] prams = new SqlParameter[] {
                new SqlParameter("@systemID", SqlDbType.BigInt),
                output
            };
            prams[0].Value = int.Parse(systemID);
            DbHelperSQL.ExcuteNonQueryBySqlProc("Get_ConsoleState", prams);
            return output.Value.ToString();
        }
        public void DeleteAllAlarm(string userName, string password, List<string> alarm) {
            IUserInfo userInfo = DALFactory.CreateUserInfo();
            int nowUserType = userInfo.Exist(userName, password);
            if (nowUserType == 0)
            {
                return;
            }
            SqlParameter[] prams = new SqlParameter[] {
                new SqlParameter("@alarmID", SqlDbType.BigInt),
            };
            foreach (string i in alarm) {
                DeleteAlarm(userName, password, i);
            }
        }
        public string GetCommunicateError() {
            
            string content = "<?xml version=\"1.0\" encoding=\"GB2312\"?><root>";
            content += DbHelperSQL.QueryGetXMLStringByProc("Get_CommunicateError", null);
            content += "</root>";
            return content;
            
        }
        public void SetElecFactor(string factor, string extraFactor, string collector, string systemID)
        {
            SqlParameter[] prams = new SqlParameter[] {
                new SqlParameter("@totalFactor", SqlDbType.Float),
                new SqlParameter("@extraFactor", SqlDbType.Float),
                new SqlParameter("@collector", SqlDbType.Int),
                new SqlParameter("@id", SqlDbType.BigInt, 8)
            };
            prams[0].Value = factor;
            prams[1].Value = extraFactor;
            prams[2].Value = collector;
            prams[3].Value = systemID;
            DbHelperSQL.QueryBySqlProc("SetElecFactor", prams);
        }
        public string GetMonthEndItem(string startTime, string endTime, string systemID) {
            SqlParameter[] prams = new SqlParameter[] {
                new SqlParameter("@startTime", SqlDbType.DateTime),
                new SqlParameter("@endTime",SqlDbType.DateTime),
                new SqlParameter("@systemID", SqlDbType.BigInt, 8)
            };
            prams[0].Value = startTime;
            prams[1].Value = endTime;
            prams[2].Value = int.Parse(systemID);

            string content = "<?xml version=\"1.0\" encoding=\"GB2312\"?><root>";
            content += DbHelperSQL.QueryGetXMLStringByProc("Get_MonthEndItem", prams);
            content += "</root>";
            return content;
        }

        public string GetDisplayMode() { 
            string content = "<?xml version=\"1.0\" encoding=\"GB2312\"?><root>";
            content += DbHelperSQL.QueryGetXMLStringByProc("Get_DisplayMode", null);
            content += "</root>";
            return content;
        }

        public string GetWeather(string city) {
            string html = null;
            string url = "http://php.weather.sina.com.cn/search.php?city=" + city;
            WebRequest req = WebRequest.Create(url);
            WebResponse res = req.GetResponse();
            Stream receiveStream = res.GetResponseStream();
            Encoding encode = Encoding.GetEncoding("gb2312");
            StreamReader sr = new StreamReader(receiveStream, encode);
            char[] readbuffer = new char[256];
            int n = sr.Read(readbuffer, 0, 256);
            while (n > 0)
            {
                string str = new string(readbuffer, 0, n);
                html += str;
                n = sr.Read(readbuffer, 0, 256);
            }
            //System.Console.Write(html);
            int start = html.IndexOf("今天白天");
            int end = html.IndexOf("今天夜间");
            string weather = html.Substring(start, end - start);
            int tokenStart = weather.IndexOf("</li>");
            int start2 = weather.IndexOf("<li>", tokenStart);
            int end2 = weather.IndexOf("</li>", tokenStart + 5);
            weather = weather.Substring(start2, end2 - start2);
            //return weather;
            if (weather.IndexOf("晴") != -1) {
                return "1";
            }
            else if (weather.IndexOf("云") != -1 || weather.IndexOf("阴") != -1) {
                return "2";
            }
            else if (weather.IndexOf("雨") != -1)
            {
                return "3";
            }
            else {
                return "0";
            }
        }
        public string GetWeather2(string city)
        {
            string html = null;
            string url = "http://weather.all2rss.com/weatherrss.asp?City=" + castToGB2312(city);
            WebRequest req = WebRequest.Create(url);
            WebResponse res = req.GetResponse();
            Stream receiveStream = res.GetResponseStream();
            Encoding encode = Encoding.GetEncoding("gb2312");
            StreamReader sr = new StreamReader(receiveStream, encode);
            char[] readbuffer = new char[256];
            int n = sr.Read(readbuffer, 0, 256);
            while (n > 0)
            {
                string str = new string(readbuffer, 0, n);
                html += str;
                n = sr.Read(readbuffer, 0, 256);
            }
            //System.Console.Write(html);
            int start = html.IndexOf("今天");
            int end = html.IndexOf("～");
            string weather = html.Substring(start, end - start);
            
            //return weather;
            if (weather.IndexOf("晴") != -1)
            {
                return "1";
            }
            else if (weather.IndexOf("云") != -1 || weather.IndexOf("阴") != -1)
            {
                return "2";
            }
            else if (weather.IndexOf("雨") != -1)
            {
                return "3";
            }
            else
            {
                return "0";
            }
        }
        // 把中文转换成GB2312编码
        private string castToGB2312(string s) {
            // x赋为汉字(根据需要GB2312可以改成UTF-8等编码)
            Byte[] textByte = System.Text.Encoding.GetEncoding("GB2312").GetBytes(s);

            // 上面这句就可以得到byte数组,再代入到下面的代码中

            StringBuilder text = new StringBuilder();
            for (int j = 0; j < textByte.Length; j++)
            {
                // Tochar
                char textChar = Convert.ToChar(int.Parse(textByte[j].ToString()));
                // To16
                text.Append(System.Uri.HexEscape(textChar));
            }
            return text.ToString();
        }
        

    }
}

