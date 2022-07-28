//
//  ChatUser.swift
//  Habiibi
//
//  Created by KhanhVu on 7/26/22.
//

import Foundation
import MessageKit
struct ChatUser: SenderType, Equatable {
    var senderId: String
    var displayName: String
}
