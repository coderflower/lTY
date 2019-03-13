//
//  SetPasswordViewController.swift
//  LTY
//
//  Created by 花菜 on 2018/12/17.
//  Copyright © 2018 Coder.flower. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

final class SetPasswordViewController: UIViewController {
    private let viewModel = SetPasswordViewModel()
    @IBOutlet var repeateField: UITextField!
    @IBOutlet var passwrodField: UITextField!
    @IBOutlet var confirmButton: UIButton!
    private let completion: ((Bool) -> Void)?
    init(_ completion: ((Bool) -> Void)? = nil) {
        self.completion = completion
        super.init(nibName: "SetPasswordViewController", bundle: nil)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureSubviews()
        configureNavigationBar()
        configureSignal()
    }

    func configureField(_ textField: UITextField) {
        textField.rx.delegate.shouldChangeCharacters = { (field, range, string) -> Bool in
            if string.isEmpty { return true }
            if !Matcher.numberAndLetter.match(string) { return false }
            guard let text = field.text else { return true }
            let length = text.count + string.count - range.length
            return length <= 16
        }
    }
}

extension SetPasswordViewController: ControllerConfigurable {
    func configureSubviews() {
        configureField(passwrodField)
        configureField(repeateField)
        confirmButton.sf.setBackgroundColor(ColorHelper.default.theme, for: .normal)
        confirmButton.sf.setBackgroundColor(ColorHelper.default.disabledColor, for: .disabled)
    }

    func configureNavigationBar() {
        navigation.item.title = "设置私密密码"
    }

    func configureSignal() {
        let input = SetPasswordViewModel.Input(
            passwordText: passwrodField.rx.text.orEmpty.asObservable(),
            repeatText: repeateField.rx.text.orEmpty.asObservable(),
            confirmTap: confirmButton.rx.tap.asObservable()
        )
        let output = viewModel.transform(input: input)
        output.isConfirmEnabled.bind(to: confirmButton.rx.isEnabled).disposed(by: rx.disposeBag)
        output.setPasswordState.drive(SFToast.rx.state).disposed(by: rx.disposeBag)
        output.result.map({ [weak self] result in
            /// 告诉上一个页面
            self?.completion?(result)
        })
            .asDriverOnErrorJustComplete()
            .drive(rx.goBack)
            .disposed(by: rx.disposeBag)
    }
}
