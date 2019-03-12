//
//  SetPasswordViewController.swift
//  LTY
//
//  Created by 花菜 on 2018/12/17.
//  Copyright © 2018 Coder.flower. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

final class SetPasswordViewController: UIViewController {
    private let viewModel = SetPasswordViewModel()
    @IBOutlet weak var repeateField: UITextField!
    @IBOutlet weak var passwrodField: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    private let completion: ((Bool) -> Void)?
    init(_ completion: ((Bool) -> Void)? = nil) {
        self.completion = completion
        super.init(nibName: "SetPasswordViewController", bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
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
            if string.isEmpty {return true}
            if !Matcher.numberAndLetter.match(string){return false}
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
            confirmTap:confirmButton.rx.tap.asObservable()
        )
        let output = viewModel.transform(input: input)
        output.isConfirmEnabled.bind(to: confirmButton.rx.isEnabled).disposed(by: rx.disposeBag)
        output.setPasswordState.drive(SFToast.rx.state).disposed(by: rx.disposeBag)
        output.result.map({ [weak self]result in
                /// 告诉上一个页面
                self?.completion?(result)
            })
            .asDriverOnErrorJustComplete()
            .drive(rx.goBack)
            .disposed(by: rx.disposeBag)
    }
}

/*
class SetPasswordViewController: UIViewController {
    let viewModel = SetPasswordViewModel()
    /// 第一次输入
    lazy var firstInputView: PasswordInputView = {
        let tmpView = PasswordInputView(inputType: .box)
        tmpView.delegate = self
        view.addSubview(tmpView)
        tmpView.backgroundColor = ColorHelper.default.background
        return tmpView
    }()
    /// 重复输入
    lazy var repeatInputView: PasswordInputView = {
        let tmpView = PasswordInputView(inputType: .box)
        tmpView.delegate = self
        tmpView.backgroundColor = ColorHelper.default.background
        view.addSubview(tmpView)
        return tmpView
    }()
    
    lazy var descLabel: UILabel = {
        let tmpLabel = UILabel("输入密码", font:  FontHelper.regular(18), color: UIColor(hex: "191919"))
        view.addSubview(tmpLabel)
        return tmpLabel
    }()
    
    let setPasswordSignal = PublishSubject<String>()
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSubviews()
        configureNavigationBar()
        configureSignal()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        _ = firstInputView.becomeFirstResponder()
    }
    
    
    var showSuccess: Binder<Bool> {
        return Binder(self) { this, isShow in
            this.descLabel.isHidden = true
            this.firstInputView.isHidden = true
            this.repeatInputView.isHidden = true
            this.view.endEditing(true)
            this.sf.goBack()
        }
    }
    

}
extension SetPasswordViewController: Actionable {
    
}
extension SetPasswordViewController: ControllerConfigurable {
    func configureSubviews() {
        view.backgroundColor = ColorHelper.default.background
        descLabel.snp.makeConstraints({
            $0.top.equalTo(navigation.bar.snp.bottom).offset(110)
            $0.centerX.equalToSuperview()
        })
        firstInputView.snp.makeConstraints({
            $0.left.equalToSuperview()
            $0.width.equalToSuperview()
            $0.top.equalTo(descLabel.snp.bottom).offset(50)
            $0.height.equalTo(50)
        })
        repeatInputView.snp.makeConstraints({
            $0.left.equalTo(firstInputView.snp.right)
            $0.width.equalToSuperview()
            $0.top.equalTo(descLabel.snp.bottom).offset(50)
            $0.height.equalTo(50)
        })
        
    }
    func configureNavigationBar() {
        navigation.item.title = "设置交易密码"
    }
    func configureSignal() {
        let input = SetPasswordViewModel.Input(repeatEndSignal: setPasswordSignal)
        let ouput = viewModel.transform(input: input)
        ouput.state.drive(SFToast.rx.state).disposed(by: rx.disposeBag)
        ouput.result.bind(to: showSuccess).disposed(by: rx.disposeBag)
    }
}
extension SetPasswordViewController: PasswordInputViewDelegate {
    func passwordInputViewCompletedEdited(_ inputView: PasswordInputView) {
        if inputView == firstInputView {
            firstInputView.snp.updateConstraints({
                $0.left.equalToSuperview().offset(-UIScreen.width)
            })
            UIView.animate(withDuration: 0.1, animations: {
                self.view.layoutIfNeeded()
            }, completion: { (_) in
                self.descLabel.text = "再次输入密码"
                _ = self.repeatInputView.becomeFirstResponder()
            })
        } else if inputView == repeatInputView {
            /// 判断两次输入是否一样
            if inputView.text == firstInputView.text {
                myLog("设置交易密码成功")
                setPasswordSignal.onNext(inputView.text)
            } else {
                myLog("重新设置")
                SFToast.show(info: "两次输入不一致,请重新输入")
                self.firstInputView.reset()
                self.repeatInputView.reset()
                firstInputView.snp.updateConstraints({
                    $0.left.equalToSuperview()
                })
                UIView.animate(withDuration: 0.25, animations: {
                    self.view.layoutIfNeeded()
                }, completion: { (_) in
                    self.descLabel.text = "输入密码"
                    _ = self.firstInputView.becomeFirstResponder()
                })
            }
            
        }
    }
}
*/
