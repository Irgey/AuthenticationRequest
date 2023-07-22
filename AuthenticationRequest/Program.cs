using System;
using System.IO;
using System.Net;

namespace AuthenticationRequest
{
    class Program
    {
        static void Main(string[] args)
        {
            CreatioDataFetcher login = new CreatioDataFetcher("https://01195748-5-demo.creatio.com/", "Supervisor", "Supervisor", "I:/result.html");
            login.TryFetchData();
            Console.WriteLine("For exit press ENTER...");
            Console.ReadLine();
        }
    }
}
