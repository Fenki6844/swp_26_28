interface Verkaufbar {
    readonly Name: string;
    readonly Preis: number;
}

class Fahrzeug implements Verkaufbar {
    private fahrzeugtyp: string;
    private name: string;
    private preis: number;

    get Fahrzeugtyp(): string {
        return this.fahrzeugtyp;
    }

    get Name(): string {
        return this.name;
    }

    get Preis(): number {
        return this.preis;
    }

    constructor(fahrzeugtyp: string, name: string, preis: number) {
        this.fahrzeugtyp = fahrzeugtyp;
        this.name = name;
        this.preis = preis;
    }
}

class Fahrrad extends Fahrzeug {
    private anzahlGaenge: number;

    get AnzahlGaenge(): number {
        return this.anzahlGaenge;
    }

    constructor(name: string, anzahlGaenge: number, preis: number) {
        super("Fahrrad", name, preis);
        this.anzahlGaenge = anzahlGaenge;
    }
}

class Auto extends Fahrzeug {
    private anzahlTueren: number;

    get AnzahlTueren(): number {
        return this.anzahlTueren;
    }

    constructor(fahrzeugtyp: string, name: string, anzahlTueren: number, preis: number) {
        super(fahrzeugtyp, name, preis);
        this.anzahlTueren = anzahlTueren;
    }
}

class PKW extends Auto {
    private motorTyp: string;

    get MotorTyp(): string {
        return this.motorTyp;
    }

    constructor(name: string, anzahlTueren: number, motorTyp: string, preis: number) {
        super("PKW", name, anzahlTueren, preis);
        this.motorTyp = motorTyp;
    }
}

class LKW extends Auto {
    private motorTyp: string;

    get MotorTyp(): string {
        return this.motorTyp;
    }

    constructor(name: string, anzahlTueren: number, motorTyp: string, preis: number) {
        super("LKW", name, anzahlTueren, preis);
        this.motorTyp = motorTyp;
    }
}

class Garage {
    private verkaufbareDinge: Verkaufbar[] = [];

    public add(ding: Verkaufbar): void {
        this.verkaufbareDinge.push(ding);
    }

    public getDinge(): Verkaufbar[] {
        return this.verkaufbareDinge;
    }

    public anzahlFahrzeuge(): number {
        return this.verkaufbareDinge.filter(item => item instanceof Fahrzeug).length;
    }

    public anzahlAutos(): number {
        return this.verkaufbareDinge.filter(item => item instanceof Auto).length;
    }
}

const myBMWWith4Doors = new PKW("BMW", 4, "Benzin", 45000);
const myBMWWith2Doors = new PKW("BMW", 2, "Benzin", 38000);
const myMANWith2Doors = new LKW("MAN", 2, "Diesel", 120000);
const myFahrrad = new Fahrrad("Mountainbike", 21, 900);

const myGarage = new Garage();
myGarage.add(myBMWWith4Doors);
myGarage.add(myBMWWith2Doors);
myGarage.add(myMANWith2Doors);
myGarage.add(myFahrrad);

console.log(`Anzahl Fahrzeuge in der Garage: ${myGarage.anzahlFahrzeuge()} davon Autos: ${myGarage.anzahlAutos()}`);
