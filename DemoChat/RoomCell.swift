//
// Created by bruce on 2019-04-04.
// Copyright (c) 2019 ___FULLUSERNAME___. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import SwifterSwift

class RoomCell: UITableViewCell {
    let relativeLayout : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        
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
    let contactImage : UIImageView = {
        let contactImage = UIImageView(image: #imageLiteral(resourceName: "avatar_default"))
        return contactImage
    }()
    let activeStatusCircle = Circle()
    let mainMessageBlock = UIView()
    let smRecievers = UILabel()
    let createAtTime = UILabel()
    let message = UILabel()
    let unreadSmsCount : UILabel = {
        let unreadSmsCount = UILabel()
        unreadSmsCount.text = "4"
        unreadSmsCount.textAlignment = .center
        unreadSmsCount.fontSize = 13
        unreadSmsCount.textColor = .white
        unreadSmsCount.layer.cornerRadius = 7
        unreadSmsCount.layer.backgroundColor = #colorLiteral(red: 1, green: 0.1862676254, blue: 0.1680173263, alpha: 1)
        return unreadSmsCount
    }()
    let separateLine : UIView = {
        let separateLine = UIView()
        separateLine.backgroundColor = .gray
        return separateLine
    }()

    override open func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 15
        layer.masksToBounds = false
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpViews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setUpViews() {
        backgroundColor = UIColor.white
        addSubview(relativeLayout)

        relativeLayout.addSubview(contactImage)
        relativeLayout.addSubview(activeStatusCircle)
        relativeLayout.addSubview(mainMessageBlock)
        relativeLayout.addSubview(separateLine)

        contactImage.snp.makeConstraints { maker in
            maker.width.equalTo(50)
            maker.height.equalTo(50)
            maker.leading.equalToSuperview().offset(10)
            maker.centerY.equalToSuperview()
        }

        activeStatusCircle.snp.makeConstraints { maker in
            maker.width.equalTo(10)
            maker.height.equalTo(10)
            maker.bottom.equalToSuperview().offset(15)
            maker.top.equalToSuperview()
            maker.leading.equalToSuperview()
            maker.trailing.equalTo(mainMessageBlock.snp.leading)
        }

        mainMessageBlock.snp.makeConstraints { maker in
            maker.leading.equalTo(contactImage.snp.trailing).offset(10)
            maker.trailing.equalToSuperview().offset(-10)
            maker.top.lessThanOrEqualToSuperview()
            maker.bottom.lessThanOrEqualToSuperview()

        }

        mainMessageBlock.addSubview(smRecievers)
        mainMessageBlock.addSubview(createAtTime)
        mainMessageBlock.addSubview(message)
        mainMessageBlock.addSubview(unreadSmsCount)

        smRecievers.snp.makeConstraints { maker in
            maker.leading.equalToSuperview()
            maker.bottom.equalTo(contactImage.snp.centerY)
            maker.width.lessThanOrEqualToSuperview().multipliedBy(0.6)
        }

        createAtTime.snp.makeConstraints { maker in
            maker.trailing.equalToSuperview().offset(-10)
            maker.top.equalToSuperview().offset(11)
            maker.width.lessThanOrEqualToSuperview().multipliedBy(0.3)
            maker.lastBaseline.equalTo(smRecievers.snp.lastBaseline)
        }

        message.snp.makeConstraints { maker in
            maker.leading.equalTo(smRecievers.snp.leading)
            maker.top.equalTo(smRecievers.snp.bottom).offset(3)
            maker.width.lessThanOrEqualToSuperview().multipliedBy(0.6)
        }

        unreadSmsCount.snp.makeConstraints { maker in
            maker.lastBaseline.equalTo(message.snp.lastBaseline)
            maker.trailing.equalTo(createAtTime.snp.trailing)
            maker.width.equalTo(24)
            maker.height.equalTo(16)
        }

        separateLine.snp.makeConstraints { maker in
            maker.bottom.equalToSuperview()
            maker.trailing.equalToSuperview()
            maker.leading.equalTo(mainMessageBlock.snp.leading)
            maker.height.equalTo(1)
        }


        relativeLayout.snp.makeConstraints { maker -> Void in
            maker.leading.trailing.top.equalToSuperview().offset(10)
            maker.height.equalTo(80)
            maker.bottom.equalToSuperview().offset(10)
        }
    }


}
