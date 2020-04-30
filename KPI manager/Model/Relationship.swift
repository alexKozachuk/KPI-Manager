//
//  Relationship.swift
//  KPI manager
//
//  Created by Sasha on 29/04/2020.
//  Copyright © 2020 Sasha. All rights reserved.
//

import Foundation

struct Table: Decodable {
    var relationships: [Relationship]
}

struct Relationship: Decodable {
    var keyField: String
}
