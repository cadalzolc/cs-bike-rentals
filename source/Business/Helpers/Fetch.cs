using Microsoft.Data.SqlClient;
using System.Collections.Generic;
using System.Data;
using System.Linq;

namespace web.urapz
{
    public class Fetch
    {

        #region " Property "

        private const string GetBikesSQL = "SELECT *, (Stock - Leased) AS Available FROM " +
                                    "( " +
                                        "SELECT B.*, " +
                                            "Leased = (SELECT COUNT(*) AS N " +
                                                    "FROM CRM_Rentals_Detail RD " +
                                                        "LEFT OUTER JOIN CRM_Rentals R ON  R.ID = RD.Rental_ID " +
                                                  "WHERE R.Bike_ID = B.ID AND R.Status = 'L') " +
                                        "FROM VW_CRM_Bikes B " +
	                                ") AS Bikes";

        #endregion

        #region " Init "

        public Log Logger { get; set; } = new Log();

        private readonly IConnectionService MyServer;

        public Fetch(IConnectionService _MyServer)
        {
            MyServer = _MyServer;
        }

        #endregion

        #region " Get - Bikes "

        public IEnumerable<Bike> GetBikes(int Top, string Search = "")
        {
            string WHR = "";

            if (!Search.Equals(""))
            {
                WHR = string.Format("WHERE Name LIKE '%{0}%' OR Category LIKE '%{0}%'", Search);
            }
           
            var DT = MyServer.ToData(string.Format("{0} {1}", GetBikesSQL, WHR));

            if (DT == null) return new List<Bike>();

            IEnumerable<Bike> Recs = Table.ToBikes(DT.AsEnumerable());

            return Recs.Take(Top);
        }

        public IEnumerable<Bike> GetBikesByCategoryID(int Category)
        {
            var WHR = Category == 0 ? "" : string.Format("WHERE Category_ID = {0}", Category);
            var DT = MyServer.ToData(string.Format("{0} {1}", GetBikesSQL, WHR));

            if (DT == null) return new List<Bike>();

            return Table.ToBikes(DT.AsEnumerable());
        }

        #endregion

        #region " Get - Bikes Info "

        public Bike GetBikesInfo(int ID)
        {
            var DT = MyServer.ToData(string.Format("SELECT TOP 1 * FROM VW_CRM_Bikes WHERE ID = {0}", ID));

            if (DT == null) return new Bike();
            if (DT.Rows.Count.Equals(0)) return new Bike();

            return Table.ToBike(DT.Rows[0]);
        }

        public Bike_Rental GetBikesInfoRental(int ID)
        {
            var DT = MyServer.ToData(string.Format("EXEC SP_INF_Bikes {0}", ID));

            if (DT == null) return new Bike_Rental();
            if (DT.Rows.Count.Equals(0)) return new Bike_Rental();

            return Table.ToBikeRental(DT.Rows[0]);
        }


        #endregion

        #region " Get - Collection "

        public Bike_Collection GetCollectionInfo(int ID)
        {
            var DT = MyServer.ToData(string.Format("SELECT TOP 1 * FROM VW_CRM_Bikes_Collections WHERE ID = {0}", ID));

            if (DT == null) return new Bike_Collection();
            if (DT.Rows.Count.Equals(0)) return new Bike_Collection();

            return Table.ToBikeColllection(DT.Rows[0]);
        }

        public IEnumerable<Bike_Collection> GetCollection(int Bike_ID)
        {
            var DT = MyServer.ToData(string.Format("EXEC SP_CRM_GetList_Collection_Available {0}", Bike_ID));

            if (DT == null) return new List<Bike_Collection>();

            return Table.ToBikeColllections(DT.AsEnumerable());
        }

        #endregion

        #region " Get - Rentals "

        public IEnumerable<Rental> GetRentalsByStatus(string Status)
        {
            var DT = MyServer.ToData(string.Format("EXEC SP_CRM_GetList_Rentals_By_Status '{0}'", Status));

            if (DT == null) return new List<Rental>();

            return Table.ToRentals(DT.AsEnumerable());
        }

        public IEnumerable<Rental> GetRentalsByStatusWithFilter(string Status, string Where)
        {
            var SC = string.Format("SELECT * FROM (SELECT * FROM VW_CRM_Rentals WHERE Status = '{0}') AS SR {1}", Status, Where);
            var DT = MyServer.ToData(string.Format("{0} ORDER BY Rental_Date DESC", SC));

            if (DT == null) return new List<Rental>();

            return Table.ToRentals(DT.AsEnumerable());
        }

        #endregion

        #region " Get - Rental Info "

        public Rental GetRentalInfo(int ID)
        {
            var DT = MyServer.ToData(string.Format("SELECT TOP 1 * FROM VW_CRM_Rentals WHERE ID = {0}", ID));

            if (DT == null) return new Rental();
            if (DT.Rows.Count.Equals(0)) return new Rental();

            return Table.ToRental(DT.Rows[0]);
        }

        #endregion

        #region " Get - Rentals Collection "

        public IEnumerable<Rental_Collection> GetRentalsCollections(int Rental_ID)
        {
            var DT = MyServer.ToData(string.Format("EXEC SP_CRM_GetList_Rentals_Collection {0}", Rental_ID));

            if (DT == null) return new List<Rental_Collection>();

            return Table.ToRentalColllections(DT.AsEnumerable());
        }

        #endregion

        #region " Get - Rental Calculation "

        public Rental_Calculate GetRentalCalculateInfo(int ID)
        {
            var DT = MyServer.ToData(string.Format("EXEC SP_CAL_Rentals_Return {0}", ID));

            if (DT == null) return new Rental_Calculate();
            if (DT.Rows.Count.Equals(0)) return new Rental_Calculate();

            return Table.ToRentalCalculate(DT.Rows[0]);
        }

        #endregion

        #region " Get - Rental Sales "

        public IEnumerable<Rental_Sales> GetRentalSales()
        {
            var DT = MyServer.ToData("SELECT * FROM VW_CRM_Sales ORDER BY Rental_Date DESC");

            if (DT == null) return new List<Rental_Sales>();
            if (DT.Rows.Count.Equals(0)) return new List<Rental_Sales>();

            return Table.ToRentalSales(DT.AsEnumerable());
        }

        public IEnumerable<SalesInfo> GetRentalSalesSummary(int Year, int Month)
        {
            var DT = MyServer.ToData(string.Format("SELECT Rental_Date, SUM(Total) AS Total  FROM VW_CRM_Sales WHERE YEAR(Rental_Date) = {0} AND MONTH(Rental_Date) = {1} GROUP BY Rental_Date ORDER BY Rental_Date DESC", Year, Month));

            if (DT == null) return new List<SalesInfo>();
            if (DT.Rows.Count.Equals(0)) return new List<SalesInfo>();

            return Table.ToRentalSalesSummary(DT.AsEnumerable());
        }

        #endregion

    }
}