//
//  UIViewController+Extension.swift
//  SeSAC2LectureNetworkBasic
//
//  Created by 강민혜 on 8/23/22.
//

import UIKit

extension UIViewController {
    
    func setBackgroundColor() {
        view.backgroundColor = .red
    }
    
    // 어제 일자를 yyyyMMdd 양식 맞추기
    func getYesterday() -> String {

        let format = DateFormatter()
        format.dateFormat = #"yyyyMMdd"#
        format.locale = Locale(identifier: Locale.current.identifier)
        format.timeZone = TimeZone(identifier: TimeZone.current.identifier)

        let yesterday = Date().dayBefore

        return format.string(from: yesterday)
    }
}
