abstract class Animal {
    constructor(
        private readonly _name: string,
        private _colour: string,
        private readonly _birthDate: Date,
    ) {
        if (_birthDate > new Date()) {
            throw new Error("Geburtsdatum liegt in der Zukunft");
        }
    }

    public get Name(): string {
        return this._name;
    }

    public get Colour(): string {
        return this._colour;
    }

    public set Colour(value: string) {
        this._colour = value;
    }

    public get BirthDate(): Date {
        return this._birthDate;
    }

    public getAge(): number {
        const today = new Date();
        const birth = this._birthDate;
        const years = today.getFullYear() - birth.getFullYear();

        const todayKey = today.getMonth() * 100 + today.getDate();
        const birthKey = birth.getMonth() * 100 + birth.getDate();

        return todayKey >= birthKey ? years : years - 1;
    }

    public abstract makeSound(): void;
}

class Cow extends Animal {
    public makeSound(): void {
        console.log("Muuuuh");
    }
}

class Cat extends Animal {
    public makeSound(): void {
        console.log("Miau");
    }
}

const myKuh = new Cow("Kuh1", "weiß", new Date(2020, 4, 15));
const myKatze = new Cat("Katze1", "schwarz", new Date(2023, 11, 1));
const animals: Animal[] = [myKuh, myKatze];

animals.forEach(animal => animal.makeSound());
animals.forEach(animal => console.log(`${animal.Name} ist ${animal.getAge()} Jahre alt`));

console.log(`${myKuh.Name} wurde am ${myKuh.BirthDate.toLocaleDateString("de-DE")} geboren`);

const myKuh2 = myKuh;
console.log(myKuh2 === myKuh);
myKuh.Colour = "braun";
console.log(myKuh2.Colour);

try {
    new Cat("Katze2", "grau", new Date(2099, 0, 1));
} catch (e) {
    console.log(`Fehler: ${(e as Error).message}`);
}