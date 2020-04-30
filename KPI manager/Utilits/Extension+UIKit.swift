//
//  Extension + UIKit.swift
//  KPI manager
//
//  Created by Sasha on 27/04/2020.
//  Copyright © 2020 Sasha. All rights reserved.
//

import UIKit

extension UITableView {
    
    func getAllCells(rowCount: Int, section: Int) -> [UITableViewCell]{
        
        var array: [UITableViewCell] = []
        for row in 0 ..< rowCount {
            if let cell = self.cellForRow(at: IndexPath(row: row, section: section)) {
                array.append(cell)
            }
        }
        
        return array
    }
    
}
