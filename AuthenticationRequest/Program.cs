using System;
using System.IO;
using System.Net;

namespace AuthenticationRequest
{
    class Program
    {
        static void Main(string[] args)
        {
            CreatioLogin login = new CreatioLogin("https://01195748-5-demo.creatio.com/", "Supervisor", "Supervisor", "I:/result.html");
            login.TryLogin();
            Console.WriteLine("For exit press ENTER...");
            Console.ReadLine();
        }
    }
}
