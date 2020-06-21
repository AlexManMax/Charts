//
//  HeightData.swift
//  Charts
//
//  Created by Алексей Ведушев on 21.06.2020.
//  Copyright © 2020 Алексей Ведушев. All rights reserved.
//

import Foundation

struct HeightVale {
    
    private let cmInFT: Float = 30.48
    
    private var valueInCM: Float
    
    init(cm: Float) {
        self.valueInCM = cm
    }
    
    init(ft: Int, inches: Int) {
        self.valueInCM = Float(inches) * 2.54 + Float(ft) * cmInFT
    }
    
    var cm: Float {
        valueInCM
    }
    
    var ft: Float {
        valueInCM / cmInFT
    }
    
    func getFtIn() -> (ft: Float, inches: Float) {
        let totalIn = valueInCM / 2.54
        let ft = (totalIn / 12).rounded(.down)
        let inchesValue = totalIn - 12 * ft
        return (ft: ft, inches: inchesValue)
    }
}
