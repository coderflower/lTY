//
//  PassworManagerViewController.swift
//  LTY
//
//  Created by 花菜 on 2019/3/11.
//  Copyright © 2019 Coder.flower. All rights reserved.
//

import UIKit

final class PassworManagerViewController: UIViewController {
    private let viewModel = PasswordManagerViewModel()
    @IBOutlet private var changePasswordView: UIView!
    @IBOutlet private var `switch`: UISwitch!
    @IBOutlet private var changePasswordButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureSubviews()
        configureNavigationBar()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        `switch`.isOn = UserService.shared.hasPassword
    }
}

extension PassworManagerViewController: Actionable {
    @IBAction func changePasswordButtonAction(_: Any) {
        let vc = ModifyPasswordViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func valueChangeAction(_ sender: UISwitch) {
        if sender.isOn {
            /// 如果本身是开启的
            //            sender.isOn = false
            /// 跳转到设置密码页面
            let vc = SetPasswordViewController { [weak self] isSuccess in
                sender.isOn = isSuccess
                self?.changePasswordView.isHidden = !isSuccess
            }
            navigationController?.pushViewController(vc, animated: true)
        } else {
            UIAlertController.rx.show(in: self, title: "是否确认关闭密码", message: nil, buttons: [.cancel("取消"), .destructive("确认关闭")], textFields: [{
                $0.textAlignment = .center
                $0.isSecureTextEntry = true
            }]).subscribe(onSuccess: { [weak self] index, input in
                myLog(input)
                if index == 0 {
                    sender.isOn = true
                }
                guard let password = input.first else { return }
                /// 判断是否入旧密码相同
                if UserService.shared.user?.password == password {
                    sender.isOn = false
                    UserService.shared.update(password: nil)
                    self?.changePasswordView.isHidden = true
                } else {
                    sender.isOn = true
                    /// 旧密码错误
                    SFToast.show(info: "密码输入错误,请重试")
                }
            }).disposed(by: rx.disposeBag)
        }
    }
}

extension PassworManagerViewController: ControllerConfigurable {
    func configureSubviews() {
        view.backgroundColor = ColorHelper.default.background
        `switch`.isOn = UserService.shared.hasPassword
        changePasswordView.isHidden = !UserService.shared.hasPassword
    }

    func configureNavigationBar() {
        navigation.item.title = "密码管理"
    }
}
