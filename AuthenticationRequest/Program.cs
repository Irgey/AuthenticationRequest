using System;
using System.IO;
using System.Net;

namespace AuthenticationRequest
{
    class Program
    {
        static void Main(string[] args)
        {
            CreatioLogin login = new CreatioLogin("http://localhost/7.15.1.1295_SalesEnterprise", "Supervisor", "Supervisor");
            login.TryLogin();
            Console.WriteLine("Для выхода нажмите ENTER...");
            Console.ReadLine();
        }
    }
}
