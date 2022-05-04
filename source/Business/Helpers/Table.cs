using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Threading.Tasks;

namespace web.urapz
{
    public class Table
    {

        #region " To Key Value "

        public static KeyValue ToKeyValue(DataRow Row)
        {
            return new KeyValue
            {
                Key = Row["Key"].ToString(),
                Value = Row["Value"].ToNullString(),
            };
        }

        public static IEnumerable<KeyValue> ToKeyValue(IEnumerable<DataRow> Rows)
        {
            if (Rows == null || Rows.Count().Equals(0)) return new List<KeyValue>();
            return Rows.Select(r => ToKeyValue(r));
        }

        #endregion

        #region " To User "

        public static User_Account ToUser(DataRow Row)
        {
            if (Row == null) return new User_Account();
            var _Photo = Row["Photo"].ToNullString();
            return new User_Account
            {
                ID = Row["ID"].ToNullString(),
                Name = Row["Name"].ToString(),
                Role_ID = Row["Role_ID"].ToNullString(),
                Role = Row["Role"].ToNullString(),
                Username = Row["Username"].ToNullString(),
                Email = Row["Email"].ToNullString(),
                Password = Row["Password"].ToNullString(),
                Photo = (_Photo.Equals("") ? "default.png" : _Photo),
                Status = Row["Status"].ToNullString(),
            };
        }

        public static IEnumerable<User_Account> ToUser(IEnumerable<DataRow> Rows)
        {
            if (Rows == null || Rows.Count().Equals(0)) return new List<User_Account>();
            return Rows.Select(r => ToUser(r));
        }

        #endregion

        #region " To Bike "

        public static Bike ToBike(DataRow Row)
        {
            if (Row == null) return new Bike();
            return new Bike
            {
                ID = Row["ID"].ToInt(),
                Name = Row["Name"].ToString(),
                Category = new Bike_Category()
                {
                    ID = Row["Category_ID"].ToInt(),
                    Name = Row["Category"].ToString(),
                },
                Hourly_Rate = Row["Hourly_Rate"].ToDouble(),
                Stock = Row["Stock"].ToInt(),
                Photo = Row["Photo"].ToNullString("default.jpg")       
            };
        }

        public static IEnumerable<Bike> ToBikes(IEnumerable<DataRow> Rows)
        {
            if (Rows == null || Rows.Count().Equals(0)) return new List<Bike>();
            return Rows.Select(r => ToBike(r));
        }

        #endregion

        #region " To Bike Rental "

        public static Bike_Rental ToBikeRental(DataRow Row)
        {
            if (Row == null) return new Bike_Rental();
            return new Bike_Rental
            {
                ID = Row["ID"].ToInt(),
                Name = Row["Name"].ToString(),
                Category = new Bike_Category()
                {
                    ID = Row["Category_ID"].ToInt(),
                    Name = Row["Category"].ToString(),
                },
                Hourly_Rate = Row["Hourly_Rate"].ToDouble(),
                Stock = Row["Stock"].ToInt(),
                Photo = Row["Photo"].ToNullString("default.jpg"),
                Leased = Row["Leased"].ToInt(),
                Available = Row["Available"].ToInt()
            };
        }

        public static IEnumerable<Bike_Rental> ToBikeRentals(IEnumerable<DataRow> Rows)
        {
            if (Rows == null || Rows.Count().Equals(0)) return new List<Bike_Rental>();
            return Rows.Select(r => ToBikeRental(r));
        }

        #endregion

        #region " To Bike Collection "

        public static Bike_Collection ToBikeColllection(DataRow Row)
        {
            if (Row == null) return new Bike_Collection();
            return new Bike_Collection
            {
                Collection_ID = Row["ID"].ToInt(),
                Bike_ID = Row["Bike_ID"].ToInt(),
                Bike = Row["Bike"].ToString(),
                Category = new Bike_Category()
                {
                    ID = Row["Category_ID"].ToInt(),
                    Name = Row["Category"].ToString(),
                },
                Hourly_Rate = Row["Hourly_Rate"].ToDouble(),
                Photo = Row["Photo"].ToNullString("default.jpg"),
                Mobile_GPS = Row["Mobile_GPS"].ToNullString(),
                Status = Row["Status"].ToNullString(),
                Map_URL = Row["GPS_URL"].ToNullString(),
            };
        }

        public static IEnumerable<Bike_Collection> ToBikeColllections(IEnumerable<DataRow> Rows)
        {
            if (Rows == null || Rows.Count().Equals(0)) return new List<Bike_Collection>();
            return Rows.Select(r => ToBikeColllection(r));
        }

        #endregion

        #region " To Rental "

