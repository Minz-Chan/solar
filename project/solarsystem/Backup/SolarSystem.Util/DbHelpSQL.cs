using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.SqlClient;
using System.Data;
using System.Collections;
using System.Configuration;
using System.Xml;
namespace SolarSystem.Utils
{
    public static class DbHelperSQL
    {

        //与SQLServer数据库的连接字符串

        //private static string sqlConString = "server=MY-TOMATO\\SQLEXPRESS;Database=MySolarDB;uid=sa;pwd=123456;";
        private static string sqlConString = System.Configuration.ConfigurationManager.ConnectionStrings["connStr"].ToString();

        /// <summary>
        /// 准备SqlCommand对象,该对象默认的执行方式为Sql语句，若要执行存储过程，则在调用该函数后需将
        /// SqlCommand的CommandType改成StoredProcedure
        /// </summary>
        /// <param name="conn">SqlCommand所对应的连接</param>
        /// <param name="cmd">需要准备的SqlCommand对象</param>
        /// <param name="tran">SqlCommand对象所对应的事务</param>
        /// <param name="sqlText">SqlCommand所要执行的Sql语句或存储过程名</param>
        /// <param name="prams">SqlCommand所需要的参数</param>
        private static void PrepareCommand(SqlConnection conn, SqlCommand cmd, SqlTransaction tran, string sqlText, SqlParameter[] prams)
        {
            cmd.Connection = conn;
            if (tran != null)
            {
                cmd.Transaction = tran;
            }
            cmd.CommandText = sqlText;
            if (prams != null)
            {
                foreach (SqlParameter p in prams)
                {
                    cmd.Parameters.Add(p);
                }
            }
        }

        /// <summary>
        /// 通过SQL语句进行查询
        /// </summary>
        /// <param name="sqlText">要执行的查询语句</param>
        /// <param name="prams">该查询语句所需要的参数</param>
        /// <returns>返回查询的数据表</returns>
        public static DataTable QueryBySqlText(string sqlText, SqlParameter[] prams)
        {
            using (SqlConnection conn = new SqlConnection(sqlConString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    PrepareCommand(conn, cmd, null, sqlText, prams);
                    SqlDataReader sdr = null;
                    try
                    {
                        conn.Open();
                        sdr = cmd.ExecuteReader(CommandBehavior.CloseConnection);
                        
                        cmd.Parameters.Clear();
                    }
                    catch (SqlException ex)
                    {
                        throw ex;
                    }
                    DataTable dt = new DataTable();

                    dt.Load(sdr);
                    return dt;
                    
                }
            }
        }

        public static string QueryGetXMLStringByProc(string sqlProc, SqlParameter[] prams) {
            using (SqlConnection conn = new SqlConnection(sqlConString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    PrepareCommand(conn, cmd, null, sqlProc, prams);
                    cmd.CommandType = CommandType.StoredProcedure;
                    //SqlDataReader sdr = null;
                    XmlReader xmlReader = null;
                    try
                    {
                        conn.Open();
                        
                        xmlReader = cmd.ExecuteXmlReader();
                        xmlReader.Read();
                        cmd.Parameters.Clear();
                    }
                    catch (SqlException ex)
                    {
                        throw ex;
                    }

                    string content = "";
                  
                    while (!xmlReader.EOF)
                    {
                        content += xmlReader.ReadOuterXml() + "\n";
                    }
                    return content;
                }
            }
        }

        public static string QueryGetXMLString(string sqlText, SqlParameter[] prams) {
            using (SqlConnection conn = new SqlConnection(sqlConString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    PrepareCommand(conn, cmd, null, sqlText, prams);
                    //SqlDataReader sdr = null;
                    XmlReader xmlReader = null;
                    try
                    {
                        conn.Open();
                        //sdr = cmd.ExecuteReader(CommandBehavior.CloseConnection);
                        xmlReader = cmd.ExecuteXmlReader();
                        xmlReader.Read();
                        cmd.Parameters.Clear();
                    }
                    catch (SqlException ex)
                    {
                        throw ex;
                    }

                    //DataTable dt = new DataTable();
                    
                    string content = "";
                    //dt.Load(sdr);
                    //return dt;
                    //xml.Load(xmlReader);
                    while (!xmlReader.EOF) {
                        content += xmlReader.ReadOuterXml() + "\n";
                    }
                    
                    
                    return content;

                }
            }
        }



        /// <summary>
        /// 执行一条计算查询结果语句，返回查询结果（object）。
        /// </summary>
        /// <param name="SQLString">计算查询结果语句</param>
        /// <returns>查询结果（object）</returns>
        public static object GetSingle(string SQLString, params SqlParameter[] cmdParms)
        {
            using (SqlConnection connection = new SqlConnection(sqlConString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    PrepareCommand(connection, cmd, null, SQLString, cmdParms);
                    try
                    {
                        connection.Open();

                        object obj = cmd.ExecuteScalar();
                        cmd.Parameters.Clear();
                        if ((Object.Equals(obj, null)) || (Object.Equals(obj, System.DBNull.Value)))
                        {
                            return null;
                        }
                        else
                        {
                            return obj;
                        }
                    }
                    catch (SqlException ex)
                    {
                        throw ex;
                    }
                }
            }
        }

