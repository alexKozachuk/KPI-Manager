//
//  AppConfig.swift
//  KPI manager
//
//  Created by Sasha on 25/04/2020.
//  Copyright © 2020 Sasha. All rights reserved.
//

import Foundation
import ArcGIS

enum TableID: Int {
    case waterMeter = 18
    case waterPipes = 3
    case waterHatch = 8
    case waterCounter = 22
    case waterMeasure = 23
}

class MapConfig {
    
    let featureServiceString = "https://services7.arcgis.com/6LV5dTlFXsOot0n8/arcgis/rest/services/GenPlan2_gdb/FeatureServer"
    var featureServiceURL: URL {
        return URL(string: featureServiceString)!
    }

    func getFeatureTable(by id: TableID) -> AGSServiceFeatureTable {
        guard let featureServiceURL = URL(string: "https://services7.arcgis.com/6LV5dTlFXsOot0n8/arcgis/rest/services/GenPlan_gdb/FeatureServer/" + String(id.rawValue)) else { fatalError("Error: Problem with FeatureServer in AppConfig")}
        return AGSServiceFeatureTable(url: featureServiceURL)
    }
    
}
