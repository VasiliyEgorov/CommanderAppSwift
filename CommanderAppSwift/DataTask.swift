//
//  DataTask.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 19.04.2018.
//  Copyright © 2018 VasiliyEgorov. All rights reserved.
//

import Foundation

class DataTask: Hashable, Equatable {
    
    let taskId: String
    var task : URLSessionDataTask?
    
    init(taskId: String) {
        self.taskId = taskId
    }
    
    // MARK: - Equatable
    
    static func ==(lhs: DataTask, rhs: DataTask) -> Bool {
        return lhs.taskId == rhs.taskId
    }
    
    // MARK: - Hashable
    
    var hashValue: Int {
        return taskId.hashValue
    }
}
