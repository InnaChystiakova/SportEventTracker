//
//  EventCollectionViewLayout.swift
//  SportEventTracker
//
//  Created by Inna Chystiakova on 24/09/2024.
//

import UIKit

class EventCollectionViewLayout: UICollectionViewFlowLayout {
    override init() {
        super.init()
        self.itemSize = CGSize(width: 140, height: 100)
        self.scrollDirection = .horizontal
        self.minimumInteritemSpacing = 1
        self.minimumLineSpacing = 1
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
