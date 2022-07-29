use rand::Rng;
use std::io;
use std::io::Write;

fn main() {
    let number = rand::thread_rng().gen_range(1..6);

    let mut guesses = 1;

    fn get_number() -> i32 {
        let mut buffer = String::new();
        io::stdin()
            .read_line(&mut buffer)
            .expect("Stdin Failed");

        match buffer.trim().parse::<i32>() {
            Ok(n) => n,
            Err(_) => -1,
        }
    }
    print!("guess 1 - 5: ");
    io::stdout().flush().unwrap();
    let mut guess = get_number();

    while guess != number {
        if guess < number {
            println!("guess higher!");
        } else {
            println!("guess lower!");
        }

        guess = get_number();
        guesses += 1;
    }

    println!("you got it in {} tries", guesses);
}
