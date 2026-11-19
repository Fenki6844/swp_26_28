using System;

Cow myCow = new Cow("Kuh1", "weiß");
myCow.MakeSound();
Cat myCat = new Cat("Katze1", "grau");
myCat.MakeSound();
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
    public void MakeSound() { Console.WriteLine("Muhhh"); }
}

class Cat : Animal
{
    public Cat(string name, string colour) : base(name, colour) { }
    public void MakeSound() { Console.WriteLine("Miau"); }
}
