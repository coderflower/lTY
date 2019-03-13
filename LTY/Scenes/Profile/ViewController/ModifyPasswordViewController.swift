//
//  ModifyPasswordViewController.swift
//  LTY
//
//  Created by 花菜 on 2019/3/11.
//  Copyright © 2019 Coder.flower. All rights reserved.
//

import UIKit

final class ModifyPasswordViewController: UIViewController {
    private let viewModel = ModifyPasswordViewModel()
    private lazy var oldPasswordField: UITextField = {
        let field = UITextField()
        field.placeholder = "请输入旧密码"
        view.addSubview(field)
        return field
    }()

    private lazy var newPasswordField: UITextField = {
        let field = UITextField()
        field.placeholder = "请输入新密码"
        view.addSubview(field)
        return field
    }()

    //

    private lazy var confirmButton: UIButton = {
        let button = UIButton("确定", color: UIColor.white, font: FontHelper.regular(18))
        button.sf.setBackgroundColor(ColorHelper.default.theme, for: .normal)
        button.sf.setBackgroundColor(ColorHelper.default.disabledColor, for: .disabled)
        button.cornerRadius = 5
        view.addSubview(button)
        return button
    }()

    private lazy var descLabel: UILabel = {
        let label = UILabel("请牢记密码,否则将无法找回", font: FontHelper.regular(12), color: UIColor(hex: "E84632"))
        view.addSubview(label)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureSubviews()
        configureNavigationBar()
        configureSignal()
    }
}

extension ModifyPasswordViewController: ControllerConfigurable {
    func configureSubviews() {
        view.backgroundColor = ColorHelper.default.background
        let oldPasswordFieldBackView = UIView(UIColor.white)
        let newPasswordFieldBackView = UIView(UIColor.white)
        view.addSubview(oldPasswordFieldBackView)
        view.addSubview(newPasswordFieldBackView)
        configureField(oldPasswordField)
        configureField(newPasswordField)
        oldPasswordFieldBackView.snp.makeConstraints({
            $0.left.equalToSuperview().offset(10)
            $0.top.equalTo(navigation.bar.snp.bottom).offset(50)
            $0.height.equalTo(40)
            $0.right.equalToSuperview().offset(-10)
        })
        newPasswordFieldBackView.snp.makeConstraints({
            $0.left.right.height.equalTo(oldPasswordFieldBackView)
            $0.top.equalTo(oldPasswordFieldBackView.snp.bottom).offset(10)
        })

        oldPasswordField.snp.makeConstraints({
            $0.left.equalTo(oldPasswordFieldBackView).offset(10)
            $0.right.equalTo(oldPasswordFieldBackView).offset(-10)
            $0.centerY.equalTo(oldPasswordFieldBackView)
        })

        newPasswordField.snp.makeConstraints({
            $0.left.equalTo(newPasswordFieldBackView).offset(10)
            $0.right.equalTo(newPasswordFieldBackView).offset(-10)
            $0.centerY.equalTo(newPasswordFieldBackView)
        })

        confirmButton.snp.makeConstraints({
            $0.top.equalTo(newPasswordFieldBackView.snp.bottom).offset(20)
            $0.right.equalToSuperview().offset(-10)
            $0.left.equalToSuperview().offset(10)
            $0.height.equalTo(40)
        })

        descLabel.snp.makeConstraints({
            $0.top.equalTo(confirmButton.snp.bottom).offset(20)
            $0.left.right.equalTo(confirmButton)
        })
    }

    func configureField(_ textField: UITextField) {
        /// 关闭自动联想
        textField.autocorrectionType = .no
        /// 关闭首字母大写
        textField.autocapitalizationType = .none
        textField.isSecureTextEntry = true
        textField.rx.delegate.shouldChangeCharacters = { (field, range, string) -> Bool in
            if string.isEmpty { return true }
            if !Matcher.numberAndLetter.match(string) { return false }
            guard let text = field.text else { return true }
            let length = text.count + string.count - range.length
            return length <= 16
        }
    }

    func configureNavigationBar() {
        navigation.item.title = "修改密码"
    }

    func configureSignal() {
        let input = ModifyPasswordViewModel.Input(oldPassword: oldPasswordField.rx.text.orEmpty.asObservable(),
                                                  newPassword: newPasswordField.rx.text.orEmpty.asObservable(),
                                                  confirmTap: confirmButton.rx.tap.asObservable())

        let output = viewModel.transform(input: input)
        output.changePasswordState.drive(SFToast.rx.state).disposed(by: rx.disposeBag)
        output.isConfirmEnabled.bind(to: confirmButton.rx.isEnabled).disposed(by: rx.disposeBag)
        output.result.map(to: ()).drive(rx.goBack).disposed(by: rx.disposeBag)
    }
}
