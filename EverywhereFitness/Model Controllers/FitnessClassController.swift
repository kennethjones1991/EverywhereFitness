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
    case noRep
}

let baseURL = URL(string: "https://everywherefitness-58d32-default-rtdb.firebaseio.com/")!

class FitnessClassController {
    typealias CompletionHandler = (Result<Bool, NetworkError>) -> Void
    
    init() {
        fetchAll()
    }
    
    func createClass(fitnessClass: FitnessClass, completion: @escaping CompletionHandler = { _ in }) {
        guard let uuid = fitnessClass.identifier else {
            completion(.failure(.noIdentifier))
            return
        }
        
        let requestURL = baseURL.appendingPathComponent(uuid.uuidString).appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.put.rawValue
        
        do {
            guard let representation = fitnessClass.classRepresentation else {
                completion(.failure(.noRep))
                return
            }
            
            request.httpBody = try JSONEncoder().encode(representation)
        } catch {
            print("Error encoding class \(fitnessClass): \(error)")
            completion(.failure(.noEncode))
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print("Error PUTting class to server: \(error)")
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
    
    func fetchAll(completion: @escaping CompletionHandler = { _ in }) {
        let requestURL = baseURL.appendingPathExtension("json")
        
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            if let error = error {
                print("Error fetching classes: \(error)")
                DispatchQueue.main.async {
                    completion(.failure(.otherError))
                }
                return
            }
            
            guard let data = data else {
                print("No data returned by data task")
                DispatchQueue.main.async {
                    completion(.failure(.noData))
                }
                return
            }
            
            do {
                let classRepresentations = Array(try JSONDecoder().decode([String : FitnessClassRepresentation].self, from: data).values)
                
                try self.updateClasses(with: classRepresentations)
                DispatchQueue.main.async {
                    completion(.success(true))
                }
            } catch {
                print("Error decoding class representations: \(error)")
                DispatchQueue.main.async {
                    completion(.failure(.noDecode))
                }
                return
            }
        }.resume()
    }
    
    func deleteClass(_ fitnessClass: FitnessClass, completion: @escaping CompletionHandler = { _ in }) {
        guard let uuid = fitnessClass.identifier else {
            completion(.failure(.noIdentifier))
            return
        }
        
        let requestURL = baseURL.appendingPathComponent(uuid.uuidString).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.delete.rawValue
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            print(response!)
            completion(.success(true))
        }.resume()
    }
    
    private func update(fitnessClass: FitnessClass, with representation: FitnessClassRepresentation) {
        fitnessClass.name = representation.name
        fitnessClass.type = representation.type
        fitnessClass.dateTime = representation.dateTime
        fitnessClass.duration = Int16(representation.duration)
        fitnessClass.intensity = representation.intensity
        fitnessClass.location = representation.location
        fitnessClass.maxSize = Int16(representation.maxSize)
    }
    
    private func updateClasses(with representations: [FitnessClassRepresentation]) throws {
        let context = CoreDataStack.shared.container.newBackgroundContext()
        
        let identifiersToFetch = representations.compactMap({ UUID(uuidString: $0.identifier )})
        
        let representationsByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, representations))
        var classesToCreate = representationsByID
        
        let fetchRequest: NSFetchRequest<FitnessClass> = FitnessClass.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier IN %@", identifiersToFetch)
        
        context.perform {
            do {
                let existingClasses = try context.fetch(fetchRequest)
                
                for fitnessClass in existingClasses {
                    guard let id = fitnessClass.identifier,
                        let representation = representationsByID[id] else { continue }
                    
                    self.update(fitnessClass: fitnessClass, with: representation)
                    classesToCreate.removeValue(forKey: id)
                }
                
                for representation in classesToCreate.values {
                    FitnessClass(classRepresentation: representation, context: context)
                }
            } catch {
                print("Error fetching classes for UUIDs: \(error)")
            }
            
            do {
                try CoreDataStack.shared.save(context: context)
            } catch {
                print("There's an error!")
            }
        }
    }
}
