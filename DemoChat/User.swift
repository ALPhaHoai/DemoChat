//
// Created by bruce on 2019-04-05.
// Copyright (c) 2019 ___FULLUSERNAME___. All rights reserved.
//

struct User {
    var username: String = ""
    var avatar: String = ""
    var id: String = ""
    var name: String = ""

    init() {

    }

    init(username: String, avatar: String, id: String, name: String) {
        self.username = username
        self.avatar = avatar
        self.id = id
        self.name = name
    }
}