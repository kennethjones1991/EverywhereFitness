//
//  FitnessClass+Convenience.swift
//  EverywhereFitness
//
//  Created by Kenneth Jones on 1/19/21.
//

import Foundation
import CoreData

enum ClassType: String, CaseIterable {
    case yoga, running, boxing, weightlifting, dancing, biking
}

enum Intensity: String, CaseIterable {
    case beginner, intermediate, advanced
}

extension FitnessClass {
    var classRepresentation: FitnessClassRepresentation? {
        guard let name = name,
              let type = type,
              let intensity = intensity,
              let location = location else { return nil }
        
        return FitnessClassRepresentation(identifier: identifier?.uuidString ?? "", name: name, type: type, dateTime: dateTime ?? Date(), duration: Int(duration), intensity: intensity, location: location, maxSize: Int(maxSize))
    }
    
    @discardableResult convenience init(identifier: UUID = UUID(),
                                        name: String,
                                        type: ClassType,
                                        dateTime: Date,
                                        duration: Int,
                                        intensity: Intensity,
                                        location: String,
                                        maxSize: Int,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.identifier = identifier
        self.name = name
        self.type = type.rawValue
        self.dateTime = dateTime
        self.duration = Int16(duration)
        self.intensity = intensity.rawValue
        self.location = location
        self.maxSize = Int16(maxSize)
    }
    
    @discardableResult convenience init?(classRepresentation: FitnessClassRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        guard let type = ClassType(rawValue: classRepresentation.type),
              let intensity = Intensity(rawValue: classRepresentation.intensity),
              let identifier = UUID(uuidString: classRepresentation.identifier) else {
            return nil }
        
        self.init(identifier: identifier,
                  name: classRepresentation.name,
                  type: type,
                  dateTime: classRepresentation.dateTime,
                  duration: classRepresentation.duration,
                  intensity: intensity,
                  location: classRepresentation.location,
                  maxSize: classRepresentation.maxSize,
                  context: context)
    }
}
