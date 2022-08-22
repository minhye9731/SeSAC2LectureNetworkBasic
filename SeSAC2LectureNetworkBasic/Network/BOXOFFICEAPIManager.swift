//
//  BOXOFFICEAPIManager.swift
//  SeSAC2LectureNetworkBasic
//
//  Created by 강민혜 on 8/23/22.
//

import Foundation
import Alamofire
import SwiftyJSON
import JGProgressHUD
import RealmSwift

class BOXOFFICEAPIManager {
    static let shared = BOXOFFICEAPIManager()
    
    private init() { }
    
    func fetchBOXOFFICEAPI(type: Endpoint, text: String, tasks: Results<UserBoxOfficeList>, localRealm: Realm, completionHandler: @escaping(Realm) -> ()) {
        
        let url = type.requestURL +  "key=\(APIKey.BOXOFFICE)&targetDt=\(text)"
        
        AF.request(url, method: .get).validate().responseData { response in
            switch response.result {
            case .success(let value) :
                
                let json = JSON(value)
                print("JSON: \(json)")
                
                for movie in json["boxOfficeResult"]["dailyBoxOfficeList"].arrayValue {
                    
                    let movieNm = movie["movieNm"].stringValue
                    let openDt = movie["openDt"].stringValue
                    let audiAcc = movie["audiAcc"].stringValue
                    
                    let newData = UserBoxOfficeList(movieTitle: movieNm, releaseDate: openDt, totalCount: audiAcc)
                    
                    try! localRealm.write {
                        localRealm.add(newData)
                        print("realm에 데이터 담기 성공 : \(newData)")
                    }
                }
                
                completionHandler(localRealm)
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
