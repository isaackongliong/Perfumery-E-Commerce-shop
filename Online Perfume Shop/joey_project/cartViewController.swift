//
//  cartViewController.swift
//  joey_project
//
//  Created by T04-09 on 23/2/23.
//  Copyright © 2023 ITE. All rights reserved.
//

import UIKit
import CoreData


var finalPrice: Double = 0
class cartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var cartArray = [Cart]()
    var discount = 0
    
    let app = UIApplication.shared.delegate as! AppDelegate
    var context: NSManagedObjectContext!
    
    @IBOutlet var creditsUse_lbl: UILabel!
    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        context = app.persistentContainer.viewContext
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        load()
        calculateTotalCredits()
        // Do any additional setup after loading the view.
    }
    
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
                discount = Int.random(in: 0..<21)
                calculateDiscountedCredits()
                popAlert(title: "Here's your discount", msg: "You have \(discount)%")
                print("Shaked")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cartCell", for: indexPath)
        cell.textLabel!.text = cartArray[indexPath.row].name
        print (cartArray[indexPath.row].price)
        cell.detailTextLabel!.text =  "\(cartArray[indexPath.row].price)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let delete = cartArray[indexPath.row]
            context.delete(delete)
            do {
                try context.save()
                cartArray.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                calculateTotalCredits()
                print(cartArray.count)
            } catch {
                print(error)
            }
        }
    }
    
    @IBAction func continueShopping_btn(_ sender: UIButton) {
        performSegue(withIdentifier: "toProductPage", sender: nil)
    }
    @IBAction func order_btn(_ sender: UIButton) {
        makeOrder()
        performSegue(withIdentifier: "toDeliveryPage", sender: nil)
    }
    
    func makeOrder() {
        do {
            let results = try context.fetch(User.fetchRequest())
            for result in results as! [User] {
                print(result.credits)
                if cartArray.count == 0 {
                    popAlert(title: "Sorry", msg: "Your cart is empty.")
                } else if finalPrice > Double(result.credits) {
                    popAlert(title: "Sorry", msg: "You have not enough credits.")
                } else {
                   let order = NSBatchDeleteRequest(fetchRequest: Cart.fetchRequest())
                    do {
                        try app.persistentContainer.persistentStoreCoordinator.execute(order, with: context)
                    } catch {
                        print(error)
                }
                }
                print(result.credits)
            }
        } catch {
            print(error)
        }
    }
    
    func calculateDiscountedCredits() {
            finalPrice *= ((100 - Double(discount))/100)
            creditsUse_lbl.text = "Total: \(String(format:"%.2f", (finalPrice)))"
    }
    
    func calculateTotalCredits() {
        var totalPrice: Double = 0
        for item in cartArray {
            totalPrice += Double(item.price)
            finalPrice = totalPrice
            creditsUse_lbl.text = "Total: \(String(format:"%.2f", (totalPrice)))"
            finalPrice = totalPrice
        }
        if cartArray.count == 0 {
            creditsUse_lbl.text = "Total: 0"
        }
    }
        
    func load() {
        do {
            cartArray = try context.fetch(Cart.fetchRequest())
        } catch {
            popAlert(title: "Error", msg: "\(error)")
        }
        tableView.reloadData()
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
