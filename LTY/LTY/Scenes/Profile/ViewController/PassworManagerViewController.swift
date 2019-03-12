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
        configureSignal()
    }

    @IBAction func valueChangeAction(_ sender: UISwitch) {
        if sender.isOn {
            /// 如果本身是开启的
            sender.isOn = false
            /// 跳转到设置密码页面
            let vc = SetPasswordViewController()
            navigationController?.pushViewController(vc, animated: true)
        }
        else {
            /// 如果本身是关闭的,
            
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
    func configureSignal() {
        let input = PasswordManagerViewModel.Input(
            isOn: self.switch.rx.value.shareOnce(),
            changePasswordTap: changePasswordButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.isHiddenChangeView.bind(to: changePasswordView.rx.isHidden).disposed(by: rx.disposeBag)
        
//        (self.switch.rx.value).subscribeNext(weak: self) { (self) in {isOn in
//                myLog(isOn)
//            }
//        }.disposed(by: rx.disposeBag)
        
    }
}
