using System;

class Program
{
    static void Main()
    {
        Console.WriteLine("=======================================");
        Console.WriteLine("Willkommen zum mathematischen Programm!");
        Console.WriteLine("=======================================");
        Console.Write("Geben Sie eine natürliche Zahl ein: ");
        int zahl = Convert.ToInt32(Console.ReadLine());

        Console.WriteLine("1) Quadrat");
        Console.WriteLine("2) Wurzel");
        Console.WriteLine("3) Fakultät");
        Console.WriteLine("4) Multiplikation");
        Console.WriteLine("5) Division");
        Console.WriteLine("6) Addition");
        Console.WriteLine("7) Subtraktion");

        Console.Write("Ihre Auswahl: ");
        int auswahl = Convert.ToInt32(Console.ReadLine());


        if (auswahl == 1)
        {
            Console.WriteLine("Das Quadrat ist: " + zahl * zahl);
        }

        if (auswahl == 2)
        {
            Console.WriteLine("Die Wurzel ist: " + Math.Sqrt(zahl));
        }

        if (auswahl == 3)
        {
            int ergebnis = 1;

            for (int i = 1; i <= zahl; i++)
            {
                ergebnis = ergebnis * i;
            }

            Console.WriteLine("Die Fakultät ist: " + ergebnis);
        }

        if (auswahl == 4)
        {
            Console.Write("Geben Sie einen Divisor ein: ");
            int divisor = Convert.ToInt32(Console.ReadLine());
            Console.WriteLine("Das Ergebnis der Division ist: " + (zahl / divisor));
        }

        if (auswahl == 5)
        {
            Console.Write("Geben Sie einen Multiplikator ein: ");
            int multiplikator = Convert.ToInt32(Console.ReadLine());
            Console.WriteLine("Das Ergebnis der Multiplikation ist: " + (zahl * multiplikator));
        }

        if (auswahl == 6)
        {
            Console.Write("Geben Sie einen Addend ein: ");
            int addend = Convert.ToInt32(Console.ReadLine());
            Console.WriteLine("Das Ergebnis der Addition ist: " + (zahl + addend));
        }

        if (auswahl == 7)
        {
            Console.Write("Geben Sie einen Subtrahenden ein: ");
            int subtrahend = Convert.ToInt32(Console.ReadLine());
            Console.WriteLine("Das Ergebnis der Subtraktion ist: " + (zahl - subtrahend));
        }
        Console.WriteLine("Zum beenden des Programms drücken Sie eine beliebige Taste.");
    }
}
