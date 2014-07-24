using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace SolarSystem.Model
{
    public class UserDetailData
    {
        public string userName;
        public string userPassword;
        public string userPhone;
        public string userTypeID;
        public string userID;
        public string userPictureRoute;
        //public List<IdAndRight> communityInfo;
    }
    public class IdAndRight {
        public string communityID;
        public string rightID;
    }
}
