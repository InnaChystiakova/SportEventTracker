//
//  EventCollectionView.swift
//  SportEventTracker
//
//  Created by Inna Chystiakova on 24/09/2024.
//

import UIKit

class EventCollectionView: UICollectionView {
 
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .clear
        self.register(EventCollectionViewCell.self, forCellWithReuseIdentifier: EventCollectionViewCell.reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
