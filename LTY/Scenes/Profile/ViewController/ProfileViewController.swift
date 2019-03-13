//
//  ProfileViewController.swift
//  LTY
//
//  Created by 花菜 on 2019/3/6.
//  Copyright © 2019 Coder.flower. All rights reserved.
//

import CollectionKit
import UIKit
class ProfileViewController: UIViewController {
    let viewModel = ProfileViewModel()
    private lazy var collectionView: CollectionView = {
        let tmpView = CollectionView()
        view.addSubview(tmpView)
        tmpView.provider = provider
        return tmpView
    }()

    let dataSource = ArrayDataSource<ProfileModel>(data: [])

    lazy var provider = Provider.shared.profileProvider(dataSource: dataSource)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureSubviews()
        configureNavigationBar()
        configureSignal()
        provider.tapHandler = { [weak self] tap in
            self?.hanldeAction(by: tap.data.actionType)
        }
    }
}

extension ProfileViewController: ControllerConfigurable {
    func configureSubviews() {
        view.backgroundColor = ColorHelper.default.background
        collectionView.snp.makeConstraints({
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(navigation.bar.snp.bottom)
        })
    }

    func configureNavigationBar() {
        navigation.item.title = "个人中心"
    }

    func configureSignal() {
        let input = ProfileViewModel.Input()
        let output = viewModel.transform(input: input)
        dataSource.data = output.dataSource
    }
}

extension ProfileViewController: Actionable {
    func hanldeAction(by type: ProfileModel.ActionType) {
        switch type {
        case .about:
            navigate(to: AboutViewController())
        case .password:
            navigate(to: PassworManagerViewController())
        case .images:
            showAlert { [weak self] in
                self?.navigate(to: PhotoWallViewController())
            }
        case .diary:
            showAlert { [weak self] in
                self?.navigate(to: AllItemViewController(HomeViewModel(pageSize: 5)))
            }
        }
    }

    func navigate(to viewController: UIViewController) {
        navigationController?.pushViewController(viewController, animated: true)
    }

    func isSetPassword() -> Bool {
        return UserDefaults.standard.string(forKey: SFConst.passwordKey) != nil
    }

    func showAlert(completion: @escaping () -> Void) {
        if let password = UserService.shared.user?.password {
            /// 如果本身是关闭的,
            UIAlertController.rx.show(in: self,
                                      title: "请输入密码",
                                      message: "输入正确的密码才能继续访问",
                                      buttons: [.cancel("取消"), .destructive("确认")],
                                      textFields: [{
                                          $0.isSecureTextEntry = true
                                          $0.textAlignment = .center
            }])
                .subscribe(onSuccess: { index, input in
                    if index == 0 { return }
                    guard let input = input.first else { return }
                    /// 判断是否入旧密码相同
                    if password == input {
                        completion()
                    } else {
                        SFToast.show(info: "密码错误")
                    }
                }).disposed(by: rx.disposeBag)
        } else {
            completion()
        }
    }
}
