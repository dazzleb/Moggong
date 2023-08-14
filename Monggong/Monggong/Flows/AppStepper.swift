//
//  AppStepper.swift
//  Monggong
//
//  Created by 시혁 on 2023/08/14.
//

import RxFlow
import RxCocoa
import RxRelay
import RxSwift
class AppSteper: Stepper {
    var steps: RxRelay.PublishRelay<RxFlow.Step> = PublishRelay()
    
    var initialStep: Step {
        return AppStep.loginIsRequired
    }
    
    func readyToEmitSteps() {
        print(#fileID, #function, #line, "- ")
    }
    
}
