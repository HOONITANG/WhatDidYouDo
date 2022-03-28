//
//  Extensions.swift
//
//  Created by Stephen Dowless on 1/12/20.
//  Copyright © 2020 Stephan Dowless. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

// contraint를 편하게 작성하기 위해 추가함.
extension UIView {
    func anchor(top: NSLayoutYAxisAnchor? = nil,
                left: NSLayoutXAxisAnchor? = nil,
                bottom: NSLayoutYAxisAnchor? = nil,
                right: NSLayoutXAxisAnchor? = nil,
                paddingTop: CGFloat = 0,
                paddingLeft: CGFloat = 0,
                paddingBottom: CGFloat = 0,
                paddingRight: CGFloat = 0,
                width: CGFloat? = nil,
                height: CGFloat? = nil) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    func center(inView view: UIView, yConstant: CGFloat? = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: yConstant!).isActive = true
    }
    
    func centerX(inView view: UIView, topAnchor: NSLayoutYAxisAnchor? = nil, paddingTop: CGFloat? = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        if let topAnchor = topAnchor {
            self.topAnchor.constraint(equalTo: topAnchor, constant: paddingTop!).isActive = true
        }
    }
    
    func centerY(inView view: UIView, leftAnchor: NSLayoutXAxisAnchor? = nil, paddingLeft: CGFloat? = nil, constant: CGFloat? = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constant!).isActive = true
        
        if let leftAnchor = leftAnchor, let padding = paddingLeft {
            self.leftAnchor.constraint(equalTo: leftAnchor, constant: padding).isActive = true
        }
    }
    
    func setDimensions(width: CGFloat, height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: width).isActive = true
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    func addConstraintsToFillView(_ view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        anchor(top: view.topAnchor, left: view.leftAnchor,
               bottom: view.bottomAnchor, right: view.rightAnchor)
    }
}

// MARK: - UIColor
// let color = UIColor(rgb: 0xFFFFFF)
// let color = UIColor(rgb: 0xFFFFFF).withAlphaComponent(1.0)
// let color2 = UIColor(argb: 0xFFFFFFFF)
extension UIColor {
    /// Hex Code Color을 사용하게 하는 메서드
    convenience init(red: Int, green: Int, blue: Int, a: Int = 0xFF) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: CGFloat(a) / 255.0
        )
    }
    /// Hex Code Color을 사용하게 하는 메서드
    convenience init(rgb: Int) {
        self.init(
            red:(rgb >> 16) & 0xFF,
            green:(rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
    
    // let's suppose alpha is the first component (ARGB)
    /// Hex Code Color을 사용하게 하는 메서드
    convenience init(argb: Int) {
        self.init(
            red: (argb >> 16) & 0xFF,
            green: (argb >> 8) & 0xFF,
            blue: argb & 0xFF,
            a: (argb >> 24) & 0xFF
        )
    }
}

extension Object {
    /// RealmObject를 Dictionary로 변경하는 메서드
    func toDictionary() -> [String: Any] {
        let properties = self.objectSchema.properties.map { $0.name }
        var mutabledic = self.dictionaryWithValues(forKeys: properties)
        for prop in self.objectSchema.properties as [Property] {
            if (prop.name == "lastEvent") {}
            else {
                // find lists
                if let nestedObject = self[prop.name] as? Object {
                    mutabledic[prop.name] = nestedObject.toDictionary()
                } else if let nestedListObject = self[prop.name] as? RLMSwiftCollectionBase {
                    var objects = [[String: Any]]()
                    for index in 0..<nestedListObject._rlmCollection.count  {
                        let object = nestedListObject._rlmCollection[index] as! Object
                        objects.append(object.toDictionary())
                    }
                    mutabledic[prop.name] = objects
                }
            }
        }
        return mutabledic
    }
}

extension Date {
    
    /// 날짜 계산을 위한 메서드
    /// Date - Date -> 두 Date의 차이를 구할 수 있다.
    static func -(recent: Date, previous: Date) -> (month: Int?, day: Int?, hour: Int?, minute: Int?, second: Int?) {
        let day = Calendar.current.dateComponents([.day], from: previous, to: recent).day
        let month = Calendar.current.dateComponents([.month], from: previous, to: recent).month
        let hour = Calendar.current.dateComponents([.hour], from: previous, to: recent).hour
        let minute = Calendar.current.dateComponents([.minute], from: previous, to: recent).minute
        let second = Calendar.current.dateComponents([.second], from: previous, to: recent).second
        
        return (month: month, day: day, hour: hour, minute: minute, second: second)
    }
    
    /// 날짜 계산을 위한 메서드
    /// 해당하는 Date에 minutes만큼 시간을 더한다.
    func adding(minutes: Int) -> Date {
        return Calendar.current.date(byAdding: .minute, value: minutes, to: self)!
    }
    
}

// 다국어를 위해 추가함
extension Locale {
    var isKorean: Bool {
        return languageCode == "ko"
    }
    var isEnglish: Bool {
        return languageCode == "en"
    }
    var isJapan: Bool {
        return languageCode == "ja"
    }
}

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}


// controller를 view안에 넣기위해 사용하는 방법
extension UIViewController {
    func embed(_ viewController:UIViewController, inView view:UIView){
        viewController.willMove(toParent: self)
        viewController.view.frame = view.bounds
        view.addSubview(viewController.view)
        self.addChild(viewController)
        viewController.didMove(toParent: self)
    }
}

/// push Naivagtion의 애니메이션 방향을 바꾸기 위해 추가함.
extension UINavigationController {
    func pushViewControllerFromLeft(controller: UIViewController) {
        let trasition = CATransition()
        trasition.duration = 0.5
        trasition.type = CATransitionType.push
        trasition.subtype = CATransitionSubtype.fromLeft
        trasition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(trasition, forKey: kCATransition)
        pushViewController(controller, animated: false)
    }
    
    func popViewControllerToLeft() {
        let trasition = CATransition()
        trasition.duration = 0.5
        trasition.type = CATransitionType.push
        trasition.subtype = CATransitionSubtype.fromRight
        trasition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(trasition, forKey: kCATransition)
        popViewController(animated: false)
    }
    
    
}

extension Bundle {
    var isProduction: Bool {
        #if DEBUG
            return false
        #else
            guard let path = self.appStoreReceiptURL?.path else {
                return true
            }
            return !path.contains("sandboxReceipt")
        #endif
    }
}
