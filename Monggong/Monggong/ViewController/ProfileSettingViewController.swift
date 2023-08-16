import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxRelay
import RxFlow
import Then
import SnapKit
class ProfileSettingViewController: UIViewController, Stepper {
    var disposeBag: DisposeBag = DisposeBag()
    var steps: PublishRelay<Step> = PublishRelay()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
        
        guard let currentUser = UserInfo.shared.getCurrentUser() else {
            return
        }
    }
}
