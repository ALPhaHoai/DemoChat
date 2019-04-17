//
// Created by bruce on 2019-04-04.
// Copyright (c) 2019 ___FULLUSERNAME___. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

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
    let activeStatusCircle = UIImageView()
    let mainMessageBlock = UIView()
    let smRecievers = UILabel()
    let createAtTime = UILabel()
    let message = UILabel()
    let unreadSmsCount : UIView = {
        let unreadSmsCount = UIView()
        unreadSmsCount.bounds = CGRect(x: 0.0, y: 0.0, width: 16, height: 10)
        unreadSmsCount.layer.cornerRadius = 5
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
            maker.bottom.equalToSuperview()
            maker.top.equalToSuperview()
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
            maker.top.bottom.equalToSuperview()
        }

        mainMessageBlock.addSubview(smRecievers)
        mainMessageBlock.addSubview(createAtTime)
        mainMessageBlock.addSubview(message)
        mainMessageBlock.addSubview(unreadSmsCount)

        smRecievers.snp.makeConstraints { maker in
            maker.leading.equalToSuperview()
            maker.top.equalToSuperview().offset(6)
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
            maker.width.height.equalTo(10)
        }

        separateLine.snp.makeConstraints { maker in
            maker.bottom.equalToSuperview()
            maker.trailing.equalToSuperview()
            maker.leading.equalTo(mainMessageBlock.snp.leading)
        }


        relativeLayout.snp.makeConstraints { maker -> Void in
            maker.leading.trailing.top.equalToSuperview().offset(10)
            maker.bottom.equalToSuperview().offset(-10)
        }
    }


}
