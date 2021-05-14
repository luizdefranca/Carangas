//  Rest.swift
//  Carangas
//
//  Created by Luiz on 5/10/21.

import Foundation



public enum NetworkRoute: String{

    case basePath = "https://carangas.herokuapp.com/cars"
    case urlFipe = "https://fipeapi.appspot.com/api/1/carros/marcas.json"

}

enum RestOperator: String {
    case save = "POST"
    case update = "PUT"
    case delete = "DELETE"
}

class Rest {

    //MARK: Proprieties
    private static let basePath = "https://carangas.herokuapp.com/cars"
    private static let urlFipe = "https://fipeapi.appspot.com/api/1/carros/marcas.json"

    private static let session = URLSession(configuration: configuration)
    
    private static let configuration: URLSessionConfiguration = {
        let config = URLSessionConfiguration.default
        config.allowsCellularAccess = true
        config.httpAdditionalHeaders = ["Content-Type":"application/json"]
        config.timeoutIntervalForRequest = 10.0
        config.httpMaximumConnectionsPerHost = 5
        return config
    }()


    class func loadCars(onComplete: @escaping([Car]) -> Void, onError: @escaping (RestError) -> Void) {
        
        var cars = [Car]()
        guard let url = URL(string: NetworkRoute.basePath.rawValue) else {
            onError(RestError.url)
            return
        }
        
        Rest.session.dataTask(with: url) { (data: Data?,
                                            response: URLResponse?,
                                            error: Error?) in
            
            if error == nil {
                guard let response = response as? HTTPURLResponse else {return}
                if response.statusCode == 200 {


                    guard let data = data else {
                        onError(.noData)
                        return
                    }
                    onError(.noData)
                    print(RestError.noData.description)
                    return

                    do {
                        cars = try JSONDecoder().decode([Car].self, from: data)
                        
                        cars.forEach { car in 
                            print(car.name)
                        }
                        onComplete(cars)
                        
                    } catch {
                        // algum erro ocorreu com os dados
                        onError(.invalidJSON)
                        print(error.localizedDescription)
                    }
                } else {
                    print("Algum status inválido(-> \(response.statusCode) <-) pelo servidor!! ")
                }
            } else {
                onError(.taskError(error: error!))
                print(error.debugDescription)
            }
            
        }.resume()
    }
    
    //TODO: Refactory
    
    class func save(car: Car, onComplete: @escaping (Bool) -> Void){
        applyOperation(car: car, operation: .save, onComplete: onComplete)
        /*
         guard let url = URL(string: basePath) else {
         onComplete(false)
         return
         }
         var request = URLRequest(url: url)
         request.httpMethod = "POST"
         // transformar objeto para um JSON, processo contrario do decoder -> Encoder
         guard let jsonData = try? JSONEncoder().encode(car) else {
         onComplete(false)
         return
         }
         request.httpBody = jsonData

         let dataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
         if error == nil {

         // verificar e desembrulhar em uma unica vez
         guard let response = response as? HTTPURLResponse, response.statusCode == 200, let _ = data else {
         onComplete(false)
         return
         }

         // sucesso
         onComplete(true)

         } else {
         onComplete(false)
         }
         }
         dataTask.resume()

         */
    }


    class func update(car: Car, onComplete: @escaping (Bool) -> Void ) {
        applyOperation(car: car, operation: .update, onComplete: onComplete)
        /*
         // 1 -- bloco novo: o endpoint do servidor para UPDATE é: URL/id
         let urlString = basePath + "/" + car._id!

         // 2 -- usar a urlString ao invés da basePath
         guard let url = URL(string: urlString) else {
         onComplete(false)
         return
         }

         // 3 -- o verbo do httpMethod deve ser alterado para PUT ao invés de POST
         var request = URLRequest(url: url)
         request.httpMethod = "PUT"
         let dataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
         if error == nil {

         // verificar e desembrulhar em uma unica vez
         guard let response = response as? HTTPURLResponse, response.statusCode == 200, let _ = data else {
         onComplete(false)
         return
         }

         // sucesso
         onComplete(true)

         } else {
         onComplete(false)
         }
         }
         dataTask.resume()
         */
    }

    class func delete(car: Car, onComplete: @escaping (Bool) -> Void) {
        applyOperation(car: car, operation: .delete, onComplete: onComplete)
    }

    private class func applyOperation(car: Car, operation: RestOperator , onComplete: @escaping (Bool) -> Void ) {
        print("function: \(#function)")
        
        let urlString = NetworkRoute.basePath.rawValue + "/" + (car._id ?? "")

        //Add UTF-8 Encode Capacibility

        guard let escapedString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: escapedString) else {
            print("\(RestError.url.description) \n - file: \(#file) function: \(#function) line: \(#line) ")
            onComplete(false)
            return
        }

