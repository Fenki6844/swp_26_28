Console.Write("Geben Sie einen Text ein: ");
string text = Console.ReadLine();

char[] zeichen = text.ToCharArray();
Array.Reverse(zeichen);

string umgekehrt = new string(zeichen);

Console.WriteLine("Umgekehrt: " + umgekehrt);