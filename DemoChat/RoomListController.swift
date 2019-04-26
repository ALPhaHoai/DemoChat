//
// Created by bruce on 2019-04-04.
// Copyright (c) 2019 ___FULLUSERNAME___. All rights reserved.
//

import SocketIO
import UIKit
import SnapKit
import Material
import Alamofire
import SwifterSwift


var socketManager: SocketManager? = nil
public  var socket : SocketIOClient? = nil
public let endpoint = "http://192.168.1.59:3000"

class RoomListController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var token = ""
    var user = User()
    var RoomList = [Room]() {
        didSet {
            roomTable.reloadData()
        }
    }
    
    let roomTable: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.allowsSelection = true
        return tableView
    }()
    
    let searchIcon = UIImageView(image: #imageLiteral(resourceName: "search"))
    
    
    let searchInput: UITextField = {
        let searchInput = UITextField()
        searchInput.layer.borderWidth = 1
        searchInput.layer.borderColor = #colorLiteral(red: 0.3893361358, green: 0.3893361358, blue: 0.3893361358, alpha: 0.6355147688)
        searchInput.layer.cornerRadius = 18
        searchInput.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        searchInput.placeholder = "Tìm kiếm"
        searchInput.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 70, height: 30))
        searchInput.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 30))
        searchInput.leftViewMode = .always
        searchInput.rightViewMode = .always
        return searchInput
    }()
    
    let roomTableCellId = "cellId1"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        login("eupvn")
    }
    
    private func setupViews() {
        roomTable.delegate = self
        roomTable.dataSource = self
        roomTable.register(RoomCell.self, forCellReuseIdentifier: roomTableCellId)
        roomTable.backgroundColor = .white
        roomTable.allowsSelection = true
        
        view.addSubview(searchInput)
        view .addSubview(searchIcon)
        view.addSubview(roomTable)
        
        searchInput.snp.makeConstraints { maker in
            maker.leading.equalTo(view.snp.leading).offset(30)
            maker.trailing.equalTo(view.snp.trailing).offset(-30)
            maker.top.equalTo(view.snp.top).offset(100)
            maker.height.equalTo(35)
        }
        
        roomTable.snp.makeConstraints { maker in
            maker.leading.trailing.bottom.equalToSuperview()
            maker.top.equalTo(searchInput.snp.bottom)
        }
        
        searchIcon.snp.makeConstraints { maker in
            maker.centerY.equalTo(searchInput.snp.centerY)
            maker.width.height.equalTo(30)
            maker.leading.equalTo(searchInput.snp.leading).offset(20)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        roomTable.deselectAllItems(animated: false)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.RoomList.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let room = ChatRoomController()
        room.user = self.user
        let item = self.RoomList[indexPath.row]
        room.currentRoom = item
        self.navigationController?.pushViewController(room, animated: false)
        
    }
    
    //    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //        let item = self.clients[indexPath.row]
    //        self.currentRoom = Room(sender: self.user.id, recieve: item["User_ID"] as? String ?? "", name: item["Room_Name"] as? String ?? "")
    //        socket!.emit("createroom", [
    //            "sender": self.currentRoom.sender,
    //            "receive": self.currentRoom.recieve,
    //            "currentRoom": self.currentRoom.name,
    //        ])
    //    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: roomTableCellId, for: indexPath) as? RoomCell {
            let room = RoomList[indexPath.row]
            cell.smRecievers.text = room.RoomName + " : "
            cell.createAtTime.text = room.UserID
            cell.message.text = room.Name
            cell.contactImage.download(url: room.Avatar, placeholder: #imageLiteral(resourceName: "avatar_default"))
            
            if room.page != 0 {
                cell.unreadSmsCount.isHidden = true
            } else {
                cell.unreadSmsCount.text = String(room.page)
            }
            
            
            cell.activeStatusCircle.isHidden = !room.isActive
            
            
            return cell
            
        } else {
            return UITableViewCell()
        }
    }
    
    
    private func login(_ username: String) {
        let parameters = ["username": username]
        Alamofire.request(endpoint + "/login", method: .post, parameters: parameters).responseJSON { res in
            print(res)
            if let result = res.result.value as? [String: Any] {
                guard
                    let status = result["status"] as? Int,
                    status == 1,
                    let data = result["data"] as? [String: Any],
                    let token = data["token"] as? String,
                    let users = data["user"] as? [String: Any]
                    else {
                        if let message = result["message"] as? String {
                            self.showMessage(message)
                        } else {
                            self.showMessage("Unknow Error")
                        }
                        return;
                }
                
                
                self.token = token
                
                self.user = User()
                self.user.Avatar = users["Avatar"] as? String ?? ""
                self.user.Username = users["Username"] as? String ?? ""
                self.user.User_ID = users["User_ID"] as? String ?? ""
                self.user.name = users["name"] as? String ?? ""
                
                self.setUpSocket(token)
                
                self.setUpRoomListData(users)
                
            } else {
                self.showMessage("Unknow Error")
            }
        }
    }
    func setUpRoomListData(_ users: [String: Any]) {
        if let clients = users["clients"] as? [[String: Any]] {
            for item in clients {
                var room = Room()
                room.Avatar = item["Avatar"] as? String ?? " "
                room.RoomName = item["Room_Name"] as? String ?? " "
                room.Name = item["name"] as? String ?? " "
                room.UserID = item["User_ID"] as? String ?? " "
                room.isActive = (item["online"] as? Bool ?? false)
                self.RoomList.append(room)
            }
        }
    }
    
    func setUpSocket(_ token : String){
        if socket == nil {
            self.createConnection()
        }
        
        socket?.on(clientEvent: .connect, callback: { data, ack in
            print("socket connected")
            self.updateDeviceId()
            socket!.emit("join", self.user.User_ID)
        })
        
    }
    
    func updateDeviceId(){
        print("Updating device id")
    }
    
    private func createConnection() {
        socketManager = SocketManager(socketURL: URL(string: endpoint)!, config: [.log(true), .compress, .connectParams(["token": token])])
        socket = socketManager!.defaultSocket
        print("socket connecting...")
        socket!.connect()
    }
    
    
    
}