        var request = URLRequest(url: url)
        var httpMethod = ""

        switch operation {
            case .delete:
                httpMethod = RestOperator.delete.rawValue
                print("Delete Method")
            case .save:
                print("Save Method")
                httpMethod = RestOperator.save.rawValue
            case .update:
                print("Update Method")
                httpMethod = RestOperator.update.rawValue
        }

        request.httpMethod = httpMethod
        guard let jsonData = try? JSONEncoder().encode(car) else {
            print("\(RestError.invalidJSON.description) \n - file: \(#file) function: \(#function) line: \(#line)")
        onComplete(false)
        return
        }
        request.httpBody = jsonData

        session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if error == nil {
                // verificar e desembrulhar em uma unica vez
                guard let response = response as? HTTPURLResponse, response.statusCode == 200, let _ = data else {
                    print("\(RestError.noResponse.description) \n - file: \(#file) function: \(#function) line: \(#line) ")
                    onComplete(false)
                    return
                }

                // ok
                onComplete(true)

            } else {
                print("\(RestError.noResponse.description) \n - file: \(#file) function: \(#function) line: \(#line) ")
                onComplete(false)
            }
        }.resume()
    }

    class func loadBrands(onComplete: @escaping ([Brand]?) -> Void, onError: @escaping (RestError)-> Void){

        guard let url = URL(string: NetworkRoute.urlFipe.rawValue) else {
            print("\(RestError.url.description) - \(#file) - \(#function) - \(#line)")
            onError(.url)
            return
        }
        session.dataTask(with: url) { (data, response, error) in
            if error == nil {

                guard let httpResponse = response as? HTTPURLResponse else {
                    onError(.url)
                    print("\(RestError.noResponse.description) - \(#file) - \(#function) - \(#line)")
                    return
                }

                if httpResponse.statusCode == 200 {
                    guard let data = data else {
                        onError(.noData)
                        print("\(RestError.noData.description) - \(#file) - \(#function) - \(#line)")
                        return
                    }
                    do {
                        let brands = try JSONDecoder().decode([Brand].self, from: data)
                        dump(brands)
                        onComplete(brands)
                    } catch  {
                        onError(.invalidJSON)
                        print("\(RestError.invalidJSON.description) - \(#file) - \(#function) - \(#line)")
                        return
                    }

                } else {
                    onError(.responseStatusCode(code: httpResponse.statusCode))
                    print("\(RestError.responseStatusCode(code: httpResponse.statusCode).description) - \(#file) - \(#function) - \(#line)")
                    return
                }
            } else {
                //TODO: - Create an error for this case
                print("Task with error")
            }
        }.resume()
    }

    class func fetchCars<T: Codable>(onComplete: @escaping(Result<T, RestError>) -> Void )//, onError: @escaping (RestError) -> Void)
    {

        guard let url = URL(string: NetworkRoute.basePath.rawValue) else {
            onComplete( .failure(RestError.url))
            return
        }

        Rest.session.dataTask(with: url) { (data: Data?,
                                            response: URLResponse?,
                                            error: Error?) in
            var requestedData : T
            if error == nil {
                guard let response = response as? HTTPURLResponse else {return}
                if response.statusCode == 200 {


                    guard let data = data else {
                        onComplete(.failure(.noData))
                        return
                    }

                    do {
                        requestedData = try JSONDecoder().decode(T.self, from: data)

                        dump(requestedData)
                        onComplete(.success(requestedData) )

                    } catch {
                        // algum erro ocorreu com os dados
                        onComplete(.failure(.invalidJSON))
                        print(error.localizedDescription)
                    }
                } else {
                    onComplete(.failure(.responseStatusCode(code: response.statusCode)))
                    print("Algum status inválido(-> \(response.statusCode) <-) pelo servidor!! ")
                    print("\(RestError.responseStatusCode(code: response.statusCode).description) - \(#file) - \(#function) - \(#line)")
                }
            } else {
                onComplete(.failure(.taskError(error: error!)))
                print("\(RestError.taskError(error: error!)).description) - \(#file) - \(#function) - \(#line)")
            }

        }.resume()
    }
}




/*
 func fetchPosts(url: URL, completion: @escaping (Result<[Post],NetworkError>) -> Void) {

     URLSession.shared.dataTask(with: url) { data, response, error in

         guard let data = data, error == nil else {
             if let error = error as NSError?, error.domain == NSURLErrorDomain {
                     completion(.failure(.domainError))
             }
             return
         }

         do {
             let posts = try JSONDecoder().decode([Post].self, from: data)
             completion(.success(posts))
         } catch {
             completion(.failure(.decodingError))
         }

     }.resume()

 }

 let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!

 fetchPosts(url: url) { result in

     switch result {
         case .success(let posts):
             print(posts)
         case .failure:
             print("FAILED")
     }
 }

 */
