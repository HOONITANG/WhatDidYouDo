//
//  AppDelegate.swift
//  WhatDidYouDoToday
//
//  Created by Taehoon Kim on 2022/02/12.
//

import UIKit
import RealmSwift
import Firebase
import GoogleMobileAds
import AdSupport

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    /// 처음 설치 유무
    var hasAlreadyLaunched :Bool!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //print(Realm.Configuration.defaultConfiguration.fileURL)
        
        // 데이터 추적 권한 요청
        // requestPermission()
        //        if #available(iOS 14, *) {
        //            ATTrackingManager.requestTrackingAuthorization { (status) in
        //                DispatchQueue.main.async {
        //                    switch status {
        //                    case .authorized:
        //                        // Tracking authorization dialog was shown
        //                        // and we are authorized
        //                        //print("Authorized")
        //
        //                        // Now that we are authorized we can get the IDFA
        //                        print(ASIdentifierManager.shared().advertisingIdentifier)
        //                    case .denied:
        //                        // Tracking authorization dialog was
        //                        // shown and permission is denied
        //                        //print("Denied")
        //                        break
        //                    case .notDetermined:
        //                        // Tracking authorization dialog has not been shown
        //                        //print("Not Determined")
        //                        break
        //                    case .restricted:
        //                        //print("Restricted")
        //                        break
        //                    @unknown default:
        //                        //print("Unknown")
        //                        break
        //                    }
        //                }
        //            }
        //        }
        
        // 광고 등록
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        // Firebase등록
        FirebaseApp.configure()
        
        // 날짜 변경하기 전 호출
        ComputeDayPass().operate()
        
        hasAlreadyLaunched = UserDefaults.standard.bool(forKey: "hasAlreadyLaunched")
        if hasAlreadyLaunched { hasAlreadyLaunched = true }
        // 처음 설치 하는 경우 실행됨.
        else {
            // 기본 태그 그룹 생성
            let tag = Tag(title: "Daily")
            tag.isDefault = true
            RealmService.shared.create(tag)
            
            // 하루 지남을 인식하기 위한 date 설정
            let date = CalendarHelper().getStandardDate()
            let defaults = UserDefaults.standard
            defaults.set(date, forKey:"dateKeyForUserDefault")
            
            // 설치되었음을 알리기 위해 true 설정
            UserDefaults.standard.set(true, forKey: "hasAlreadyLaunched")
            
            // 광고 alert 처음에만 호출하게 기본값설정
            UserDefaults.standard.set(true, forKey: "adAlert")
        }
        
        _ = RemoteConfigManager.shared
        return true
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

