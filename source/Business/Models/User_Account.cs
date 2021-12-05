using Microsoft.AspNetCore.Http;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace web.urapz
{
    public class User_Account
    {
        public string ReturnURL { get; set; } = "";
        public bool RememberMe { get; set; } = false;
        public string NewPassword { get; set; } = "";
        public string ConfirmPassword { get; set; } = "";
        public string ID { get; set; } = "";
        public string Role_ID { get; set; } = "";
        public string Role { get; set; } = "";
        public string Name { get; set; } = "";
        public string Email { get; set; } = "";
        public string Username { get; set; } = "";
        public string Password { get; set; } = "";
        public string Mobile { get; set; } = "";
        public string PIN { get; set; } = "";
        public string Code { get; set; } = "";
        public string Password_Old { get; set; } = "";
        public string Password_New { get; set; } = "";
        public string Password_Confirm { get; set; } = "";
        public string Photo { get; set; } = "";
        public IFormFile Photo_Upload { get; set; } = null;
        public string Last_Login { get; set; } = "";
        public string Status { get; set; } = "";
    }
}