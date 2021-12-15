//
//  Builder.swift
//  Radio
//
//  Created by Andrii on 14.12.2021.
//

import UIKit
import SideMenuSwift

protocol BuilderProtocol {
    func createMainModule(router: RouterProtocol) -> UIViewController
    func createListModule(groupID: Int, router: RouterProtocol) -> UIViewController
}

class Builder: BuilderProtocol {
    let networkService = NetworkService()

    func createMainModule(router: RouterProtocol) -> UIViewController {
        let vc = SideMenuController(contentViewController: MainController(),
                                    menuViewController: MenuController())

        
        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let view = storyboard.instantiateViewController(withIdentifier: LoginController.className) as! LoginController
//
//        let presenter = LoginPresenter(view: view, networkService: networkService, router: router)
//        view.presenter = presenter
//        return view
        return vc

    }
    
    func createListModule(groupID: Int, router: RouterProtocol) -> UIViewController {
//        let view = ListController()
//        let presenter = ListPresenter(groupID: groupID, view: view, networkService: networkService, router: router)
//        view.presenter = presenter
//        return view

        return UIViewController()
    }
}
