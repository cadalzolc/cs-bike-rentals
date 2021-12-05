using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace web.urapz
{
    public class Rental
    {
        public int Rental_ID { get; set; } = 0;
        public string Rental_No { get; set; } = "";
        public int Collection_ID { get; set; } = 0;
        public int Bike_ID { get; set; } = 0;
        public string Bike { get; set; } = "";
        public int Category_ID { get; set; } = 0;
        public string Category { get; set; } = "";
        public string Collection_Name { get; set; } = "";
        public string Customer { get; set; } = "";
        public string Customer_Address { get; set; } = "";
        public string Customer_Mobile { get; set; } = "";
        public double Hourly_Rate { get; set; } = 0;
        public int Hourly_Usage { get; set; } = 0;
        public string Rental_Start { get; set; } = "";
        public string Rental_Date { get; set; } = "";
        public string Status { get; set; } = "";
        public string Stamper_ID { get; set; } = "";
        public string Stamper { get; set; } = "";
        public string Mobile_GPS { get; set; } = "";
        public string Mobile_Location { get; set; } = "";
        public string Photo { get; set; } = "";
        public IEnumerable<Bike_Collection> Collections { get; set; } = new List<Bike_Collection>();
    }
}
