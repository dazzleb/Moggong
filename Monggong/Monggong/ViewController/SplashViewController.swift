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
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            self.loadUserInfo()
        }
        
    }
    func loadUserInfo() {
//        if let userID = UserInfo.shared.getCurrentUser(){
//            // 로그인 기록 존재
//            FirebaseLoginService.shared.haveUidWithResult(uid: userID.id, result: { (result: Result<User?, Error>) in
//                // db 조회
//                switch result {
//                case .success(let user):
//                    if let user = user {
//                        self.steps.accept(AppStep.mainTabBarIsRequired)
//                    }
//                case .failure(let err):
//                    print(err)
//                }
//            })
//        }else{
//            steps.accept(AppStep.loginIsRequired)
//            return
//        }
        
        
        if let userUID =  UserDefaults.standard.string(forKey: "uid"){
            // 로그인 기록 존재
            FirebaseLoginService.shared.haveUidWithResult(uid: userUID, result: { (result: Result<User?, Error>) in
                // db 조회
                switch result {
                case .success(let user):
                    if let user = user {
                        self.steps.accept(AppStep.mainTabBarIsRequired)
                    }
                case .failure(let err):
                    print(err)
                }
            })
        }else { // 로그인 성공 기록 없을때
            steps.accept(AppStep.loginIsRequired)
            return
        }
    }
}
