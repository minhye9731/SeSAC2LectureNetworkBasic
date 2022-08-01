//
//  UserDefaultsHelper.swift
//  SeSAC2LectureNetworkBasic
//
//  Created by 강민혜 on 8/1/22.
//

import Foundation
import UIKit


class UserDefaultsHelper {
    
    private init() { }
    
    static let standard = UserDefaultsHelper()
    // singleton pattern 자기 자신의 인스턴스를 타입 프로퍼티 형태로 가지고 있음
    
    let userDefaults = UserDefaults.standard
    
    enum Key: String {
        case nickname, age
    }
    
    
    var nickname: String {
        get {
            return userDefaults.string(forKey: Key.nickname.rawValue) ?? "대장"
        }
        set { // 연산 프로퍼티 parameter
            userDefaults.set(newValue, forKey: Key.nickname.rawValue)
            
        }
    }
    
    var age: Int {
        get {
            return userDefaults.integer(forKey: Key.age.rawValue) // 얘는 디폴트값이 0이라서 문제없음.
        }
        set {
            userDefaults.set(newValue, forKey: Key.age.rawValue)
        }
    }
    
}







