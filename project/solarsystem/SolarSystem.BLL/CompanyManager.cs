using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using SolarSystem.DAL;
using SolarSystem.DAL.Impl;
using SolarSystem.DAL.Interface;


namespace SolarSystem.BLL
{
    public class CompanyManager
    {
        private ICompanyInfo companyInfo = DALFactory.CreateCompanyInfo();
        public string GetAllCompanyInfoList(){
            return companyInfo.GetAllCompanyInfoList();
        }

        public string GetCompanyInfo(string companyIdentifier){
            return companyInfo.GetCompanyInfo(companyIdentifier);
        }
    }
}
