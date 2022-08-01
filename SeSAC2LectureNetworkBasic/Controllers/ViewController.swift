//
//  ViewController.swift
//  SeSAC2LectureNetworkBasic
//
//  Created by 강민혜 on 7/27/22.
//

import UIKit

class ViewController: UIViewController, ViewPresentableProtocol {
    
    static let identifier: String = "ViewController"
    
    // 연산 프로퍼티로 쓰겠다 할때는 get, set 모두 사용할 수 있음
    var navigationTitleString: String {
        get {
            return "대장님의 다마고치"
        }
        set {
            title = newValue
        }
    }
    
    // get만 쓰고 싶다 할 때는, var를 let으로 설정해도 괜찮음
    var backgroundColor: UIColor {
        get {
            return .blue
        }
    }
    
    // MARK: - userdefaults 저장해두고 쓰기
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserDefaultsHelper.standard.nickname = "고래밥" // set으로 저장한 것과 마찬가지 역할
        title = UserDefaultsHelper.standard.nickname // get으로 저장된 데이터 가져와서 보여준 것과 마찬가지
        
        UserDefaultsHelper.standard.age = 80
        print(UserDefaultsHelper.standard.age)
        
    }
    
    func configureView() {
        navigationTitleString = "고래밥님의 다마고치"
        //        backgroundColor = .red // 읽기 전용인데 값을 입력도 가능함
        
        title = navigationTitleString
        view.backgroundColor = backgroundColor
    }
    
//    func configureLabel() {
//        <#code#>
//    }
    
}


