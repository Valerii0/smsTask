//
//  Message.swift
//  SmsTask
//
//  Created by Valerii Petrychenko on 10/28/19.
//  Copyright © 2019 Valerii Petrychenko. All rights reserved.
//

import Foundation

class Message {
    var createdOn: String
    var subMessages: [String]
    var delivered = "Delivered"

    init(createdOn: String, subMessages: [String]) {
        self.createdOn = createdOn
        self.subMessages = subMessages
    }
}
