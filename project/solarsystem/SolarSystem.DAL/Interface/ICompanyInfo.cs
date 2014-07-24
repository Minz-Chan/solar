using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace SolarSystem.DAL.Interface
{
    public interface ICompanyInfo
    {
        /// <summary>
        /// 获取所有公司信息列表
        /// </summary>
        /// <returns>XML数据格式，包含完整公司信息</returns>
        string GetAllCompanyInfoList();

        /// <summary>
        /// 根据公司标识获取公司信息
        /// </summary>
        /// <param name="companyIdentifier">公司唯一标识</param>
        /// <returns>XML数据格式，包含单个公司信息</returns>
        string GetCompanyInfo(string companyIdentifier);
    }
}
