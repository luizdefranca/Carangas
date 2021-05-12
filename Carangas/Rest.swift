//
//  Rest.swift
//  Carangas
//
//  Created by Luiz on 5/10/21.
//  Copyright © 2021 Eric Brito. All rights reserved.
//

import Foundation

enum RestError: Error, CustomStringConvertible {
    case url
    case taskError(error: Error)
    case noResponse
    case noData
    case responseStatusCode(code: Int)
    case invalidJSON

    public var description: String {
        switch self {
            case .url:
                return "Invalid url"
            case .taskError(error: let error):
                return "Error running task - \(error)"
            case .noResponse:
                return "Request without response"
            case .noData:
                return "No valid data"
            case .responseStatusCode(code: let code):
                return "Invalid status code - \(code)"
            case .invalidJSON:
                return "Can't convert JSON"
        }
    }
}


enum RESTOperation: String {
    case save = "SAVE"
    case update = "UPDATE"
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
        guard let url = URL(string: Rest.basePath) else {
            onError(RestError.url)
            return
        }
        
        // tarefa criada, mas nao processada
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

    private class func applyOperation(car: Car, operation: RESTOperation , onComplete: @escaping (Bool) -> Void ) {

        let urlString = basePath + "/" + (car._id ?? "")
        var request = URLRequest(url: URL(string: urlString)!)
        var httpMethod = ""

        switch operation {
            case .delete:
                httpMethod = RESTOperation.delete.rawValue
                print("Delete Method")
            case .save:
                print("Save Method")
                httpMethod = RESTOperation.save.rawValue
            case .update:
                print("Update Method")
                httpMethod = RESTOperation.update.rawValue
        }

        request.httpMethod = httpMethod


        session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if error == nil {
                // verificar e desembrulhar em uma unica vez
                guard let response = response as? HTTPURLResponse, response.statusCode == 200, let _ = data else {
                    onComplete(false)
                    return
                }

                // ok
                onComplete(true)

            } else {
                onComplete(false)
            }
        }.resume()
    }

    class func loadBrands(onComplete: @escaping ([Brand]?) -> Void, onError: @escaping (RestError)-> Void){

        guard let url = URL(string: urlFipe) else {
            onError(.url)
            return
        }
        session.dataTask(with: url) { (data, response, error) in

            if error != nil {

                guard let httpResponse = response as? HTTPURLResponse else {
                    onComplete(nil)
                    return
                }
            }

        }
    }
}
