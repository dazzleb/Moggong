import Foundation
import RxSwift
import RxCocoa
import RxRelay
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
//import Alamofire
protocol GoogleAuthServiceProtocol {
    //    func login() -> User
    func login() -> Observable<User?>
    func logout()
}
/// google Auth
class GoogleAuthService: GoogleAuthServiceProtocol {
    
    
    var disposeBag: DisposeBag = DisposeBag()
    func login() -> Observable<User?>{
        
        return Observable.create { observer in
            
            if let topVC = UIApplication.shared.topViewController(){
                
                GIDSignIn.sharedInstance.signIn(withPresenting: topVC) { [unowned self] result, error in
                    if let error = error {
                        print("ERR")
                        observer.onError(error)
                        return
                    }
                    
                    guard let user = result?.user,
                          let idToken = user.idToken?.tokenString else {
                        observer.onCompleted()
                        return }
                    
                    //                    let googleClientId = FirebaseApp.app()?.options.clientID ?? ""
                    //                    let signInConfig = GIDConfiguration.init(clientID: googleClientId)
                    let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                                   accessToken: user.accessToken.tokenString)
                    //  signIn 메서드에 전달한 후 반환되는 Google 인증 토큰으로부터 Firebase 인증 사용자 인증 정보를 만듭니다.
                    Auth.auth().signIn(with: credential) { result, error in
                        if let error = error {
                            observer.onError(error)
                            return
                        }
                        print("로그인 실패:  \(error.debugDescription)")
                        print("로그인 성공 유저:  \(String(describing: result?.user.uid))")
                        /// id
                        let userID = result?.user.uid ?? ""
                        /// name
                        var name: String = ""
                        // 회원가입이 필요한지 로그인이 필요한지 판단
                        FirebaseLoginService.shared.haveUidWithResult(uid: userID,
                                                                      result: { (result: Result<User?, Error>) in
                            switch result {
                            case .success(let user):// db 존재시 값 담김
                                if let user = user {
                                    //들어온 유저 정보 저장
                                    UserInfo.shared.updateCurrentUser(user) // 유저 정보 업데이트 (로컬) Splash 에서 로그인 유저의 정보를 확인하기 위함
//TODO: - DB에 추가 는어디에?
                                    observer.onNext(user) // 값 방출
                                    observer.onCompleted()
                                }
                            case .failure(let err):
                                observer.on(Event.error(err))
                            }
                        })
                    } // 인증 정보
                }// GIDSignIn
            }// if let
            return Disposables.create()
        }
}// login
    
    /// google auth logout
    func logout(){
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
} // class
