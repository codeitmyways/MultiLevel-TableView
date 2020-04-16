//
//  CetegoryCell.swift
//  DesiLux
//
//  Created by Sumit meena on 05/04/20.
//  Copyright © 2020 Sumit Meena. All rights reserved.
//

import UIKit

class CetegoryCell: UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnExpand: UIButton!
    
    @IBOutlet weak var imgCheckBox: UIImageView!
    var categories = [ProductsCategory]()
    
    @IBOutlet weak var leftContraint: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func updateData(category:ProductsCategory,intHirarchyCount:Int){
        self.leftContraint.constant = CGFloat(intHirarchyCount*15)
        var isLastChild = false
        if let childs = category.data,childs.count > 0 {
            categories = childs
            btnExpand.isHidden = false
        }else{
            btnExpand.isHidden = true
            
        }
        if category.isExpand{
            btnExpand.setTitle("-", for: .normal)
            lblTitle.textColor = UIColor(named: "themTextFieldTextColor")
        }else{
            btnExpand.setTitle("+", for: .normal)
            lblTitle.textColor = UIColor(named: "themTextCollapse")
            
        }
        if category.isSelected > 0{
            imgCheckBox.image = UIImage(systemName: "checkmark.rectangle.fill")
        }else{
            imgCheckBox.image = UIImage(systemName: "rectangle")
        }
        self.lblTitle.text = category.category
        //self.tableViewChild.frame = CGRect(x: self.tableViewChild.frame.origin.x, y: self.tableViewChild.frame.origin.y, width: self.tableViewChild.frame.size.width, height: self.tableViewChild.contentSize.height)
    }
    
}


