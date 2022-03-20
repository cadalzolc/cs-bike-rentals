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
        public string Map_URL { get; set; } = "";
        public Rental_Collection GPS_Info { get; set; } = new Rental_Collection();
        public IEnumerable<Rental_Collection> Rental_Collections { get; set; } = new List<Rental_Collection>();
    }

    public class Rental_Collection : Bike_Collection 
    {
        public int Rental_ID { get; set; } = 0;
        public int Rental_Collection_ID { get; set; } = 0;
        public string Stamper { get; set; } = "";
        public int Stamper_ID { get; set; } = 0;
        public string HtmlRaw { get; set; } = "";
    }

    public class Rental_Calculate
    {
        public int Rental_ID { get; set; } = 0;
        public string Rental_No { get; set; } = "";
        public string Customer { get; set; } = "";
        public string Customer_Address { get; set; } = "";
        public string Rental_Date { get; set; } = "";
        public string Rental_Start { get; set; } = "";
        public string Rental_End{ get; set; } = "";
        public double Rent { get; set; } = 0;
        public int Lapse { get; set; } = 0;
        public double Penalty { get; set; } = 0;
        public double Total { get; set; } = 0;
    }

    public class Rental_Sales
    {
        public int Rental_ID { get; set; } = 0;
        public string Rental_Date { get; set; } = "";
        public double Rent { get; set; } = 0;
        public double Penalty { get; set; } = 0;
        public double Total { get; set; } = 0;
        public int Stamper_ID { get; set; } = 0;
    }

}