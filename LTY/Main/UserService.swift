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
    init(_ password: String? = nil) {
        self.password = password
    }
}


final class UserService {
    static let shared = UserService()
    /// 保存用户信息目录
    let userDataPath: URL = {
        var pathUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        pathUrl.appendPathComponent("user.data")
        return pathUrl
    }()
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
    
    var hasPassword: Bool {
        return !(user?.password?.isEmpty ?? false)
    }
    func deletePassword() {
        let user = User()
        self.user = user
    }
}
