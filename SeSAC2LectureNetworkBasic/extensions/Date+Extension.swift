//
//  Date+Extension.swift
//  SeSAC2LectureNetworkBasic
//
//  Created by 강민혜 on 8/23/22.
//

import Foundation

// Calendar로 어제 날짜 구하는 연산 프로퍼티 생성
// 사용자에 따라 위치와 시간을 상세설정해둔게 calendar임

extension Date {
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: self)!
    }
}
