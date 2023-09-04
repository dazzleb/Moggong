import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxRelay
import RxFlow
import Then
import SnapKit
class SplashViewController: UIViewController, Stepper {
    var disposeBag: DisposeBag = DisposeBag()
    var steps: PublishRelay<Step> = PublishRelay()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
        DispatchQueue.main.asyncAfter(deadline: .now()+1.2) {
            self.loadUserInfo()
        }
        
    }
    func loadUserInfo() {
        if let userUID =  UserDefaults.standard.string(forKey: "uid"){
            // 조회
            FirebaseLoginService.shared.haveUidWithResult(uid: userUID, result: { (result: Result<User?, Error>) in
                switch result {
                case .success(let user):
                    if let user = user {
                        self.steps.accept(AppStep.mainTabBarIsRequired)
                    }
                case .failure(let err):
                    print(err)
                }
            })
        }else {
            steps.accept(AppStep.loginIsRequired)
            return
        }
    }
}
