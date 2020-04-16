//
//  ViewController.swift
//  MultiLevel-TableView
//
//  Created by Sumit meena on 14/04/20.
//  Copyright © 2020 Sumit Meena. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
@IBOutlet weak var tableView: UITableView!
    final var categories  = [ProductsCategory]()
//       var arrDataCell  = [ProductsCategory]()
       var positions  = [[Int]]()
    let fileManager = FileManager.default
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(CetegoryCell.nib, forCellReuseIdentifier: CetegoryCell.identifier)

        // Do any additional setup after loading the view.
        loadJson()
    }
    func refreshTable(){
        for (index, _) in categories.enumerated() {
            positions.append([index])
        }
        self.tableView.reloadData()

    }
    
    func loadJson(){
        guard let mainUrl = Bundle.main.url(forResource: "ProductsCategory", withExtension: "json") else { return }
                
        do {
            let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
            let subUrl = documentDirectory.appendingPathComponent("ProductsCategory.json")
            loadFile(mainPath: mainUrl, subPath: subUrl)
        } catch {
            print(error)
        }

    }
    func loadFile(mainPath: URL, subPath: URL){
        if fileManager.fileExists(atPath: subPath.path){
            decodeData(pathName: subPath)
            
            if categories.isEmpty{
                decodeData(pathName: mainPath)
            }
            
        }else{
            decodeData(pathName: mainPath)
        }
        
    }
    func decodeData(pathName: URL){
        do{
            let jsonData = try Data(contentsOf: pathName)
            let decoder = JSONDecoder()
            categories = try decoder.decode([ProductsCategory].self, from: jsonData)
            print(categories.count)
            self.refreshTable()
        } catch {
            print(error)

        }
    }


}
extension ViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return positions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //ShopBannerCell
        let positionArray = positions[indexPath.row]
        var categoryForCell : ProductsCategory?
        for index in positionArray {
            if categoryForCell ==  nil {
                categoryForCell = categories[index]
            }else{
                categoryForCell = categoryForCell?.data![index]
            }
        }
        
        
        if let cell  = tableView.dequeueReusableCell(withIdentifier: CetegoryCell.identifier, for: indexPath) as? CetegoryCell, let category : ProductsCategory = categoryForCell{
            cell.updateData(category: category, intHirarchyCount: positionArray.count)
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var ipsArr = Array<IndexPath>()
        let row = indexPath.row
        let position = positions[indexPath.row]
        if var category : ProductsCategory = getCategory(atIndex: indexPath.row) {
             if let childs = category.data,childs.count > 0  {
                if !category.isExpand{
                    category.setIsExpand(isExpand: true)
                    for (index, _) in (category.data?.enumerated())! {
                        var parentPosition = position
                        parentPosition.append(index)
                        self.positions.insert(parentPosition, at: row + index + 1)
                        let ip = IndexPath(row: row + index + 1, section: 0)
                        ipsArr.append(ip)
                    }
                    
                    tableView.beginUpdates()
                    tableView.insertRows(at: ipsArr, with: .left)
                    tableView.reloadRows(at: [indexPath], with: .none)
                    tableView.endUpdates()
                    
                }else{
                    var count = 1
                    while row + 1 < self.positions.count
                    {
                        var element = self.positions[row + 1]
                        if position.count < element.count {
                            var category = getCategory(atIndex: row + 1)
                            category.setIsExpand(isExpand: false)
                            self.positions.remove(at: row + 1)
                            let ip = IndexPath(row: row + count, section: 0)
                            ipsArr.append(ip)
                            count += 1
                        }else{
                            break
                        }
                        
                        
                    }
                    category.setIsExpand(isExpand: false)
                    tableView.beginUpdates()
                    tableView.deleteRows(at: ipsArr, with: .right)
                    tableView.reloadRows(at: [indexPath], with: .none)
                    tableView.endUpdates()
                }
                
            }else{
                if category.isSelected > 0 {
                    ipsArr = self.removeSelect(atIndex: indexPath.row)
                    category.setIsExpand(isExpand: false)
                }else{
                    ipsArr = self.addSelect(atIndex: indexPath.row)
                    category.setIsExpand(isExpand: true)
                }
                
                tableView.beginUpdates()
                tableView.reloadRows(at: ipsArr, with: .none)
                tableView.endUpdates()
            }
        }
    }
    
}
extension ViewController{
    func getCategory(atIndex index:Int)-> ProductsCategory {
        let positionArray = self.positions[index]
        var categoryForCell : ProductsCategory?
        for index in positionArray {
            if categoryForCell ==  nil {
                categoryForCell = categories[index]
            }else{
                categoryForCell = categoryForCell?.data![index]
            }
        }
        return  categoryForCell!
    }
    func addSelect(atIndex index:Int)->Array<IndexPath>{
        var ipsArr = Array<IndexPath>()

        let positionArray = self.positions[index]
        var positions = positionArray
        var categoryForCell : ProductsCategory?
        for index in positionArray {
            if categoryForCell ==  nil {
                categoryForCell = categories[index]
            }else{
                categoryForCell = categoryForCell?.data![index]
            }
            if let cellIndex = self.positions.firstIndex(of: positions){
                positions.removeLast()
                let ip = IndexPath(row: cellIndex, section: 0)
                ipsArr.append(ip)
            }
            var locacategoryForCell = categoryForCell
            categoryForCell?.setIsSelected(isSelected: locacategoryForCell!.isSelected+1)
        }
        return ipsArr
    }
    func removeSelect(atIndex index:Int)->Array<IndexPath>{
        var ipsArr = Array<IndexPath>()

        let positionArray = self.positions[index]
        var positions = positionArray
        var categoryForCell : ProductsCategory?
        for index in positionArray {
            if categoryForCell ==  nil {
                categoryForCell = categories[index]
            }else{
                categoryForCell = categoryForCell?.data![index]
            }
            if let cellIndex = self.positions.firstIndex(of: positions){
                positions.removeLast()
                let ip = IndexPath(row: cellIndex, section: 0)
                ipsArr.append(ip)
                
            }
            var locacategoryForCell = categoryForCell
            categoryForCell?.setIsSelected(isSelected: locacategoryForCell!.isSelected-1)
        }
        return ipsArr
    }
}


