//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    let db = Firestore.firestore()
    var message : [Message] = [
    
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "⚡️FlashChat"
        navigationItem.hidesBackButton = true
        tableView.dataSource = self
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        loadMessage()
    }
    func loadMessage (){
        db.collection(K.FStore.collectionName)
            .order(by: K.FStore.dateField)
            .addSnapshotListener
        { querySnapshot, error in
            self.message = []
            if let e = error {
                print(e)
            } else {
                if let snapshotDocuments = querySnapshot?.documents{
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let sender = data[K.FStore.senderField] as? String, let messageBody = data[K.FStore.bodyField] as? String {
                            let newMessage = Message(sender: sender, body: messageBody)
                            self.message.append(newMessage)
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                let indexPath = IndexPath(row: self.message.count - 1 , section: 0)
                                self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        if let messageBody = messageTextfield.text,
            let messageSender = Auth.auth().currentUser?.email {
            db.collection(K.FStore.collectionName).addDocument(data: [K.FStore.senderField :messageSender, K.FStore.bodyField : messageBody, K.FStore.dateField :Date().timeIntervalSince1970 ])
            { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Successfully save data with \(messageBody)")
                }
            }
        }
        messageTextfield.text = ""
        
    }
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        
        do {
          try Auth.auth().signOut()
            
            navigationController?.popToRootViewController(animated: true)
            
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
    }
    
}
extension ChatViewController : UITableViewDataSource {
    // MARK: - UItableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return message.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = message[indexPath.row]
       
        guard let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as? MessageCell else {
            return UITableViewCell()
        }
        cell.label.text = message.body
        if message.sender == Auth.auth().currentUser?.email {
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            cell.messageBublle.backgroundColor = UIColor(named: K.BrandColors.lightPurple)
            cell.label.textColor = UIColor(named: K.BrandColors.purple)
        } else {
            cell.leftImageView.isHidden = false
            cell.rightImageView.isHidden = true
            cell.messageBublle.backgroundColor = UIColor(named: K.BrandColors.purple)
            cell.label.textColor = UIColor(named: K.BrandColors.lightPurple)
        }
        return cell
        
    }
    
    
}
