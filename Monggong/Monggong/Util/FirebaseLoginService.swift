//
//  FirebaseLoginServiec.swift
//  Monggong
//
//  Created by 시혁 on 2023/08/22.
//

import Foundation
import Firebase
import FirebaseStorage
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseFirestoreCombineSwift
import RxSwift
class FirebaseLoginService {
    static let shared = FirebaseLoginService()
    var disposeBag = DisposeBag()
    //1. 매개변수로 uid 를 받는다.
    //2. Users 테이블 엣허 uid 존재 여부 확인
    
    let db = Firestore.firestore()
    var ref: DocumentReference? = nil
    // 회원가입 되어있는지 확인
    // 성공 -> 해당 사용자 정보 가져옴
    // 실패
    //    Result<Success, Error>
    ///
    //    func haveUid(uid: String, result: @escaping (User?, Error?) -> Void) {
    //        let docRef = db.collection("users").document("\(uid)")
    //
    //        docRef.getDocument { (document, error) in
    //
    //            if error != nil {
    //                result(nil, error)
    //                return
    //            }
    //
    //            if let document = document, document.exists {
    //                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
    //                let userId: String = document.data()?["id"] as? String ?? ""
    //                let name: String = document.data()?["name"] as? String ?? ""
    //                let loginUser : User = User(id: userId, name: name)
    //                result(loginUser, nil)
    //                print("Document data: \(dataDescription)")
    //            } else {
    //                print("Document does not exist")
    //                result(nil, nil)
    //                //추가
    //            }
    //        }
    //
    //    }
    /// 현재 유저의 UID 를 통해 회원정보 존재 여부 확인
    func haveUidWithResult(uid: String, result: @escaping (Result<User?, Error>) -> Void) {
        let docRef = db.collection("users").document("\(uid)")
        
        docRef.getDocument { (document, error) in
            
            if let error = error {
                result(Result.failure(error))
                return
            }
            
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                
                let userId: String = document.data()?["id"] as? String ?? ""
                let name: String = document.data()?["name"] as? String ?? ""
                
                let loginUser : User = User(id: userId, name: name)
                result(Result.success(loginUser))
            } else {
                print("Document does not exist")
                result(Result.success(nil)) // 에러도 없고 값도 없을 때
                //추가
            }
        }
        
    }
    /// 유저의 정보를 DB에 저장
//    func writeUserInfo(user: User){
//        let userId = user.id
//        // Add a new document in collection "cities"
//        db.collection("users").document("\(user.id)").setData([
//            "id": "\(user.id)",
//            "name": "\(user.name)"
//        ]) { err in
//            if let err = err {
//                print("Error writing document: \(err)")
//            } else {
//                print("Document successfully written!")
//            }
//        }
//    }// wire
    
    
    
    
    //3. uid 로 유저 정보 가져오는 메서드 를 만든다.
    func write(name:Observable<String>){
        let userDefaults = UserDefaults.standard
        
        let user = UserInfo.shared.getCurrentUser()
        //userDefaults.object(forKey: "uid")
        name
            .subscribe(onNext: { name in
                if let userID = user?.id as? String {
                    self.db.collection("users").document("\(userID)").setData([
                        "id": "\(userID)",
                        "name": "\(name)"
                    ]) { err in
                        if let err = err {
                            print("Error writing document: \(err)")
                        } else {
                            print("Document successfully written!")
                        }
                    }
                }else {
                    print("x")
                }
            })
            .disposed(by: disposeBag)
        
        
        
        
    }
    
}
