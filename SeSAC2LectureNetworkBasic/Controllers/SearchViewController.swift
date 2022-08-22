//
//  SearchViewController.swift
//  SeSAC2LectureNetworkBasic
//
//  Created by 강민혜 on 7/27/22.
//

import UIKit
import Alamofire
import SwiftyJSON
import JGProgressHUD
import RealmSwift

/*
 Swift Protocol
 - Delegate
 - Datasource
 
 1. 왼팔/오른팔 프로토콜 지정
 2. 테이블뷰 아웃렛 연결
 3. 테이블뷰 이름과 프로토콜 요소 연결 (1+2)
 */

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchTableView: UITableView!
    
    let localRealm = try! Realm()
    var tasks: Results<UserBoxOfficeList>!
    
    let hud = JGProgressHUD() //progress view
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        
        // 연결고리 작업 : 테이블뷰가 해야 할 역할 > 뷰 컨트롤러에게 요청
        searchTableView.delegate = self
        searchTableView.dataSource = self
        
        // XML : xml interface builder <= 예전에는 NIB
        searchTableView.register(UINib(nibName: ListTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: ListTableViewCell.reuseIdentifier)
        
        searchBar.delegate = self
        
        tasks = localRealm.objects(UserBoxOfficeList.self).sorted(byKeyPath: "releaseDate", ascending: false)
        
//        if ??? {
//
//            print("어제일자 기준 데이터가 있는게 아니라면, 어제데이터로 최신 업데이트")
//        }
        
        
        
        requestBoxOfficeData(type: .boxOfficeURL, yesterday: getYesterday())
        
        // Date, DateFormatter Calendar 이 세개가 어떤 역할을 각각하는지 찾아봐라.
        // 어제일자 구하는거 dateformatter로 구하는방법도 있음. 하지만 그닥 추천안함(calendar를 추천)
        //        let format = DateFormatter()
        //        format.dateFormat = "yyyyMMdd"
        //        let yesterday = (   - 864?00) // 방법1
        //        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date()) // 방법2
        //        let dateResult = format.starts(with: yesterday!)
        //        requestBoxOffice(text: dateResult)
        
        // 네트워크 통신: 서버 점검 등에 대한 예외 처리
        // 네트워크가 느린 환경 테스트 -> 설정 가능 옵션 가능
        // : 실기기 테스트 시 Condition 조절 가능!
        // : 시뮬레이터에서도 가능! (추가 설치)
        // window > devices and simulators
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(#function)
        searchTableView.reloadData()
    }
    
    func configureView() {
        searchTableView.backgroundColor = .clear
        searchTableView.separatorColor = .clear
        searchTableView.rowHeight = 60
    }
    
    func requestBoxOfficeData(type: Endpoint, yesterday: String) {
        
        hud.show(in: view) // 로딩바 보여주기
        
        //        BOXOFFICEAPIManager.shared.fetchBOXOFFICEAPI(type: .boxOfficeURL, text: yesterday, tasks: tasks, localRealm: localRealm) { realmData in
        //
        //            print(realmData)
        //
        //            DispatchQueue.main.async {
        //                self.searchTableView.reloadData()
        //                self.hud.dismiss()
        //            }
        //
        //        }
        
        let url = type.requestURL +  "key=\(APIKey.BOXOFFICE)&targetDt=\(yesterday)"
        
        AF.request(url, method: .get).validate().responseData { [self] response in
            switch response.result {
            case .success(let value) :
                
                let json = JSON(value)
                
                for movie in json["boxOfficeResult"]["dailyBoxOfficeList"].arrayValue {
                    
                    let movieNm = movie["movieNm"].stringValue
                    let openDt = movie["openDt"].stringValue
                    let audiAcc = movie["audiAcc"].stringValue
                    
                    let newData = UserBoxOfficeList(movieTitle: movieNm, releaseDate: openDt, totalCount: audiAcc)
                    
                    try! self.localRealm.write {
                        self.localRealm.add(newData)
                        print("realm에 데이터 담기 성공 : \(newData)")
                    }
                }
                
                self.searchTableView.reloadData()
                self.hud.dismiss()
                
                
            case .failure(let error):
                self.hud.dismiss()
                print(error)
            }
        }
    }
    
    
    
    //    func requestBoxOffice(text: String) {
    //
    //        hud.show(in: view) // 로딩바 보여주기
    //        list.removeAll()
    //
    //        let url = "\(EndPoint.boxOfficeURL)key=\(APIKey.BOXOFFICE)&targetDt=\(text)"
    //
    //        AF.request(url, method: .get).validate().responseData { response in
    //            switch response.result {
    //            case .success(let value) :
    //                let json = JSON(value)
    //                print("JSON: \(json)")
    //
    //                for movie in json["boxOfficeResult"]["dailyBoxOfficeList"].arrayValue {
    //
    //                    let movieNm = movie["movieNm"].stringValue
    //                    let openDt = movie["openDt"].stringValue
    //                    let audiAcc = movie["audiAcc"].stringValue
    //
    //                    let data = BoxOfficeModel(movieTitle: movieNm, releaseDate: openDt, totalCount: audiAcc)
    //
    //                    self.list.append(data)
    //                }
    //
    //                // 데이터가 다 들어간 이후에 갱신! 필수!
    //                self.searchTableView.reloadData()
    //                self.hud.dismiss()
    //
    //                print(self.list)
    //
    //            case .failure(let error):
    //                self.hud.dismiss()
    //                print(error)
    //
    //            }
    //        }
    //    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.reuseIdentifier, for: indexPath) as? ListTableViewCell else { return UITableViewCell() }
        let row = tasks[indexPath.row]
        
        cell.configureUI()
        
        cell.titleLabel.text = "\(row.movieTitle) :  \(row.releaseDate)" + " (\(row.totalCount))"
        
        //        cell.titleLabel.text = "\(list[indexPath.row].movieTitle): \(list[indexPath.row].releaseDate)"
        
        return cell
    }
    
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        //        requestBoxOffice(text: searchBar.text!) // 옵셔널 바인딩, 8글자, 숫자, 날짜로 변경 시 유효한 형태의 값만 감지 등
        
        requestBoxOfficeData(type: .boxOfficeURL, yesterday: searchBar.text!)
    }
}
