//
//  ImageSearchViewController.swift
//  SeSAC2LectureNetworkBasic
//
//  Created by 강민혜 on 8/3/22.
//

import UIKit

import Alamofire
import SwiftyJSON

class ImageSearchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchImage()
        
    }
    

    // fethImage, requestImage, callRequestImage, getRequest... ㅡ> response에 따라 네이밍을 설정해주기도 함
    // 페이지네이션
    func fetchImage() {
        let text = "과자".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! // 이 한줄이 중요
        
        let url = EndPoint.imageSearchURL + "query=\(text)&display=30&start=31" // 왜 한글만 안되지?
        
        let header: HTTPHeaders = ["X-Naver-Client-Id": APIKey.NAVER_ID, "X-Naver-Client-Secret": APIKey.NAVER_SECRET]

        
        AF.request(url, method: .get, headers: header).validate(statusCode: 200..<500).responseJSON { response in
            switch response.result {
            case .success(let value) :
                let json = JSON(value)
                print("JSON: \(json)")
                

                
            case .failure(let error):
                print(error)
            }
        }
    }

}
