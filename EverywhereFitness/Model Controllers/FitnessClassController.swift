//
//  FitnessClassController.swift
//  EverywhereFitness
//
//  Created by Kenneth Jones on 1/19/21.
//

import Foundation
import CoreData

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum NetworkError: Error {
    case noIdentifier
    case otherError
    case noData
    case noDecode
    case noEncode
    case badResponse
}

let baseURL = URL(string: "https://everywherefitness-58d32-default-rtdb.firebaseio.com/")!

class FitnessClassController {
    typealias CompletionHandler = (Result<Bool, NetworkError>) -> Void

    func createClass(fitnessClass: FitnessClass, completion: @escaping CompletionHandler = { _ in }) {
        var request = URLRequest(url: baseURL)
        request.httpMethod = HTTPMethod.post.rawValue

        do {
            guard let representation = fitnessClass.classRepresentation else {
                completion(.failure(.badResponse))
                return
            }

            request.httpBody = try JSONEncoder().encode(representation)
        } catch {
            print("Error encoding class \(fitnessClass): \(error)")
            completion(.failure(.noEncode))
            return
        }

        URLSession.shared.dataTask(with: request) { (_, _, error) in
            if let error = error {
                print("Error POSTing class to server: \(error)")
                DispatchQueue.main.async {
                    completion(.failure(.otherError))
                    return
                }
            }

            DispatchQueue.main.async {
                completion(.success(true))
            }
        }.resume()
    }
    
    func fetchAll() {
        // TODO: fetch all classes
    }
    
    func fetchClass() {
        // TODO: fetch single class
    }
    
    func deleteClass() {
        // TODO
    }
    
    func updateClasses() {
        // TODO
    }
}
