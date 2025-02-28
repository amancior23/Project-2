//
//  CommentViewController.swift
//  Project 2
//
//  Created by Amancio Ramirez on 2/28/25.
//

import UIKit
import ParseSwift

class CommentViewController: UIViewController {
    
    var post: Post? // The post for which comments are displayed
    var comments: [Comment] = []

    let tableView = UITableView()
    let commentTextField = UITextField()
    let postButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Comments"
        view.backgroundColor = .white
        setupUI()
        fetchComments()
    }

    private func setupUI() {
        // Configure TableView
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CommentCell.self, forCellReuseIdentifier: "CommentCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        // Configure TextField for writing comments
        commentTextField.placeholder = "Write a comment..."
        commentTextField.borderStyle = .roundedRect
        commentTextField.translatesAutoresizingMaskIntoConstraints = false
        
        // Configure Post Button
        postButton.setTitle("Post", for: .normal)
        postButton.addTarget(self, action: #selector(postComment), for: .touchUpInside)
        postButton.translatesAutoresizingMaskIntoConstraints = false
        
        let inputContainer = UIView()
        inputContainer.translatesAutoresizingMaskIntoConstraints = false
        inputContainer.addSubview(commentTextField)
        inputContainer.addSubview(postButton)

        view.addSubview(tableView)
        view.addSubview(inputContainer)
        
        // Layout Constraints
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: inputContainer.topAnchor),
            
            inputContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            inputContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            inputContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            inputContainer.heightAnchor.constraint(equalToConstant: 50),
            
            commentTextField.leadingAnchor.constraint(equalTo: inputContainer.leadingAnchor, constant: 10),
            commentTextField.centerYAnchor.constraint(equalTo: inputContainer.centerYAnchor),
            commentTextField.trailingAnchor.constraint(equalTo: postButton.leadingAnchor, constant: -10),
            
            postButton.trailingAnchor.constraint(equalTo: inputContainer.trailingAnchor, constant: -10),
            postButton.centerYAnchor.constraint(equalTo: inputContainer.centerYAnchor),
            postButton.widthAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func fetchComments() {
        let query = Comment.query()
            .include("username")  // This ensures that the User object is fully fetched
            .order([.ascending("createdAt")]) // Order comments by creation time

        query.find { result in
            switch result {
            case .success(let fetchedComments):
                self.comments = fetchedComments
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print("Error fetching comments: \(error.localizedDescription)")
            }
        }
    }

    
    @objc private func postComment() {
        print("Post button tapped!")

        guard let text = commentTextField.text, !text.isEmpty else {
            print("Comment is empty!")
            return
        }
        guard let user = User.current else {
            print("No logged-in user!")
            return
        }
//        guard let postId = post?.objectId else {
//            print("Post ID is missing!")
//            return
//        }

//        print("User: \(user.username ?? "Unknown User"), Posting on Post ID: \(postId)")
        
        let newComment = Comment(username: user, text: text)

        newComment.save { result in
            switch result {
            case .success(let savedComment):
                print("Comment saved successfully: \(savedComment)")
                self.comments.append(savedComment)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.commentTextField.text = ""
                }
            case .failure(let error):
                print("Error posting comment: \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension CommentViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentCell
        let comment = comments[indexPath.row]
        cell.configure(with: comment)
        return cell
    }
}
