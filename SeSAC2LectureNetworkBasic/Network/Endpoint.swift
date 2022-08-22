//
//  Endpoint.swift
//  SeSAC2LectureNetworkBasic
//
//  Created by 강민혜 on 8/23/22.
//

import Foundation

enum Endpoint {
    
    case boxOfficeURL
    case lottoURL
    case translateURL
    case imageSearchURL
    
    var requestURL: String {
        switch self {
        case .boxOfficeURL:
            return URL.makeEndPointString("kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?")
        case .lottoURL:
            return "www.dhlottery.co.kr/common.do?method=getLottoNumber"
        case .translateURL:
            return URL.makeEndPointString("openapi.naver.com/v1/papago/n2mt")
        case .imageSearchURL:
            return URL.makeEndPointString("openapi.naver.com/v1/search/image.json?")
        }
    }
}
