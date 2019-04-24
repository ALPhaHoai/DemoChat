//
// Created by bruce on 2019-04-04.
// Copyright (c) 2019 ___FULLUSERNAME___. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import SwifterSwift

class MessageCell: UITableViewCell {
    let cellView: UIView = {
        let cellView = UIView()
        cellView.backgroundColor = .clear
        
        return cellView
    }()
    
    let avatar : UIImageView = {
        let avatar = UIImageView(image: #imageLiteral(resourceName: "avatar_default"))
        return avatar
    }()
    
    let triangle : TriangleView = {
        let triangle = TriangleView()
        triangle.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        return triangle
    }()
    
    let messageLayout : UIView = {
        let messageLayout  = UIView()
        //messageLayout.layer.masksToBounds = false
        //messageLayout.clipsToBounds = true
        messageLayout.layer.cornerRadius = 10
        //messageTextLayout.bounds = messageTextLayout.frame.insetBy(dx: -10.0, dy: -10.0)
        return messageLayout
    }()
    
    let messageImage : UIImageView = {
        let messageImage = UIImageView()
        messageImage.layer.masksToBounds = true
        messageImage.contentMode = .scaleAspectFill
        messageImage.isHidden = true
        //messageImage.image = #imageLiteral(resourceName: "avatar_default")
        
        return messageImage
    }()
    let messageBody : UILabel = {
        let messageBody = UILabel()
        //        messageBody.contentMode = .scaleToFill
        messageBody.padding = UIEdgeInsets(inset: 10)
        //        messageBody.sizeToFit()
        //        messageBody.minimumScaleFactor = 0.5
        //        messageBody.lineBreakMode = .byClipping
        messageBody.numberOfLines = 0
        //messageBody.backgroundColor = .blue
        return messageBody
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        addSubview(cellView)
        cellView.addSubview(avatar)
        cellView.addSubview(triangle)
        cellView.addSubview(messageLayout)
        messageLayout.addSubview(messageImage)
        messageLayout.addSubview(messageBody)
        
        cellView.snp.makeConstraints { maker -> Void in
            maker.top.equalToSuperview().offset(5)
            maker.bottom.equalToSuperview().offset(-5)
            maker.leading.equalToSuperview().offset(10)
            maker.trailing.equalToSuperview().offset(-10)
        }
        triangle.snp.makeConstraints { maker -> Void in
            maker.width.equalTo(7)
            maker.height.equalTo(10)
            maker.top.equalToSuperview().offset(15)
        }
        messageLayout.snp.makeConstraints { maker -> Void in
            maker.width.lessThanOrEqualToSuperview().multipliedBy(0.7)
            maker.top.equalToSuperview().offset(10)
            maker.bottom.equalToSuperview().offset(-10)
        }
        
        messageImage.snp.makeConstraints { maker -> Void in
            maker.leading.top.equalToSuperview().offset(10)
            maker.trailing.bottom.equalToSuperview().offset(-10)
        }
        
        messageBody.snp.makeConstraints { maker -> Void in
            maker.top.equalToSuperview()
            maker.bottom.equalToSuperview()
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpData(message: Message){
        if let messageImage = message.messageImage {
            self.messageBody.isHidden = true
            self.messageImage.isHidden = false
            if let url = URL(string: messageImage) {
                self.messageImage.download(from: url, placeholder: #imageLiteral(resourceName: "avatar_default"))
            } else {
                self.messageImage.image = #imageLiteral(resourceName: "avatar_default")
            }
        } else {
            self.messageBody.text = message.message
        }
        //        setNeedsDisplay()
    }
    override func prepareForReuse(){
        super.prepareForReuse()
        
        self.messageBody.isHidden = false
        self.messageImage.isHidden = true
        self.messageImage.image = nil
    }
    
}

class ImcomingMessageCell: MessageCell{
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupView() {
        avatar.snp.makeConstraints { maker -> Void in
            maker.width.height.equalTo(40)
            maker.top.equalToSuperview().offset(10)
            maker.leading.equalToSuperview().offset(10)
        }
        triangle.snp.makeConstraints { maker -> Void in
            maker.leading.equalTo(avatar.snp.trailing).offset(10)
        }
        messageLayout.snp.makeConstraints { maker -> Void in
            maker.leading.equalTo(triangle.snp.trailing).offset(0)
            //            maker.trailing.lessThanOrEqualToSuperview().offset(-30)
        }
        
        messageImage.snp.makeConstraints { maker -> Void in
            maker.leading.equalToSuperview().offset(10)
            maker.trailing.equalToSuperview().offset(-10)
        }
        
        messageBody.snp.makeConstraints { maker -> Void in
            maker.leading.equalTo(messageLayout.snp.leading)
            maker.trailing.equalTo(messageLayout.snp.trailing)
        }
        
        avatar.isHidden = false
        triangle.fillColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        triangle.rotate(byAngle: -90, ofType: .degrees)
        messageBody.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        //        messageBody.textAlignment = .left
        messageLayout.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    }
}

class SendingMessageCell: MessageCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupView() {
        triangle.snp.makeConstraints { maker -> Void in
            maker.trailing.equalToSuperview()
        }
        messageLayout.snp.makeConstraints { maker -> Void in
            maker.trailing.equalTo(triangle.snp.leading)
        }
        messageImage.snp.makeConstraints { maker -> Void in
            maker.leading.equalToSuperview().offset(10)
            maker.trailing.equalToSuperview().offset(-10)
        }
        messageBody.snp.makeConstraints { maker -> Void in
            maker.trailing.equalTo(messageLayout.snp.trailing)
            maker.leading.equalTo(messageLayout.snp.leading)
        }
        
        avatar.isHidden = true
        triangle.fillColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        triangle.rotate(byAngle: 90, ofType: .degrees)
        messageBody.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        //        messageBody.textAlignment = .right
        messageLayout.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
    }
}
