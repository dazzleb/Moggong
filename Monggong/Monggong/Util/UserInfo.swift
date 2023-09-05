//
//  UserInfo.swift
//  Monggong
//
//  Created by 시혁 on 2023/08/16.
//

import Foundation
import Alamofire
import RxSwift
class UserInfo {
    static let shared = UserInfo()
    
    var user: User? = nil
    /// 유저 정보 업데이트
    func updateCurrentUser(_ user: User) {
        self.user = user
    }
    /// 유저 정보 호출
    func getCurrentUser() -> User? {
        return self.user
    }
    
}
class Util {
    static let shared = Util()
    ///
    func getRandomName(completion: @escaping (String?) -> Void) {
            let url = "https://nickname.hwanmoo.kr/"
            let parameters: [String: Any] = [
                "format": "json",
                "count": 1,
            ]
            
            AF.request(url, method: .get, parameters: parameters)
                .responseData { response in
                    switch response.result {
                    case .success(let data):
                        do {
                            let randomName = try JSONDecoder().decode(RandomName.self, from: data)
                            if let firstWord = randomName.words.first {
                                print("Random Name: \(firstWord)")
                                completion(firstWord)
                            } else {
                                print("No random name available")
                                completion(nil)
                            }
                        } catch {
                            print("JSON decoding failed: \(error)")
                            completion(nil)
                        }
                    case .failure(let error):
                        print("Random name loading failed: \(error)")
                        completion(nil)
                    }
                }
        }
    func pickUpName() -> Observable<String?> {
       return Observable.create { observer in
            Util.shared.getRandomName { response in
                guard let res = response else {
                    observer.onNext("")
                    observer.onCompleted()
                    return
                }
                observer.onNext(res)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
}
