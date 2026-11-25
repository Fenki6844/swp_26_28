using System;

Cow myCow = new Cow("Kuh1", "weiß");
myCow.MakeSound();        
myCow.MakeSound(8);       

Cat myCat = new Cat("Katze1", "grau");
myCat.MakeSound();        
myCat.MakeSound(6);       

class Animal
{
    private string _name;
    private string _colour;

    public string Name { get => _name; set => _name = value; }
    public string Colour { get => _colour; set => _colour = value; }

    public Animal(string name, string colour)
    {
        _name = name;
        _colour = colour;
    }
}

class Cow : Animal
{
    public Cow(string name, string colour) : base(name, colour) { }

    public void MakeSound()
    {
        Console.WriteLine("Muhhh");
    }

    public void MakeSound(int duration)
    {
        if (duration < 1) duration = 1;
        Console.WriteLine("Mu" + new string('h', duration));
    }
}

class Cat : Animal
{
    public Cat(string name, string colour) : base(name, colour) { }

    public void MakeSound()
    {
        Console.WriteLine("Miau");
    }

    public void MakeSound(int duration)
    {
        if (duration < 1) duration = 1;
        Console.WriteLine("Mi" + new string('a', duration) + "u");
    }
}