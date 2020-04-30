//
//  LayerDesigner.swift
//  KPI manager
//
//  Created by Sasha on 26/04/2020.
//  Copyright © 2020 Sasha. All rights reserved.
//

import Foundation
import ArcGIS

class LayerDesigner {
    
    func designLayerRenderMark(layer: AGSFeatureLayer, style: AGSSimpleMarkerSymbolStyle, color: UIColor, size: CGFloat) {
        let uniqueValueRenderer = AGSUniqueValueRenderer()
        let symbol = AGSSimpleMarkerSymbol(style: style, color: color, size: size)
        uniqueValueRenderer.defaultSymbol = symbol
        layer.renderer = uniqueValueRenderer
        layer.renderingMode = .dynamic
    }
    
    func designLayerRenderLine(layer: AGSFeatureLayer, style: AGSSimpleLineSymbolStyle, color: UIColor, width: CGFloat) {
        let uniqueValueRenderer = AGSUniqueValueRenderer()
        let symbol = AGSSimpleLineSymbol(style: style, color: color, width: width)
        uniqueValueRenderer.defaultSymbol = symbol
        layer.renderer = uniqueValueRenderer
        layer.renderingMode = .dynamic
    }
    
}
