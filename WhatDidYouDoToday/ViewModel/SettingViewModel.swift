//
//  SettingViewModel.swift
//  WhatDidYouDoToday
//
//  Created by Taehoon Kim on 2022/02/16.
//

import UIKit

enum SettingType: Int, CaseIterable {
    case premium
    //case general
    case backup
    case appInfo
}

enum SettingContentActionType: Int, CaseIterable {
    case DiscoverPremium
    case ThemeColorSettings
    case FontSettings
    case ICloud
    case AppInfo
    case Notice
    case ContactUs
    case AppReview
    case LanguageSettings
}

struct SettingViewModel {
    
    var type: SettingType
    
    // table Section의 이름
    var sectionName: String {
        switch type {
        case .premium:
            return I18NStrings.Setting.premium
//        case .general:
//            return I18NStrings.Setting.general
        case .backup:
            return I18NStrings.Setting.restoreBackup
        case .appInfo:
            return I18NStrings.Setting.appRelated
        }
    }
    
    // table Row의 이름
    var contentName: [[String: Bool]] {
        switch type {
        case .premium:
            return [[I18NStrings.Setting.discoverPremium: true]]
//        case .general:
//            return [[I18NStrings.Setting.themeColorSettings: true],[I18NStrings.Setting.fontSettings: true]]
        case .backup:
            return [[I18NStrings.Setting.iCloud: true]]
        case .appInfo:
        return [[I18NStrings.Setting.appInfo: true],
                    [I18NStrings.Setting.notice: true],
                    [I18NStrings.Setting.contactUs: false],
                    [I18NStrings.Setting.review: false]]
            // [I18NStrings.Setting.languageSettings: true]
        }
    }
    
    // table Row를 선택 했을 때 동작하려는 Action 모음
    var contentAction: [[String: SettingContentActionType]] {
        switch type {
        case .premium:
            return [["프리미엄 알아보기": SettingContentActionType.DiscoverPremium]]
        //case .general:
//            return [["테마 컬러 설정": SettingContentActionType.ThemeColorSettings],["폰트 설정": SettingContentActionType.FontSettings]]
        case .backup:
            return [["iCloud": SettingContentActionType.ICloud]]
        case .appInfo:
            return [["앱 정보": SettingContentActionType.AppInfo],
                    ["공지사항": SettingContentActionType.Notice],
                    ["문의하기": SettingContentActionType.ContactUs],
                    ["리뷰하기": SettingContentActionType.AppReview]]
//                    ["언어 설정": SettingContentActionType.LanguageSettings]]
        }
    }
    
    init(type: SettingType) {
        self.type = type
    }
}

