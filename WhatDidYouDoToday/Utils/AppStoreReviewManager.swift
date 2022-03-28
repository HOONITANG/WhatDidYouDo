//
//  AppStoreReviewManager.swift
//  WhatDidYouDoToday
//
//  Created by Taehoon Kim on 2022/02/16.
//
import StoreKit

enum AppStoreReviewManager {
    static func requestReviewIfAppropriate(scene: UIWindowScene) {
        // 여러 조건들을 추가 할 수 있음.
        // item을 3개이상 추가 이후에 호출한다. 라는 조건을 추가 할 수 있음
        // 기본 정책 1년간 3번 이하로 호출됨
        
        SKStoreReviewController.requestReview(in: scene)
  }
}
