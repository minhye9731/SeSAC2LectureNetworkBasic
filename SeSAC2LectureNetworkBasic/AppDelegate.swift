//
//  AppDelegate.swift
//  SeSAC2LectureNetworkBasic
//
//  Created by 강민혜 on 7/27/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // 2. 노티 제거
        // allremove : 이전에 온 것만 지움
        // pending : 이전에 온 것, 앞으로 올 것 모두 지움
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        
        // delegate 연결
        UNUserNotificationCenter.current().delegate = self
        
        
        return true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        // ios 14 기준 버전별 분기처리해줄 수 있음
//        completionHandler([.alert , .badge, .sound]) alert이 list와 banner로 나뉨
        completionHandler([.list, .banner, .badge, .sound])
    }
    

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

