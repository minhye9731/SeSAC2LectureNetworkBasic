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
    
    var lottoPickerView = UIPickerView()
    
    @IBOutlet var lottoNumberList: [UILabel]!
    @IBOutlet weak var bonusNumber: UILabel!
    
    @IBOutlet weak var dateTitle: UILabel!
    
    @IBOutlet weak var lottoNoLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    
    let latestNo = getLatestDrwtNo()
    var numberList: [Int] { return Array(1...latestNo).reversed()}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        
        resultLabel.text = "당첨결과"
        configureLabel(label: lottoNoLabel, color: .red)
        configureLabel(label: resultLabel, color: .black)
        
        numberTextField.textContentType = .oneTimeCode
        
        numberTextField.tintColor = .clear // 편법
        numberTextField.inputView = lottoPickerView // 키보드 업로드 방지
        
        lottoPickerView.delegate = self
        lottoPickerView.dataSource = self
        
        requestLotto(number: latestNo)
    }
    
    // MARK: - UI 구성
    func setUI() {
        view.backgroundColor = .white
        
        dateTitle.text = "추첨일자"
        dateTitle.font = .boldSystemFont(ofSize: 15)
        dateTitle.textColor = .darkGray
        
        // 나중에는 숫자 10의자리별로 색상 구별하기
        for i in 0...5 {
            lottoNumberList[i].layer.cornerRadius = 8
            lottoNumberList[i].clipsToBounds = true
            
            lottoNumberList[i].backgroundColor = .darkGray
            
            lottoNumberList[i].textColor = .white
            lottoNumberList[i].font = .boldSystemFont(ofSize: 24)
            
            lottoNumberList[i].textAlignment = .center
            
        }
        
        bonusNumber.layer.cornerRadius = 8
        bonusNumber.clipsToBounds = true
        
        bonusNumber.backgroundColor = .blue
        bonusNumber.textColor = .white
        bonusNumber.font = .boldSystemFont(ofSize: 24)
        bonusNumber.textAlignment = .center
        
    }
    
    func configureLabel(label: UILabel, color: UIColor) {
        label.textColor = color
        label.font = .systemFont(ofSize: 30)
        label.textAlignment = .center
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
                
                // 뽑은 회차 표기
                self.lottoNoLabel.text = "\(number)회"
                
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
}
// MARK: - 가장최근 회차 구하기

func getLatestDrwtNo() -> Int{
    
    let startDate = Date(y: 2022, m: 7, d: 23, hh: 20, mm: 35, ss: 0)!
    let now = Date()
    
    print(startDate)
    print(now)
    
    let calendar = Calendar.current
    let gapMinutes = calendar.dateComponents([.minute], from: startDate, to: now).minute!
    
    print(gapMinutes)
    
    if gapMinutes < 10080 {
        print("아직 다음회차 추첨시간 이전입니다. 최근 회차는 1025회차")
        return 1025
        
    } else {
        let gapCycle = gapMinutes / 10080
        let latestLottoNo = 1025 + gapCycle
        print("이번회차는 \(latestLottoNo)차 입니다.")
        return latestLottoNo
    }
    
}


// MARK: - pickerview 설정
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


// MARK: - Date 구조체 확장이용해서 날짜생성하는 생성자 구현
extension Date {
    
    init?(y year: Int, m month: Int, d day: Int, hh hour: Int, mm minute: Int, ss second: Int) {
        
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        components.hour = hour
        components.minute = minute
        components.second = second
        
        guard let date = Calendar.current.date(from: components) else {
            return nil
        }
        
        self = date
    }
}
