using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace web.urapz
{
    public class Data_Response_Base
    { 
        public bool Success { get; set; } = false;
        public string Message { get; set; } = "";
    }

    public class Data_Response : Data_Response_Base
    {
        public string Data { get; set; } = "";
        public Data_Response(string message) { Message = message; }
        public Data_Response(string message, bool success) { Message = message; Success = success; }
        public Data_Response(string message, bool success, string data) { Message = message; Success = success; Data = data; }
    }

    public class Rental_Response : Data_Response_Base
    {
        public Rental Data { get; set; } = new Rental();
        public Rental_Response() { }
        public Rental_Response(string message) { Message = message; }
        public Rental_Response(string message, bool success) { Message = message; Success = success; }
        public Rental_Response(string message, bool success, Rental data) { Message = message; Success = success; Data = data; }
    }

}