//
//  NavigationControllerExtension.swift
//  SportEventTracker
//
//  Created by Inna Chystiakova on 23/09/2024.
//

import UIKit

extension UINavigationController {

    func setupNavigationBar() {
        let barColor = UIColor(red: 84.0/255.0, green: 158.0/255.0, blue: 167.0/255.0, alpha: 1.0)
        let barTitleFont = UIFont(name: "MATHERNAL Free Regular", size: 25.0) ?? .italicSystemFont(ofSize: 25)
        
        let appearance = UINavigationBar.appearance()
        appearance.tintColor = .white
        appearance.backgroundColor = barColor
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white, .font: barTitleFont]
    }
}
