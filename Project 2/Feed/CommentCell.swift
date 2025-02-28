//
//  CommentCell.swift
//  Project 2
//
//  Created by Amancio Ramirez on 2/28/25.
//

import UIKit

class CommentCell: UITableViewCell {
    
    let usernameLabel = UILabel()
    let timestampLabel = UILabel()
    let commentLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        usernameLabel.font = UIFont.boldSystemFont(ofSize: 14)
        timestampLabel.font = UIFont.systemFont(ofSize: 12, weight: .light)
        timestampLabel.textColor = .gray
        commentLabel.font = UIFont.systemFont(ofSize: 14)
        commentLabel.numberOfLines = 0
        
        let stackView = UIStackView(arrangedSubviews: [usernameLabel, timestampLabel, commentLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        ])
    }
    
    func configure(with comment: Comment) {
        usernameLabel.text = comment.username?.username ?? "Unknown"
        commentLabel.text = comment.text
        
        if let date = comment.createdAt {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d, yyyy h:mm a"
            timestampLabel.text = formatter.string(from: date)
        } else {
            timestampLabel.text = "Just now"
        }
    }
}
