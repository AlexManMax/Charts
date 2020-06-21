//
//  IMTLelvel.swift
//  Charts
//
//  Created by Алексей Ведушев on 21.06.2020.
//  Copyright © 2020 Алексей Ведушев. All rights reserved.
//

import UIKit

enum IMTLevel: CaseIterable {
    case verySevereDepletion
    case underweight
    case norm
    case overweight
    case firstDegreeObesity
    case secondDegreeObesity
    
    init(weight: Float, height: Float) {
        let imt = weight / (height * height)
        self.init(imt: imt)
    }
    
    init(imt: Float) {
        if let level = IMTLevel.allCases.first(where: { $0.range.contains(imt)}) {
            self = level
            return
        } else {
            if imt < IMTLevel.verySevereDepletion.range.lowerBound {
                self = IMTLevel.verySevereDepletion
                return
            } else if imt > IMTLevel.secondDegreeObesity.range.upperBound {
                self = IMTLevel.secondDegreeObesity
                return
            }
        }
        self = IMTLevel.verySevereDepletion
    }
    
    var range: Range<Float> {
        switch self {
        case .verySevereDepletion:
            return 15..<16
        case .underweight:
            return 16..<18.5
        case .norm:
            return 18.5..<25
        case .overweight:
            return 25..<30
        case .firstDegreeObesity:
            return 30..<35
        case .secondDegreeObesity:
            return 35..<40
        }
    }
    
    var color: UIColor {
        switch self {
        case .verySevereDepletion:
            return #colorLiteral(red: 0.1819873154, green: 0.2744832635, blue: 0.8309889436, alpha: 1)
        case .underweight:
            return #colorLiteral(red: 0.3122283816, green: 0.5883885026, blue: 0.9939255118, alpha: 1)
        case .norm:
            return #colorLiteral(red: 0.05180351436, green: 0.7864189744, blue: 0.8669361472, alpha: 1)
        case .overweight:
            return #colorLiteral(red: 0.9944290519, green: 0.8150370717, blue: 0.1587764919, alpha: 1)
        case .firstDegreeObesity:
            return #colorLiteral(red: 0.989759028, green: 0.6979183555, blue: 0.3566628695, alpha: 1)
        case .secondDegreeObesity:
            return #colorLiteral(red: 0.9955756068, green: 0.2813150883, blue: 0.3798769116, alpha: 1)
        }
    }
    
    var name: String {
        switch self {
        case .verySevereDepletion:
            return "Очень сильное истощение"
        case .underweight:
            return "Недотаточная масса тела"
        case .norm:
            return "Норма"
        case .overweight:
            return "Избыточная масса тела"
        case .firstDegreeObesity:
            return "Ожирение первой степени"
        case .secondDegreeObesity:
            return "Ожирение второй степени"
        }
    }
}
