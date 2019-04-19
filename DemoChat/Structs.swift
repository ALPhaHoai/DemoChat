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

class TriangleView : UIView {
    var _color: UIColor! = UIColor.blue
    var _margin: CGFloat! = 0
    
    @IBInspectable var margin: Double {
        get { return Double(_margin)}
        set { _margin = CGFloat(newValue)}
    }
    
    
    @IBInspectable var fillColor: UIColor? {
        get { return _color }
        set{ _color = newValue }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        context.beginPath()
        context.move(to: CGPoint(x: rect.minX + _margin, y: rect.maxY - _margin))
        context.addLine(to: CGPoint(x: rect.maxX - _margin, y: rect.maxY - _margin))
        context.addLine(to: CGPoint(x: (rect.maxX / 2.0), y: rect.minY + _margin))
        context.closePath()
        
        context.setFillColor(_color.cgColor)
        context.fillPath()
    }
}
