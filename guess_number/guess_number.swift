let number = Int.random(in: 1...5)

var guess: Int
var guesses = 1

print("guess 1-5:", terminator: " ")

guess = Int(readLine() ?? "-1") ?? -1

while guess != number {
    if guess < number {
        print("guess higher!")
    } else {
        print("guess lower!")
    }

    guess = Int(readLine() ?? "-1") ?? -1
    guesses += 1
}

print("you got it in \(guesses) tries")