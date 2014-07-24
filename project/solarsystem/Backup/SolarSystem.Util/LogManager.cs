using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;

namespace SolarSystem.Utils
{
    public class LogManager
    {
        private static string LogPath = AppDomain.CurrentDomain.BaseDirectory;
        private static string ErrorLogName = LogPath + @"\" + "Error_Log";   // 构造存储 错误 信息类型的日志目录名
        private static string HandleLogName = LogPath + @"\" + "Handle_Log";

        public static void SendLog(string data) {
            try
            {
                if (!Directory.Exists(HandleLogName))         // 判断错误日志的目录是否存在
                {
                    Directory.CreateDirectory(HandleLogName);        // 创建错误日志目录
                }

                string HandleLogFile = HandleLogName + @"\" + "Handle_" + System.DateTime.Now.ToShortDateString() + ".txt"; // 构造存储错误日志的txt文件名

                if (!File.Exists(HandleLogFile))        // 判断文件是否存在
                {
                    FileStream fs = new FileStream(HandleLogFile, FileMode.Create); // 创建文件
                    fs.Close();
                }

                //string[] tmp = ex.StackTrace.ToString().Split('在');
                //string info = System.DateTime.Now.ToString() + tmp[tmp.Length - 1] + "  出错原因：" + ex.Message;
                string info = System.DateTime.Now.ToString() + "操作" + data;

                System.IO.StreamWriter myWriter = new StreamWriter(HandleLogFile, true, Encoding.Default);
                myWriter.WriteLine(info);            // 记录错误日志
                myWriter.Close();
            }
            catch
            { }
        }

        #region  <<-----错误信息类型的日志----->>
        public static void ErrorLog(Exception ex)
        {
            try
            {
                if (!Directory.Exists(ErrorLogName))         // 判断错误日志的目录是否存在
                {
                    Directory.CreateDirectory(ErrorLogName);        // 创建错误日志目录
                }

                string ErrorLogFile = ErrorLogName + @"\" + "Error_" + System.DateTime.Now.ToShortDateString() + ".txt"; // 构造存储错误日志的txt文件名

                if (!File.Exists(ErrorLogFile))        // 判断文件是否存在
                {
                    FileStream fs = new FileStream(ErrorLogFile, FileMode.Create); // 创建文件
                    fs.Close();
                }

                string[] tmp = ex.StackTrace.ToString().Split('在');
                string info = System.DateTime.Now.ToString() + tmp[tmp.Length - 1] + "  出错原因：" + ex.Message;

                System.IO.StreamWriter myWriter = new StreamWriter(ErrorLogFile, true, Encoding.Default);
                myWriter.WriteLine(info);            // 记录错误日志
                myWriter.Close();
            }
            catch
            { }
        }
        #endregion
    }
}
