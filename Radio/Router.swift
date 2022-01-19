//
//  Router.swift
//  Radio
//
//  Created by Andrii on 14.12.2021.
//

import UIKit

protocol RouterMainProtocol {
    var navigationController: UINavigationController? { get set }
    var builder: BuilderProtocol? { get set }
}

protocol RouterProtocol: RouterMainProtocol {
    func showLogin(animated: Bool)
    func initialViewController()
    func showList(grpupID: Int)
    func dismiss()
}

class Router: RouterProtocol {
    
    var navigationController: UINavigationController?
    var builder: BuilderProtocol?
    
    init(navigationController: UINavigationController, builder: BuilderProtocol) {
        self.navigationController = navigationController
        self.builder = builder
     }
    
    func initialViewController() {
        guard let vc = builder?.createMainModule(router: self) else { return }

        let nc = UINavigationController()
        nc.viewControllers = [vc]
        nc.modalPresentationStyle = .overFullScreen
        navigationController?.present(CountryListController(), animated: true, completion: nil)
    }
    
    func showLogin(animated: Bool) {
//        guard let vc = builder?.createLoginModule(router: self) else { return }
//        
//        let nc = UINavigationController()
//        nc.viewControllers = [vc]
//        nc.modalPresentationStyle = .overFullScreen
//        navigationController?.present(nc, animated: animated, completion: nil)
    }

    func dismiss() {
        navigationController?.dismiss(animated: true, completion: nil)
    }

    func showList(grpupID: Int) {
        guard let vc = builder?.createListModule(groupID: grpupID, router: self) else { return }
        navigationController?.viewControllers = [vc]
    }
}
