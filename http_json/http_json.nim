import  httpclient,
        json

type Person = object
    name: string
    eye_color: string

let luke =  new_http_client()
            .get_content("https://swapi.dev/api/people/1")
            .parse_json()
            .to(Person)

echo luke.name & " has " & luke.eye_color & " eyes"