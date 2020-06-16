//
//  UITableView+Extension.swift
//  Charts
//
//  Created by Алексей Ведушев on 14.06.2020.
//  Copyright © 2020 Алексей Ведушев. All rights reserved.
//

import UIKit

extension UITableView {
    
    func registerCellNib<T: UITableViewCell>(cellType: T.Type) {
        let nib = UINib(nibName: String(describing: T.self), bundle: nil)
        register(nib, forCellReuseIdentifier: String(describing: cellType.self))
    }
    
    func dequeReusable<T: UITableViewCell>(cellType: T.Type, indexPath: IndexPath) -> T {
        dequeueReusableCell(withIdentifier: String(describing: T.self), for: indexPath) as! T
    }
}
