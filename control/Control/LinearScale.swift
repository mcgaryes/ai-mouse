//
//  LinearScale.swift
//  Control
//
//  Created by Eric McGary on 11/19/16.
//
//

import Foundation

class LinearScale
{
    
    // ============================================================
    // === Internal API ===========================================
    // ============================================================
    
    // MARK: Internal Properties
    
    var domain: [Double] = [0.0, 0.0]
    var range: [Double] = [0.0, 0.0]
    
    // MARK: Internal Methods
    
    func scale(value: Double) -> Double
    {
        let minValue = domain[0];
        let maxValue = domain[1];
        let minScale = range[0]
        let maxScale = range[1]
        
        let ratio = ((maxScale - minScale) / (maxValue - minValue))
        return (minScale + (ratio * (value - minValue)))
    }
    
}
