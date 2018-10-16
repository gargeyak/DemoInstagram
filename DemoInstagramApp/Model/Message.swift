//
//  Message.swift
//  DemoInstagramApp
//
//  Created by Ady on 8/13/18.
//  Copyright © 2018 RJTCompuquest. All rights reserved.
//

import Foundation


class Message {
    var incoming: Bool?
    var text: String?
    var timestamp: Int?
    
    init(incoming: Bool?, text: String?, timestamp: Int?) {
        
        self.incoming = incoming
        self.text = text
        self.timestamp = timestamp
    }
}
