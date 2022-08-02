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
    
    @IBOutlet weak var dateTitle: UILabel!
    
    @IBOutlet weak var background1: UIView!
    @IBOutlet weak var background2: UIView!
    
    
    let numberList: [Int] = Array(1...1025).reversed()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        
        numberTextField.textContentType = .oneTimeCode
        
        numberTextField.tintColor = .clear // 편법
        numberTextField.inputView = lottoPickerView // 키보드 업로드 방지
        
        lottoPickerView.delegate = self
        lottoPickerView.dataSource = self
        
        requestLotto(number: 986)
    }
    
    // MARK: - UI 구성
    
    func setUI() {
        view.backgroundColor = .white
        
        dateTitle.text = "추첨일자"
        dateTitle.font = .boldSystemFont(ofSize: 15)
        dateTitle.textColor = .darkGray
        
        background1.backgroundColor = .systemGray5
        background2.backgroundColor = .systemGray5
        
        background1.layer.cornerRadius = 10
        background2.layer.cornerRadius = 10
        
        // 나중에는 숫자 10의자리별로 색상 구별하기
        lottoNumberList[0].backgroundColor = .red
        lottoNumberList[1].backgroundColor = .yellow
        lottoNumberList[2].backgroundColor = .blue
        lottoNumberList[3].backgroundColor = .green
        lottoNumberList[4].backgroundColor = .green
        bonusNumber.backgroundColor = .yellow
        
        for i in 0...4 {
            lottoNumberList[i].textColor = .white
            lottoNumberList[i].font = .boldSystemFont(ofSize: 10)
        }
        
        bonusNumber.textColor = .white
        bonusNumber.font = .boldSystemFont(ofSize: 10)

    }
    
    
    
    // MARK: - 데이터 통신
    func requestLotto(number: Int) {
        
        // AF: 200~299 status code means success usually
        let url = "\(EndPoint.lottoURL)&drwNo=\(number)"
        
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
        
        // picker로 선택한 회차에 대한 정보를 통신해서 보여주는 함수
        requestLotto(number: numberList[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(numberList[row])회차"
    }
    
}
