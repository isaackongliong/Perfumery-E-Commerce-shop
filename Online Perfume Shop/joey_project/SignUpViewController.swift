//
//  SignUpViewController.swift
//  joey_project
//
//  Created by T04-09 on 14/2/23.
//  Copyright © 2023 ITE. All rights reserved.
//

import UIKit
import CoreData


class SignUpViewController: UIViewController {
    
    let app = UIApplication.shared.delegate as! AppDelegate
    var context:NSManagedObjectContext!
    
    var regArray = [User]()
    var credit = 200

    @IBOutlet var username_tf: UITextField!
    @IBOutlet var pwd1_tf: UITextField!
    @IBOutlet var pwd2_tf: UITextField!
    @IBOutlet var username_lbl: UILabel!
    @IBOutlet var pwd1_lbl: UILabel!
    @IBOutlet var pwd2_lbl: UILabel!
    @IBOutlet var register_btn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        context = app.persistentContainer.viewContext

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func username(_ sender: Any) {
        if let username = username_tf.text {
            if let errorMessage = invalidUsername(username) {
                    username_lbl.text = errorMessage
                    username_lbl.isHidden = false
                } else {
                    username_lbl.isHidden = true
            }
        }
    }
    
    func invalidUsername(_ value: String) -> String? {
        let regularExpression = ".*[A-Z0-9a-z].*"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regularExpression)
        if !predicate.evaluate(with: value) {
            return "Required"
        }
        return nil
    }
    
    @IBAction func pwd1(_ sender: Any) {
        if let pwd1 = pwd1_tf.text {
            if let errorMessage = invalidPwd1(pwd1) {
                pwd1_lbl.text = errorMessage
                pwd1_lbl.isHidden = false
                register_btn.isEnabled = false
            } else {
                pwd1_lbl.isHidden = true
                register_btn.isEnabled = true
            }
        }
    }
    
    func invalidPwd1(_ value: String) -> String? {
        if value.count <= 0 {
            return "Required"
        }
        if value.count < 8 {
            return "Password must be at least 8 characters"
        }
        if containsDigit(value) {
            return "Password must contain at least 1 digit"
        }
        if containsLowercase(value) {
            return "Password must contain at least 1 lowercase character"
        }
        if containsUppercase(value) {
            return "Password must contain at least 1 uppercase"
        }
        return nil
    }
    func containsDigit( _ value: String) -> Bool {
        let regularExpression = ".*[0-9]+.*"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regularExpression)
        return !predicate.evaluate(with: value)
    }
    func containsLowercase( _ value: String) -> Bool {
        let regularExpression = ".*[a-z]+.*"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regularExpression)
        return !predicate.evaluate(with: value)
    }
    func containsUppercase( _ value: String) -> Bool {
        let regularExpression = ".*[A-Z]+.*"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regularExpression)
        return !predicate.evaluate(with: value)
    }
        
    @IBAction func pwd2(_ sender: Any) {
        if let pwd2 = pwd2_tf.text {
            if let errorMessage = invalidPwd2(pwd2) {
                pwd2_lbl.text = errorMessage
                pwd2_lbl.isHidden = false

                } else {
                    pwd2_lbl.isHidden = true
                }
        }
    }
    
    func invalidPwd2(_ value: String) -> String? {
        if value.count <= 0 {
            return "Required"
        }
        if pwd2_tf.text != pwd1_tf.text {
            return "Password does not match"
        }
        return nil
    }
    
    @IBAction func register_btn(_ sender: UIButton) {
        if username_tf.text == "" || pwd1_tf.text == "" || pwd2_tf.text == "" {
            popAlert(title: "Warning", msg: "Please fill up all the fields")
        } else if pwd1_tf.text != pwd2_tf.text {
            popAlert(title: "Warning", msg: "Passwords do not match")
        } else {
            addUser()
            self.performSegue(withIdentifier: "toLoginPage", sender: nil)
            (username_tf.text, pwd1_tf.text, pwd2_tf.text) = (nil, nil, nil)
            loadUser()
            print("Done")
        }
    }
    
    func loadUser() {
        do{
            let allUser = try context.fetch(User.fetchRequest())
            for user in allUser as! [User] {
                print("\(user.username ?? ""),\(user.password ?? ""), \(user.credits)")
            }
            
        } catch {
            popAlert(title: "Error", msg: "\(error)")
        }
    }
    
    func addUser() {
        let newReg = NSEntityDescription.insertNewObject(forEntityName: "User", into: context) as! User
        newReg.username = username_tf.text
        newReg.password = pwd1_tf.text
        newReg.credits = Int16(credit)
        app.saveContext()
    }
    
    
    func popAlert (title: String, msg: String) {
        let alert = UIAlertController(title: "Alert", message: msg, preferredStyle: .alert)
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
