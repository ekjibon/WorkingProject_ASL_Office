using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.ViewModel.SetUp
{
    public class PushNotificationVM
    {
        public string to { get; set; }
        public string priority { get; set; }
        public NotificationVM notification { get; set; }
        public NotificationDataVM data { get; set; }
    }

    public class NotificationVM
    {
        public string title { get; set; }
        public string body { get; set; }
        public string image { get { return "https://addiesoft.com/assets/images/footerlogo.png"; } }

    }
    public class NotificationDataVM
    {
        public string click_action { get { return "FLUTTER_NOTIFICATION_CLICK"; } }
        public string id { get; set; }
        public string status { get; set; }
        public int type { get; set; }
        public bool content_available { get; set; }
        public string priority { get; set; }
        public string title { get; set; }
        public string body { get; set; }


    }
}
