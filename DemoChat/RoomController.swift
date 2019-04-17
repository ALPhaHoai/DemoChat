//
// Created by bruce on 2019-04-04.
// Copyright (c) 2019 ___FULLUSERNAME___. All rights reserved.
//

import SocketIO
import UIKit
import SnapKit
import Material
import Alamofire


var socketManager: SocketManager? = nil
public  var socket : SocketIOClient? = nil

class RoomController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let endpoint = "http://192.168.1.59:3000"
    var token = ""
    var user = User()
    var clients = [Client]() {
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


    let roomTableCellId = "cellId1"


    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setUpConnection()
        doLogin(username: "ha1")
    }
    
    
    func setupData(_ token: String, _ users: [String: Any]) {
        self.user = User(
            username: users["Username"] as? String ?? "",
            avatar: users["Avatar"] as? String ?? "",
            id: users["User_ID"] as? String ?? "",
            name: users["name"] as? String ?? "")
        
        if let clients = users["clients"] as? [[String: Any]] {
            for room in clients {
                var client = Client()
                client.sender = user.id
                client.avatar = room["Avatar"] as? String ?? ""
                client.roomName = room["Room_Name"] as? String ?? ""
                client.userID = room["User_ID"] as? String ?? ""
                client.username = room["Username"] as? String ?? ""
                client.name = room["name"] as? String ?? ""
                client.online = (room["online"] as? Int ?? 0 != 0)
                client.type = room["type"] as? Int ?? 0
                self.clients.append(client)
            }
        }
        
        self.token = token
    }


    private func setUpConnection() {
        socketManager = SocketManager(socketURL: URL(string: self.endpoint)!, config: [.log(true), .compress, .connectParams(["token": token])])
        socket = socketManager!.defaultSocket

        socket!.on(clientEvent: .connect, callback: { data, ack in
            print("socket connected")
            socket!.emit("join", self.user.id)
        })
        print("socket connecting...")
        socket!.connect()
    }


    private func setupViews() {
        roomTable.delegate = self
        roomTable.dataSource = self
        roomTable.register(RoomCell.self, forCellReuseIdentifier: roomTableCellId)
        roomTable.backgroundColor = .blue

        view.addSubview(roomTable)

        roomTable.snp.makeConstraints { maker -> Void in
            maker.edges.equalToSuperview()
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
        return self.clients.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let room = ChatBoxController()
        room.user = self.user
        let item = self.clients[indexPath.row]
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
            let cellData = clients[indexPath.row]
            cell.smRecievers.text = self.user.id
            cell.message.text = cellData.roomName
            cell.createAtTime.text = "5 mins ago"
            return cell

        } else {
            return UITableViewCell()
        }
    }


    private func doLogin(username: String) {
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
                            self.showError(error: message)
                        } else {
                            self.showError(error: "Unknow Error")
                        }
                        return;
                }
                
                self.setupData(token,  users)
                
            } else {
                self.showError(error: "Unknow Error")
            }
        }
    }
    
    

}
