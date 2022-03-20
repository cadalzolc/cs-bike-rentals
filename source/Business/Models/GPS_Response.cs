using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace web.urapz.bike_rentals
{
    public class GPS_Response
    {
        public string from { get; set; } = "";
        public string body { get; set; } = "";
        public string stamp { get; set; } = "";
    }

    public class GPS_Data
    {
        public string provider { get; set; } = "";
        public string token { get; set; } = "";
        public string sender { get; set; } = "";
        public string to { get; set; } = "";
        public string body { get; set; } = "";
    }

}
