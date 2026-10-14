using System;
using System.Collections.Generic;
using System.Text;

namespace Projektorientierung_Teil_1
{
    public class Kuh
    {
        string _name; // private field to store the name of the cow

        string _colour; // private field to store the colour of the cow

        public string Name // public property to get the name of the cow
        {
            get { return _name; }
        }

        public string Colour // public property to get the colour of the cow
        {
            get { return _colour; }
        }

        // Constructor for the Kuh class
        public Kuh(string name, string colour)
        {
            _name = name;
            _colour = colour;
        }

    }
}
