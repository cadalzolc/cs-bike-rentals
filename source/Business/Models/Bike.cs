using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace web.urapz
{

    public class Bike : IDName
    {
        public Bike_Category Category { get; set; } = new Bike_Category();
        public string Photo { get; set; } = "";
        public double Hourly_Rate { get; set; } = 0;
        public int Stock { get; set; } = 0;
    }

    public class Bike_Category : IDName {}

    public class Bike_Collection : Bike
    {
        public int Collection_ID { get; set; } = 0;
        public string Mobile_GPS { get; set; } = "";
        public string Status { get; set; } = "";
        public int Bike_ID { get; set; } = 0;
        public string Bike { get; set; } = "";
    }
}