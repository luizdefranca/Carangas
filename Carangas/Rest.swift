//
//  Rest.swift
//  Carangas
//
//  Created by Luiz on 5/10/21.
//  Copyright © 2021 Eric Brito. All rights reserved.
//

import Foundation

enum CarError {
    case url
    case taskError(error: Error)
    case noResponse
    case noData
    case responseStatusCode(code: Int)
    case invalidJSON
}

class Rest {

    private static let basePath = "https://carangas.herokuapp.com/cars"

    // session criada automaticamente e disponivel para reusar
    private static let session = URLSession(configuration: configuration)

    private static let configuration: URLSessionConfiguration = {
        let config = URLSessionConfiguration.default
        config.allowsCellularAccess = true
        config.httpAdditionalHeaders = ["Content-Type":"application/json"]
        config.timeoutIntervalForRequest = 10.0
        config.httpMaximumConnectionsPerHost = 5
        return config
    }()

    class func loadCars(onComplete: @escaping([Car]) -> Void, onError: @escaping (CarError) -> Void) {

        var cars = [Car]()
        guard let url = URL(string: Rest.basePath) else {
            onError(CarError.url)
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
}
