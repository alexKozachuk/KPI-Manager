//
//  ListVC.swift
//  KPI manager
//
//  Created by Sasha on 30/04/2020.
//  Copyright © 2020 Sasha. All rights reserved.
//

import UIKit
import ArcGIS

class ListVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var dataSource: [[TableColumn]] = [[]]
    var features: [AGSArcGISFeature] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    func configure(result: AGSRelatedFeatureQueryResult, idTable: String) {
        
        if result.featureEnumerator().allObjects.count > 0 {
            guard let relatedTable = result.relatedTable as? AGSServiceFeatureTable else { return }
            guard var url = relatedTable.url else { return }
            let urlSeseion = URLSession.shared
            var urlComponents = URLComponents(string: url.absoluteString)!

            urlComponents.queryItems = [
                URLQueryItem(name: "f", value: "json")
            ]
            
            if let url1 = urlComponents.url {
                url = url1
            }
            
            let task = urlSeseion.dataTask(with: url) { data, response, error in
                do {
                    let relTable: Table = try JSONDecoder().decode(Table.self, from: data!)
                    guard let relationship = relTable.relationships.first else { return }
                    let idRelatedTable = relationship.keyField
                    
                    let queryParameters = AGSQueryParameters()
                    queryParameters.whereClause = "\(idRelatedTable) like '%\(idTable)%'"
                    print(idRelatedTable)
                    queryParameters.returnGeometry = true
                    let outFields: AGSQueryFeatureFields = .loadAll
                    relatedTable.queryFeatures(with: queryParameters, queryFeatureFields: outFields) { [weak self] result, error in
                        
                        if let error = error {
                            print("Error querying the trailheads feature layer: \(error.localizedDescription)")
                            return
                        }
                        
                        guard let result = result, let features = result.featureEnumerator().allObjects as? [AGSArcGISFeature] else {
                            print("Something went wrong casting the results.")
                            return
                        }
                        
                        if let first = features.first {
                            print(first.attributes)
                        }
                        
                        for item in features {
                            self?.features.append(item)
                            let data = item.attributes
                            var array: [TableColumn] = []
                            for (key, value) in data {
                                if let stringKey = key as? String {
                                    if let stringValue = value as? String {
                                         array.append(TableColumn(title: stringKey, value: stringValue))
                                    } else if let intValue = value as? Int {
                                         array.append(TableColumn(title: stringKey, value: String(intValue)))
                                    } else if let dataValue = value as? Date {
                                        let formatter = DateFormatter()
                                        formatter.dateStyle = .short
                                        array.append(TableColumn(title: stringKey, value: formatter.string(from: dataValue)))
                                    } else {
                                        array.append(TableColumn(title: stringKey, value: ""))
                                    }
                                }
                            }
                            self?.dataSource.append(array)
                        }
                        
                        DispatchQueue.main.async {
                            self?.tableView.reloadData()
                        }
                    }
                    
                } catch {
                    print("JSON error: \(error.localizedDescription)")
                }
            }
            
            task.resume()

        }
    }
}

extension ListVC: UITableViewDelegate {
    
}

extension ListVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource[section].count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = dataSource[indexPath.section][indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldCell", for: indexPath) as! TextFieldCell
        cell.setup(tableColumn: item)
        return cell
    }
    
    
}
