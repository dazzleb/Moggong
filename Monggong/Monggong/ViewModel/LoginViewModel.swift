import Foundation
import RxSwift
import RxCocoa
import RxRelay
import RxFlow
protocol LoginModelTypeProtocol {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
class LoginViewModel: LoginModelTypeProtocol, Stepper {
    
    var steps: PublishRelay<Step> = PublishRelay()
    
    var disposeBag = DisposeBag()
    
    let userInfo: BehaviorRelay<User> = BehaviorRelay(value: User(id: "",
                                                                  name: "",
                                                                  profileURL: "",
                                                                  isLogined: false))
    
    private let googleAuthLoginService: GoogleAuthService
    
    struct Input {
        var googleLoginBtnTriger: Observable<Void>
    }
    
    init(google: GoogleAuthService = GoogleAuthService()){
        self.googleAuthLoginService = google
    }
    
    //MARK: transform
    func transform(input: Input) {
        
        let isLoginOk : Observable<User> = self.userInfo
            .asObservable()
            .share(replay: 1) // google & apple
        
//        var isLoginOk : Observable<User> =
        input.googleLoginBtnTriger
            .debug("⭐️googleLoginBtnTriger")
            .flatMapLatest({
                return self.googleAuthLoginService.login()
            })
//            .filter { $0.isLogined == true }
//            .bind(to: self.userInfo)
            .bind(onNext: self.userInfo.accept(_:))
            .disposed(by: disposeBag)
//        func accept(_ event: User) {}
        
        isLoginOk
            .map { user -> AppStep in
                return AppStep.profileIsRequired(userInfo: user)
            }
            .bind(to: self.steps)
            .disposed(by: disposeBag)
        
        // (User) -> Void
//        return Output(isLoginOk: isLoginOk)
    }
}
