//
// Created by bruce on 2019-04-04.
// Copyright (c) 2019 ___FULLUSERNAME___. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class RoomCell: UITableViewCell {
    let roomname = UILabel()
    let userid = UILabel()
    let name = UILabel()

    let cellView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white

        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        view.layer.shadowOpacity = 0.2
        view.layer.shadowRadius = 1.0
        view.layer.masksToBounds = false
        view.clipsToBounds = false
        view.layer.cornerRadius = 3

        view.layer.borderWidth = 1
        view.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 0.5)



        return view
    }()
    override open func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 15
        layer.masksToBounds = false
    }
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

        cellView.addSubview(roomname)
        cellView.addSubview(userid)
        cellView.addSubview(name)

        roomname.snp.makeConstraints { maker in
            maker.leading.equalToSuperview().offset(10)
            maker.centerY.equalToSuperview()
        }
        userid.snp.makeConstraints { maker in
            maker.leading.equalTo(roomname.snp.trailing).offset(10)
            maker.centerY.equalToSuperview()
        }
        name.snp.makeConstraints { maker in
            maker.leading.equalTo(userid.snp.trailing).offset(10)
            maker.centerY.equalToSuperview()
        }
        cellView.snp.makeConstraints { maker -> Void in
            maker.edges.equalToSuperview().offset(10)
        }
    }
}