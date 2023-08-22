//
//  SetFlow.swift
//  Monggong
//
//  Created by 시혁 on 2023/08/22.
//

import Foundation
import RxFlow
import RxCocoa
import RxSwift
import UIKit

enum SetStep: Step {
    case settingIsRequired
}
final class SetFlow: Flow {
  
    var root: Presentable {
        return self.rootViewController
    }
    
    private let rootViewController: UINavigationController = .init()
    
    init() {
     
    }
    deinit {
        print("\(type(of: self)): \(#function)")
    }
    
    func navigate(to step: RxFlow.Step) -> RxFlow.FlowContributors {
        guard let step = step as? SetStep else { return FlowContributors.none }
        
        switch step {
        case .settingIsRequired:
            let settingVC = SetViewController()
            self.rootViewController.pushViewController(settingVC, animated: true)
            
            return .one(flowContributor: .contribute(withNext: settingVC))
        default:
            return .none
        }
    }
}
