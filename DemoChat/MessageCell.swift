//
//  MessageCell.swift
//  ChatAppLBTA
//
//  Created by bruce on 2019/4/26.
//  Copyright © 2019 bruce. All rights reserved.
//

import UIKit
import SnapKit
import SwifterSwift

class MessageCell: UITableViewCell {
    
    let messageBody = UILabel()
    let messageLayout = UIView()
    
    func setUpData(_ message: Message){
        switch message.type {
        case .text:
            self.messageBody.text = message.message
        case .photo:
            self.messageBody.isHidden = true
            self.messageImage.isHidden = false
            self.messageImage.download(url: message.messageImage, placeholder: #imageLiteral(resourceName: "avatar_default"))
        case .file:
            self.messageBody.text =  message.messageFileName
        }
    }
    
    let messageImage : ScaleAspectFitImageView = {
        let messageImage = ScaleAspectFitImageView()
        messageImage.layer.masksToBounds = true
        messageImage.contentMode = .scaleAspectFit
        messageImage.isHidden = true
        return messageImage
    }()
    
    let triangle : TriangleView = {
        let triangle = TriangleView()
        triangle.translatesAutoresizingMaskIntoConstraints = false
        triangle.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        return triangle
    }()
    
    override func prepareForReuse() {
        messageImage.isHidden = true
        messageBody.isHidden = false
        messageBody.text = nil
        messageImage.image = nil
        super.prepareForReuse()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        
        selectionStyle = .none
//        transform = CGAffineTransform(scaleX: 1, y: -1)
        messageLayout.backgroundColor = .yellow
        messageLayout.layer.cornerRadius = 12
        
        addSubview(triangle)
        addSubview(messageLayout)
        messageLayout.addSubview(messageImage)
        messageLayout.addSubview(messageBody)
        messageBody.text = "We want to provide a longer string that is actually going to wrap onto the next line and maybe even a third line."
        messageBody.numberOfLines = 0
        
        messageBody.snp.makeConstraints{ maker in
            maker.top.equalToSuperview().offset(16)
            maker.bottom.equalToSuperview().offset(-16)
            maker.leading.equalToSuperview().offset(16)
            maker.trailing.equalToSuperview().offset(-16)
        }
        
        messageImage.snp.makeConstraints{ maker in
            maker.top.equalToSuperview().offset(16)
            maker.bottom.equalToSuperview().offset(-16)
            maker.leading.equalToSuperview().offset(16)
            maker.trailing.equalToSuperview().offset(-16)
            maker.height.lessThanOrEqualTo(256)
        }
        
        messageLayout.snp.makeConstraints{ maker in
            maker.top.equalToSuperview().offset(16)
            maker.bottom.equalToSuperview().offset(-16)
            maker.width.lessThanOrEqualToSuperview().multipliedBy(0.7)
        }
        
        triangle.snp.makeConstraints { maker in
            maker.width.equalTo(7)
            maker.height.equalTo(10)
            maker.top.equalTo(messageLayout.snp.top).offset(15)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class IncomingMessageCell: MessageCell{
    let avatar : UIImageView = {
        let avatar = UIImageView(image: #imageLiteral(resourceName: "avatar_default"))
        avatar.translatesAutoresizingMaskIntoConstraints = false
        return avatar
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        messageLayout.backgroundColor = .white
        messageBody.textColor =  .black
        
        addSubview(avatar)
        avatar.snp.makeConstraints{maker in
            maker.top.equalTo(messageLayout.snp.top)
            maker.leading.equalToSuperview().offset(10)
            maker.width.height.equalTo(40)
        }
        
        messageLayout.snp.makeConstraints{maker in
            maker.leading.equalTo(triangle.snp.trailing)
        }
        triangle.snp.makeConstraints{ maker in
            maker.leading.equalTo(avatar.snp.trailing).offset(10)
        }
        
        
        triangle.fillColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        triangle.rotate(byAngle: -120, ofType: .degrees)
        messageBody.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        messageLayout.backgroundColor = triangle.fillColor
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class SendingMessageCell: MessageCell{
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        messageLayout.backgroundColor = .darkGray
        messageBody.textColor =  .white
        
        triangle.snp.makeConstraints{ maker in
            maker.trailing.equalToSuperview().offset(-10)
        }
        messageLayout.snp.makeConstraints{ maker in
            maker.trailing.equalTo(triangle.snp.leading)
        }
        
        triangle.fillColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        triangle.rotate(byAngle: 120, ofType: .degrees)
        messageBody.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        messageLayout.backgroundColor = triangle.fillColor
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


