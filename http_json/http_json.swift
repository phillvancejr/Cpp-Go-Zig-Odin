import Foundation

// conform to Decodable protocol
struct Person: Decodable {
    var name: String
    var eye_color: String
}

// like a Go wait group?
let wait = DispatchGroup()
wait.enter()

let url = URL(string: "https://swapi.dev/api/people/1")!
let task = URLSession.shared.dataTask(with: url) { data, response, error in
    guard 
        let data = data,
        error == nil 
    else { 
        print("ERROR \(error!)")
        return
     }

    // just print json
    // let json = try? JSONSerialization.jsonObject(with: data, options: [])
    // print("\(json!)")

    // decode into struct
    let decoder = JSONDecoder()
    let luke = try! decoder.decode(Person.self, from: data)

    print("\(luke.name) has \(luke.eye_color) eyes")
    wait.leave()
}

// launch task
task.resume()
// wait for the task to finish
wait.wait()