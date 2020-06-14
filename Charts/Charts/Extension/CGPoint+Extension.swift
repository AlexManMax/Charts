//
//  CGPoint+Extension.swift
//  Charts
//
//  Created by Алексей Ведушев on 14.06.2020.
//  Copyright © 2020 Алексей Ведушев. All rights reserved.
//

import UIKit


extension CGPoint {
    func distance(to point: CGPoint) -> CGFloat {
        return sqrt(pow((point.x - x), 2) + pow((point.y - y), 2))
    }
}
