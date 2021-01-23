//
//  BigClassTableViewCell.swift
//  EverywhereFitness
//
//  Created by Kenneth Jones on 1/22/21.
//

import UIKit

class BigClassTableViewCell: UITableViewCell {
    
    @IBOutlet weak var classImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var intensityLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!

    static let reuseIdentifier = "BigFitnessClassCell"
    
    var fitnessClass: FitnessClass? {
        didSet {
            updateViews()
        }
    }
    
    private func updateViews() {
        guard let fitnessClass = fitnessClass else { return }
        
        nameLabel.text = fitnessClass.name
        typeLabel.text = fitnessClass.type?.capitalized
        intensityLabel.text = fitnessClass.intensity?.capitalized
        locationLabel.text = fitnessClass.location
        durationLabel.text = "\(fitnessClass.duration)min"
        
        switch fitnessClass.type {
        case "weights":
            classImageView.image = UIImage(named: "weights")
        case "cardio":
            classImageView.image = UIImage(named: "cardio")
        case "mma":
            classImageView.image = UIImage(named: "mma")
        default:
            classImageView.image = UIImage(named: "weights")
        }
    }

}
