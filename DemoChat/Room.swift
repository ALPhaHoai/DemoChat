//
// Created by bruce on 2019-04-05.
// Copyright (c) 2019 ___FULLUSERNAME___. All rights reserved.
//

struct Room {
    var sender = ""
    var recieve = ""
    var name = ""
    init(){}

    init(sender: String, recieve: String, name: String) {
        self.sender = sender
        self.recieve = recieve
        self.name = name
    }
}