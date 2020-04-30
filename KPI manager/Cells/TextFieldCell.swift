//
//  TableViewCell.swift
//  KPI manager
//
//  Created by Sasha on 27/04/2020.
//  Copyright © 2020 Sasha. All rights reserved.
//

import UIKit


class TextFieldCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup(tableColumn: TableColumn, isEnabled: Bool = false) {
        self.titleLabel.text = tableColumn.title
        self.textField.text = tableColumn.value
        self.textField.isEnabled = isEnabled
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
