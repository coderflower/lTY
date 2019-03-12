//
//  PhotoWallViewController.swift
//  LTY
//
//  Created by 花菜 on 2019/3/11.
//  Copyright © 2019 Coder.flower. All rights reserved.
//

import UIKit
import CollectionKit
import RxCocoa
final class PhotoWallViewController: UIViewController {
    private let viewModel = PhotoWallViewModel()
    private lazy var collectionView: CollectionView = {
        let tmpView = CollectionView()
        view.addSubview(tmpView)
        /// 包装空数据 provider
        let emptyImageView = UIImageView(image: UIImage(named: "home_empty"))
        emptyImageView.contentMode = .center
        let emptyProvider = EmptyStateProvider(emptyStateView: emptyImageView, content: self.provider)
        tmpView.provider = emptyProvider
        return tmpView
    }()
    let collectionDataSource = ArrayDataSource<PhotoWallViewCellViewModel>(data: [])
    lazy var provider: BasicProvider<PhotoWallViewCellViewModel, PhotoWallViewCell> = {
        
        let viewSource = ClosureViewSource<PhotoWallViewCellViewModel, PhotoWallViewCell>(viewUpdater: { (view: PhotoWallViewCell, data: PhotoWallViewCellViewModel, at: Int) in
            view.update(data)
        })
        let sizeSource = { (index: Int, data: PhotoWallViewCellViewModel, collectionSize: CGSize) -> CGSize in
            return CGSize(width: collectionSize.width, height: collectionSize.width * 0.5)
        }
        let provider = BasicProvider<PhotoWallViewCellViewModel, PhotoWallViewCell>(
            dataSource: collectionDataSource,
            viewSource: viewSource,
            sizeSource: sizeSource)
        provider.layout = FlowLayout(spacing: 10).inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        
        provider.animator = FadeAnimator()
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

extension PhotoWallViewController: ControllerConfigurable {
    func configureSubviews() {
        view.backgroundColor = ColorHelper.default.background
        collectionView.snp.makeConstraints({
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(navigation.bar.snp.bottom)
        })
    }
    func configureNavigationBar() {
        navigation.item.title = "照片墙"
    }
    func configureSignal() {
        
        let input = PhotoWallViewModel.Input(viewWillAppear: rx.viewWillAppear)
        let output = viewModel.transform(input: input)
        
        output.state.drive(SFToast.rx.state).disposed(by: rx.disposeBag)
        output.dataSource.bind(to: dataSource).disposed(by: rx.disposeBag)
        
        
    }
    var dataSource: Binder<[PhotoWallViewCellViewModel]> {
        return Binder(self) {this , data in
            this.collectionDataSource.data = data
        }
    }
}
