//
//  AuthenticationViewController.swift
//  Hasura-Todo-iOS
//
//  Created by Jaison on 17/01/17.
//  Copyright © 2017 Hasura. All rights reserved.
//

import UIKit

class AuthenticationViewController: UIViewController {
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Hasura.sharedInstance.authToken != nil {
            navigateToTodoVC()
        }
    }
    
    @IBAction func onLoginButtonClicked(_ sender: UIButton) {
        if isFormValid() {            
            HasuraApi.login(username: username.text!, password: password.text!, completionHandler: { (response) in
                switch response.result {
                case .failure(let error):
                    self.showErrorAlert(error: error)
                    break
                case .success(let data):
                    Hasura.sharedInstance.setSession(authResponse: data)
                    self.navigateToTodoVC()
                    break
                }
            })
        }
    }
    
    @IBAction func onRegisterButtonClicked(_ sender: UIButton) {
        if isFormValid() {
            HasuraApi.register(username: username.text!, password: password.text!, completionHandler: { (response) in
                switch response.result {
                case .failure(let error):
                    self.showErrorAlert(error: error)
                    break
                case .success(let data):
                    Hasura.sharedInstance.setSession(authResponse: data)
                    self.navigateToTodoVC()
                    break
                }
            })
        }
    }
    
    private func navigateToTodoVC() {
        let navigationVC = storyboard!.instantiateViewController(withIdentifier: "TodoNavigationController")
        self.present(navigationVC, animated: true, completion: nil)
    }
    
    private func isFormValid() -> Bool {
        if username.text!.isEmpty {
            showAlert(title: "Invalid",message: "Username field cannot be left empty")
            return false
        }
        
        if password.text!.isEmpty {
            showAlert(title: "Invalid", message: "Password field cannot be left empty")
            return false
        }
        return true
    }
    
    
    
}
