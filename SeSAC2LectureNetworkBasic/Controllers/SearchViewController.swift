////
////  SearchViewController.swift
////  SeSAC2LectureNetworkBasic
////
////  Created by 강민혜 on 7/27/22.
////
//
//import UIKit
//
///*
// Swift Protocol
// - Delegate
// - Datasource
//
// 1. 왼팔/오른팔 프로토콜 지정
// 2. 테이블뷰 아웃렛 연결
// 3. 테이블뷰 이름과 프로토콜 요소 연결 (1+2)
//
// */
//
//// extension으로 모든 뷰컨 배경색상 정하기
//extension UIViewController {
//
//    func setBackgroundColor() {
//        view.backgroundColor = .red
//    }
//}
//
//class SearchViewController: UIViewController, ViewPresentableProtocol, UITableViewDelegate, UITableViewDataSource {
//
//    var navigationTitleString: String {
//        get {
//            return "대장님의 다마고치"
//        }
//        set {
//            title = newValue
//        }
//    }
//
//    var backgroundColor: UIColor
//
//    static let identifier: String = "SearchViewController"
//
//
//
//    @IBOutlet weak var searchTableView: UITableView!
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        view.backgroundColor = .red
//
//        searchTableView.backgroundColor = .clear
//        // 연결고리 작업 : 테이블뷰가 해야 할 역할 > 뷰 컨트롤러에게 요청
//        searchTableView.delegate = self // self는 SearchViewController의 인스턴스 자체를 의미
//        searchTableView.dataSource = self
//
//        // 테이블뷰가 사용할 테이블뷰 셀(XIB) 등록
//        // XML : xml interface builder <= 예전에는 NIB
//        searchTableView.register(UINib(nibName: ListTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ListTableViewCell.identifier)
//
//
//    }
//
//    func configureView() {
//        searchTableView.backgroundColor = .clear
//        searchTableView.separatorColor = .clear
//        searchTableView.rowHeight = 60
//    }
//
////    func configureLabel() {
////        <#code#>
////    }
//
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 100
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.identifier, for: indexPath) as? ListTableViewCell else { return UITableViewCell() }
//        // 함수의 반환타입이 셀이라서 return쪽을 저렇게 적어줌
//
//        cell.backgroundColor = .clear // 보통 셀컬러를 그냥 투명으로 해주면, 배경색이랑 동일하게 나와서 편리함
//        cell.titleLabel.font = .boldSystemFont(ofSize: 22)
//        cell.titleLabel.text = "HELLO"
//
//        return cell
//    }
//}
