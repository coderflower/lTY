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
    @IBOutlet private weak var changePasswordView: UIView!
    @IBOutlet private weak var `switch`: UISwitch!
    @IBOutlet private weak var changePasswordButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureSubviews()
        configureNavigationBar()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.switch.isOn = UserService.shared.hasPassword
    }
    @IBAction func valueChangeAction(_ sender: UISwitch) {
        if sender.isOn {
            /// 如果本身是开启的
//            sender.isOn = false
            /// 跳转到设置密码页面
            let vc = SetPasswordViewController { [weak self] (isSuccess) in
                sender.isOn = isSuccess
                self?.changePasswordView.isHidden = !isSuccess
            }
            navigationController?.pushViewController(vc, animated: true)
        }
        else {
            /// 如果本身是关闭的,
            UIAlertController.rx.show(in: self, title: "是否确认关闭密码", message: nil, buttons: [.cancel("取消"), .destructive("确认关闭")], textFields: [{
                    $0.textAlignment = .center
                }]).subscribe(onSuccess: { [weak self](index, input) in
                    myLog(input)
                    if index == 0 {
                        sender.isOn = true
                    }
                    guard let password = input.first else {return}
                    /// 判断是否入旧密码相同
                    if UserService.shared.user?.password == password {
                        sender.isOn = false
                        self?.changePasswordView.isHidden = true
                    }
                }).disposed(by: rx.disposeBag)
        }
    }
    
}

extension PassworManagerViewController: ControllerConfigurable {
    func configureSubviews() {
        view.backgroundColor = ColorHelper.default.background
        
    }
    func configureNavigationBar() {
        navigation.item.title = "密码管理"
    }
   
}
