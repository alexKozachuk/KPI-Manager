//
//  ViewController.swift
//  KPI manager
//
//  Created by Sasha on 25/04/2020.
//  Copyright © 2020 Sasha. All rights reserved.
//

import UIKit
import ArcGIS

class MainVC: UIViewController {
    
    private let graphicsOverlay = AGSGraphicsOverlay()
    let appConfig = MapConfig()
    let layerDesigner = LayerDesigner()
    
    var layerHatch: AGSFeatureLayer!
    var layerMeter: AGSFeatureLayer!
    var layerPipes: AGSFeatureLayer!
    
    var tableHatch: AGSServiceFeatureTable!
    var tableMeter: AGSServiceFeatureTable!
    var tablePipes: AGSServiceFeatureTable!
    var tableCounter: AGSServiceFeatureTable!
    var tableMeasure: AGSServiceFeatureTable!
    
    
    var selectedTable: AGSServiceFeatureTable!
    var selectedFeature: AGSArcGISFeature!
    var selectedFeatures: [AGSArcGISFeature] = []
    
    @IBOutlet weak var mapView: AGSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.graphicsOverlays.add(graphicsOverlay)
        setupMap()
        
        selectedTable = tableMeter
        if let count = selectedTable.relatedTables()?.count {
            print(count)
        }
    }
    
    private func setupMap() {
        let map = AGSMap(basemapType: .navigationVector, latitude: 50.449680, longitude: 30.454492, levelOfDetail: 17)

        tableHatch = appConfig.getFeatureTable(by: .waterHatch)
        tableMeter = appConfig.getFeatureTable(by: .waterMeter)
        tablePipes = appConfig.getFeatureTable(by: .waterPipes)
        tableCounter = appConfig.getFeatureTable(by: .waterCounter)
        tableMeasure = appConfig.getFeatureTable(by: .waterMeasure)
        
        layerHatch = AGSFeatureLayer(featureTable: tableHatch)
        layerMeter = AGSFeatureLayer(featureTable: tableMeter)
        layerPipes = AGSFeatureLayer(featureTable: tablePipes)
        
        layerDesigner.designLayerRenderMark(layer: layerHatch, style: .square, color: .blue, size: 11)
        layerDesigner.designLayerRenderMark(layer: layerMeter, style: .triangle, color: .blue, size: 11)
        layerDesigner.designLayerRenderLine(layer: layerPipes, style: .solid, color: .blue, width: 2)
        
        map.operationalLayers.add(layerHatch!)
        map.operationalLayers.add(layerPipes!)
        map.operationalLayers.add(layerMeter!)
        map.tables.addObjects(from: [tableCounter, tableMeasure])
        
        mapView.touchDelegate = self
        mapView.callout.delegate = self
        
        self.mapView.map = map
    }
    
    
    
}



extension MainVC: AGSGeoViewTouchDelegate {
    
    func geoView(_ geoView: AGSGeoView, didTapAtScreenPoint screenPoint: CGPoint, mapPoint: AGSPoint) {
        
        self.mapView.identifyLayer(self.layerMeter, screenPoint: screenPoint, tolerance: 12, returnPopupsOnly: false, maximumResults: 10) { [weak self] (result: AGSIdentifyLayerResult) -> Void in
            
            if let error = result.error {
                print(error)
                return
            }
            
            if let feature = result.geoElements.first as? AGSArcGISFeature {
                //self?.selectedFeature = feature
                //self?.selectedFeatures = []
                self?.select(feature, atLocation: mapPoint)
            } else {
                self?.deselect()
            }
        }
    }
    
    private func select(_ feature:  AGSArcGISFeature, atLocation location: AGSPoint) {
        let title = feature.attributes["Name"] as? String
        mapView.callout.title = "Водний лічильник: " + (title ?? "undefinded")
        mapView.callout.isAccessoryButtonHidden = false
        mapView.callout.show(for: feature, tapLocation: location, animated: true)
    }
    
    // *** ADD ***
    private func deselect() {
        mapView.callout.dismiss()
    }
    
    
}

extension MainVC: AGSCalloutDelegate {
    func didTapAccessoryButton(for callout: AGSCallout) {
        if let feature = callout.representedObject as?  AGSArcGISFeature, let table = feature.featureTable as? AGSServiceFeatureTable {
            let vc = DetailVC.instantiate(from: .main)
            //vc.configure(feature: feature, relatedFeatures: selectedFeatures)
            //vc.configure1(feature: selectedFeatures)
            vc.configure2(feature: feature, table: table)
            navigationController?.pushViewController(vc, animated: true)
            self.deselect()
        }
    }
}

