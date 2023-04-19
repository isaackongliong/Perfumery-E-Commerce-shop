//
//  TableViewDetail.swift
//  joey_project
//
//  Created by user232692 on 2/21/23.
//  Copyright © 2023 ITE. All rights reserved.
//

import Foundation
import UIKit
import CoreData


var addedProductName = ""
var addedProductPrice = ""

class TableViewDetail: UIViewController,UITableViewDelegate {
    
    let app = UIApplication.shared.delegate as! AppDelegate
    var context: NSManagedObjectContext!
    
    @IBOutlet weak var details: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    var selectedImage : ProductModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        load()
        context = app.persistentContainer.viewContext
        
        //tableViewCell.productPrice.text = String(thisProduct.price)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func add_btn(_ sender: Any) {
        addedProduct()
        performSegue(withIdentifier: "buying", sender: nil)

    }
    
    func addedProduct() {
        let cart = NSEntityDescription.insertNewObject(forEntityName: "Cart", into: context) as! Cart
        cart.name = selectedImage.name
        cart.price = Int16(selectedImage.price)
        print("\(String(cart.name!))", "\(String(cart.price))")
        app.saveContext()
    }
    
    func load() {
        name.text = selectedImage.name
        image.image = UIImage(named: selectedImage.imageName)
        details.text = selectedImage.details
        price.text = "Credits: " + String(selectedImage.price)
        addedProductName = selectedImage.name
        addedProductPrice = String(selectedImage.price)
    }
}
