using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Threading.Tasks;

namespace web.urapz
{
    public class SalesReport
    {
        public List<KeyValue> Months { get; set; } = new List<KeyValue>() 
        {
            new KeyValue("1", "JANUARY"),
            new KeyValue("2", "FEBRUARY"),
            new KeyValue("3", "MARCH"),
            new KeyValue("4", "APRIL"),
            new KeyValue("5", "MAY"),
            new KeyValue("6", "JUNE"),
            new KeyValue("7", "JULY"),
            new KeyValue("8", "AUGUST"),
            new KeyValue("9", "SEPTEMBER"),
            new KeyValue("10", "OCTOBER"),
            new KeyValue("11", "NOVEMBER"),
            new KeyValue("12", "DECEMBER"),
        };

        public string Title { get; set; } = "";

        public DateTime GetLastDayOfMonth(int Year, int Month)
        {
            return new DateTime(Year, Month, DateTime.DaysInMonth(Year, Month));
        }

        public List<SalesInfo> SalesData { get; set; } = new List<SalesInfo>();

        public List<SalesSummary> CalculateMonthlySales(List<SalesInfo> data, int Year, int Month)
        {
            var Summary = new List<SalesSummary>();
            var LastDay = GetLastDayOfMonth(Year, Month).Day;
            var MonthID = Month.ToString();
            for(var d = 1; d <= LastDay; d++)
            {
                 var strDate = string.Format("{1}/{2}/{0}", Year, Month, d);
                CultureInfo provider = new CultureInfo("en-US");
                DateTime newDate = DateTime.Parse(strDate, provider);
               
                //var newDate = Convert.ToDateTime(strDate);
                Summary.Add(new SalesSummary() 
                { 
                    Date = newDate.ToString("MMM dd, yyyy"), 
                    Year = Year, 
                    Month_ID = Month, 
                    Month = Months.Where(m => m.Key.Equals(MonthID)).Select(m => m.Value).SingleOrDefault(),
                    Amount = data.Where(s => s.Date.Equals(newDate.ToString("yyyy-MM-dd"))).Select(r => r.Amount).SingleOrDefault().ToDouble(0)
                });
            }
            return Summary;
        }
    }

    public class SalesInfo
    {
        public int ID { get; set; } = 0;
        public string Date { get; set; } = "";
        public string Month { get; set; } = "";
        public double Amount { get; set; } = 0;
        public string Remarks { get; set; } = "";
    }

    public class SalesSummary
    {
        public string Date { get; set; } = "";
        public int Month_ID { get; set; } = 0;
        public string Month { get; set; } = "";
        public int Year { get; set; } = 0;
        public double Amount { get; set; } = 0;
    }
}