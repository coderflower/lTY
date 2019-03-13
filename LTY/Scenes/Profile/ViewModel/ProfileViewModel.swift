//
//  ProfileViewModel.swift
//  LTY
//
//  Created by 花菜 on 2019/3/11.
//  Copyright © 2019 Coder.flower. All rights reserved.
//

import Foundation
import UIKit
final class ProfileViewModel {
    func transform(input _: Input) -> Output {
        let models = [ProfileModel(title: "所有日记", actionType: .diary),
                      ProfileModel(title: "密码管理", actionType: .password),
                      ProfileModel(title: "我的相册", actionType: .images),
                      ProfileModel(title: "关于我们", actionType: .about),
                      ProfileModel(title: "去评论", actionType: .comment)]
        return Output(dataSource: models)
    }
}

extension ProfileViewModel: ViewModelType {
    struct Input {}

    struct Output {
        let dataSource: [ProfileModel]
    }
}
