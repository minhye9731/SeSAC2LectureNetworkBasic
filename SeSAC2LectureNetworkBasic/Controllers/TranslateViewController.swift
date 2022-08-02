//
//  TranslateViewController.swift
//  SeSAC2LectureNetworkBasic
//
//  Created by 강민혜 on 7/28/22.
//

import UIKit

import Alamofire
import SwiftyJSON

// UIButton, UITextField > 액션 연결 가능
// UITextView, UISearchBar, UIPickerView > 액션 연결 불가
// 왜?? 컨트롤 객체 기반이 아니다. 액션 연결 가능한 애들은 control을 채택해서 상속?받아서 구성됨

// UIResponderChain > 애플문서, 블로그 등 좋은 자료 많음

class TranslateViewController: UIViewController {

    @IBOutlet weak var userInputTextView: UITextView!
    @IBOutlet weak var exchangeButton: UIButton!
    @IBOutlet weak var userOutputTextView: UITextView!
    
    let textViewPlaceholder = "번역하고 싶은 문장을 작성해보세요."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()

        userInputTextView.delegate = self
        
        requestTranslatedData()
    }
    
    
    func setUI() {
        userInputTextView.backgroundColor = .systemGray3
        userInputTextView.text = textViewPlaceholder
        userInputTextView.textColor = .black
        userInputTextView.font = UIFont(name: "KyoboHandwriting2020", size: 17)
        
        exchangeButton.setImage(UIImage(named: "updown"), for: .normal)
        
        userOutputTextView.backgroundColor = .yellow
        userOutputTextView.textColor = .blue
        userOutputTextView.font = UIFont(name: "KyoboHandwriting2020", size: 17)
    }
    
    // 네트워크관련 코드 필요
    func requestTranslatedData() {
        
        let url = EndPoint.translateURL
        
        let parameter = ["source": "ko", "target": "en", "text": "\(userInputTextView.text!)"]
        
        let header: HTTPHeaders = ["X-Naver-Client-Id": APIKey.NAVER_ID, "X-Naver-Client-Secret": APIKey.NAVER_SECRET]

        
        AF.request(url, method: .post, parameters: parameter, headers: header).validate(statusCode: 200..<500).responseJSON { response in
            switch response.result {
            case .success(let value) :
                let json = JSON(value)
                print("JSON: \(json)")
                
                let statusCode = response.response?.statusCode ?? 500
                
                if statusCode == 200 {
                    self.userOutputTextView.text = "\(json["message"]["result"]["translatedText"].stringValue)"
                } else {
                    self.userInputTextView.text = json["errorMessage"].stringValue
                }
    
                
            case .failure(let error):
                print(error)
            }
        }
        
        
    }
    
    
    @IBAction func exchangeButtonTapped(_ sender: UIButton) {
        // 각 언어가 써있는 곳 언어 바꿔볼까
        
    }

}

extension TranslateViewController: UITextViewDelegate {
    // 텍스트뷰의 텍스트가 변할 때마다 호출
    func textViewDidChange(_ textView: UITextView) {
        
//        if textView.text.isEmpty {
//            textView.text = textViewPlaceholder
//        }
        requestTranslatedData()
        print(textView.text.count)
    }
    
    // 편집이 시작될 때, 커서가 시작될 때
    // 텍스트뷰 글자 : 플레이스 홀더랑 글자가 같으면 clear, color
    func textViewDidBeginEditing(_ textView: UITextView) {
        print("begin")
        
        textView.text.removeAll()
        
        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    // 편집이 끝났을 때, 커서가 없어지는 순간
    // 텍스트뷰 글자 : 사용자가 아무 글자도 안썼으면 플레이스 홀더 글자 보이게 해!
    func textViewDidEndEditing(_ textView: UITextView) {
        print("end")
        
        if textView.text.isEmpty {
            textView.text = textViewPlaceholder
            textView.textColor = .lightGray
        }
    }
    
}
