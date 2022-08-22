//
//  URL+Extension.swift
//  SeSAC2LectureNetworkBasic
//
//  Created by 강민혜 on 8/23/22.
//

import Foundation

extension URL {
    
    static let baseURL = "https://"
    
    static func makeEndPointString(_ endpoint: String) -> String {
        return baseURL + endpoint
    }

}
