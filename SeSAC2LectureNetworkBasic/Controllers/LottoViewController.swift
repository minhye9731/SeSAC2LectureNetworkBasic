//
//  LottoViewController.swift
//  SeSAC2LectureNetworkBasic
//
//  Created by 강민혜 on 7/28/22.
//

import UIKit
import WebKit

import SwiftyJSON
import Alamofire

class LottoViewController: UIViewController {
    
    @IBOutlet weak var numberTextField: UITextField!
//    @IBOutlet weak var lottoPickerView: UIPickerView!
    
    var lottoPickerView = UIPickerView()
    // 코드로 뷰를 만드는 기능이 훨씬 더 많이 남아있습니다!!
    
    @IBOutlet var lottoNumberList: [UILabel]!
    @IBOutlet weak var bonusNumber: UILabel!
    
    let numberList: [Int] = Array(1...1025).reversed()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        numberTextField.textContentType = .oneTimeCode
        
        numberTextField.tintColor = .clear // 편법
        numberTextField.inputView = lottoPickerView // 키보드 업로드 방지
        
        lottoPickerView.delegate = self
        lottoPickerView.dataSource = self
        
        requestLotto(number: 986)
    }
    
    func requestLotto(number: Int) {
        
        // AF: 200~299 status code means success usually
        let url = "https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=\(number)"
        
        AF.request(url,
                   method: .get)
        .validate(statusCode: 200..<400)
        .responseJSON {
            response in
            
            switch response.result {
                
            case .success(let value):
                
                    // 통신받아온 데이터를 JSON으로 변형하여 json에 저장
                    let json = JSON(value)
                    
                    // 로또번호 표기
                    for order in 1...6 {
                        self.lottoNumberList[order - 1].text = "\(json["drwtNo\(order)"].intValue)"
                    }
                    
                    // 보너스 넘버 표기
                    self.bonusNumber.text = "\(json["bnusNo"].intValue)"
                    
                    // 뽑기 일자 표기
                    let date = json["drwNoDate"].stringValue
                    self.numberTextField.text = date
                

                
            case .failure(let error):
                print(error)
            }
        }
    }

}


extension LottoViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return numberList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
//        requestLotto(number: numberList[row])
//        numberTextField.text = "\(numberList[row])회차" // 얘는 이제 필요없음
        
        // picker로 선택한 회차에 대한 정보를 통신해서 보여주는 함수
        requestLotto(number: numberList[row])
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(numberList[row])회차"
    }
    
}
