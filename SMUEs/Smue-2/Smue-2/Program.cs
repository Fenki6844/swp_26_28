using System;
using System.Linq;

class Program
{
    static void Main()
    {
        Console.Write("Geben Sie einen Wert ein: ");
        string eingabe = Console.ReadLine() ?? "";

        if (int.TryParse(eingabe, out int zahl))
        {
            Console.WriteLine("\nSie haben eine ganze Zahl eingegeben, welche mathematische Operation möchten Sie darauf ausführen?");
            Console.WriteLine("1) Addition");
            Console.WriteLine("2) Multiplikation");
            Console.WriteLine("3) Division");
            Console.WriteLine("4) Fakultät");
            Console.WriteLine("5) Wurzelziehen");
            Console.Write("Ihre Auswahl: ");

            int auswahl = Convert.ToInt32(Console.ReadLine() ?? "0");

            if (auswahl == 1)
            {
                Console.Write("Geben Sie einen Addend ein: ");
                int addend = Convert.ToInt32(Console.ReadLine());
                Console.WriteLine("Das Ergebnis der Addition ist: " + (zahl + addend));
            }

            if (auswahl == 2)
            {
                Console.Write("Geben Sie einen Multiplikator ein: ");
                int multiplikator = Convert.ToInt32(Console.ReadLine());
                Console.WriteLine("Das Ergebnis der Multiplikation ist: " + (zahl * multiplikator));
            }

            if (auswahl == 3)
            {
                Console.Write("Geben Sie einen Divisor ein: ");
                int divisor = Convert.ToInt32(Console.ReadLine() ?? "0");

                if (divisor == 0)
                {
                    Console.WriteLine("Fehler: Division durch 0 ist nicht erlaubt!");
                    return;
                }

                Console.WriteLine("Das Ergebnis der Division ist: " + (zahl / divisor));
            }

            if (auswahl == 4)
            {
                if (zahl < 0)
                {
                    Console.WriteLine("Fakultät ist für negative Zahlen nicht definiert.");
                    return;
                }

                int ergebnis = 1;
                for (int i = 1; i <= zahl; i++)
                {
                    ergebnis *= i;
                }
                Console.WriteLine("Die Fakultät ist: " + ergebnis);
            }

            if (auswahl == 5)
            {
                if (zahl < 0)
                {
                    Console.WriteLine("Wurzelziehen aus einer negativen Zahl ist nicht möglich.");
                    return;
                }

                Console.WriteLine("Die Wurzel ist: " + Math.Sqrt(zahl));
            }

            return;
        }

        Console.WriteLine("\nZeichenkette verarbeiten:");
        Console.WriteLine("1) Selbstlaute entfernen");
        Console.WriteLine("2) Umdrehen");
        Console.WriteLine("3) Zeichen zählen");
        Console.Write("Auswahl: ");

        int textAuswahl = Convert.ToInt32(Console.ReadLine() ?? "0");

        if (textAuswahl == 1)
        {
            string ergebnis = eingabe;
            foreach (char s in "aeiouAEIOUäöüÄÖÜ")
            {
                ergebnis = ergebnis.Replace(s.ToString(), "");
            }
            Console.WriteLine("Das Ergebnis ohne Selbstlaute ist: " + ergebnis);
        }

        if (textAuswahl == 2)
        {
            string umgedreht = new string(eingabe.Reverse().ToArray());
            Console.WriteLine("Das Ergebnis des Umdrehens ist: " + umgedreht);
        }

        if (textAuswahl == 3)
        {
            Console.WriteLine("Das Ergebnis der Zeichenanzahl ist: " + eingabe.Length);
        }
    }
}