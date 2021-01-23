//
//  FitnessClassRepresentation.swift
//  EverywhereFitness
//
//  Created by Kenneth Jones on 1/19/21.
//

import Foundation

struct FitnessClassRepresentation: Codable {
    var identifier: String
    var name: String
    var type: String
    var duration: Int
    var intensity: String
    var location: String
    var maxSize: Int
}
