//
//  TabBarController.swift
//  HisseKarZararTakip
//
//  Created by Ezgi Sümer Günaydın on 15.05.2024.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dataSaveVC = DataSaveViewController()
        let dataShowVC = DataShowViewController()
        
        
        let controllers = [dataSaveVC, dataShowVC]
        self.viewControllers = controllers.map {
            UINavigationController(rootViewController: $0)
        }
        selectedIndex = 0
        
        self.viewControllers?[0].title = "Save"
        self.viewControllers?[1].title = "List"
        self.viewControllers?[0].tabBarItem.image = UIImage(systemName: "arrowshape.down")
        self.viewControllers?[1].tabBarItem.image = UIImage(systemName: "list.clipboard")
        
    }
}

    

