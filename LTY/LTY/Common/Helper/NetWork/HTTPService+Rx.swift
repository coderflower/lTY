//
//  Mapper.swift
//  CarBook
//
//  Created by 花菜 on 2018/6/7.
//  Copyright © 2018年 Coder.flower. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Moya
import Cache
extension HTTPService {
    
    struct Response<T: Codable>: Codable {
        let status: Int
        let msg: String
        let data: T
        
        var success: Bool {
            return status == 0
        }
    }
    
}

extension HTTPService {
    
    enum Error: SFError {
       
        case status(code: Int, message: String)
        
        var message: String {
            switch self {
            case let .status(_, message):
                return message
            }
        }
        var code: Int {
            switch self {
            case let .status(code, _):
                return code
            }
        }
        var errorMessage: String {
            return message
        }
        
    }
    
}

