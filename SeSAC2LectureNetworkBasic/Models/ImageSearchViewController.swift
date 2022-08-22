//
//  ImageSearchViewController.swift
//  SeSAC2LectureNetworkBasic
//
//  Created by 강민혜 on 8/3/22.
//

import UIKit

import Alamofire
import SwiftyJSON
import Kingfisher
import JGProgressHUD

class ImageSearchViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // 배열
    var list: [snackModel] = []
    
    //progress view
    let hud = JGProgressHUD()
    
    // 네트워크 요청할 시작 페이지 넘버
    var startPage = 1
    var totalCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self // 페이지네이션 위해 추가
        searchBar.delegate = self
        
        collectionView.register(UINib(nibName: ImageSearchCollectionViewCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: ImageSearchCollectionViewCell.reuseIdentifier)
        
        configureLayout()
        
    }
    
    // fethImage, requestImage, callRequestImage, getRequest... ㅡ> response에 따라 네이밍을 설정해주기도 함
    // 페이지네이션
    func fetchImage(query: String) {
        
        guard let text = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return } // 이 한줄이 중요
        
        let url = EndPoint.imageSearchURL + "query=\(text)&display=30&start=\(startPage)" // 왜 한글만 안되지?
        
        let header: HTTPHeaders = ["X-Naver-Client-Id": APIKey.NAVER_ID, "X-Naver-Client-Secret": APIKey.NAVER_SECRET]

        
        AF.request(url, method: .get, headers: header).validate(statusCode: 200..<500).responseData { response in
            switch response.result {
            case .success(let value) :
                let json = JSON(value)
                print("JSON: \(json)")
                
                self.totalCount = json["total"].intValue
                
//                for snack in json["items"].arrayValue {
//
//                    let imageUrl = snack["thumbnail"].stringValue
//
//                    let data = snackModel(imageUrl: imageUrl)
//
//                    self.list.append(data)
                
                
                // 어차피 받아오는 데이터는 1개 imgurl이니까 아래 한줄로만 해도됨
                // self.list.append(item["link"].stringValue)
//                }
                
                // 위의 함수를 고차함수 map으로 처리해본다.
//                self.list = json["items"].arrayValue.map { $0["link"].stringValue }
                
                
            
                self.collectionView.reloadData()
                
            case .failure(let error):
                print(error)
            }
        }
    }

}

// MARK: - search bar 설정
extension ImageSearchViewController: UISearchBarDelegate {
    
    // 검색 버튼 클릭 시 실행
    // 검색 단어가 바뀌는 것으로 쿼리정보 수정 후 통신 진행
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            list.removeAll()
            startPage = 1
            
//            collectionView.scrollToItem(at: <#T##IndexPath#>, at: <#T##UICollectionView.ScrollPosition#>, animated: <#T##Bool#>)
            
            fetchImage(query: text)
        }
    }
    
    // 취소 버튼 눌렀을 떄 실행
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        list.removeAll()
//        collectionView.reloadData()
//        searchBar.text = ""
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    
    // 서치바에 커서가 깜짝이기 시작할 떄 실행
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
}

// MARK: - 페이지네이션 적용
// 페이지네이션 방법3.
// 용량이 큰 이미지를 다운받아 셀에 보여보려고 하는 경우에 효과적
// 셀이 화면이 보이기 전에 미리 필요한 리소스를 다운받을 수도 있고, 필요하지 않다면 데이터를 취소할 수도 있음
// ios10 이상, 스크롤 성능 향상됨.

extension ImageSearchViewController:  UICollectionViewDataSourcePrefetching {
    
    // 셀이 화면에 보이기 직전에 필요한 리소스를 미리 다운 받는 기능
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
        for indexPath in indexPaths {
            if list.count - 1 == indexPath.item && list.count < totalCount {
                startPage += 30 // display 몇 개 하냐에 따라 더해주는 숫자는 다름
                fetchImage(query: searchBar.text!)
            }
        }
        print("===\(indexPaths)") // 어떤 셀을 미리 준비시키는 것을 알 수 있음
    }
    
    // 취소: 직접 취소하는 기능을 구현해야 함
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        print("===실패\(indexPaths)")
    }

}



// MARK: - collectionView 설정
extension ImageSearchViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let item = collectionView.dequeueReusableCell(withReuseIdentifier: ImageSearchCollectionViewCell.reuseIdentifier, for: indexPath) as? ImageSearchCollectionViewCell else { return ImageSearchCollectionViewCell() }
        
        let url = URL(string: list[indexPath.row].imageUrl)
        item.snackImageView.kf.setImage(with: url)
        
        return item
    }
    
    // 페이지네이션 방법1. 컬렉션뷰가 특정 셀을 그리려는 시점에 호출되는 메서드
    // 마지막 셀에 사용자가 위치해있는 지 명확하게 확인하기가 어려움
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        <#code#>
//    }
    
    // 페이지네이션 방법2. UICcrollViewDelegateProtocol
    // 테이블뷰/컬렉션뷰는 스크롤뷰를 상속받고 있어서, 스크롤뷰 프로토콜을 사용할 수 있음
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print(scrollView.contentOffset)
//    }
    
    
}

extension ImageSearchViewController {
    
    func configureLayout() {
        
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 8
        let width = UIScreen.main.bounds.width - (spacing * 3)
        layout.itemSize = CGSize(width: width / 2, height: width / 2)
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        
        collectionView.collectionViewLayout = layout
    }
}
