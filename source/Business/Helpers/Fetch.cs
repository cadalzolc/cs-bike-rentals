using Microsoft.Data.SqlClient;
using System.Collections.Generic;
using System.Data;

namespace web.urapz
{
    public class Fetch
    {

        #region " Init "

        public Log Logger { get; set; } = new Log();

        private readonly IConnectionService MyServer;

        public Fetch(IConnectionService _MyServer)
        {
            MyServer = _MyServer;
        }

        #endregion

        #region " Get - Bikes "

        public IEnumerable<Bike> GetBikes(int Top)
        {
            var DT = MyServer.ToData(string.Format("SELECT TOP {0} * FROM VW_CRM_Bikes", Top));

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

        #endregion

    }
}