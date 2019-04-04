//
// Created by bruce on 2019-04-04.
// Copyright (c) 2019 ___FULLUSERNAME___. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class ChatBoxController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var token = ""
    var users = [String: Any]()

    let roomTable: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.allowsSelection = true
        return tableView
    }()

    let messageTable: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.allowsSelection = true
        return tableView
    }()



    let messageInput: UITextField = {
        let messageInput = UITextField()
        messageInput.placeholder = "write your message"
        return messageInput
    }()


    let sendButton: UIButton = {
        let sendButton = UIButton()
        sendButton.setTitle("Send", for: .normal)
        return sendButton
    }()

    let roomTableCellId = "cellId1"
    let messageTableCellId = "cellId2"

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    private func setupViews() {
        roomTable.delegate = self
        roomTable.dataSource = self
        roomTable.register(ChatBoxController.self, forCellReuseIdentifier: roomTableCellId)


        messageTable.delegate = self
        messageTable.dataSource = self
        messageTable.register(ChatBoxController.self, forCellReuseIdentifier: messageTableCellId)


        view.addSubview(roomTable)
        view.addSubview(messageTable)

        roomTable.snp.makeConstraints { maker -> Void in
            maker.top.leading.trailing.equalToSuperview()
            maker.bottom.equalTo(view.snp.centerX)
        }
        messageTable.snp.makeConstraints { maker -> Void in
            maker.bottom.leading.trailing.equalToSuperview()
            maker.top.equalTo(view.snp.centerX)
        }

        let sendMessageBlock = UIStackView()
        sendMessageBlock.axis = .horizontal
        sendMessageBlock.addSubview(messageInput)
        sendMessageBlock.addSubview(sendButton)

        messageTable.tableFooterView = sendMessageBlock
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == roomTable, let cell = tableView.dequeueReusableCell(withIdentifier: roomTableCellId, for: indexPath) as? RoomCell {
            return cell
        } else if tableView == messageTable,
                  let cell = tableView.dequeueReusableCell(withIdentifier: messageTableCellId, for: indexPath) as? MessageCell {
            return cell
        }
        return UITableViewCell()
    }

}