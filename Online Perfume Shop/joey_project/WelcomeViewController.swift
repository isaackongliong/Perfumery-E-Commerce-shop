//
//  intro.swift
//  joey_project
//
//  Created by user232692 on 2/21/23.
//  Copyright © 2023 ITE. All rights reserved.
//

import UIKit
import CoreData

class WelcomeViewController: UIViewController {
    let app = UIApplication.shared.delegate as! AppDelegate
    var context: NSManagedObjectContext!
    
    var userArray = [User]()
    var earn = 0
    var totalEarned: Int16 = 0
    @IBOutlet var welcome_lbl: UILabel!
    @IBOutlet var credits_lbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        context = app.persistentContainer.viewContext
        getcredit()
        // Do any additional setup after loading the view.
    }
    
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
                earn = Int.random(in: 10..<101)
                calculateEarn()
                popAlert(title: "Here's your reward", msg: "You earn \(earn) of credits")
                print("Shaked")
        }
    }
    
    @IBAction func cart_btn(_ sender: UIButton) {
        performSegue(withIdentifier: "toCartPage", sender: nil)
    }
    
    func getcredit(){
        do {
            let results = try context.fetch(User.fetchRequest())
            for result in results as! [User] {
                if (result.username == username) && (result.password == password) {
                    welcome_lbl.text = "Welcome, \(result.username!)"
                    credits_lbl.text = "You have\n\(result.credits)"
                }
            }
        } catch{
            print(error)
        }
    }
    
    func calculateEarn() {
        do {
            let results = try context.fetch(User.fetchRequest())
            for result in results as! [User] {
                totalEarned = result.credits + Int16(earn)
                result.credits = totalEarned
                credits_lbl.text = "You have\n\(result.credits)"
                try context.save()
            }
        } catch {
            print(error)
        }
    }

    func popAlert (title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
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
