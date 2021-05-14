//
//  RestProtocol.swift
//  Carangas
//
//  Created by Luiz on 5/13/21.
//  Copyright © 2021 Eric Brito. All rights reserved.
//

import Foundation

protocol RestProtocol {

    static func save<T:Encodable> (object: T, onComplete: @escaping (Result< Void , RestError>) -> Void)
    static func update<T:Encodable> (object: T, onComplete: @escaping (Result< Void , RestError>) -> Void)
    static func delete<T:Encodable> (object: T, onComplete: @escaping (Result< Void , RestError>) -> Void)
    static func fetchData<T: Codable>(onComplete: @escaping(Result<T, RestError>) -> Void )
    static func fetchCars<Car: Codable>(onComplete: @escaping(Result<Car, RestError>) -> Void )
    static func fetchBrands<Brand: Codable>(onComplete: @escaping(Result<Brand, RestError>) -> Void )
    
}
