//
// Created by bruce on 2019-04-05.
// Copyright (c) 2019 ___FULLUSERNAME___. All rights reserved.
//

import UIKit

struct Message {
    var nickname = ""
    var message = ""
    var incoming = false
    var time = 0
    init() {
    }
}

struct Room {
    var RoomName = ""
    var UserID = ""
    var Name = ""
    var Avatar = ""
    var isActive = false
    var page = 0
    
    init() {
    }
}


struct User {
    var User_ID = ""
    var Username = ""
    var Avatar = ""
    var Status = ""
    var name = ""
    init() {
    }
}


class SendingTriangleView : UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {return}
        
        context.beginPath()
        context.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        context.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        context.addLine(to: CGPoint(x: (rect.maxX / 2.0), y: rect.minY))
        
        context.setFillColor(#colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1))
        context.fillPath()
    }
    
}

class IncomingTriangleView : UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {return}
        
        context.beginPath()
        context.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        context.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        context.addLine(to: CGPoint(x: (rect.maxX / 2.0), y: rect.minY))
        
        context.setFillColor(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1))
        context.fillPath()
    }
    
}
class Circle : UIView {
    override func draw(_ rect: CGRect) {
        let halfSize : CGFloat = min(bounds.size.width/2, bounds.size.height/2)
        let desiredLineWidth: CGFloat = 1
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: halfSize, y: halfSize), radius: CGFloat(bitPattern: UInt(halfSize - (desiredLineWidth/2.0))), startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2), clockwise: true)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        shapeLayer.fillColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        shapeLayer.strokeColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        shapeLayer.lineWidth = desiredLineWidth
        
        layer.addSublayer(shapeLayer)
    }
}
