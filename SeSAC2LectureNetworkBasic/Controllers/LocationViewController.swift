//
//  LocationViewController.swift
//  SeSAC2LectureNetworkBasic
//
//  Created by 강민혜 on 7/29/22.
//

import UIKit

class LocationViewController: UIViewController {
    
//    static var reuseIdentifier: String = "LocationViewController"

    // LocationViewController.self 메타 타입 => "LocationViewController"

    // Notification 1. 담당 객체 가져오기
    let notificationCenter = UNUserNotificationCenter.current()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        requestAuthorization()
        
        // custom font 이름 확인용
        for family in UIFont.familyNames {
            print("=========\(family)=========")
            
            for name in UIFont.fontNames(forFamilyName: family) {
                print(name)
            }
            
        }

    }
    
    // MARK: - 버튼 클릭시 액션
    @IBAction func notificationButtonTapped(_ sender: UIButton) {
        sendNotification()
    }
    
    // MARK: - notification 설정
    // Notification 2. 권한 요청
    func requestAuthorization() {
        
        let authorizationOptions = UNAuthorizationOptions(arrayLiteral: .alert, .badge, .sound)
        
        notificationCenter.requestAuthorization(options: authorizationOptions) { success, error in
            
            if success {
                self.sendNotification()
            }
            
            
        }
    }
    
    // Notification 3. 권한 허용한 사용자에게 알림 요청 (언제? 어떤 컨텐츠?)
    // iOS 시스템에서 알림을 담당 > 알림 등록
    
    /*
     - 권한 허용 해야만 알림이 온다
     - 권한 허용 문구 시스템적으로 최초 한 번만 뜬다.
     - 허용 안 된 경우, 애플 설정으로 직접 유도하는 코드를 구성 해야 한다.
     
     - 기본적으로 알림은 포그라운드에서 수신되지 않는다.
     - 로컬 알림에서 60초 이상 반복 가능 / 갯수 제한 64개 (등록기준? 아이덴테파이어? 등 어떤 기준인지는 찾아봐라~!!
     
     1. 뱃지 제거? > 언제 제거하는게 맞을까? => active
     2. 노티 제거? > 노티의 유효 기간은? > 카톡(오픈채팅, 단톡) vs 잔디 => didfinishlaunch withoptions/active/foreground 등
     3. 포그라운드 수신?
     
     +a
     - 노티는 앱 실행이 기본인데, 특정 노티를 클릭할때 특정 화면으로 가고 싶다면?
     - 포그라운드 수신, 특정 화면에서는 안받고 특정 조건에 대해서만 포그라운드 수신을 하고 싶다면??
     - iOS15 notification 받는 것에도 우선순위가 있음 : 집중모드 등 5-6 우선순위 존재!
     */
    
    func sendNotification() {
        
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "다마고치를 키워보세요"
        notificationContent.subtitle = "오늘 행운의 숫자는 \(Int.random(in: 1...100))입니다."
        notificationContent.body = "저는 따끔따끔 다마고치입니다. 배고파요."
        notificationContent.badge = 40
        
        // 언제 보낼 것인가? 1. 시간 간격 2. 캘린더 3. 위치에 따라 설정 가능
        // 시간 간격은 60초 이상으로 설정해야 반복 가능
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        
//        var dateComponents = DateComponents()
//        dateComponents.minute = 15 //매시 15분마다 알림이 온다
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        // 알림 요청
        // identifier:
        // 만약 알림 관리 할 필요 X -> 알림 클릭하면 앱을 켜주는 정보
        // 만약 알림 관리 할 필요 O -> +1, 고유 이름, 규칙 등
        // ex) 12개 >
        let request = UNNotificationRequest(identifier: "A", content: notificationContent, trigger: trigger)
        
        notificationCenter.add(request)
    }
    

}
