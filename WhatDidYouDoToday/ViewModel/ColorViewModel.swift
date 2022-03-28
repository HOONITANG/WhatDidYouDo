//
//  ColorViewModel.swift
//  WhatDidYouDoToday
//
//  Created by Taehoon Kim on 2022/02/14.
//

import Foundation

struct ColorViewModel {
    var type: ColorType
    var index: Int = 0 {
        didSet { bgColor = items[index] }
    }
    var bgColor: Int = 0x000000
    var selectedItem: [String:Any]
    
    init(type: ColorType, selectedItem: [String:Any]) {
        self.type = type
        self.selectedItem = selectedItem
    }
    
    var items:[Int]  {
        switch type {
        case .basic:
            // black, red, blue, yellow, orange
            return [0x000000,0xff3b30,0x007aff,0xff9500,0x4cd964]
        case .warm:
            return [0xEDCFA9,0xE89F72,0xFF935E,0xD5724A,0xAA4B31]
        case .pastel:
            return [0xFCD1D1,0xECE2E,0xD3E0DC,0xAEE1E1,0xD9D7F1]
        case .cold:
            return [0x93B5C6,0xBCEBFD,0xC9CCD5,0xE4D8DC,0xFFE3E3]
        case .dark:
            return [0x535353,0x424242,0x323232,0x06405FA,0x032D44]
        case .spring:
            return [0xFEFFDE,0xDDFFBC,0x91C788,0x53744E,0x5D272D]
        case .coffee:
            return [0x493535,0x6C5050,0xEED6C4,0xFFF3E4,0xFCF0C8]
        case .retro:
            return [0xC6D57F,0xD57F7F,0xA2CDCD,0xF4DFB3,0x3E2257]
        }
    }
    
    var description:String {
        switch type {
        case .basic:
            return I18NStrings.Tag.basic
        case .warm:
            return I18NStrings.Tag.warm
        case .pastel:
            return I18NStrings.Tag.pastel
        case .cold:
            return I18NStrings.Tag.cold
        case .dark:
            return I18NStrings.Tag.dark
        case .spring:
            return I18NStrings.Tag.spring
        case .coffee:
            return I18NStrings.Tag.coffee
        case .retro:
            return I18NStrings.Tag.retro
        }
    }
    
    var isSelected:Bool {
        return selectedItem["type"] as! ColorType == type && selectedItem["index"] as! Int == index
    }
    
    
}

