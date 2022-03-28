//
//  PremiumViewModel.swift
//  TimeTodoPlanner
//
//  Created by Taehoon Kim on 2022/01/23.
//

import UIKit


enum PremiumOption: Int, CaseIterable {
    // case AddTag
    // case PadLock
    // case Backup
    case Cancel
    case AfterAdd
}

struct PremiumViewModel {
    var option: PremiumOption
    
    var title: String {
        switch option {
        
//        case .AddTag:
//            return I18NStrings.Setting.premiumOption1
//        case .PadLock:
//            return I18NStrings.Setting.premiumOption2
//        case .Backup:
//            return I18NStrings.Setting.premiumOption3
        
        case .Cancel:
            return I18NStrings.Setting.premiumOption4
        case .AfterAdd:
            return I18NStrings.Setting.premiumOption5
        }
    }
    
    var description: String {
        switch option {
        
//        case .AddTag:
//            return I18NStrings.Setting.premiumOptionDescriptoin1
//        case .PadLock:
//            return I18NStrings.Setting.premiumOptionDescriptoin2
//        case .Backup:
//            return I18NStrings.Setting.premiumOptionDescriptoin3
        case .Cancel:
            return I18NStrings.Setting.premiumOptionDescriptoin4
        case .AfterAdd:
            return I18NStrings.Setting.premiumOptionDescriptoin5
        }
    }
    
    var image: UIImage? {
        switch option {
//        case .AddTag:
//            return UIImage(named: "premium_add_tag")
//        case .PadLock:
//            return UIImage(named: "premium_padlock")
//        case .Backup:
//            return UIImage(named: "premium_backup")
        case .Cancel:
            return UIImage(named: "premium_cancel")
        case .AfterAdd:
            return UIImage(named: "add_after")
        }
    }
    
    init(option: PremiumOption) {
        self.option = option
    }
}
