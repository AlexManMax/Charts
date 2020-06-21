//
//  WeightData.swift
//  Charts
//
//  Created by Алексей Ведушев on 21.06.2020.
//  Copyright © 2020 Алексей Ведушев. All rights reserved.
//

import Foundation

struct WeightData {
    fileprivate let lbInKG: Float = 2.20462
    
    private let valueInKG: Float
    
    init(kg: Float) {
        self.valueInKG = kg
    }
    
    init(lb: Float) {
        self.valueInKG = lb * lbInKG
    }
    
    var kgValue: Float {
        valueInKG
    }
    
    var lbValue: Float {
        valueInKG / lbInKG
    }
}
