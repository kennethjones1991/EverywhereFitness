//
//  HomeViewController.swift
//  EverywhereFitness
//
//  Created by Kenneth Jones on 1/19/21.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

//        if let secondTab = self.tabBarController?.viewControllers?[1] as? ProfileViewController {
//            secondTab.fitClassController = fitClassController
//        }
//
//        if let thirdTab = self.tabBarController?.viewControllers?[1] as? ScheduleTableViewController {
//            thirdTab.fitClassController = fitClassController
//        }
//
//        if let fourthTab = self.tabBarController?.viewControllers?[1] as? CreateViewController {
//            fourthTab.fitClassController = fitClassController
//        }
    }
    
    
    @IBAction func visitProfile(_ sender: Any) {
        tabBarController?.selectedIndex = 1
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
