//
//  ProductsCategory.swift
//  DesiLux
//
//  Created by Sumit meena on 05/04/20.
//  Copyright © 2020 Sumit Meena. All rights reserved.
//

import Foundation
class ProductsCategory : Codable{
    var category : String = ""
    var data:[ProductsCategory]?
    var isExpand = false
    var isSelected = 0
    var intHirarchyCount = 0
    var parentIndexes = [Int]()
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let category = try container.decodeIfPresent(String.self, forKey: .category) {
            self.category = category
        }
        if let data = try container.decodeIfPresent([ProductsCategory].self, forKey: .data) {
            self.data = data
        }
    }

    init(categoryName:String, data:[ ProductsCategory]? = [ProductsCategory]()) {
        self.category = categoryName
        self.data = data
    }
    func setIsExpand(isExpand:Bool){
        self.isExpand = isExpand
        
    }
    func setIsSelected(isSelected:Int){
        self.isSelected = isSelected
        
    }
    func addParendIndex(parentIndexs:[Int]){
        self.parentIndexes = parentIndexs
    }

    func updateHirarchyCount(count:Int){
        self.intHirarchyCount = count
    
    }

}
