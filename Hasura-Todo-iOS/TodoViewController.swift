//
//  TodoViewController.swift
//  Hasura-Todo-iOS
//
//  Created by Jaison on 17/01/17.
//  Copyright © 2017 Hasura. All rights reserved.
//

import UIKit

class TodoViewController: UITableViewController {
    
    var data =  [TodoRecord]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Fetch all todos for the user
        HasuraApi.getTodos { (response) in
            switch response.result {
            case .failure(let error) :
                self.showErrorAlert(error: error)
                break
            case .success(let data):
                self.data = data
                self.tableView.reloadData()
                break
            }
        }
    }
    
    
    @IBAction func onAddTodoClicked(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Create a new to-do", message: nil, preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (action) in
            self.addTodo(newTodoTitle: alert.textFields![0].text!)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    private func addTodo(newTodoTitle: String) {
        HasuraApi.addATodo(todoTitle: newTodoTitle) { (response) in
            switch response.result {
            case .failure(let error):
                self.showErrorAlert(error: error)
                break
            case .success(let data):
                self.data.append(contentsOf: data.returning!)
                self.tableView.reloadData()
                break
            }
        }
    }
    
    @IBAction func onLogoutClicked(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Sign Out",message: "Are you sure you want to sign out?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "SignOut", style: .destructive, handler: { (action) in
            self.performLogout()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func performLogout() {
        HasuraApi.logout { (response) in
            switch response.result {
            case .failure(let error):
                self.showErrorAlert(error: error)
                break
            case .success( _):
                Hasura.sharedInstance.clearSession()
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath)
        cell.textLabel!.text = data[indexPath.row].title
        cell.selectionStyle = .none        
        if data[indexPath.row].completed == true {
            //If todo is completed, strike through its text
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: cell.textLabel!.text!)
            attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, attributeString.length))
            cell.textLabel!.attributedText = attributeString
        }
                
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedTodo = data[indexPath.row]
        selectedTodo.completed = !selectedTodo.completed
        
        HasuraApi.updateATodo(todo: selectedTodo) { (response) in
            switch response.result {
            case .failure(let error):
                self.showErrorAlert(error: error)
                break
            case .success:
                tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
                break
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            HasuraApi.deleteATodo(todoId: data[indexPath.row].id, completionHandler: { (response) in
                switch response.result {
                case .success:
                    self.data.remove(at: indexPath.row)
                    self.tableView.reloadData()
                    break
                case .failure(let error):
                    self.showErrorAlert(error: error)
                    break
                }
            })
        }
    }
    
}

