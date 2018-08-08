//
//  MainViewController.swift
//  Movie
//
//  Created by Da on 7/31/18.
//  Copyright © 2018 Tran Cuong. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showHud(ConstantString.load)
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let homeViewController = setupViewController(name_storyboard: Storyboard.home, id: Storyboard_id.home)
        let topMovieViewController = setupViewController(name_storyboard: Storyboard.topMovie, id: Storyboard_id.topMovie)
        let libraryViewController = setupViewController(name_storyboard: Storyboard.library, id: Storyboard_id.library)
        let searchViewController = setupViewController(name_storyboard: Storyboard.search, id: Storyboard_id.search)
         self.viewControllers = [homeViewController,
                                topMovieViewController,
                                libraryViewController,
                                searchViewController]
        self.tabBar.tintColor = UIColor(red: 238/255, green: 130/255, blue: 238/255, alpha: 1)
        self.hideHUD()
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print("Selected")
    }
    
    private func setupView() {
          self.delegate = self
    }
    
    func setupViewController(name_storyboard: String, id: String) -> UIViewController {
        let storyboard = UIStoryboard(name: name_storyboard, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: id)
        let image = UIImage(named: name_storyboard)
        let tabBarItem = UITabBarItem(title: name_storyboard, image: image, selectedImage: image)
        vc.tabBarItem = tabBarItem
        return vc
    }
}

extension MainViewController: UITabBarControllerDelegate {
}
