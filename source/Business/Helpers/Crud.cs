using Microsoft.Data.SqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Threading.Tasks;

namespace web.urapz
{
    public class Crud
    {

        #region " Init "

        public Log log = new Log();

        private readonly IConnectionService MyServer;

        public Crud(IConnectionService _MyServer)
        {
            MyServer = _MyServer;
        }

        #endregion

        #region " Login "

        public ApiResult Login(User_Account User)
        {
            try
            {
                using var Con = MyServer.Connection();
                using var Cmd = new SqlCommand("SP_SYS_Login", Con)
                {
                    CommandType = CommandType.StoredProcedure
                };
                Cmd.Parameters.Add("@Username", SqlDbType.VarChar, 35);
                Cmd.Parameters.Add("@Password", SqlDbType.VarChar, 35);
                Cmd.Parameters.Add("@Err", SqlDbType.VarChar, 300);

                Cmd.Parameters["@Err"].Direction = ParameterDirection.InputOutput;

                Cmd.Parameters["@Username"].Value = User.Username;
                Cmd.Parameters["@Password"].Value = User.Password;
                Cmd.Parameters["@Err"].Value = "";

                Cmd.ExecuteNonQuery();

                var Err = Cmd.Parameters["@Err"].Value.ToNullString();

                if (Err != "") return new ApiResult(Err);

                var DT = MyServer.ToData(Cmd);

                if (DT == null || DT.Rows.Count == 0) return new ApiResult("Invalid username/password");

                var Row = DT.Rows[0];
                var Model = Table.ToUser(Row);

                return new ApiResult("Success", true, Model);
            }
            catch (Exception ex)
            {
                log.WriteError(ex.Message, "CMS Login");
                return new ApiResult("Something went wrong in your request");
            }
        }

        #endregion

        #region " Register "

        public ApiResult Register(User_Account User)
        {
            try
            {
                using var Con = MyServer.Connection();
                using var Cmd = new SqlCommand("SP_SYS_Register", Con)
                {
                    CommandType = CommandType.StoredProcedure
                };
                Cmd.Parameters.Add("@Name", SqlDbType.VarChar, 80);
                Cmd.Parameters.Add("@Username", SqlDbType.VarChar, 70);
                Cmd.Parameters.Add("@Password", SqlDbType.VarChar, 35);
                Cmd.Parameters.Add("@Err", SqlDbType.VarChar, 300);

                Cmd.Parameters["@Err"].Direction = ParameterDirection.InputOutput;

                Cmd.Parameters["@Name"].Value = User.Name;
                Cmd.Parameters["@Username"].Value = User.Email;
                Cmd.Parameters["@Password"].Value = User.Password;
                Cmd.Parameters["@Err"].Value = "";

                Cmd.ExecuteNonQuery();

                var Err = Cmd.Parameters["@Err"].Value.ToNullString();

                if (Err != "") return new ApiResult(Err);

                return new ApiResult("Success", true);
            }
            catch (Exception ex)
            {
                log.WriteError(ex.Message, "CMS Register");
                return new ApiResult("Something went wrong in your request");
            }
        }

        #endregion

        #region " Password Change "

        public ApiResult PasswordChange(User_Account Model)
        {
            try
            {
                Model.Password = Model.Password.ToSkin();

                using var Con = MyServer.Connection();
                using var Cmd = new SqlCommand("SP_SYS_Password_Change", Con)
                {
                    CommandType = CommandType.StoredProcedure
                };
                Cmd.Parameters.Add("@User_ID", SqlDbType.Int);
                Cmd.Parameters.Add("@Password", SqlDbType.VarChar, 35);
                Cmd.Parameters.Add("@Err", SqlDbType.VarChar, 300);

                Cmd.Parameters["@Err"].Direction = ParameterDirection.InputOutput;

                Cmd.Parameters["@User_ID"].Value = Model.ID.ToDecode();
                Cmd.Parameters["@Password"].Value = Model.Password;
                Cmd.Parameters["@Err"].Value = "";

                Cmd.ExecuteNonQuery();

                var Err = Cmd.Parameters["@Err"].Value.ToNullString();

                if (Err != "") return new ApiResult(Err);

                return new ApiResult("Password was successfully changed!", true, Model);
            }
            catch (Exception ex)
            {
                log.WriteError(ex.Message, "Change Password");
                return new ApiResult("Something went wrong in your request!");
            }
        }

        #endregion

        #region " Rental Submit "

