//
//  ProfileViewController.swift
//  LTY
//
//  Created by 花菜 on 2019/3/6.
//  Copyright © 2019 Coder.flower. All rights reserved.
//

import UIKit
import CollectionKit
class ProfileViewController: UIViewController {
    let viewModel = ProfileViewModel()
    private lazy var collectionView: CollectionView = {
        let tmpView = CollectionView()
        view.addSubview(tmpView)
        tmpView.provider = provider
        return tmpView
    }()
    let dataSource = ArrayDataSource<ProfileModel>(data: [])
    lazy var provider: BasicProvider<ProfileModel, ProfileViewCell> = {
        
        let viewSource = ClosureViewSource<ProfileModel, ProfileViewCell>(viewUpdater: { (view: ProfileViewCell, data: ProfileModel, at: Int) in
            view.update(data)
        })
        let sizeSource = { (index: Int, data: ProfileModel, collectionSize: CGSize) -> CGSize in
            return CGSize(width: collectionSize.width, height: 44)
        }
        let provider = BasicProvider<ProfileModel, ProfileViewCell>(
            dataSource: dataSource,
            viewSource: viewSource,
            sizeSource: sizeSource)
        provider.layout = FlowLayout(spacing: 1).inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        provider.tapHandler = {[weak self]tap in
            self?.hanldeAction(by: tap.data.actionType)
        }
        return provider
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureSubviews()
        configureNavigationBar()
        configureSignal()
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
        navigation.item.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "settings"))
    }
    func configureSignal() {
        navigation.item.rightBarButtonItem?.rx.tap.bind(to: rx.goBack).disposed(by: rx.disposeBag)
        let input = ProfileViewModel.Input()
        let output = viewModel.transform(input: input)
        dataSource.data = output.dataSource
    }
}

extension ProfileViewController: Actionable {
    func hanldeAction(by type: ProfileModel.ActionType) {
        
        switch type {
        case .about:
            myLog(type.rawValue)
        case .password:
            /// 判断用户是否设置密码,
            let viewController: UIViewController
            if isSetPassword() {
                viewController = ModifyPasswordViewController()
            } else {
                viewController = SetPasswordViewController()
            }
            navigate(to: viewController)
        case .images:
            showAlert { [weak self] in
                self?.navigate(to: PhotoWallViewController())
            }
        case .diary:
            showAlert { [weak self] in
                self?.navigate(to: AllItemViewController())
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
        if let password = UserDefaults.standard.string(forKey: SFConst.passwordKey) {
            UIAlertController.rx.prompt(in: self, title: "请输入密码", message: "输入正确的密码才能继续访问", defaultValue: nil, closeTitle: "取消", confirmTitle: "确定").subscribe(onSuccess: { (input) in
                myLog(password)
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