        public static Rental ToRental(DataRow Row)
        {
            if (Row == null) return new Rental();
            return new Rental
            {
                Rental_ID = Row["ID"].ToInt(),
                Rental_Date = Row["Rental_Date"].ToNullString(),
                Rental_Start = Row["Rental_Start"].ToNullString(),
                Bike_ID = Row["Bike_ID"].ToInt(),
                Bike = Row["Bike"].ToNullString(),
                Category_ID = Row["Category_ID"].ToInt(),
                Category = Row["Category"].ToNullString(),
                Customer = Row["Customer"].ToNullString(),
                Customer_Mobile = Row["Customer_Mobile"].ToNullString(),
                Customer_Address = Row["Customer_Address"].ToNullString(),
                Hourly_Rate = Row["Hourly_Rate"].ToDouble(),
                Hourly_Usage = Row["Hourly_Usage"].ToInt(),
                Status = Row["Status"].ToNullString(),
                Stamper_ID = Row["Processor_ID"].ToNullString(),
                Stamper = Row["Processor"].ToNullString()
            };
        }

        public static IEnumerable<Rental> ToRentals(IEnumerable<DataRow> Rows)
        {
            if (Rows == null || Rows.Count().Equals(0)) return new List<Rental>();
            return Rows.Select(r => ToRental(r));
        }

        #endregion

        #region " To Rental Collection "

        public static Rental_Collection ToRentalColllection(DataRow Row)
        {
            if (Row == null) return new Rental_Collection();
            return new Rental_Collection
            {
                Rental_Collection_ID = Row["ID"].ToInt(),
                Rental_ID = Row["Rental_ID"].ToInt(),
                Collection_ID = Row["Collection_ID"].ToInt(),
                Bike_ID = Row["Bike_ID"].ToInt(),
                Mobile_GPS = Row["Mobile_GPS"].ToNullString(),
                Map_URL = Row["GPS_URL"].ToNullString(),
            };
        }

        public static IEnumerable<Rental_Collection> ToRentalColllections(IEnumerable<DataRow> Rows)
        {
            if (Rows == null || Rows.Count().Equals(0)) return new List<Rental_Collection>();
            return Rows.Select(r => ToRentalColllection(r));
        }

        #endregion

        #region " To Rental Calculate "

        public static Rental_Calculate ToRentalCalculate(DataRow Row)
        {
            if (Row == null) return new Rental_Calculate();
            return new Rental_Calculate
            {
                Rental_ID = Row["ID"].ToInt(),
                Rental_No = "BRN" + Row["ID"].ToInt().ToString("00000"),
                Rental_Date = Row["Rental_Date"].ToNullString(),
                Rental_Start = Row["Rental_Start"].ToNullString(),
                Rental_End = Row["Rental_End"].ToNullString(),
                Customer = Row["Customer"].ToNullString(),
                Customer_Address = Row["Customer_Address"].ToNullString(),
                Rent = Row["Rent"].ToDouble(),
                Lapse = Row["Lapse"].ToInt(),
                Penalty = Row["Penalty"].ToDouble(),
                Total = Row["Total"].ToDouble(),
            };
        }

        public static IEnumerable<Rental_Calculate> ToRentalCalculates(IEnumerable<DataRow> Rows)
        {
            if (Rows == null || Rows.Count().Equals(0)) return new List<Rental_Calculate>();
            return Rows.Select(r => ToRentalCalculate(r));
        }

        #endregion

        #region " To Rental Sales "

        public static Rental_Sales ToRentalSale(DataRow Row)
        {
            if (Row == null) return new Rental_Sales();
            return new Rental_Sales
            {
                Rental_ID = Row["Rental_ID"].ToInt(),
                Rental_Date = Row["Rental_Date"].ToString(),
                Rent = Row["Rent"].ToDouble(),
                Penalty = Row["Penalty"].ToDouble(),
                Total = Row["Total"].ToDouble(),
            };
        }

        public static IEnumerable<Rental_Sales> ToRentalSales(IEnumerable<DataRow> Rows)
        {
            if (Rows == null || Rows.Count().Equals(0)) return new List<Rental_Sales>();
            return Rows.Select(r => ToRentalSale(r));
        }

        #endregion

        #region " To Rental Sales Summary "

        public static SalesInfo ToRentalSaleSummary(DataRow Row)
        {
            if (Row == null) return new SalesInfo();
            return new SalesInfo
            {
                Date = Row["Rental_Date"].ToString(),
                Amount = Row["Total"].ToDouble(),
            };
        }

        public static IEnumerable<SalesInfo> ToRentalSalesSummary(IEnumerable<DataRow> Rows)
        {
            if (Rows == null || Rows.Count().Equals(0)) return new List<SalesInfo>();
            return Rows.Select(r => ToRentalSaleSummary(r));
        }

        #endregion

    }
}