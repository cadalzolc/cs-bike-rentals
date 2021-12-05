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

        #endregion

        #region " Get - Collection "

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

    }
}