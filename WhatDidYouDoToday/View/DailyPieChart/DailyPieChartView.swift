//
//  DailyPieChartView.swift
//  WhatDidYouDoToday
//
//  Created by Taehoon Kim on 2022/02/20.
//

import UIKit

class DailyPieChartView: UIView {
    
    var viewModel: [PieEventViewModel]?
    let total = CGFloat(24)
    let standardAngle: CGFloat = -(.pi / 2)
    
    let innerRadius = CGFloat(16)
    lazy var radius = frame.height / 2
    lazy var radiusForLabel = frame.height / 3
    // 외부의 contraint때문에, orign.x,origin.y값을 빼줌
    lazy var pieCenter = CGPoint(x: frame.midX - frame.origin.x, y: frame.midY - frame.origin.y)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        createBackGroundPieChart()
        createDailyPieChart()
        createPieChartIndicator()
        createHourIndicator()
        createLabel()
    }
    
    
    // background Circle: 사용하지 않은 공백의 시간을 표현함.
    func createBackGroundPieChart() {
       
        // background Circle: 사용하지 않은 공백의 시간을 표현함.
        let shapeLayer: CAShapeLayer = CAShapeLayer()
        let path = UIBezierPath()
        path.addArc(withCenter: pieCenter, radius: radius, startAngle: 0, endAngle: (360 * .pi) / 180, clockwise: true)
        shapeLayer.fillColor = UIColor.systemGray6.cgColor
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.lineWidth = 2
        shapeLayer.path = path.cgPath
        layer.addSublayer(shapeLayer)
    }
    
   
    // 실제 활동한 Pie 영역을 나타냄
    func createDailyPieChart() {
        guard let viewModel = viewModel else {
            return
        }
        // 각 event 시간별 비율을 표현함.
        viewModel.enumerated().forEach { (index, event) in
            let shapeLayer: CAShapeLayer = CAShapeLayer()
            let path = UIBezierPath()
            
            let startPoint = event.startPoint
            let endPoint = event.endPoint
            var startAngle: CGFloat = 0.0
            var endAngle: CGFloat = 0.0
            
            startAngle = standardAngle + (startPoint / total) * (.pi * 2)
            endAngle = standardAngle + (endPoint / total) * (.pi * 2)
            
            path.move(to: pieCenter)
            path.addArc(withCenter: pieCenter, radius: radius - innerRadius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            
            shapeLayer.fillColor = event.backgroundColor.cgColor
            shapeLayer.path = path.cgPath
            
            layer.addSublayer(shapeLayer)
        }
    }
    
    // Pie 영역에 대한 Title을 나타냄
    func createLabel() {
        guard let viewModel = viewModel else {
            return
        }

        // 각 event 시간별 비율을 표현함.
        viewModel.enumerated().forEach { (index, event) in
            
            // Text가 그려질 위치를 알기 위해 radius가 더 작은 Arc를 그림
            let path = UIBezierPath()
            let startPoint = event.startPoint
            let endPoint = event.endPoint
            let halfEndPoint = (startPoint + endPoint) / 2
            let startAngle: CGFloat = standardAngle + (startPoint / total) * (.pi * 2)
            
            // 시간의 중간 지점: 기존 Pie Chart의 호의 중간 위치를 알기위해 사용.
            let halfEndAngle: CGFloat = standardAngle + (halfEndPoint / total) * (.pi * 2)
            path.move(to: pieCenter)
            path.addArc(withCenter: pieCenter, radius: radiusForLabel, startAngle: startAngle, endAngle: halfEndAngle, clockwise: true)
            
            // CATextLayer생성
            let label = CATextLayer()
            let labelSize = event.labelSize()
            
           
            let width = labelSize.width// 텍스트길이에 따라 다름.
            let height = labelSize.height // 텍스트에 따라 다름.
            
            // 위치 조정, 중간에 나타내기 위해 텍스트의 widht,height을 빼줌.
            label.frame = CGRect(x: path.currentPoint.x - CGFloat((width / 2)) , y: path.currentPoint.y - CGFloat((height / 2)), width: width, height: height)
            
            label.contentsScale = UIScreen.main.scale
            
            label.fontSize = 12
            label.foregroundColor = UIColor.black.cgColor
            label.string = event.label
            layer.addSublayer(label)
        }
    }
    
    // PieChart의 24시간 Indicator를 나타냄
    func createPieChartIndicator() {
        
        // Indicator를 표현함.
        var startAngle: CGFloat = standardAngle
        var endAngle: CGFloat = 0.0
        
        for i in 0...Int(total) {
            let currentPoint = getPieChartEachPoint(with: radius - innerRadius, startAngle: startAngle, endAngle: endAngle)
            let outPoint = getPieChartEachPoint(with: radius - innerRadius, startAngle: startAngle, endAngle: endAngle)
            
            // 24분의 1 pie
            endAngle = (1 / total) * (.pi * 2)
            startAngle += endAngle
            
            // 선그리기
            let linePath = UIBezierPath()
            linePath.move(to: currentPoint)
            linePath.addLine(to: outPoint)
            let shapeLayer: CAShapeLayer = CAShapeLayer()
            
            linePath.lineCapStyle = .round
            
            shapeLayer.lineWidth = 2
            shapeLayer.strokeColor = UIColor.black.cgColor
            shapeLayer.opacity = 1.0
            shapeLayer.path = linePath.cgPath
            shapeLayer.lineCap = .round
            shapeLayer.lineJoin = .round
            
            
            if i == 0 || i == 5 || i == 11 || i == 17 || i == 23 {
                // 이 위치엔 dot이 아닌 createHourIndicator에서 텍스트를 써줌.
            } else {
                layer.addSublayer(shapeLayer)
            }
        }
    }
    
    func createHourIndicator() {
        
        // Indicator를 표현함.
        var startAngle: CGFloat = standardAngle
        var endAngle: CGFloat = 0.0
        
        for i in 0...4 {
            let currentPoint = getPieChartEachPoint(with: radius - innerRadius, startAngle: startAngle, endAngle: endAngle)
            
            // 4분의 1 pie
            endAngle = (6 / total) * (.pi * 2)
            startAngle += endAngle
            
            // Text 생성
            let label = CATextLayer()
            label.alignmentMode = .center
            let width = 16 // 텍스트길이에 따라 다름.
            let height = 16  // 텍스트에 따라 다름.
            // 위치 조정
            label.frame = CGRect(x: currentPoint.x - CGFloat((width / 2)) , y: currentPoint.y - CGFloat((height / 2)), width: CGFloat(width), height: CGFloat(height))
            label.contentsScale = UIScreen.main.scale
            label.fontSize = 12
            label.foregroundColor = UIColor.black.cgColor
            // label.string = "공부하기,\n공부하기"
            
            if i == 1 {
                label.string = "12"
            } else if i == 2 {
                label.string = "18"
            } else if i == 3 {
                label.string = "24"
            } else if i == 4 {
                label.string = "6"
            }
            
            layer.addSublayer(label)
        }
    }
    
    // 현재 시간을 분으로 변경함 1시20분 -> 80
    func convertDateToMinutes(_ date: Date) -> Double {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        let digit: Double = pow(10, 2)
        let index = Double((hour * 60) + minute) / Double(60)
        let result = round(index * digit) / digit
        
        return result
    }
    
    // pie Chart의 각 point를 전달하는 메서드
    func getPieChartEachPoint(with radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat) -> CGPoint {
    
        let path = UIBezierPath()
        path.move(to: pieCenter)
        path.addArc(withCenter: pieCenter, radius: radius, startAngle: startAngle, endAngle: startAngle + endAngle, clockwise: true)
       
        return path.currentPoint
    }
}
