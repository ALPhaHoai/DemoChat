//
// Created by bruce on 2019-04-04.
// Copyright (c) 2019 ___FULLUSERNAME___. All rights reserved.
//

import SocketIO
import UIKit
import SnapKit
import Material
import SwifterSwift

class ChatRoomController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    let INCOMING_MESSAGE_CELL = "INCOMING_MESSAGE_CELL"
    let SENDING_MESSAGE_CELL = "SENDING_MESSAGE_CELL"
    var token = ""
    var currentRoom = Room()
    var user = User()
    
    var messages = [Message]()
    
    let messageTable: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.allowsSelection = true
        return tableView
    }()
    
    let btnCamera: UIImageView = {
        let btnCamera = UIImageView(image: #imageLiteral(resourceName: "camera"))
        btnCamera.isUserInteractionEnabled = true
        return btnCamera
    }()
    
    let btnGallery: UIImageView = {
        let btnGallery = UIImageView(image: #imageLiteral(resourceName: "gallery"))
        btnGallery.isUserInteractionEnabled = true
        return btnGallery
    }()
    
    let btnAttachment: UIImageView = {
        let btnAttachment = UIImageView(image: #imageLiteral(resourceName: "attachment"))
        btnAttachment.isUserInteractionEnabled = true
        return btnAttachment
    }()
    
    let messageInput: UITextField = {
        let messageInput = UITextField()
        messageInput.layer.borderWidth = 1
        messageInput.layer.borderColor = #colorLiteral(red: 0.3893361358, green: 0.3893361358, blue: 0.3893361358, alpha: 0.6355147688)
        messageInput.layer.cornerRadius = 20
        messageInput.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        messageInput.placeholder = "Aa"
        
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 20))
        messageInput.leftView = paddingView
        messageInput.leftViewMode = .always
        
        return messageInput
    }()
    
    let sendMessageBlock: UIView = {
        let sendMessageBlock = UIView()
        sendMessageBlock.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        return sendMessageBlock
    }()
    
    
    
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
                    self.messageTable.reloadData()
                } else {
                    var newMessage = Message()
                    newMessage.nickname = response["sender"] as? String ?? " "
                    newMessage.message = response["message"] as? String ?? " "
                    newMessage.incoming = newMessage.nickname == self.user.User_ID
                    newMessage.time = response["time"] as? Int ?? 0
                    self.messages.append(newMessage)
                    self.messageTable.reloadData()
                }
            }
        }
    }
    
    
    private func setupViews() {
        messageTable.delegate = self
        messageTable.dataSource = self
        messageInput.delegate = self
        messageTable.register(ImcomingMessageCell.self, forCellReuseIdentifier: INCOMING_MESSAGE_CELL)
        messageTable.register(SendingMessageCell.self, forCellReuseIdentifier: SENDING_MESSAGE_CELL)
        //messageTable.backgroundColor = .green
        messageTable.allowsSelection = false
        btnCamera.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(btnCameraTapDetected)))
        btnGallery.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(btnGalleryTapDetected)))
        btnAttachment.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(btnAttachmentTapDetected)))
        
        
        view.addSubview(messageTable)
        view.addSubview(sendMessageBlock)
        
        sendMessageBlock.addSubview(btnCamera)
        sendMessageBlock.addSubview(btnGallery)
        sendMessageBlock.addSubview(btnAttachment)
        sendMessageBlock.addSubview(messageInput)
        
        let iconSize = 30
        
        btnCamera.snp.makeConstraints { maker in
            maker.width.height.equalTo(iconSize)
            maker.leading.equalToSuperview().offset(15)
            maker.centerY.equalToSuperview()
        }
        btnGallery.snp.makeConstraints { maker in
            maker.width.height.equalTo(iconSize)
            maker.leading.equalTo(btnCamera.snp.trailing).offset(5)
            maker.centerY.equalToSuperview()
        }
        btnAttachment.snp.makeConstraints { maker in
            maker.width.height.equalTo(iconSize)
            maker.leading.equalTo(btnGallery.snp.trailing).offset(5)
            maker.centerY.equalToSuperview()
        }
        messageInput.snp.makeConstraints { maker in
            maker.leading.equalTo(btnAttachment.snp.trailing).offset(15)
            maker.trailing.equalToSuperview().offset(-15)
            maker.centerY.equalToSuperview()
            maker.height.equalTo(40)
        }
        
        sendMessageBlock.snp.makeConstraints { maker in
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
            maker.bottom.equalToSuperview()
            maker.height.equalTo(65)
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
            self.messageTable.scrollToBottom()
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        if message.incoming, let cell = tableView.dequeueReusableCell(withIdentifier: INCOMING_MESSAGE_CELL, for: indexPath) as? ImcomingMessageCell {
            cell.setUpData(message: message)
            return cell
        } else if let cell = tableView.dequeueReusableCell(withIdentifier: SENDING_MESSAGE_CELL, for: indexPath) as? SendingMessageCell {
            cell.setUpData(message: message)
            return cell
        }
        return UITableViewCell()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.sendMessage(self)
        return true
    }
    
    @objc func btnCameraTapDetected(){
        showMessage("btnCameraTapDetected Clicked")
    }
    
    @objc func btnGalleryTapDetected(){
        showMessage("btnGalleryTapDetected Clicked")
    }
    
    @objc func btnAttachmentTapDetected(){
        showMessage("btnAttachmentTapDetected Clicked")
    }
    
}
