using System;
using System.IO;
using System.Net;

namespace AuthenticationRequest
{
    class Program
    {
        static void Main(string[] args)
        {
            CreatioLogin login = new CreatioLogin("http://mycreatio.com", "Supervisor", "Supervisor");
            login.TryLogin();
            Console.WriteLine("Для выхода нажмите ENTER...");
            Console.ReadLine();
        }
    }
}
