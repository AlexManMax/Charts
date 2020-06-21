//
//  IMTData.swift
//  Charts
//
//  Created by Алексей Ведушев on 21.06.2020.
//  Copyright © 2020 Алексей Ведушев. All rights reserved.
//

import Foundation

struct IMTData {
    let value: Float
    
    var level: IMTLevel {
        .init(imt: value)
    }
}
