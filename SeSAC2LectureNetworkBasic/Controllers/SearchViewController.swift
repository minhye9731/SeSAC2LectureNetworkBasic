//
//  SearchViewController.swift
//  SeSAC2LectureNetworkBasic
//
//  Created by 강민혜 on 7/27/22.
//

import UIKit
import Alamofire
import SwiftyJSON

/*
 Swift Protocol
 - Delegate
 - Datasource

 1. 왼팔/오른팔 프로토콜 지정
 2. 테이블뷰 아웃렛 연결
 3. 테이블뷰 이름과 프로토콜 요소 연결 (1+2)

 */

/*
 각 json
 */


// extension으로 모든 뷰컨 배경색상 정하기
extension UIViewController {

    func setBackgroundColor() {
        view.backgroundColor = .red
    }
}



class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
//    static let identifier: String = "SearchViewController"
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchTableView: UITableView!
    
    // box 배열
    var list: [BoxOfficeModel] = []
    
//    var navigationTitleString: String {
//        get {
//            return "대장님의 다마고치"
//        }
//        set {
//            title = newValue
//        }
//    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        
        searchTableView.backgroundColor = .clear
        // 연결고리 작업 : 테이블뷰가 해야 할 역할 > 뷰 컨트롤러에게 요청
        searchTableView.delegate = self // self는 SearchViewController의 인스턴스 자체를 의미
        searchTableView.dataSource = self

        // 테이블뷰가 사용할 테이블뷰 셀(XIB) 등록
        // XML : xml interface builder <= 예전에는 NIB
        searchTableView.register(UINib(nibName: ListTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: ListTableViewCell.reuseIdentifier)
        
        searchBar.delegate = self
        requestBoxOffice(text: "20220801")

    }

    func configureView() {
        searchTableView.backgroundColor = .clear
        searchTableView.separatorColor = .clear
        searchTableView.rowHeight = 60
    }

    func configureLabel() {
        
    }


    func requestBoxOffice(text: String) {
        
        list.removeAll() // 로딩바를 띄워주면 여기에서 삭제해도 좋음
        
        // AF: 200~299 status code 301
        // 인증키 제한
        let url = "\(EndPoint.boxOfficeURL)key=\(APIKey.BOXOFFICE)&targetDt=\(text)"
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value) :
                let json = JSON(value)
                print("JSON: \(json)")
                
                for movie in json["boxOfficeResult"]["dailyBoxOfficeList"].arrayValue {
                    
                    let movieNm = movie["movieNm"].stringValue
                    let openDt = movie["openDt"].stringValue
                    let audiAcc = movie["audiAcc"].stringValue
                    
                    let data = BoxOfficeModel(movieTitle: movieNm, releaseDate: openDt, totalCount: audiAcc)
                    
                    self.list.append(data)
                }
                
                print(self.list)
                
                
                
//                let movieNm1 = json["boxOfficeResult"]["dailyBoxOfficeList"][0]["movieNm"].stringValue
//                let movieNm2 = json["boxOfficeResult"]["dailyBoxOfficeList"][1]["movieNm"].stringValue
//                let movieNm3 = json["boxOfficeResult"]["dailyBoxOfficeList"][2]["movieNm"].stringValue
                
                // list 배열에 데이터 추가
//                self.list.append(movieNm1)
//                self.list.append(movieNm2)
//                self.list.append(movieNm3)
                
                
                // 데이터가 다 들어간 이후에 갱신! 필수!
                self.searchTableView.reloadData()
                
                print(self.list)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.reuseIdentifier, for: indexPath) as? ListTableViewCell else { return UITableViewCell() }
        // 함수의 반환타입이 셀이라서 return쪽을 저렇게 적어줌

        cell.backgroundColor = .clear // 보통 셀컬러를 그냥 투명으로 해주면, 배경색이랑 동일하게 나와서 편리함
        cell.titleLabel.font = .boldSystemFont(ofSize: 22)
        cell.titleLabel.text = "\(list[indexPath.row].movieTitle): \(list[indexPath.row].releaseDate)"

        return cell
    }

    
    
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        requestBoxOffice(text: searchBar.text!) // 옵셔널 바인딩, 8글자, 숫자, 날짜로 변경 시 유효한 형태의 값만 감지 등
    }
}
