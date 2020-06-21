//
//  UIView+Extension.swift
//  Charts
//
//  Created by Алексей Ведушев on 18.06.2020.
//  Copyright © 2020 Алексей Ведушев. All rights reserved.
//

import UIKit

    
extension UIView {
    class func fromNib<T: UIView>() -> T {
        return Bundle(for: T.self).loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
}


