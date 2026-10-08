using System;

class Program
{
    static void Main()
    {
        Console.Write("Geben Sie eine natürliche Zahl ein: ");
        int zahl = Convert.ToInt32(Console.ReadLine());

        Console.WriteLine("1) Quadrat");
        Console.WriteLine("2) Wurzel");
        Console.WriteLine("3) Fakultät");

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
    }
}