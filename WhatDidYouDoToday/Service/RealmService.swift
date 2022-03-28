//
//  RealmService.swift
//  WhatDidYouDoToday
//
//  Created by Taehoon Kim on 2022/02/12.
//

import Foundation


import UIKit
import RealmSwift

class RealmService {
    // sigleton pattern
    static let shared = RealmService()
    
    // Realm()으로 선언된 변수는 Document/밑에 있는 realmDB에 대한 포인터다.
    // 기존에 생성한 realmDB가 없다면 자동으로 생성된다.
    var realm = try! Realm()
    
    // realm에 object를 추가해주는 메서드
    func create<T:Object>(_ object:T) {
        do {
            try realm.write {
                realm.add(object)
            }
        } catch let error as NSError {
            post(error)
        }
    }
    
    // 객체의 값을 넣어주면, 자동으로 업데이트되는 메서드
    func update<T:Object>(_ object:T, with dictionary:[String:Any?]) {
        do {
            try realm.write {
                for (key, value) in dictionary {
                    if key != "_id" {
                        object.setValue(value, forKey: key)
                    }
                }
            }
        } catch let error as NSError {
            post(error)
        }
    }
    
    // 객체의 값을 넣어주면, 삭제하는 메서드
    func delete<T:Object>(_ object:T) {
        do {
            try realm.write {
                realm.delete(object)
            }
        } catch let error as NSError {
            post(error)
        }
    }
    
    
    // error handle notification event
    func post(_ error: Error) {
        print("DEBUG: realm Error is \(error)")
    }
    
}
