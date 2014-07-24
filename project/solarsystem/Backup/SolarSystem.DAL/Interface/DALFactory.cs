using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using SolarSystem.DAL.Interface;
using SolarSystem.DAL.Impl;

namespace SolarSystem.DAL
{
    public sealed class DALFactory
    {
        private static IUserInfo userInfoDao = null;
        public static IUserInfo CreateUserInfo()
        {
            if (userInfoDao != null)
            {
                return userInfoDao;
            }
            else
            {
                return new UserInfoImpl();
            }
        }
        public static ICommunityInfo CreateCommunityInfo() {
            return new CommunityInfoImpl();
        }
        public static ISystemInfo CreateSystemInfo() {
            return new SystemInfoImpl();
        }
        public static IRegionInfo CreateRegionInfo() {
            return new RegionInfoImpl();
        }
        public static ISystemOperation CreateSystemOperator() {
            return new SystemOperationIml();
        }
    }
}
