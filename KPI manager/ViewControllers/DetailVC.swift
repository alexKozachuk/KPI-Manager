//
//  DetailVC.swift
//  KPI manager
//
//  Created by Sasha on 26/04/2020.
//  Copyright © 2020 Sasha. All rights reserved.
//

import UIKit
import ArcGIS

class DetailVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var dataSource: [TableColumn] = []
    var relatedSource: [String] = []
    let appConfig = MapConfig()
    var featureTable: AGSServiceFeatureTable!
    var feature: AGSFeature!
    var relationFeatures: [AGSFeature] = []
    var results: [AGSRelatedFeatureQueryResult] = []
    var idTable: String = ""
    
    var isEditable: Bool = false {
        didSet {
            tableView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMenu()
    }
    
    func setupMenu() {
        let editButton = UIBarButtonItem(title: "Edit", style: .done, target: self, action: #selector(editButtonTapped))
        navigationItem.rightBarButtonItem = editButton
    }
    
    @objc func editButtonTapped() {
        if isEditable {
            let cells = tableView.getAllCells(rowCount: dataSource.count, section: 0)

            for (index, cell) in cells.enumerated() {
                guard let textFieldCell = cell as? TextFieldCell else { return }
                guard let testFieldText = textFieldCell.textField.text else { return }
                let value = dataSource[index].value
                let key = dataSource[index].title
                if testFieldText != value {
                    dataSource[index].value = testFieldText
                    feature.attributes[key] = testFieldText
                }
            }
            
            self.featureTable.update(feature, completion: { (error:Error?) -> Void in
                
                if let error = error {
                    print("Error while updating feature :: \(error.localizedDescription)")
                    return
                }
                self.featureTable.applyEdits(completion: { (featureEditResults: [AGSFeatureEditResult]?, error: Error?)-> Void in
                    if let error = error {
                        print("Error while applying edit :: \(error.localizedDescription)")
                        return
                    }
                    print("Apply Edits successful")
                    self.tableView.reloadData()
                })
            })
            
            
        }
        
        
        isEditable.toggle()
        navigationItem.rightBarButtonItem?.title = isEditable ? "Done" : "Edit"
    }
    
    private func queryRelatedFeatures(table: AGSServiceFeatureTable, feature: AGSArcGISFeature) {
        
        table.queryRelatedFeatures(for: feature) { [weak self] (results: [AGSRelatedFeatureQueryResult]?, error: Error?) in
            
            
            if let error = error {
                print(error)
            } else if let results = results {
                self?.results = results
                self?.relatedSource = []
                for result in results  {
                    guard let key = result.relationshipInfo?.keyField else { continue }
                    guard let feature = result.feature else { return }
                    guard let idTable = feature.attributes[key] else { return }
                    guard let name = result.relatedTable?.displayName else { return }
                    self?.relatedSource.append(name)
                    self?.idTable = idTable as! String
                    
                }
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
            
        }
    }

    func configure(feature dataSource: AGSFeature, relatedFeatures: [AGSFeature]) {
        self.dataSource = []
        let data = dataSource.attributes
        self.feature = dataSource
        self.relationFeatures = relatedFeatures
        
        for (key, value) in data {
            if let stringKey = key as? String {
                if let stringValue = value as? String {
                     self.dataSource.append(TableColumn(title: stringKey, value: stringValue))
                } else if let intValue = value as? Int {
                     self.dataSource.append(TableColumn(title: stringKey, value: String(intValue)))
                }
            }
        }
        
        for item in relatedFeatures {
            guard let name = item.featureTable?.displayName else { return }
            relatedSource.append(name)
        }
        
        
        
    }
    
    func configure1(feature dataSource: [AGSFeature]) {
        self.relationFeatures = dataSource
        
        for item in dataSource {
            let data = item.attributes
            
            for (key, value) in data {
                
                if let stringKey = key as? String {
                    if let stringValue = value as? String {
                         self.dataSource.append(TableColumn(title: stringKey, value: stringValue))
                    } else if let intValue = value as? Int {
                         self.dataSource.append(TableColumn(title: stringKey, value: String(intValue)))
                    }
                }
                
            }
            
        }
        
        
    }
    
    func configure2(feature: AGSArcGISFeature, table: AGSServiceFeatureTable) {
        let data = feature.attributes
        self.feature = feature
        self.featureTable = table
        
        for (key, value) in data {
            if let stringKey = key as? String {
                if let stringValue = value as? String {
                     self.dataSource.append(TableColumn(title: stringKey, value: stringValue))
                } else if let intValue = value as? Int {
                     self.dataSource.append(TableColumn(title: stringKey, value: String(intValue)))
                }
            }
        }
        
        queryRelatedFeatures(table: table, feature: feature)
        
    }
    
}

extension DetailVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let item = results[indexPath.row]
            guard let card = item.relationshipInfo?.cardinality.rawValue else { return }
            if card == 1 {
                let vc = ListVC.instantiate(from: .main)
                vc.configure(result: item, idTable: idTable)
                navigationController?.pushViewController(vc, animated: true)
            }
            
        } else {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
}

extension DetailVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? dataSource.count : relatedSource.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let item = dataSource[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldCell", for: indexPath) as! TextFieldCell
            cell.setup(tableColumn: item, isEnabled: isEditable)
            return cell
        } else {
            let item = relatedSource[indexPath.row]
            let cell = UITableViewCell()
            cell.textLabel?.text = item
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Item"
        } else {
            return "Related Tables"
        }
    }
    
    
}
