//
//  UserInfo.swift
//  Monggong
//
//  Created by 시혁 on 2023/08/16.
//

import Foundation

class UserInfo {
    static let shared = UserInfo()
    
    var user: User? = nil

    func updateCurrentUser(_ user: User) {
        self.user = user
    }
    
    func getCurrentUser() -> User? {
        return self.user
    }
    
}
