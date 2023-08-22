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
        
        let isLoginOk : Observable<User> = self.userInfo
            .asObservable()
            .debug("로그인 시도")
            .share(replay: 1) // google & apple
        
        //        var isLoginOk : Observable<User> =
        input.googleLoginBtnTriger
            .debug("⭐️googleLoginBtnTriger")
            .flatMapLatest({
                return self.googleAuthLoginService.login()
            })
            .debug("google")
        //            .filter { $0.isLogined == true }
        //            .bind(to: self.userInfo)
            .bind(onNext: self.userInfo.accept(_:))
            .disposed(by: disposeBag)
        //        func accept(_ event: User) {}
        input.appleLoginBtnTriger
            .debug("appleLoginTriger")
            .bind(onNext: {self.appleAuthLoginService.startSignInWithAppleFlow()})
            .disposed(by: disposeBag)
        
        self.appleAuthLoginService.appleUser.bind(to: self.userInfo)
            .disposed(by: disposeBag)
        isLoginOk
            .debug("야호!")
            .map { user -> AppStep in
                return AppStep.mainTabBarIsRequired
            }
            .bind(to: self.steps)
            .disposed(by: disposeBag)
        
    }
}
