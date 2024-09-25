//
//  SportListCollectionViewCell.swift
//  SportEventTracker
//
//  Created by Inna Chystiakova on 24/09/2024.
//

import UIKit

struct EventSection: Hashable {}

class SportListCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "SectionCollectionViewCell"
    private var sportEvents: [SportEventWrapper] = []
        
    lazy var eventCollectionView: EventCollectionView = {
        let layout = EventCollectionViewLayout()
        return EventCollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    private var dataSource: UICollectionViewDiffableDataSource<EventSection, SportEventWrapper>!
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupCollectionView()
        setupLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCollectionView() {
        eventCollectionView.delegate = self
        contentView.addSubview(eventCollectionView)
        
        dataSource = UICollectionViewDiffableDataSource<EventSection, SportEventWrapper>(collectionView: eventCollectionView) { (collectionView, indexPath, event) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EventCollectionViewCell.reuseIdentifier, for: indexPath) as? EventCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            cell.configure(with: event)
            return cell
        }
    }
    
    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<EventSection, SportEventWrapper>()
        snapshot.appendSections([EventSection()])
        
        for event in sportEvents {
            if event.isFavorite {
                guard let index = sportEvents.firstIndex(where: { $0.sportEvent.eventUUID == event.sportEvent.eventUUID }) else {
                    continue
                }
                sportEvents.remove(at: index)
                sportEvents.insert(event, at: 0)
            }
        }
        
        snapshot.appendItems(sportEvents)
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func setupLayouts() {
        NSLayoutConstraint.activate([
            eventCollectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            eventCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            eventCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            eventCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func configure(with events: [SportEventWrapper]) {
        self.sportEvents = events
        applySnapshot()
        eventCollectionView.reloadData()
    }
}

extension SportListCollectionViewCell: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? EventCollectionViewCell else {
            return
        }
        
        if let event = dataSource.itemIdentifier(for: indexPath) {
            cell.isFavorite.toggle()
            event.isFavorite = cell.isFavorite
            self.applySnapshot()
        }
    }
}
