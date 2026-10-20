using System;
using System.IO;

public class Kuh
{
    private string _name;
    private string _colour;

    public string Name => _name;
    public string Colour => _colour;

    public Kuh(string name, string colour)
    {
        if (string.IsNullOrEmpty(name))
        {
            throw new InvalidDataException("Der Name der Kuh darf nicht leer sein.");
        }

        _name = name;
        _colour = colour;
    }
}