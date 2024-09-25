//
//  SportListCollectionView.swift
//  SportEventTracker
//
//  Created by Inna Chystiakova on 24/09/2024.
//

import UIKit

class SportListCollectionView: UICollectionView {
 
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.register(SportListCollectionViewCell.self, forCellWithReuseIdentifier: SportListCollectionViewCell.reuseIdentifier)
        self.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.reuseIdentifier)
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
