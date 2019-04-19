//
// Created by bruce on 2019-04-04.
// Copyright (c) 2019 ___FULLUSERNAME___. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import SwifterSwift

class ImcomingMessageCell: UITableViewCell {
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
    
    let avatar : UIImageView = {
        let avatar = UIImageView(image: #imageLiteral(resourceName: "avatar_default"))
        return avatar
    }()
    
    let triangle : UIView = {
        let triangle = IncomingTriangleView()
        return triangle
    }()
    
    let messageTextLayout : UIView = {
        let messageTextLayout  = UIView()
        messageTextLayout.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        messageTextLayout.layer.masksToBounds = false
        messageTextLayout.clipsToBounds = false
        messageTextLayout.layer.cornerRadius = 10
        //messageTextLayout.bounds = messageTextLayout.frame.insetBy(dx: -10.0, dy: -10.0)
        
        return messageTextLayout
    }()
    
    let messageImage = UIImageView()
    let messageBody = UILabel()
    
    
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

        cellView.addSubview(avatar)
        cellView.addSubview(triangle)
        cellView.addSubview(messageTextLayout)

        cellView.snp.makeConstraints { maker -> Void in
            maker.leading.equalToSuperview().offset(10)
            maker.trailing.equalToSuperview().offset(-10)
            maker.top.equalToSuperview().offset(5)
            maker.bottom.equalToSuperview().offset(-5)
        }
        
        avatar.snp.makeConstraints { maker -> Void in
            maker.width.height.equalTo(40)
            maker.top.equalToSuperview().offset(10)
            maker.leading.equalToSuperview().offset(10)
            maker.trailingMargin.equalTo(10)
        }
        
        triangle.snp.makeConstraints { maker -> Void in
            maker.width.equalTo(7)
            maker.height.equalTo(10)
            maker.leading.equalTo(avatar.snp.trailing).offset(10)
            maker.top.equalToSuperview().offset(10)
        }
        
        messageTextLayout.addSubview(messageImage)
        messageTextLayout.addSubview(messageBody)
        messageTextLayout.snp.makeConstraints { maker -> Void in
            maker.width.lessThanOrEqualToSuperview().multipliedBy(0.7)
            maker.top.equalToSuperview().offset(10)
            maker.bottom.equalToSuperview().offset(-10)
            maker.leading.equalTo(triangle.snp.trailing).offset(0)
            maker.trailing.lessThanOrEqualToSuperview().offset(10)
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
