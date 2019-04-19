//
// Created by bruce on 2019-04-04.
// Copyright (c) 2019 ___FULLUSERNAME___. All rights reserved.
//

import SocketIO
import UIKit
import SnapKit
import Material

class ChatRoomController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let INCOMING_MESSAGE_CELL = 101
    let SENDING_MESSAGE_CELL = 102
    
    var token = ""
    var currentRoom = Room()
    var user = User()
    
    var messages = [Message]() {
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
        setUpSocket()
        requestMessageHistory()
    }
    
    private func requestMessageHistory() {
        let parameters = [
            "sender": self.user.User_ID,
            "receive": self.currentRoom.UserID,
            "currentRoom": self.currentRoom.RoomName,
            ]
        socket?.emit("createroom", parameters)
    }
    
    private func setUpSocket() {
        socket!.on("message") { (data, ack) in
            if let response = data[0] as? [String: Any] {
                if let histories = response["histories"] as? [[String: Any]] {
                    for message in histories {
                        var newMessage = Message()
                        newMessage.nickname = message["sender"] as? String ?? " "
                        newMessage.message = message["message"] as? String ?? " "
                        newMessage.incoming = newMessage.nickname == self.user.User_ID
                        newMessage.time = message["time"] as? Int ?? 0
                        self.messages.append(newMessage)
                    }
                } else {
                        var newMessage = Message()
                        newMessage.nickname = response["sender"] as? String ?? " "
                        newMessage.message = response["message"] as? String ?? " "
                        newMessage.incoming = newMessage.nickname == self.user.User_ID
                        newMessage.time = response["time"] as? Int ?? 0
                        self.messages.append(newMessage)
                }
            }
        }
    }
    
    
    private func setupViews() {
        messageTable.delegate = self
        messageTable.dataSource = self
        messageTable.register(ImcomingMessageCell.self, forCellReuseIdentifier: messageTableCellId)
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
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
            maker.bottom.equalToSuperview()
            maker.height.equalTo(50)
        }
        
        messageTable.snp.makeConstraints { maker -> Void in
            maker.leading.trailing.equalToSuperview()
            maker.bottom.equalTo(sendMessageBlock.snp.top).offset(-10)
            maker.top.equalToSuperview()
        }
    }
    
    @objc func sendMessage(_ sender: AnyObject?) {
        if let messageBody: String = self.messageInput.text {
            print("sending this message: " + messageBody)
            
            socket!.emit("messagedetection", self.user.User_ID, self.currentRoom.UserID, self.currentRoom.RoomName, messageBody)
            self.messageInput.text = ""
            
        }
    }
    
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        
        if message.incoming, let cell = tableView.dequeueReusableCell(withIdentifier: messageTableCellId, for: indexPath) as? ImcomingMessageCell {
            //cell.nickname.text = cellData["recieve"]
            cell.messageBody.text = message.message
            return cell
        } else if let cell = tableView.dequeueReusableCell(withIdentifier: messageTableCellId, for: indexPath) as? SendingMessageCell {
            //cell.nickname.text = cellData["recieve"]
            cell.messageBody.text = message.message
            return cell
        }
        return UITableViewCell()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.sendMessage(self)
        return true
    }
    
}
