//
//  Comment.swift
//  Project 2
//
//  Created by Amancio Ramirez on 2/28/25.
//

import Foundation
import ParseSwift

struct Comment: ParseObject {
    var originalData: Data?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseSwift.ParseACL?
    var objectId: String?
    var username: User?
    var text: String?
//    var postId: String?
}
