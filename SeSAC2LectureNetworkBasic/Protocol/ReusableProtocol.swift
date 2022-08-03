//
//  ReusableProtocol.swift
//  SeSAC2LectureNetworkBasic
//
//  Created by 강민혜 on 8/1/22.
//

import Foundation
import UIKit

protocol ReusableProtocol {
    static var reuseIdentifier: String { get }
}

extension UIViewController: ReusableProtocol { // extension 저장 프로퍼티 불가능
    
    static var reuseIdentifier: String { // 연산 프로퍼티 get만 사용한다면 get 생략 가능
        return String(describing: self)
    }
}

extension UITableViewCell: ReusableProtocol {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
