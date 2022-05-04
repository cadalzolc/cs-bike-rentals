using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace web.urapz
{
    public class Pages
    {
        public IEnumerable<User_Account> List_Users = new List<User_Account>();
        public IEnumerable<Bike> List_Bikes = new List<Bike>();
        public IEnumerable<Rental> List_Rentals = new List<Rental>();
        public User_Account Info_User { get; set; } = new User_Account();
        public IEnumerable<Rental_Sales> Sales = new List<Rental_Sales>();
        public IEnumerable<SalesSummary> SalesSummary = new List<SalesSummary>();
        public string KeyWord1 { get; set; } = "";
        public string KeyWord2 { get; set; } = "";
        public string KeyWord3 { get; set; } = "";
        public string KeyWord4 { get; set; } = "";
    }
}