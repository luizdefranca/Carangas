//
//  Rest.swift
//  Carangas
//
//  Created by Luiz on 5/10/21.
//  Copyright © 2021 Eric Brito. All rights reserved.
//

import Foundation

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

    func loadCars() {

        guard let url = URL(string: Rest.basePath) else {return}

        // tarefa criada, mas nao processada
        Rest.session.dataTask(with: url) { (data: Data?,
                                            response: URLResponse?,
                                            error: Error?) in

            if error == nil {
                guard let response = response as? HTTPURLResponse else {return}
                if response.statusCode == 200 {
                    guard let data = data else {return}

                    do {
                        let cars = try JSONDecoder().decode([Car].self, from: data)

                        cars.forEach { car in 
                            print(car.name)
                        }

                    } catch {
                        // algum erro ocorreu com os dados
                        print(error.localizedDescription)
                    }
                } else {
                    print("Algum status inválido(-> \(response.statusCode) <-) pelo servidor!! ")
                }
            } else {
                print(error.debugDescription)
            }

        }.resume()


    }
}
