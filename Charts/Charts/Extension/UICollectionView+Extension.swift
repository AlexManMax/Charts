//
//  UICollectionView+Extension.swift
//  Charts
//
//  Created by Алексей Ведушев on 05.06.2020.
//  Copyright © 2020 Алексей Ведушев. All rights reserved.
//

import UIKit

extension UICollectionView {
    
    func registerCellNib<T: UICollectionViewCell>(cellType: T.Type) {
        let nibName = UINib(nibName: String(describing: cellType), bundle: nil)
        register(nibName, forCellWithReuseIdentifier: String(describing: cellType))
    }
    
    func dequeResusable<T: UICollectionViewCell>(cellType: T.Type, for indexPath: IndexPath) -> T {
        dequeueReusableCell(withReuseIdentifier: String(describing: cellType), for: indexPath) as! T
    }
}
