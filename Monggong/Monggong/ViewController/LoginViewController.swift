//
//  LoginViewController.swift
//  Monggong
//
//  Created by 시혁 on 2023/08/14.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxRelay
import RxFlow
class LoginViewController: UIViewController, Stepper {
    var disposeBag: DisposeBag = DisposeBag()
    var steps: PublishRelay<Step> = PublishRelay()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .brown
    }
}
