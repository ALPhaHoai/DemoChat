//
// Created by bruce on 2019-04-04.
// Copyright (c) 2019 ___FULLUSERNAME___. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import SocketIO
import Material
import Alamofire

class LoginController: UIViewController {
    let loginButton: UIButton = {
        let loginButton = FlatButton(title: "Login")
//        loginButton.setTitle("Login", for: .normal)
//        loginButton.setTitleColor(.black, for: .normal)
//        loginButton.backgroundColor = .yellow
        return loginButton
    }()

    let username: UITextField = {
        let username = UITextField()
        username.text = "admin"
        return username
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        loginButton.addTarget(self, action: #selector(LoginController.loginButtonClicked), for: .touchUpInside)
    }

    @objc func loginButtonClicked(_ sender: AnyObject?) {
        if let username: String = self.username.text {
            doLogin(username: username)
        }
    }

    func goToChatRoom(token: String, users: [String: Any]) {
        let chatController = ChatBoxController()
        chatController.token = token
        chatController.users = users
        self.navigationController?.pushViewController(chatController, animated: false)
    }

    let loginEndpoint = "http://192.168.1.114:3000/login"

    private func doLogin(username: String) {
        let parameters = [
            "username": username,
        ]

        Alamofire.request(loginEndpoint, method: .post, parameters: parameters).responseJSON { res in
            if let result = res.result.value as? [String: Any]? {
                guard
                        let status = result["status"] as? Int,
                        status != 1,
                        let data = result["data"] as? [String: Any]?,
                        let token = data["token"] as? String,
                        let users = data["user"] as? [String: Any]
                        else {
                    if let message = result["message"] as? String {
                        showError(error: message)
                    } else {
                        showError(error: "Unknow Error")
                    }
                }

                goToChatRoom(token: token, users: users)

            } else {
                showError(error: "Unknow Error")
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

    private func setUpView() {

        view.addSubview(loginButton)
        view.addSubview(username)

        username.snp.makeConstraints { maker in
            maker.center.equalToSuperview()
        }

        loginButton.snp.makeConstraints { maker in
            maker.top.equalTo(username.snp.bottom).offset(20)
            maker.centerX.equalToSuperview()
        }
    }
}