        /// <summary>
        /// 通过SQL存储过程进行查询
        /// </summary>
        /// <param name="sqlProc">要执行的存储过程名</param>
        /// <param name="prams">该查询语句所需要的参数</param>
        /// <returns>返回查询的数据集</returns>

        public static DataTable QueryBySqlProc(string sqlProc, SqlParameter[] prams)
        {
            using (SqlConnection conn = new SqlConnection(sqlConString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    PrepareCommand(conn, cmd, null, sqlProc, prams);
                    cmd.CommandType = CommandType.StoredProcedure;
                    SqlDataReader sdr = null;
                    try
                    {
                        conn.Open();
                        sdr = cmd.ExecuteReader(CommandBehavior.CloseConnection);
                        cmd.Parameters.Clear();
                    }
                    catch (SqlException ex)
                    {
                        throw ex;
                    }

                    DataTable dt = new DataTable();
                    dt.Load(sdr);
                    return dt;
                }
            }
        }



        /// <summary>
        /// 通过Sql语句执行非查询操作
        /// </summary>
        /// <param name="sqlText">要执行的非查询SQL语句</param>
        /// <param name="prams">参数</param>
        /// <returns>返回影响的行数</returns>
        public static int ExcuteNonQueryBySqlText(string sqlText, SqlParameter[] prams)
        {
            int result = 0;
            using (SqlConnection conn = new SqlConnection(sqlConString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    PrepareCommand(conn, cmd, null, sqlText, prams);
                    try
                    {
                        conn.Open();
                        result = cmd.ExecuteNonQuery(); //> 0 ? true : false
                        cmd.Parameters.Clear();
                    }
                    catch (SqlException e)
                    {
                        throw e;
                    }
                }
            }
            return result;
        }


        /// <summary>
        /// 当执行存储过程查询操作需要传回output参数时候用该函数
        /// </summary>
        /// <param name="sqlProc">存储过程名称</param>
        /// <param name="cmd">SqlCommand对象</param>
        /// <param name="prams">存储过程所需要参数</param>
        /// <returns>DataTable</returns>
        public static DataTable ExcuteQueryWithOutputParam(string sqlProc, SqlCommand cmd, SqlParameter[] prams)
        {
            using (SqlConnection conn = new SqlConnection(sqlConString))
            {
                PrepareCommand(conn, cmd, null, sqlProc, prams);
                cmd.CommandType = CommandType.StoredProcedure;
                SqlDataReader sdr = null;
                try
                {
                    conn.Open();
                    sdr = cmd.ExecuteReader(CommandBehavior.CloseConnection);
                    cmd.Parameters.Clear();
                }
                catch (SqlException e)
                {
                    throw e;
                }

                DataTable dt = new DataTable();
                dt.Load(sdr);
                return dt;

            }
        }




        /// <summary>
        /// 通过存储过程执行非查询操作，存储过程如果返回0，则表示存储过程执行成功，否则即失败
        /// </summary>
        /// <param name="sqlProc">存储过程名</param>
        /// <param name="prams">参数</param>
        /// <returns></returns>
        public static int ExcuteNonQueryBySqlProc(string sqlProc, SqlParameter[] prams)
        {
            //int affectRows = 0;
            using (SqlConnection conn = new SqlConnection(sqlConString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    PrepareCommand(conn, cmd, null, sqlProc, prams);
                    cmd.CommandType = CommandType.StoredProcedure;


                    try
                    {
                        conn.Open();
                        cmd.ExecuteNonQuery();
                        //affectRows = cmd.ExecuteNonQuery();
                        cmd.Parameters.Clear();
                    }
                    catch (SqlException e)
                    {
                        throw e;
                    }
                }
            }
            return 1;
        }



        /// <summary>
        /// 通过存储过程执行非查询操作，存储过程如果返回0，则表示存储过程执行成功，否则即失败。当需要
        /// 输出参数的时候调用此函数
        /// </summary>
        /// <param name="sqlProc">存储过程名</param>
        /// <param name="prams">参数</param>
        /// <returns></returns>
        public static int ExcuteNonQueryBySqlProcWithOutputPram(string sqlProc, SqlCommand cmd, SqlParameter[] prams)
        {
            int result = 0;
            using (SqlConnection conn = new SqlConnection(sqlConString))
            {

                PrepareCommand(conn, cmd, null, sqlProc, prams);
                cmd.CommandType = CommandType.StoredProcedure;
                SqlParameter p = new SqlParameter("@returnValue", SqlDbType.Int);
                p.Value = 0;
                p.Direction = ParameterDirection.ReturnValue;
                cmd.Parameters.Add(p);

                try
                {
                    conn.Open();
                    cmd.ExecuteNonQuery();
                    int returnValue = int.Parse(cmd.Parameters["@returnValue"].Value.ToString());
                    result = returnValue;

                    cmd.Parameters.Clear();

                }
                catch (SqlException e)
                {
                    throw e;
                }

            }
            return result;
        }


    }
}
