//
//  CreateViewController.swift
//  EverywhereFitness
//
//  Created by Kenneth Jones on 1/19/21.
//

import UIKit

class CreateViewController: UIViewController {
    
    @IBOutlet weak var classNameField: UITextField!
    @IBOutlet weak var classTypeField: UITextField!
    @IBOutlet weak var dateTimeField: UITextField!
    @IBOutlet weak var durationField: UITextField!
    @IBOutlet weak var intensityControl: UISegmentedControl!
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var maxSizeField: UITextField!
    
    var fitClassController = FitnessClassController()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveNewClass(_ sender: UIBarButtonItem) {
        NotificationCenter.default.post(name: .fitnessClassCreated, object: nil)
    }
    
    @IBAction func cancelNewClass(_ sender: UIBarButtonItem) {
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
