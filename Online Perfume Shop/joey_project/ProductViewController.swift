//
//  WelcomeViewController.swift
//  joey_project
//
//  Created by T04-09 on 15/2/23.
//  Copyright © 2023 ITE. All rights reserved.
//

import UIKit

var productList: [ProductModel] = []

class ProductViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var productTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initList()
        // Do any additional setup after loading the view.
    }
    
    func initList() {
        productList = []
        let tomford = ProductModel(id:"0", name:"Tom Ford", imageName:"tomford", price: 150, details: "Woody and warm")
        productList.append(tomford)
        
        let burberry = ProductModel(id:"1", name:"Burberry", imageName:"burberry hero", price: 170, details: "warm spicy and serious")
        productList.append(burberry)
        
        let chloe = ProductModel(id:"2", name:"Chloe", imageName:"chloe", price: 160, details: "fresh and playful ")
        productList.append(chloe)

        let carolina = ProductModel(id:"3", name:"Carolinaa", imageName:"carolina herarra", price: 150, details: "serious and gentle")
        productList.append(carolina)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(productList.count)
        return productList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell") as! TableViewCell
        
        let thisProduct = productList[indexPath.row]
        
        tableViewCell.productName.text = thisProduct.name
        tableViewCell.productImage	.image = UIImage(named: thisProduct.imageName)
        tableViewCell.productPrice.text = String(thisProduct.price)
        tableViewCell.productDetail.text = thisProduct.details
        return tableViewCell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        self.performSegue(withIdentifier: "toDetailPage", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier == "toDetailPage")
        {
            let indexPath = self.productTableView.indexPathForSelectedRow!
            
            let tableViewDetail = segue.destination as? TableViewDetail
            
            let selectedImage = productList[indexPath.row]
            
            tableViewDetail!.selectedImage = selectedImage
            
            self.productTableView.deselectRow(at: indexPath, animated: true)
        }
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
