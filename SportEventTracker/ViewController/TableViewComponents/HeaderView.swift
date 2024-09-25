//
//  HeaderView.swift
//  SportEventTracker
//
//  Created by Inna Chystiakova on 23/09/2024.
//

import UIKit

class HeaderView: UICollectionReusableView {
    static let reuseIdentifier = "HeaderView"
    
    var isCollapsed = false {
        didSet { collapseArrow.image = UIImage(systemName: isCollapsed ? "chevron.down" : "chevron.up") }
    }
    var onCollapseToggle: ((Bool) -> Void)?     // collapse button action handler
    
    public func configure(with sectionName: String, isCollapsed: Bool) {
        self.isCollapsed = isCollapsed
        sectionLabel.text = sectionName
        sectionImageView.image = UIImage(named: sectionName.lowercased()) ?? (UIImage(systemName: "questionmark") ?? UIImage())
    }
    
    // MARK: -Init and Setup
    
    private let sectionColor = UIColor(red: 36.0/255.0, green: 43.0/255.0, blue: 54.0/255.0, alpha: 1)
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setupViews()
        setupGestureRecognizer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.backgroundColor = sectionColor
        
        addSubview(sectionImageView)
        addSubview(sectionLabel)
        addSubview(collapseArrow)
        
        NSLayoutConstraint.activate([
            sectionImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            sectionImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            sectionImageView.widthAnchor.constraint(equalToConstant: 25),
            sectionImageView.heightAnchor.constraint(equalToConstant: 25),
            
            sectionLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            sectionLabel.leadingAnchor.constraint(equalTo: sectionImageView.trailingAnchor, constant: 12),
            sectionLabel.trailingAnchor.constraint(lessThanOrEqualTo: collapseArrow.leadingAnchor, constant: -12),
            
            collapseArrow.centerYAnchor.constraint(equalTo: centerYAnchor),
            collapseArrow.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            collapseArrow.widthAnchor.constraint(equalToConstant: 20),
            collapseArrow.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    // MARK: -Lazy vars
    private lazy var sectionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var sectionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var collapseArrow: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.up")
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    @objc private func collapseButtonTapped() {
        isCollapsed.toggle()
        onCollapseToggle?(isCollapsed)
    }
    
    private func setupGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(collapseButtonTapped))
        self.addGestureRecognizer(tapGesture)
    }
}
