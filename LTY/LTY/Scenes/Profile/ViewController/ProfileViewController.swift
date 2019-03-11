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
            let set = SetPasswordViewController()
            navigationController?.pushViewController(set, animated: true)
        case .images:
            let photoWall = PhotoWallViewController()
            navigationController?.pushViewController(photoWall, animated: true)
        default:
            break
        }
    }
}
