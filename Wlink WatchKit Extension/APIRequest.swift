import Foundation

enum APIError:Error {
    case responseProblem
    case decodingProblem
    case encodingProblem
}

struct APIRequest {
    let resourceURL: URL
    init(loc: String) {
        let resourceString = "http://192.168.0.7:8080/\(loc)"
        guard let resourceURL = URL(string: resourceString) else {fatalError()}
        self.resourceURL = resourceURL
    }
    
    func findCust (_ email: String, completion: @escaping(Result<Person, APIError>) -> Void) {
        
        do {
            var urlRequest = URLRequest(url: resourceURL)
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, _ in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200,
                let jsonData = data else{
                completion(.failure(.responseProblem))
                return
            }
            do{
                let messageData = try JSONDecoder().decode(Person.self, from: jsonData)
                completion(.success(messageData))
                }catch{
                    completion(.failure(.decodingProblem))
                }
            }
            dataTask.resume()
        }catch{
            completion(.failure(.encodingProblem))
        }
    }
    
    func save (_ customer: Person, completion: @escaping(Result<Person, APIError>) -> Void) {
    
        do {
            var urlRequest = URLRequest(url: resourceURL)
            urlRequest.httpMethod = "POST"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = try JSONEncoder().encode(customer)
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, _ in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200,
                let jsonData = data else{
                completion(.failure(.responseProblem))
                return
            }
            do{
                let messageData = try JSONDecoder().decode(Person.self, from: jsonData)
                completion(.success(messageData))
                }catch{
                    completion(.failure(.decodingProblem))
                }
            }
            dataTask.resume()
        }catch{
            completion(.failure(.encodingProblem))
        }
        
        func deleteCust (_ email: String, completion: @escaping(Result<Person, APIError>) -> Void) {
            
            do {
                var urlRequest = URLRequest(url: resourceURL)
                urlRequest.httpMethod = "DELETE"
                let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, _ in
                    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200,
                    let jsonData = data else{
                    completion(.failure(.responseProblem))
                    return
                }
                do{
                    let messageData = try JSONDecoder().decode(Person.self, from: jsonData)
                    completion(.success(messageData))
                    }catch{
                        completion(.failure(.decodingProblem))
                    }
                }
                dataTask.resume()
            }catch{
                completion(.failure(.encodingProblem))
            }
        }
    }
}
