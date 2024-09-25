//
//  SportEventCollectionViewCell.swift
//  SportEventTracker
//
//  Created by Inna Chystiakova on 24/09/2024.
//

import UIKit

class EventCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "SportEventCollectionViewCell"
    private var eventStartTime: TimeInterval = 0
    
    var isFavorite = false {
        didSet { eventFavoriteImageView.tintColor = isFavorite ? .yellow : .gray }
    }
    
    private let eventTimeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .white
        label.layer.cornerRadius = 6
        label.layer.borderWidth = 2
        label.layer.borderColor = UIColor.white.cgColor
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let eventFavoriteImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "star.fill")
        imageView.tintColor = .yellow
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let eventNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 2
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:MM:SS"
        return dateFormatter
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.backgroundColor = .clear
        
        contentView.addSubview(eventTimeLabel)
        contentView.addSubview(eventFavoriteImageView)
        contentView.addSubview(eventNameLabel)
        
        setupLayouts()
    }
    
    private func setupLayouts() {
        NSLayoutConstraint.activate([
            eventTimeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            eventTimeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            eventTimeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            eventFavoriteImageView.topAnchor.constraint(equalTo: eventTimeLabel.bottomAnchor, constant: 8),
            eventFavoriteImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            eventFavoriteImageView.widthAnchor.constraint(equalToConstant: 16),
            eventFavoriteImageView.heightAnchor.constraint(equalToConstant: 16),
            
            eventNameLabel.topAnchor.constraint(equalTo: eventFavoriteImageView.bottomAnchor, constant: 8),
            eventNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            eventNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            eventNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    func configure(with event: SportEventWrapper) {
        let date = Date(timeIntervalSince1970: event.sportEvent.eventStartTime ?? 0)
        eventTimeLabel.text = dateFormatter.string(from: date)
        eventFavoriteImageView.tintColor = event.isFavorite ? .yellow : .gray
        eventNameLabel.text = event.sportEvent.eventName?.replacingOccurrences(of: "-", with: "\n")
        eventStartTime = event.sportEvent.eventStartTime ?? Date().timeIntervalSince1970
        isFavorite = event.isFavorite
        
        updateTimeLabel()
    }
    
    func updateTimeLabel() {
        ///IMPORTANT NOTE!
        ///Please, update API, because all the eventStartTime values are outdated
        ///Thta's why a dummy number 30000000 was added to the counter
        ///I wanted to be sure that you will have enough time ti review my task
        
        let timeRemaining = eventStartTime - Date().timeIntervalSince1970 + 30000000
        
        if timeRemaining > 0 {
            let hours = Int(timeRemaining) / 3600
            let minutes = (Int(timeRemaining) % 3600) / 60
            let seconds = Int(timeRemaining) % 60
            eventTimeLabel.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        } else {
            eventTimeLabel.text = "00:00:00"
        }
    }

}
