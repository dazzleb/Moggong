//
//  SetViewController.swift
//  Monggong
//
//  Created by 시혁 on 2023/08/22.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxRelay
import Then
import SnapKit
import RxFlow
class SetViewController: UIViewController, Stepper{
    var steps: RxRelay.PublishRelay<RxFlow.Step> = PublishRelay()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .brown
    }
}
