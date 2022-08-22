//
//  RealmModel.swift
//  SeSAC2LectureNetworkBasic
//
//  Created by 강민혜 on 8/22/22.
//

import Foundation
import RealmSwift

class UserBoxOfficeList: Object {
    
    @Persisted var movieTitle: String
    @Persisted var releaseDate: String
    @Persisted var totalCount: String
    
    @Persisted(primaryKey: true) var objectId: ObjectId
    
    convenience init(movieTitle: String, releaseDate: String, totalCount: String) {
        self.init()
        self.movieTitle = movieTitle
        self.releaseDate = releaseDate
        self.totalCount = totalCount
    }
}
