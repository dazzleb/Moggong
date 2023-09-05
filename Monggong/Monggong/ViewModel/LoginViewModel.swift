import Foundation
import RxSwift
import RxCocoa
import RxRelay
import RxFlow
protocol LoginModelTypeProtocol {
    associatedtype Input
    
    func transform(input: Input)
}
class LoginViewModel: LoginModelTypeProtocol, Stepper {
    
    var steps: PublishRelay<Step> = PublishRelay()
    
    var disposeBag = DisposeBag()
    
    let userInfo: BehaviorRelay<User> = BehaviorRelay(value: User(id: "",
                                                                  name: "",
                                                                  isLogined: false))
    
    private let googleAuthLoginService: GoogleAuthService
    private let appleAuthLoginService: AppleAuthService
    struct Input {
        var googleLoginBtnTriger: Observable<Void>
        var appleLoginBtnTriger: Observable<Void>
    }
    
    init(google: GoogleAuthService = GoogleAuthService(),apple: AppleAuthService = AppleAuthService()){
        self.googleAuthLoginService = google
        self.appleAuthLoginService = apple
    }
    
    //MARK: transform
    func transform(input: Input) {
//
        let isLoginOk : Observable<User> = self.userInfo
            .asObservable()
            .share(replay: 1) // google & apple
//
        input.googleLoginBtnTriger
            .debug("⭐️googleLoginBtnTriger")
            .flatMapLatest({
                return self.googleAuthLoginService.login()
            })
            .flatMapLatest({ (fetchedUser : User?) in
                if let fetchedUser = fetchedUser { // 유저 정보 존재 로그인
                    return Observable.just(fetchedUser)
                } else { // 회원가입 필요
                    return Observable.just(UserInfo.shared.getCurrentUser()!)
                }
            })
        //  .bind(to: self.userInfo)
            .bind(onNext: self.userInfo.accept(_:))
            .disposed(by: disposeBag)

        input.appleLoginBtnTriger
            .debug("appleLoginTriger")
            .bind(onNext: {self.appleAuthLoginService.startSignInWithAppleFlow()})
            .disposed(by: disposeBag)

        self.appleAuthLoginService.appleUser.bind(to: self.userInfo)
            .disposed(by: disposeBag)

        isLoginOk
//            .filter({ user in
//                user.id.count > 0
//            })
            .map { user -> AppStep in
                //TODO: 유저정보 입력 화면 으로 이동
//                UserDefaults.standard.set(user.id, forKey: "uid")
                return AppStep.registInfoRequired(userInfo: user)
            }
            .bind(to: self.steps)
            .disposed(by: disposeBag)
    }
}
