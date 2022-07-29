use std::net::{ TcpListener };
use std::io::{  Write,
                BufRead,
                BufReader }; // traits used by TcpStream

fn main() -> std::io::Result<()> {
    let server = TcpListener::bind("127.0.0.1:8000")?;
    println!("listening on port 8000");

    let (mut client, _) = server.accept()?;
    println!("client connected!");
    client.write("Welcome to Rust Chat!\n".as_bytes())?;

    loop {
        let mut msg = String::new();
        let mut reader = BufReader::new(client.try_clone().unwrap());

        if reader.read_line(&mut msg).unwrap() == 0 {
            println!("client disconnected!");
            break;
        }

        if msg.contains("bye") {
            println!("it's so hard to say goodbye!");
            client.write("good bye!\n".as_bytes())?;
            drop(client);
            break;
        }

        let mut reply = "echo: ".to_owned();
        reply.push_str(&msg);
        client.write(reply.as_bytes())?;

        print!("{}", msg);
    }

    println!("shutting down");

    Ok(())
}
