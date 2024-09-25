//
//  SportEventViewController.swift
//  SportEventTracker
//
//  Created by Inna Chystiakova on 22/09/2024.
//

import UIKit
import Foundation

private let backgroungColor = UIColor(red: 28.0/255.0, green: 31.0/255.0, blue: 38.0/255.0, alpha: 1)

struct SportListSection: Hashable {
    let sectionID: UUID
    let sectionName: String
    let eventList: [SportEventWrapper]
}

class SportEventViewController: UIViewController {
    
    private let viewModel = SportEventViewModel()
    private var viewModelSection: [SportListSection] = []

    lazy var sportCollectionView: SportListCollectionView = {
        let layout = SportListCollectionViewLayout.createLayout()
        return SportListCollectionView(frame: view.bounds, collectionViewLayout: layout)
    }()
    
    private var dataSource: UICollectionViewDiffableDataSource<SportListSection, [SportEventWrapper]>!
    private var collapsedSections = Array<UUID>()
    
    private var updateTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupViewModel()
        setupCollectionView()
        
        loadEventsData()
        
        startUpdateTimer()
    }
    
    private func loadEventsData() {
        Task {
            await viewModel.fetchSportsData()
        }
    }
    
    private func setupNavigationBar() {
        self.view.backgroundColor = backgroungColor
        self.navigationItem.title = "Sport  Event  Tracker"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: nil)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person"), style: .plain, target: self, action: nil)
    }
    
    private func setupViewModel() {
        viewModel.onEventsReceived = { [weak self] events in
            DispatchQueue.main.async {
                self?.createViewModelSections(with: events)
                self?.applySnapshot()
                self?.sportCollectionView.reloadData()
            }
        }
        
        viewModel.onErrorReceived = { [weak self] error in
            DispatchQueue.main.async {
                self?.showAlert(with: error)
            }
        }
    }
    
    private func showAlert(with error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    private func createViewModelSections(with events: [SportEventList]) {
        for eventList in events {
            viewModelSection.append(
                SportListSection(
                    sectionID: UUID(),
                    sectionName: eventList.sportName ?? "Unknown Name",
                    eventList: eventList.sportEvents.map { SportEventWrapper(sportEvent: $0) }
                )
            )
        }
    }
    
    private func setupCollectionView() {
        view.addSubview(sportCollectionView)
        setupDataSource()
    }
    
    private func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<SportListSection, [SportEventWrapper]>(collectionView: sportCollectionView) { (collectionView, indexPath, eventList) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SportListCollectionViewCell.reuseIdentifier, for: indexPath) as? SportListCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            let wrappedEvents = eventList
            cell.configure(with: wrappedEvents)
            return cell
        }
        
        dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) -> UICollectionReusableView? in
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderView.reuseIdentifier, for: indexPath) as? HeaderView else {
                fatalError("Unable to dequeue HeaderView")
            }
            
            let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            let isCollapsed = self.collapsedSections.contains(section.sectionID)
            headerView.configure(with: section.sectionName, isCollapsed: isCollapsed)
            headerView.onCollapseToggle = { [weak self] isCollapsed in
                self?.toggleSection(sectionID: section.sectionID, isCollapsed: isCollapsed)
            }
            return headerView
        }
    }
    
    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<SportListSection, [SportEventWrapper]>()
        
        for section in viewModelSection {
            snapshot.appendSections([section])
            if !collapsedSections.contains(section.sectionID) {
                snapshot.appendItems([section.eventList], toSection: section)
            }
        }
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func toggleSection(sectionID: UUID, isCollapsed: Bool) {
        if isCollapsed {
            collapsedSections.append(sectionID)
        } else {
            collapsedSections.removeAll(where: { $0 == sectionID })
        }
        applySnapshot()
    }
    
    private func startUpdateTimer() {
        updateTimer?.invalidate()
        updateTimer = nil
        
        updateTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateVisibleCells()
        }
    }
    
    private func updateVisibleCells() {
        guard let visibleCells = sportCollectionView.visibleCells as? [SportListCollectionViewCell] else {
            return
        }
        
        for eventCell in visibleCells {
            guard let eventCells = eventCell.eventCollectionView.visibleCells as? [EventCollectionViewCell] else {
                return
            }
            
            for cell in eventCells {
                cell.updateTimeLabel()
            }
        }
    }
    
    deinit {
        updateTimer?.invalidate()
        updateTimer = nil
    }
}


