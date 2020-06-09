//
//  CollumnChartFlowLayout.swift
//  Charts
//
//  Created by Алексей Ведушев on 05.06.2020.
//  Copyright © 2020 Алексей Ведушев. All rights reserved.
//

import UIKit

class CollumnChartFlowLayout: UICollectionViewFlowLayout {
    
    override func prepare() {
        super.prepare()
        
        guard let cv = collectionView else { return }
        let availableHeight = cv.bounds.inset(by: cv.safeAreaInsets).size.height
        self.itemSize = CGSize(width: CollumnDayCVCell.cellWidth, height: availableHeight)
        self.minimumLineSpacing = 0
        self.minimumInteritemSpacing = 0
        self.scrollDirection = .horizontal
//        self.headerReferenceSize = CGSize(width: 100, height: 100)
    }
}
