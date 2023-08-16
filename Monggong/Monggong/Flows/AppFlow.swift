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
    // Login
    case loginIsRequired
    // Profile Setting
    case profileIsRequired(userInfo: User)
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
            
        case .loginIsRequired:
            return navigationToScreen()
            
        case .profileIsRequired(let userInfo):
            
            return navigationToProfileScreen(userInfo)
        }
    }
    
    private func navigationToScreen() -> FlowContributors {
        let loginVM = LoginViewModel()
        let vc = LoginViewController(loginViewMoel: loginVM)
        self.rootViewController.pushViewController(vc, animated: true)
        
//        return .one(flowContributor: .contribute(withNext: vc))
        return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: loginVM))
    }
    private func navigationToProfileScreen(_ userInfo: User) -> FlowContributors {
        let vc = ProfileSettingViewController()
        
        self.rootViewController.pushViewController(vc, animated: true)
        
        return .one(flowContributor: .contribute(withNext: vc))
    }
}
