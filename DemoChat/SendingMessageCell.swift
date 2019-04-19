//
//  SendingMessageCell.swift
//  DemoChat
//
//  Created by bruce on 2019/4/19.
//  Copyright © 2019 bruce. All rights reserved.
//

import Foundation
import SnapKit
import UIKit

class SendingMessageCell: UITableViewCell {
    let cellView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        
//        view.layer.shadowColor = UIColor.black.cgColor
//        view.layer.shadowOffset = CGSize(width: 0, height: 3)
//        view.layer.shadowOpacity = 0.2
//        view.layer.shadowRadius = 1.0
//        view.layer.masksToBounds = false
//        view.clipsToBounds = false
//        view.layer.cornerRadius = 3
//
//        view.layer.borderWidth = 1
//        view.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 0.5)
        
        
        return view
    }()
    
    let triangle : UIView = {
        let triangle = TriangleView()
        triangle.fillColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        triangle.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        triangle.rotate(byAngle: 90, ofType: .degrees)
        return triangle
    }()
    
    let messageTextLayout : UIView = {
        let messageTextLayout  = UIView()
        messageTextLayout.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        messageTextLayout.layer.masksToBounds = false
        messageTextLayout.clipsToBounds = false
        messageTextLayout.layer.cornerRadius = 10
        return messageTextLayout
    }()
    
    let messageImage = UIImageView()
    let messageBody : UILabel = {
        let messageBody = UILabel()
        messageBody.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        messageBody.padding = UIEdgeInsets(inset: 10)
        return messageBody
    }()
    
    
    //    override open func awakeFromNib() {
    //        super.awakeFromNib()
    //        layer.cornerRadius = 15
    //        layer.masksToBounds = false
    //    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setup() {
        backgroundColor = UIColor.white
        addSubview(cellView)
        
        
        cellView.addSubview(triangle)
        cellView.addSubview(messageTextLayout)
        
        cellView.snp.makeConstraints { maker -> Void in
            maker.leading.equalToSuperview().offset(10)
            maker.trailing.equalToSuperview().offset(-10)
            maker.top.equalToSuperview().offset(5)
            maker.bottom.equalToSuperview().offset(-5)
        }
        
        triangle.snp.makeConstraints { maker -> Void in
            maker.width.equalTo(7)
            maker.height.equalTo(10)
            maker.trailing.equalToSuperview()
            maker.top.equalToSuperview().offset(15)
        }
        
        messageTextLayout.addSubview(messageImage)
        messageTextLayout.addSubview(messageBody)
        messageTextLayout.snp.makeConstraints { maker -> Void in
            maker.width.lessThanOrEqualToSuperview().multipliedBy(0.7)
            maker.top.equalToSuperview().offset(10)
            maker.bottom.equalToSuperview().offset(-10)
            maker.trailing.equalTo(triangle.snp.leading)
        }
        
        messageImage.snp.makeConstraints { maker -> Void in
            maker.top.equalToSuperview().offset(10)
            maker.bottom.equalToSuperview().offset(-10)
            maker.leading.equalToSuperview().offset(10)
            maker.trailing.equalToSuperview()
        }
        
        messageBody.snp.makeConstraints { maker -> Void in
            maker.edges.equalToSuperview()
        }
    }
}
