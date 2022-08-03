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

class ImageSearchViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var list: [snackModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        configureLayout()
        
        collectionView.register(UINib(nibName: ImageSearchCollectionViewCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: ImageSearchCollectionViewCell.reuseIdentifier)
        
        fetchImage()
    }
    
    
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
    
    // fethImage, requestImage, callRequestImage, getRequest... ㅡ> response에 따라 네이밍을 설정해주기도 함
    // 페이지네이션
    func fetchImage() {
        
        guard let text = "과자".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return } // 이 한줄이 중요
        
        let url = EndPoint.imageSearchURL + "query=\(text)&display=30&start=31" // 왜 한글만 안되지?      
        
        let header: HTTPHeaders = ["X-Naver-Client-Id": APIKey.NAVER_ID, "X-Naver-Client-Secret": APIKey.NAVER_SECRET]

        
        AF.request(url, method: .get, headers: header).validate(statusCode: 200..<500).responseJSON { response in
            switch response.result {
            case .success(let value) :
                let json = JSON(value)
                print("JSON: \(json)")
                
                for snack in json["items"].arrayValue {
                    
                    let imageUrl = snack["thumbnail"].stringValue
                    
                    let data = snackModel(imageUrl: imageUrl)
                    
                    self.list.append(data)
                }
            
                self.collectionView.reloadData()
                
            case .failure(let error):
                print(error)
            }
        }
    }

}

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
    
    
}
