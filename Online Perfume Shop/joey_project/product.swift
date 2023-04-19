//
//  File.swift
//  joey_project
//
//  Created by T04-09 on 20/2/23.
//  Copyright © 2023 ITE. All rights reserved.
//

import Foundation

class ProductModel
{
    var id: String!
    var name: String!
    var imageName: String!
     var price: Int!
    var details: String!
    
    init(id: String, name: String, imageName: String, price: Int, details: String)
    {
        self.id = id
        self.name = name
        self.imageName = imageName
          self.price = price
        self.details = details
    }
}

