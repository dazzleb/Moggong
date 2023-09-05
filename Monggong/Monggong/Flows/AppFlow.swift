//
//  AppFlow.swift
//  Monggong
//
//  Created by 시혁 on 2023/08/14.
//

import Foundation
import UIKit
import RxFlow
import RxCocoa
import RxSwift

enum AppStep: Step {
    //Splash
    case splash
    // Login
    case loginIsRequired
    // Profile Setting
    case registInfoRequired(userInfo: User)
    
    case mainTabBarIsRequired
}
final class AppFlow: Flow {
    var root: RxFlow.Presentable {
        return self.rootViewController
    }
    
    private let rootViewController: UINavigationController = {
        let nav = UINavigationController()
        nav.setNavigationBarHidden(false, animated: false)
        return nav
    }()
    
    func navigate(to step: RxFlow.Step) -> RxFlow.FlowContributors {
        guard let step = step as? AppStep else { return FlowContributors.none }
        
        switch step {
        case .splash:
            return navigatioToSplash()
            
        case .loginIsRequired:
            return navigationToScreen()
            
        case .registInfoRequired(let userInfo):
            return navigationToRegistIfonScreen(userInfo)
            
        case .mainTabBarIsRequired:
            return navigationToTabBar()
        }
    }
    private func navigatioToSplash() -> FlowContributors {
        let splashVC = SplashViewController()
        self.rootViewController.pushViewController(splashVC, animated: true)
        
        return .one(flowContributor: .contribute(withNext: splashVC))
    }
    private func navigationToScreen() -> FlowContributors {
        let loginVM = LoginViewModel()
        let vc = LoginViewController(loginViewMoel: loginVM)
        self.rootViewController.setViewControllers([vc], animated: true)
//        self.rootViewController.pushViewController(vc, animated: true)
        
//        return .one(flowContributor: .contribute(withNext: vc))
        return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: loginVM))
    }
    private func navigationToRegistIfonScreen(_ userInfo: User) -> FlowContributors {
        let registVM = RegistInfoViewModel()
        
        let vc = RegistUserInfoViewController(RegistInfoViewModel: registVM)
        self.rootViewController.setViewControllers([vc], animated: true)
        
        return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: registVM))
    }
    private func navigationToTabBar() -> FlowContributors {
        let tab = MainTabFlow()
        let tabBar = tab.rootViewController
        self.rootViewController.setViewControllers([tabBar], animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: tab,
                                                 withNextStepper: OneStepper(withSingleStep: MainTabStep.mainTabIsRequired)))
    }
}
