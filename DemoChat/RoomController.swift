//
// Created by bruce on 2019-04-04.
// Copyright (c) 2019 ___FULLUSERNAME___. All rights reserved.
//

import SocketIO
import UIKit
import SnapKit
import Material

class RoomController: UIViewController, UITableViewDelegate, UITableViewDataSource {
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
    }

    private func setUpConnection() {
        socketManager = SocketManager(socketURL: URL(string: "http://192.168.1.59:3000")!, config: [.log(true), .compress, .connectParams(["token": token])])
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
            cell.userid.text = self.user.id
            cell.roomname.text = cellData.roomName
            return cell

        } else {
            return UITableViewCell()
        }
    }



}