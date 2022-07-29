#[derive(serde::Deserialize, Debug)]
struct Person {
    name: String,
    eye_color: String,
}

fn main()  {
    let luke =  reqwest::blocking::get("https://swapi.dev/api/people/1").unwrap()
                .json::<Person>().unwrap();

    println!("{} has {} eyes!", luke.name, luke.eye_color);
}
