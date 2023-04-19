//
//  ViewController.swift
//  joey_project
//
//  Created by T04-09 on 14/2/23.
//  Copyright © 2023 ITE. All rights reserved.
//

import UIKit
import CoreData

var username: String = ""
var password: String = ""

class LoginViewController: UIViewController {
    
    let app = UIApplication.shared.delegate as! AppDelegate
    var context:NSManagedObjectContext!
    
    var regArray = [User]()
    
    @IBOutlet var username_tf: UITextField!
    @IBOutlet var pwd_tf: UITextField!
    @IBOutlet var login_btn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        context = app.persistentContainer.viewContext
        insertUserData()
        queryAllUserData() 
        
    }
    
    @IBAction func login_btn(_ sender: Any) {
        if (username_tf.text == "") || (pwd_tf.text == "") {
            popAlert(title: "Attention", msg: "Please field up all fields.")
        } else {
            let request: NSFetchRequest<User> = User.fetchRequest()
            request.returnsObjectsAsFaults = false
            do {
                let results = try context.fetch(request)
                for result in results as! [User] {
                    if (username_tf.text != result.username) || (pwd_tf.text != result.password) {
                        popAlert(title: "Attention", msg: "Wrong username/password")
                    } else if ((result.username == username_tf.text) && (result.password == pwd_tf.text)) {
                            performSegue(withIdentifier: "toWelcomePage", sender: nil)
                        username = result.username!
                        password = result.password!
                    }
                }
            } catch {
                popAlert(title: "Error", msg: "\(error)")
            }
        }
        
    }
    
    @IBAction func signUp_btn(_ sender: UIButton) {
         performSegue(withIdentifier: "toSignUp", sender: nil)
    }
    
    func popAlert (title: String, msg: String) {
        let alert = UIAlertController(title: "Alert", message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
     func insertUserData() {
     var user = NSEntityDescription.insertNewObject(forEntityName: "Product", into: context) as!
    Product
     user.id = "1"
     user.name = "burberry hero"
     user.price = 150
          user = NSEntityDescription.insertNewObject(forEntityName: "Product", into: context) as!
        Product
         user.id = "2"
         user.name = "carolina herarra"
         user.price = 170
          user = NSEntityDescription.insertNewObject(forEntityName: "Product", into: context) as!
        Product
         user.id = "3"
         user.name = "chloe"
         user.price = 160
            user = NSEntityDescription.insertNewObject(forEntityName: "Product", into: context) as!
        Product
         user.id = "4"
         user.name = "tomford"
         user.price = 150

     app.saveContext()
     }
    
    func queryAllUserData() {
    do {
    let allUsers = try context.fetch(Product.fetchRequest())

    for user in allUsers as! [Product] {
    print("\(user.id ?? ""), \(user.name ?? ""), \(user.price)")
    }
    }
    catch{
    print(error)
    }
    }
    
    
}

