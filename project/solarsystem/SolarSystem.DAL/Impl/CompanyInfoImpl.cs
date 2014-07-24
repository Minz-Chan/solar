using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Xml;
using System.Data.SqlClient;
using SolarSystem.DAL.Interface;
using SolarSystem.Utils;

namespace SolarSystem.DAL.Impl
{
    public class CompanyInfoImpl: ICompanyInfo
    {

        public string GetAllCompanyInfoList()
        {
            SqlParameter[] prams = new SqlParameter[] { 
                new SqlParameter("@companyIdentifier",SqlDbType.NVarChar,50)
            };
            prams[0].Value = "fjnu";

            DataTable dt_companys = DbHelperSQL.QueryBySqlText("select * from Company", null);

            if (dt_companys.Rows.Count != 0) 
            {
                XmlDocument xml = new XmlDocument();
                // 建立Xml的定义声明
                XmlDeclaration dec = xml.CreateXmlDeclaration("1.0", "GB2312", null);
                xml.AppendChild(dec);
                // 创建根节点
                XmlElement root = xml.CreateElement("Companys");
                xml.AppendChild(root);
                // 创建数据节点
                foreach (DataRow row in dt_companys.Rows)
                {
                    XmlElement c = xml.CreateElement("Company");
                    c.SetAttribute("CompanyId", row["CompanyId"].ToString());
                    c.SetAttribute("CompanyName", row["CompanyName"].ToString());
                    c.SetAttribute("CompanyIdentifier", row["CompanyIdentifier"].ToString());
                    c.SetAttribute("Bg_login", row["Bg_login"].ToString());
                    c.SetAttribute("Bg_logo", row["Bg_logo"].ToString());
                    root.AppendChild(c);
                }
                return xml.InnerXml;
            }

            return null;
        }

        public string GetCompanyInfo(string companyIdentifier)
        {
            SqlParameter[] prams = new SqlParameter[] { 
                new SqlParameter("@companyIdentifier", SqlDbType.NVarChar, 50)
            };
            prams[0].Value = companyIdentifier;

            DataTable dt_companys = DbHelperSQL.QueryBySqlText("select * from Company where CompanyIdentifier=@companyIdentifier", prams);
            if (dt_companys.Rows.Count > 0)
            {
                XmlDocument xml = new XmlDocument();
                // 建立Xml的定义声明
                XmlDeclaration dec = xml.CreateXmlDeclaration("1.0", "GB2312", null);
                xml.AppendChild(dec);
                // 创建根节点
                XmlElement root = xml.CreateElement("Companys");
                xml.AppendChild(root);

                DataRow row = dt_companys.Rows[0];
                XmlElement c = xml.CreateElement("Company");
                c.SetAttribute("CompanyId", row["CompanyId"].ToString());
                c.SetAttribute("CompanyName", row["CompanyName"].ToString());
                c.SetAttribute("CompanyIdentifier", row["CompanyIdentifier"].ToString());
                c.SetAttribute("Bg_login", row["Bg_login"].ToString());
                c.SetAttribute("Bg_logo", row["Bg_logo"].ToString());
                root.AppendChild(c);

                return xml.InnerXml;
            }
            return null;
        }
    }
}
