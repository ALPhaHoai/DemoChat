//
// Created by bruce on 2019-04-04.
// Copyright (c) 2019 ___FULLUSERNAME___. All rights reserved.
//

import SocketIO
import UIKit
import SnapKit
import Material

class ChatBoxController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var token = ""
    var currentRoom = Client()
    var user = User()

    var messages = [[String: String]]() {
        didSet {
            messageTable.reloadData()
        }
    }



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
        let sendButton = FlatButton(title: "Send")
        return sendButton
    }()



    let messageTableCellId = "cellId2"

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setUpConnection()
        loadMessageHistory()
    }

    private func loadMessageHistory() {
        socket!.emit("createroom", [
            "sender": self.currentRoom.sender,
            "receive": self.currentRoom.userID,
            "currentRoom": self.currentRoom.roomName,
        ])
    }

    private func setUpConnection() {
        socketManager = SocketManager(socketURL: URL(string: "http://192.168.1.59:3000")!, config: [.log(true), .compress, .connectParams(["token": token])])
        socket = socketManager!.defaultSocket

        socket!.on(clientEvent: .connect, callback: { data, ack in
            print("socket connected")
            socket!.emit("join", self.user.id)
        })
        socket!.on("message") { (data, ack) in
            print(data)
            if let response = data[0] as? [String: Any] {
                if let histories = response["histories"] as? [[String: String]] {
                    self.messages = histories
                    print(histories)
                } else if let _ = response["message"] as? String {
                    if let newMessage = response as? [String: String] {
                        self.messages.append(newMessage)
                    }
                }
            }
        }

        print("socket connecting...")
        socket!.connect()

    }


    private func setupViews() {
                messageTable.delegate = self
        messageTable.dataSource = self
        messageTable.register(MessageCell.self, forCellReuseIdentifier: messageTableCellId)
        messageTable.backgroundColor = .green


        view.addSubview(messageTable)


        let sendMessageBlock = UIView()
        sendMessageBlock.backgroundColor = .yellow
        sendMessageBlock.addSubview(messageInput)
        sendMessageBlock.addSubview(sendButton)
        sendButton.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        messageInput.snp.makeConstraints { maker in
            maker.leading.equalToSuperview()
            maker.centerY.equalToSuperview()
        }
        sendButton.snp.makeConstraints { maker in
            maker.leading.equalTo(messageInput.snp.trailing).offset(10)
            maker.centerY.equalToSuperview()
        }

        view.addSubview(sendMessageBlock)
        sendMessageBlock.snp.makeConstraints { maker in
            maker.leading.equalToSuperview().offset(20)
            maker.trailing.equalToSuperview().offset(-20)
            maker.bottom.equalToSuperview().offset(-30)
            maker.height.equalTo(100)
        }

        messageTable.snp.makeConstraints { maker -> Void in
            maker.leading.trailing.equalToSuperview()
            maker.bottom.equalTo(sendMessageBlock.snp.top).offset(-50)
            maker.height.lessThanOrEqualToSuperview().dividedBy(2)
            maker.height.greaterThanOrEqualToSuperview().dividedBy(3)
        }
    }

    @objc func sendMessage(_ sender: AnyObject?) {
        if let messageBody: String = self.messageInput.text {
            print(messageBody)
            if self.currentRoom.sender != "" {
                socket!.emit("messagedetection", self.currentRoom.sender, self.currentRoom.userID, self.currentRoom.roomName, messageBody)
                self.messageInput.text = ""
            } else {
                showError(error: "There is no room selected")
            }
        }
    }

    func showError(error: String) {
        let alert = UIAlertController(title: nil, message: error, preferredStyle: .alert)
        self.present(alert, animated: true)

        // duration in seconds
        let duration: Double = 5

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration) {
            alert.dismiss(animated: true)
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }




    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: messageTableCellId, for: indexPath) as? MessageCell {
            let cellData = messages[indexPath.row]
            cell.nickname.text = cellData["recieve"]
            cell.message.text = cellData["message"]
            return cell
        }
        return UITableViewCell()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.sendMessage(self)
        return true
    }


}