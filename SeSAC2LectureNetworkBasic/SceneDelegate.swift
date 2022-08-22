//
//  SceneDelegate.swift
//  SeSAC2LectureNetworkBasic
//
//  Created by 강민혜 on 7/27/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    // 앱 실행하자마자 api통신해서 realm에 담기??
//    let localRealm = try! Realm()
//    var tasks: Results<UserBoxOfficeList>!

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let _ = (scene as? UIWindowScene) else { return }
        
        // 배열의 Realm 데이터 초기화
//        tasks = localRealm.objects(UserBoxOfficeList.self).sorted(byKeyPath: "releaseDate", ascending: false)
        
        // 앱 처음실행시 API 통신해서 Realm에 담기?? 여기서? 그럼 tasks 데이터를 어떻게 뷰컨에 넘겨주냐.. 여기 아닌 것 같아
//        BOXOFFICEAPIManager.shared.fetchBOXOFFICEAPI(type: .boxOfficeURL, text: "20220801", tasks: tasks, localRealm: localRealm)
        
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        
        // Badge 제거
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

