//
// Created by bruce on 2019-04-04.
// Copyright (c) 2019 ___FULLUSERNAME___. All rights reserved.
//

import SocketIO
import UIKit
import SnapKit
import Material
import SwifterSwift
import Alamofire
import MobileCoreServices
//import Floaty

class ChatRoomController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIDocumentPickerDelegate , UIScrollViewDelegate{
    let INCOMING_MESSAGE_CELL = "INCOMING_MESSAGE_CELL"
    let SENDING_MESSAGE_CELL = "SENDING_MESSAGE_CELL"
    var currentRoom = Room()
    var user = User()
    var requestingChatHistory = false
    var noMoreChatHistory = false
    var messages = [Message]()
    
    let messageTable: UITableView = {
        let messageTable = UITableView()
        messageTable.separatorStyle = .none
        messageTable.allowsSelection = true
//        messageTable.transform = CGAffineTransform(scaleX: 1, y: -1)
        return messageTable
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
    
    //    let fab: FABButton = {
    //        let fab = FABButton(image: #imageLiteral(resourceName: "down_arrow"), tintColor: .white)
    //        fab.pulseColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    //        fab.backgroundColor = .white
    //        //        fab.layer.cornerRadius = 20
    //        //        fab.backgroundColor = .white
    //        //        fab.borderWidth =
    //                fab.isHidden = true
    //        return fab
    //    }()
    
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
                    print("detect message \(histories)")
                    for message in histories {
                        var newMessage = Message()
                        newMessage.nickname = message["sender"] as? String ?? " "
                        newMessage.message = message["message"] as? String ?? " "
                        newMessage.incoming = newMessage.nickname == self.user.User_ID
                        newMessage.time = message["time"] as? Int ?? 0
                        self.messages.append(newMessage)
                    }
                    self.messageTable.reloadData()
//                    self.messageTable.scrollToBottom()
                } else {
                    print("detect message \(response)")
                    var newMessage = Message()
                    newMessage.nickname = response["sender"] as? String ?? " "
                    newMessage.message = response["message"] as? String ?? " "
                    newMessage.incoming = newMessage.nickname != self.user.User_ID
                    newMessage.time = response["time"] as? Int ?? 0
                    self.messages.append(newMessage)
                    self.messageTable.reloadData()
                    self.messageTable.scrollToBottom(animated: true)
                }
            }
        }
    }
    
    
    private func setupViews() {
        messageTable.delegate = self
        messageTable.dataSource = self
        messageInput.delegate = self
        messageTable.register(IncomingMessageCell.self, forCellReuseIdentifier: INCOMING_MESSAGE_CELL)
        messageTable.register(SendingMessageCell.self, forCellReuseIdentifier: SENDING_MESSAGE_CELL)
        
        btnCamera.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(btnCameraTapDetected)))
        btnGallery.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(btnGalleryTapDetected)))
        btnAttachment.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(btnAttachmentTapDetected)))
        //        fab.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(fabTaped)))
        
        
        view.addSubview(messageTable)
        view.addSubview(sendMessageBlock)
        //        view.addSubview(fab)
        
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
        messageTable.snp.makeConstraints { maker in
            maker.leading.trailing.equalToSuperview()
            maker.bottom.equalTo(sendMessageBlock.snp.top).offset(-10)
//            maker.top.greaterThanOrEqualToSuperview()
            maker.top.equalToSuperview()
        }
        
        //        fab.snp.makeConstraints { maker in
        //            maker.width.height.equalTo(50)
        //            maker.centerX.equalToSuperview()
        //            maker.bottom.equalTo(sendMessageBlock.snp.top).offset(-3)
        //        }
    }
    
    @objc func sendMessage(_ sender: AnyObject?) {
        if let messageBody: String = self.messageInput.text {
            print("sending this message: " + messageBody)
            
            socket!.emit("messagedetection", self.user.User_ID, self.currentRoom.UserID, self.currentRoom.RoomName, messageBody)
            self.messageInput.text = ""
            //            self.messageTable.scrollToBottom()
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = messages[indexPath.row]
        guard let fileUrl = message.messageFile, let fileName = message.messageFileName else {
            return
        }
        self.downloadFile(fileUrl, fileName)
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        if message.incoming, let cell = tableView.dequeueReusableCell(withIdentifier: INCOMING_MESSAGE_CELL, for: indexPath) as? IncomingMessageCell {
            cell.setUpData(message)
            return cell
        } else if let cell = tableView.dequeueReusableCell(withIdentifier: SENDING_MESSAGE_CELL, for: indexPath) as? SendingMessageCell {
            cell.setUpData(message)
            return cell
        }
        return UITableViewCell()
    }
    
//    func updateTableContentInset(){
//        let numRows = tableView(self.messageTable, numberOfRowsInSection: 0)
//        var contentInsetTop = self.messageTable.bounds.size.height
//        for i in 0..<numRows {
//            let rowRect = self.messageTable.rectForRow(at: IndexPath(item: i, section: 0))
//            contentInsetTop -= rowRect.size.height
//            if contentInsetTop < 0 {
//                contentInsetTop = 0
//            }
//        }
//        self.messageTable.contentInset = UIEdgeInsets(top: contentInsetTop, left: 0, bottom: 0, right: 0)
//    }
    
    //    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    //
    //        let height = scrollView.frame.size.height
    //        let contentYoffSet = scrollView.contentOffset.y
    //        let distanceFromBottom = scrollView.contentSize.height - contentYoffSet
    //
    //        if distanceFromBottom < height + 200 || targetContentOffset.pointee.y < scrollView.contentOffset.y -  200 {//reach bottom or going up
    //            fab.fadeOut()
    //        } else if targetContentOffset.pointee.y > scrollView.contentOffset.y +  200{//going down
    //            fab.isHidden = false
    //            fab.fadeIn()
    //        }
    //    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == 0  {
            self.getChatHistory()
        }
    }
    
    func getChatHistory(){
        guard !noMoreChatHistory, !requestingChatHistory, let time = self.messages.first?.time else {
            return
        }
        let params: [String : Any] = ["token": token, "room_name": self.currentRoom.RoomName, "page": self.currentRoom.page, "currentMessTime": time]
        
        print("requestingChatHistory \(self.currentRoom.page)")
        requestingChatHistory = true
        Alamofire.request(endpoint + "/get-chat-history", method: .post, parameters: params).responseJSON { res in
            self.requestingChatHistory = false
            guard let result = res.result.value as? [String: Any] ,
                let status = result["status"] as? Int,
                status == 1,
                let data = result["data"] as? [String: Any] ,
                let histories = data["messages"] as? [[String: Any]]
                else {
                    print(params)
                    print(res)
                    return
            }
            
            if histories.count==0 {
                self.noMoreChatHistory = true
            }
            
            for message in histories {
                var newMessage = Message()
                newMessage.nickname = message["sender"] as? String ?? " "
                newMessage.message = message["message"] as? String ?? " "
                newMessage.incoming = newMessage.nickname == self.user.User_ID
                newMessage.time = message["time"] as? Int ?? 0
                self.messages.append(newMessage)
            }
            self.messageTable.reloadData()
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.sendMessage(self)
        return true
    }
    
    @objc func btnCameraTapDetected(){
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = true
            present(imagePicker, animated: true)
        } else {
            showMessage("camera is not avaiable")
        }
    }
    
    @objc func btnGalleryTapDetected(){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            present(imagePicker, animated: true)
        } else {
            showMessage("gallery is not avaiable")
        }
    }
    
    @objc func btnAttachmentTapDetected(){
        let documentPicker  = UIDocumentPickerViewController(documentTypes: [String(kUTTypeText), String(kUTTypeImage), String(kUTTypeVideo)], in: .import)
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .formSheet
        self.present(documentPicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage,
            let url = info[.imageURL] as? URL else {
                showMessage("No image found")
                return
        }
        uploadImage(image: image, fileName: url.lastPathComponent)
        picker.dismiss(animated: true, completion: nil)
    }
    
    func uploadImage(image: UIImage, fileName: String){
        let imgData = image.jpegData(compressionQuality: 0.2)!
        Alamofire.upload(multipartFormData: { (MultipartFormData) in
            MultipartFormData.append(imgData, withName: "eupchat_file", fileName: fileName, mimeType: "image/*")
        }, to: endpoint + "/upload") { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    if let err = response.error {
                        self.showMessage("upload error \(err.localizedDescription)")
                    } else {
                        guard let result = response.result.value as? [String: Any],
                            let status = result["status"] as? Int,
                            status == 1,
                            let data = result["data"] as? [String: Any],
                            let message = data["message"] as? String
                            else { return }
                        
                        var newMessage = Message()
                        newMessage.nickname = self.user.User_ID
                        newMessage.message = message
                        newMessage.incoming = false
                        newMessage.time = Date().timeIntervalSince1970.int
                        self.messages.append(newMessage)
                        self.messageTable.reloadData()
                        //                        self.messageTable.scrollToBottom()
                    }
                }
                
            case .failure(let err):
                self.showMessage("upload error \(err.localizedDescription)")
            }
        }
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL){
        let myUrl = url as URL
        print("import result : \(myUrl)")
    }
    
    func downloadFile (_ url: String, _ name: String){
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let documentsUrl = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask)[0]
            let fileUrl = documentsUrl.appendingPathComponent(name)
            return (fileUrl, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        Alamofire.download(url, to: destination).response { response in
            if response.error == nil, let filePath = response.destinationURL?.path {
               self.showMessage("Saved file \(name) to \(filePath)")
            } else {
                self.showMessage("Error \(response.error!)")
            }
        }
    }
    
    
    //    @objc func fabTaped(){
    //        fab.fadeOut()
    ////        let lastRow: Int = self.messageTable.numberOfRows() - 1
    ////        let indexPath = IndexPath(row: lastRow, section: 0)
    ////        messageTable.scrollToRow(at: indexPath, at: .top, animated: false)
    //        messageTable.scrollToBottom()
    //        fab.fadeOut()
    //    }
    
}
