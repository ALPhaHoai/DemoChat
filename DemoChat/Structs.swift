//
// Created by bruce on 2019-04-05.
// Copyright (c) 2019 ___FULLUSERNAME___. All rights reserved.
//

import UIKit
import SwiftSoup

enum MessageType {
    case photo
    case text
    case file
}
struct Message {
    var nickname = ""
    var message = ""
    var incoming = false
    var time = 0
    
    var type: MessageType {
        if messageImage != nil {
            return .photo
        } else if messageFile != nil {
            return .file
        } else {
            return .text
        }
    }
    
    var messageImage : String? {
        do {
            let doc: Document = try SwiftSoup.parse(message)
            let img = try doc.select("img").first()
            if let src : String = try img?.attr("src"), src.starts(with: "http"){
                return src
            } else {
                return nil
            }
            
        } catch {
            return nil
        }
    }
    
    var messageFile : String? {
        do {
            let doc: Document = try SwiftSoup.parse(message)
            let a = try doc.select("a").first()
            if let href: String = try a?.attr("href") , href.starts(with: "http"){
                return href
            } else {
                return nil
            }
        } catch {
            return nil
        }
    }
    var messageFileName : String? {
        if messageFile == nil {
            return nil
        }
        do {
            let doc: Document = try SwiftSoup.parse(message)
            let a = try doc.select("a").first()
            if let text = try a?.text() {
                return text
            } else {
                return nil
            }
        } catch {
            return nil
        }
    }
    
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

public class ScaleAspectFitImageView : UIImageView {
    /// constraint to maintain same aspect ratio as the image
    private var aspectRatioConstraint:NSLayoutConstraint? = nil
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        self.setup()
    }
    
    public override init(frame:CGRect) {
        super.init(frame:frame)
        self.setup()
    }
    
    public override init(image: UIImage!) {
        super.init(image:image)
        self.setup()
    }
    
    public override init(image: UIImage!, highlightedImage: UIImage?) {
        super.init(image:image,highlightedImage:highlightedImage)
        self.setup()
    }
    
    override public var image: UIImage? {
        didSet {
            self.updateAspectRatioConstraint()
        }
    }
    
    private func setup() {
        self.contentMode = .scaleAspectFit
        self.updateAspectRatioConstraint()
    }
    
    /// Removes any pre-existing aspect ratio constraint, and adds a new one based on the current image
    private func updateAspectRatioConstraint() {
        // remove any existing aspect ratio constraint
        if let c = self.aspectRatioConstraint {
            self.removeConstraint(c)
        }
        self.aspectRatioConstraint = nil
        
        if let imageSize = image?.size, imageSize.height != 0
        {
            let aspectRatio = imageSize.width / imageSize.height
            let c = NSLayoutConstraint(item: self, attribute: .width,
                                       relatedBy: .equal,
                                       toItem: self, attribute: .height,
                                       multiplier: aspectRatio, constant: 0)
            // a priority above fitting size level and below low
            c.priority = UILayoutPriority(rawValue: (UILayoutPriority.defaultLow.rawValue + UILayoutPriority.fittingSizeLevel.rawValue) / 2)
            self.addConstraint(c)
            self.aspectRatioConstraint = c
        }
    }
    
   
}

class IntrinsicTableView: UITableView {
    override var contentSize: CGSize {
        didSet {
            self.invalidateIntrinsicContentSize()
        }
    }
    override var intrinsicContentSize: CGSize {
        self.layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}

