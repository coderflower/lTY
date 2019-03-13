//
//  UserService.swift
//  LTY
//
//  Created by 花菜 on 2019/3/12.
//  Copyright © 2019 Coder.flower. All rights reserved.
//

import Foundation

struct User: Codable {
    var password: String?
    var registrationId: String?
    init(_ password: String? = nil, registrationId: String? = nil) {
        self.password = password
    }
    mutating func update(_ password: String?) {
        self.password = password
    }
    mutating func update(registrationId: String?) {
        self.registrationId = registrationId
    }
}


final class UserService {
    static let shared = UserService()
    var user: User? {
        set {
            do {
                let data = try JSONEncoder().encode(newValue)
                try data.write(to: userDataPath)
            } catch {
                debugPrint("用户信息保存失败",error)
            }
        }
        get {
            guard let data = try? Data(contentsOf: userDataPath),
                let user = try? JSONDecoder().decode(User.self, from: data) else {return nil}
            return user
        }
    }
    /// 保存用户信息目录
    let userDataPath: URL = {
        var pathUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        pathUrl.appendPathComponent("user.data")
        return pathUrl
    }()
    var hasPassword: Bool {
        return !(user?.password?.isEmpty ?? true)
    }
    
    func update(password: String?) {
        user?.update(password)
    }
}
