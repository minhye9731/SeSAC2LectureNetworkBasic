//
//  Constant.swift
//  SeSAC2LectureNetworkBasic
//
//  Created by 강민혜 on 8/1/22.
//

import Foundation

struct APIKey {
    static let BOXOFFICE = "f5eef3421c602c6cb7ea224104795888"
    
    static let NAVER_ID = "eLtcs2NG7VNTMuWN4O1d"
    static let NAVER_SECRET = "R0sJLqgLKL"
    
}


struct EndPoint {
    static let boxOfficeURL = "https://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?"
    
    static let lottoURL = "https://www.dhlottery.co.kr/common.do?method=getLottoNumber"
    
    static let translateURL = "https://openapi.naver.com/v1/papago/n2mt"
    
    static let imageSearchURL = "https://openapi.naver.com/v1/search/image.json?"
}







//enum StoryboardName {
//    case Main
//    case Search
//    case Setting
//}


struct StoryboardName {
    
    // 접근제어를 통해 초기화 방지 ->  이거를 추가해서 구조체를 사용해도 되지만, 이것마저도 귀찮을 때가 있음.
    private init() {
    
    }
    
    static let main = "Main"
    static let search = "Search"
    static let setting = "Setting"
}

/*
 1. struct type property vs. enum type property
 => 인스턴스 생성 방지가 될 수 있기 때문에 enum을 활용하는 장점이 있음.
 : 인스턴스가 생성되면 무슨 문제가 있나?
 -> 한곳에서 데이터를 저장해두고 모든 앱 상에서 재사용해서 쓰려고 하는게 목적인데, 인스턴스가 여기저기 생성되게 된다면 그 인스턴스가 곳곳에 산재하게 되어서 필요없는 공간이 낭비되고 코드의 일관성이 떨어짐
 
 2. enum case vs. enum static 무슨 차이가 있을까?
 => case에서는 중복값을 사용할 수 없음
 => case에서는 데이터 타입에 제약이 있어서
 
 그래서 확장성을 고려했을 때 enum static을 사용하는게 좋을 수 있다.
 
 */


//enum StoryboardName {
//    //    var nickname = "고래밥" // 열거형에서는 인스턴스 못만듦
//
//    static let main = "Main"
//    static let search = "Search"
//    static let setting = "Setting"
//
//}

//enum FontName: String {
//     enum 안에서는 rawvalue가 중복되는 값을 갖을 수 없음
//     -> 그래서 static let을 통해서
//
//    case title = ""
//    case body = ""
//    case caption = ""
//
//}













