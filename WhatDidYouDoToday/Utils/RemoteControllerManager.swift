//
//  RemoteConfigManager.swift
//  TimeTodoPlanner
//
//  Created by Taehoon Kim on 2022/01/25.
//

import Foundation
import FirebaseRemoteConfig


// more key https://www.raywenderlich.com/17323848-firebase-remote-config-tutorial-for-ios
/// firebase remote config에서 전달 받을 키 값
enum ValueKey: String {
    case krNotice
    case enNotice
    case jpNotice
    case reviewUrl
}

class RemoteConfigManager {
    static let shared = RemoteConfigManager()
    private let remoteConfig = RemoteConfig.remoteConfig()
    
    private init() {
        loadDefaultValues()
        fetchConfigRemoteValues()
    }
    
    func loadDefaultValues() {
        let appDefaults: [String: Any?] = [
            ValueKey.krNotice.rawValue: [],
            ValueKey.enNotice.rawValue: [],
            ValueKey.jpNotice.rawValue: [],
        ]
        RemoteConfig.remoteConfig().setDefaults(appDefaults as? [String: NSObject])
    }
    
    func activateDebugMode() {
        let settings = RemoteConfigSettings()
        // WARNING: Don't actually do this in production!
        // cache data 시간, 86400 초가 적당해보임
        settings.minimumFetchInterval = 0
        RemoteConfig.remoteConfig().configSettings = settings
    }
    
    func activateReleaseMode() {
        let settings = RemoteConfigSettings()
        // WARNING: Don't actually do this in production!
        // cache data 시간, 86400 초가 적당해보임
        settings.minimumFetchInterval = 86400
        RemoteConfig.remoteConfig().configSettings = settings
    }
    
    
    func fetchConfigRemoteValues() {
        // 1 RemoteConfing cache 등 기본 설정 
        activateReleaseMode()
        
        // 2
        RemoteConfig.remoteConfig().fetch {_, error in
            if let error = error {
                print("Uh-oh. Got an error fetching remote values \(error)")
                // In a real app, you would probably want to call the loading
                // done callback anyway, and just proceed with the default values.
                // I won't do that here, so we can call attention
                // to the fact that Remote Config isn't loading.
                return
            }
            
            // 3
            RemoteConfig.remoteConfig().activate { _, _ in
                print("Retrieved values from the notice!")
            }
            
        }
    }
    
    func json(forKey key: ValueKey) -> [[String: AnyObject]] {
        let convertedValues = RemoteConfig
            .remoteConfig()[key.rawValue]
            .jsonValue as? [[String: AnyObject]] ?? []
        
        return convertedValues
    }
    
    func bool(forKey key: ValueKey) -> Bool {
        RemoteConfig.remoteConfig()[key.rawValue].boolValue
    }
    
    func ​string(forKey key: ValueKey) -> String {
        RemoteConfig.remoteConfig()[key.rawValue].stringValue ?? ""
    }
    
    func ​double(forKey key: ValueKey) -> Double {
        RemoteConfig.remoteConfig()[key.rawValue].numberValue.doubleValue
    }
    
    

//    func color(forKey key: ValueKey) -> UIColor {
//      let colorAsHexString = RemoteConfig.remoteConfig()[key.rawValue]
//        .stringValue ?? "#FFFFFF"
//      let convertedColor = UIColor(colorAsHexString)
//      return convertedColor
//    }
//
    
    
}