        public Rental_Response Rantals_Submit(Rental Model)
        {
            try
            {
                using var Con = MyServer.Connection();
                using var Cmd = new SqlCommand("SP_CRM_Rentals", Con)
                {
                    CommandType = CommandType.StoredProcedure
                };
                Cmd.Parameters.Add("@Code", SqlDbType.VarChar, 35);
                Cmd.Parameters.Add("@Rental_Date", SqlDbType.VarChar, 25);
                Cmd.Parameters.Add("@Bike_ID", SqlDbType.Int);
                Cmd.Parameters.Add("@Customer", SqlDbType.VarChar, 80);
                Cmd.Parameters.Add("@Customer_Mobile", SqlDbType.VarChar, 10);
                Cmd.Parameters.Add("@Customer_Address", SqlDbType.VarChar, 300);
                Cmd.Parameters.Add("@Hourly_Usage", SqlDbType.Int);
                Cmd.Parameters.Add("@Rental_Start", SqlDbType.VarChar, 25);

                Cmd.Parameters["@Code"].Direction = ParameterDirection.InputOutput;

                Cmd.Parameters["@Code"].Value = "";
                Cmd.Parameters["@Rental_Date"].Value = Model.Rental_Date;
                Cmd.Parameters["@Bike_ID"].Value = Model.Bike_ID;
                Cmd.Parameters["@Customer"].Value = Model.Customer;
                Cmd.Parameters["@Customer_Mobile"].Value = Model.Customer_Mobile;
                Cmd.Parameters["@Customer_Address"].Value = Model.Customer_Address;
                Cmd.Parameters["@Hourly_Usage"].Value = Model.Hourly_Usage;
                Cmd.Parameters["@Rental_Start"].Value =Model.Rental_Start;
 
                Cmd.ExecuteNonQuery();

                Model.Rental_No = Cmd.Parameters["@Code"].Value.ToNullString();

                return new Rental_Response("Your bike rental was successfuly submitted", true, Model);
            }
            catch (Exception ex)
            {
                log.WriteError(ex.Message, "Rentals-Submit");
                return new Rental_Response("Something went wrong in your request");
            }
        }

        #endregion

        #region " Rental Accept "

        public Data_Response Rentals_Accept(int Rental_ID, int Collection_ID, int Stamper_ID)
        {
            try
            {
                using var Con = MyServer.Connection();
                using var Cmd = new SqlCommand("SP_CRM_Rentals_Accept", Con)
                {
                    CommandType = CommandType.StoredProcedure
                };
                Cmd.Parameters.AddWithValue("@Rental_ID", Rental_ID);
                Cmd.Parameters.AddWithValue("@Collection_ID", Collection_ID);
                Cmd.Parameters.AddWithValue("@Processor_ID", Stamper_ID);
                Cmd.ExecuteNonQuery();

                return new Data_Response("The rental status was successfuly accepted", true);
            }
            catch (Exception ex)
            {
                log.WriteError(ex.Message, "Rentals-Accept");
                return new Data_Response("Something went wrong in your request");
            }
        }

        #endregion

        #region " Rental Denied "

        public Data_Response Rentals_Denied(int Rental_ID, int Stamper_ID)
        {
            try
            {
                using var Con = MyServer.Connection();
                using var Cmd = new SqlCommand("SP_CRM_Rentals_Denied", Con)
                {
                    CommandType = CommandType.StoredProcedure
                };
                Cmd.Parameters.AddWithValue("@Rental_ID", Rental_ID);
                Cmd.Parameters.AddWithValue("@Processor_ID", Stamper_ID);
                Cmd.ExecuteNonQuery();

                return new Data_Response("The rental status was successfuly denied", true);
            }
            catch (Exception ex)
            {
                log.WriteError(ex.Message, "Rentals-Denied");
                return new Data_Response("Something went wrong in your request");
            }
        }

        #endregion

        #region " Sales "

        public Data_Response Sales_Save(Rental_Sales Model)
        {
            try
            {
                using var Con = MyServer.Connection();
                using var Cmd = new SqlCommand("SP_TRN_Sales_Save", Con)
                {
                    CommandType = CommandType.StoredProcedure
                };
                Cmd.Parameters.AddWithValue("@Rental_ID", Model.Rental_ID);
                Cmd.Parameters.AddWithValue("@Rental_Date", Model.Rental_Date);
                Cmd.Parameters.AddWithValue("@Rent", Model.Rent);
                Cmd.Parameters.AddWithValue("@Penalty", Model.Penalty);
                Cmd.Parameters.AddWithValue("@Total", Model.Total);
                Cmd.Parameters.AddWithValue("@Stamper_ID", Model.Stamper_ID);
                Cmd.ExecuteNonQuery();

                return new Data_Response("The rental status was successfuly returned", true);
            }
            catch (Exception ex)
            {
                log.WriteError(ex.Message, "Rentals-Save");
                return new Data_Response("Something went wrong in your request");
            }
        }

        #endregion

    }
}