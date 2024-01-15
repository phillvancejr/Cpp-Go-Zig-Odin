var rng = new Random();

var number = rng.Next(5) + 1;

var guess = -1;
var guesses = 1;

Console.Write("guess 1-5: ");
Int32.TryParse(Console.ReadLine(), out guess);

for (;guess != number; guesses++) {
    if (guess < number)
        Console.Write("guess higher! ");
    else
        Console.Write("guess  lower! ");

    if(!Int32.TryParse(Console.ReadLine(), out guess))
        guess = -1;
}

Console.WriteLine("you got it in {0} tries", guesses);