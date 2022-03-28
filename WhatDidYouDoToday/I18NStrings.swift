//
//  I18NStrings.swift
//  TimeTodoPlanner
//
//  Created by Taehoon Kim on 2022/01/25.
//

import Foundation

struct I18NStrings {
    struct Setting {
        static let setting = "setting".localized
        
        // 프리미엄
        static let premium = "premium".localized
        static let discoverPremium = "discoverPremium".localized
        static let premiumBenefits = "premiumBenefits".localized
        static let premiumDescription = "premiumDescription".localized
        static let premiumOption1 = "premiumOption1".localized
        static let premiumOption2 = "premiumOption2".localized
        static let premiumOption3 = "premiumOption3".localized
        static let premiumOption4 = "premiumOption4".localized
        static let premiumOption5 = "premiumOption5".localized
        static let premiumOptionDescriptoin1 = "premiumOptionDescriptoin1".localized
        static let premiumOptionDescriptoin2 = "premiumOptionDescriptoin2".localized
        static let premiumOptionDescriptoin3 = "premiumOptionDescriptoin3".localized
        static let premiumOptionDescriptoin4 = "premiumOptionDescriptoin4".localized
        static let premiumOptionDescriptoin5 = "premiumOptionDescriptoin5".localized
        
        static let purchase = "purchase".localized
        static let purchaseHistoryRecovery = "purchaseHistoryRecovery".localized
        
        // 일반
        static let general = "general".localized
        static let themeColorSettings = "themeColorSettings".localized
        static let fontSettings = "fontSettings".localized
        
        // 백업
        static let restoreBackup = "restoreBackup".localized
        static let iCloud = "iCloud".localized
        static let backUp = "backUp".localized
        static let restore = "restore".localized
        static let restoreMessageTitle = "restoreMessageTitle".localized
        static let restoreMessage = "restoreMessage".localized
        
       
        static let restoreCompleteTitle = "restoreCompleteTitle".localized
        static let restoreCompleteMessage = "restoreCompleteMessage".localized
        
        static let appRelated = "appRelated".localized
        static let appInfo = "appInfo".localized
        static let notice = "notice".localized
        static let contactUs = "contactUs".localized
        static let contactUsMessage = "contactUsMessage".localized
        static let review = "review".localized
        static let languageSettings = "languageSettings".localized
        
        static let languageSelect = "languageSelect".localized
    }
    
    struct Alert {
        static let end = "end".localized
        static let cancel = "cancel".localized
        static let ok = "ok".localized
        static let suspense = "suspense".localized
        static let notComplete = "notComplete".localized
        static let start = "start".localized
        static let complete = "complete".localized
        static let postpone = "postpone".localized
        static let remove = "remove".localized
        
        static let advertisement = "advertisement".localized
        static let advertisementMessage = "advertisementMessage".localized
        
        static let purchaseSuccess = "purchaseSuccess".localized
        static let purchaseFailed = "purchaseFailed".localized
        static let purchaseNotice = "purchaseNotice".localized
    }
    
    struct Tag {
        static let tag = "tag".localized
        static let color = "color".localized
        static let basic = "basic".localized
        static let pastel = "pastel".localized
        static let warm = "warm".localized
        static let cold = "cold".localized
        static let dark = "dark".localized
        static let spring = "spring".localized
        static let coffee = "coffee".localized
        static let retro = "retro".localized
        
        
        static let repeatDay = "repeatDay".localized
        static let emptyTitleMessage = "emptyTitleMessage".localized
        static let tagPlaceholder = "tagPlaceholder".localized
        static let emptyTagMessage = "emptyTagMessage".localized
        
        static let add = "add".localized
        static let modify = "modify".localized
        
        static let changeEmptyTagMessage = "changeEmptyTagMessage".localized
        static let removeDefaultTagMessage = "removeDefaultTagMessage".localized
        static let removeAllTaskMessage = "removeAllTaskMessage".localized
        static let changeEmptyTitleMessage = "changeEmptyTitleMessage".localized
        static let addEmptyTitleMessage = "addEmptyTitleMessage".localized
    }
    
    struct Event {
        static let eventChangeFailTitle = "eventChangeFailTitle".localized
        static let eventChangeFailMessage = "eventChangeFailMessage".localized
        static let eventRemoveTitle = "eventRemoveTitle".localized
        static let eventRemoveMessage = "eventRemoveMessage".localized
        static let eventCompleteMessage = "eventCompleteMessage".localized
    }
    
    struct Main {
        static let repeatRemoveMessage = "repeatRemoveMessage".localized
        static let changeStatusNotToday = "changeStatusNotToday".localized
        
    }
    
    struct Chart {
        static let totalUsageTime = "totalUsageTime".localized
        static let freeTime = "freeTime".localized
    }
}
