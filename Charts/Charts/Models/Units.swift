//
//  Notation.swift
//  Charts
//
//  Created by Алексей Ведушев on 21.06.2020.
//  Copyright © 2020 Алексей Ведушев. All rights reserved.
//

import Foundation

enum Notation {
    case imperic
    case international
}

enum Weight {
    case kg
    case lb
    
    var notation: Notation {
        switch self {
        case .kg:
            return .international
        case .lb:
            return .imperic
        }
    }
}

enum Height {
    case cm
    case foot
    
    var notation: Notation {
        switch self {
        case .cm:
            return .international
        case .foot:
            return .imperic
        }
    }
}
