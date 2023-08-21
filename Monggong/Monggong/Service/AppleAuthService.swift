//
//  AppleAuthService.swift
//  Monggong
//
//  Created by 시혁 on 2023/08/17.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay
import FirebaseCore
import FirebaseAuth
import CryptoKit
import AuthenticationServices
class AppleAuthService: NSObject,ASAuthorizationControllerPresentationContextProviding, ASAuthorizationControllerDelegate{
    
    static let shared = AppleAuthService()
    var disposeBag : DisposeBag = DisposeBag()
    var currentNonce: String?
    let appleUser: PublishRelay<User> = PublishRelay()
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return UIApplication.shared.windows.first!
    }
    /// 애플로그인 플로우
    func startSignInWithAppleFlow() {
   
            let nonce = self.randomNonceString()
            self.currentNonce = nonce
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            request.nonce = self.sha256(nonce)
            
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self
            authorizationController.performRequests()
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError(
                "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
            )
        }
        
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        
        let nonce = randomBytes.map { byte in
            // Pick a random character from the set, wrapping around if needed.
            charset[Int(byte) % charset.count]
        }
        
        return String(nonce)
    }
    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    // ASAuthorizationControllerDelegate 프로토콜
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization){
        
            if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                guard let nonce = self.currentNonce else {
                    fatalError("Invalid state: A login callback was received, but no login request was sent.")
                }
                guard let appleIDToken = appleIDCredential.identityToken else {
                    print("Unable to fetch identity token")
                    return ()
                }
                guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                    print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                    return ()
                }
                // Initialize a Firebase credential, including the user's full name.
                let credential = OAuthProvider.appleCredential(withIDToken: idTokenString,
                                                               rawNonce: nonce,
                                                               fullName: appleIDCredential.fullName)
                print(#fileID, #function, #line, "- \(credential)")
                // Sign in with Firebase.
                Auth.auth().signIn(with: credential) { (authResult, error) in
                    if error != nil {
                        // Error. If error.code == .MissingOrInvalidNonce, make sure
                        // you're sending the SHA256-hashed nonce as a hex string with
                        // your request to Apple.
                        print(error?.localizedDescription)
                        print(#fileID, #function, #line, "- 애플 로그인 실패")
                        return
                    }
                    // User is signed in to Firebase with Apple.
                    // ...
                   
                    var displayName: String = ""
                    Util.shared.getRandomName { response in
                        if let name = response {
                            displayName = name
                        }else {
                            print("name loaded to fail")
                        }
                    }

                    let uid = authResult?.user.uid ?? ""
                    let userInfo: User = User(id: uid, name: displayName,isLogined: true)
                    self.appleUser.accept(userInfo)
                    UserInfo.shared.updateCurrentUser(userInfo)
                }//Auth
            }
            // if let
            func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
                // Handle error.
                print("Sign in with Apple errored: \(error)")
            }
        }
        
    }
