//
//  CreateViewController.swift
//  EverywhereFitness
//
//  Created by Kenneth Jones on 1/19/21.
//

import UIKit

class CreateViewController: UIViewController {
    
    @IBOutlet weak var classNameField: UITextField!
    @IBOutlet weak var typeControl: UISegmentedControl!
    @IBOutlet weak var durationField: UITextField!
    @IBOutlet weak var intensityControl: UISegmentedControl!
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var maxSizeField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func saveNewClass(_ sender: UIBarButtonItem) {
        guard let name = classNameField.text,
              !name.isEmpty,
              let durationText = durationField.text,
              !durationText.isEmpty,
              let duration = Int(durationText),
              let location = locationField.text,
              !location.isEmpty,
              let maxSizeText = maxSizeField.text,
              !maxSizeText.isEmpty,
              let maxSize = Int(maxSizeText) else { return }
        
        var type: ClassType = .weights
        switch typeControl.selectedSegmentIndex {
        case 0:
            type = .weights
        case 1:
            type = .cardio
        case 2:
            type = .mma
        default:
            type = .weights
        }
        
        var intensity: Intensity = .beginner
        switch intensityControl.selectedSegmentIndex {
        case 0:
            intensity = .beginner
        case 1:
            intensity = .intermediate
        case 2:
            intensity = .advanced
        default:
            intensity = .beginner
        }
        
        let newClass = FitnessClass(name: name, type: type, duration: duration, intensity: intensity, location: location, maxSize: maxSize)
        
        FitnessClassController.sharedInstance.createClass(fitnessClass: newClass)
        try? CoreDataStack.shared.mainContext.save()
        
        NotificationCenter.default.post(name: .fitnessClassCreated, object: nil)
        
        let alert = UIAlertController(title: "Success!", message: "Your new fitness class was created!", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Awesome", style: .default) { (_) in
            self.classNameField.text = ""
            self.durationField.text = ""
            self.locationField.text = ""
            self.maxSizeField.text = ""
            self.typeControl.selectedSegmentIndex = 0
            self.intensityControl.selectedSegmentIndex = 0
        }
        
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func cancelNewClass(_ sender: UIBarButtonItem) {
        classNameField.text = ""
        durationField.text = ""
        locationField.text = ""
        maxSizeField.text = ""
        typeControl.selectedSegmentIndex = 0
        intensityControl.selectedSegmentIndex = 0
    }
}
