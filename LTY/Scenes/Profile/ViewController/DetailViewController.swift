//
//  DetailViewController.swift
//  LTY
//
//  Created by 花菜 on 2019/3/13.
//  Copyright © 2019 Coder.flower. All rights reserved.
//

import UIKit
import CollectionKit
import RxCocoa
import SKPhotoBrowser
final class DetailViewController: NiblessViewController {
    private let viewModel: HomeViewCellViewModel
    private lazy var collectionView: CollectionView = {
        let tmpView = CollectionView()
        view.addSubview(tmpView)
        tmpView.provider = provider
        return tmpView
    }()
    private lazy var contentLabel: UILabel = {
        let label = UILabel(font: FontHelper.regular(15), color: ColorHelper.default.lightText)
        label.numberOfLines = 0
        view.addSubview(label)
        return label
    }()
    private let dataSource = ArrayDataSource<UIImage>(data: [])
    private lazy var provider: BasicProvider<UIImage, UIImageView> = {
        let viewSource = ClosureViewSource<UIImage, UIImageView>(viewGenerator: { (image, at) -> UIImageView in
            let imageView = UIImageView()
            imageView.clipsToBounds = true
            return imageView
        }, viewUpdater: { (view: UIImageView, data: UIImage, at: Int) in
            view.image = data
        })
        let sizeSource = { (index: Int, data: UIImage, collectionSize: CGSize) -> CGSize in
            return CGSize(width: collectionSize.width, height: collectionSize.width * data.size.height / data.size.width)
        }
        let provider = BasicProvider<UIImage, UIImageView>(
            dataSource: dataSource,
            viewSource: viewSource,
            sizeSource: sizeSource)
        provider.layout = FlowLayout(spacing: 5).inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        return provider
    }()
    private let completion: (()-> Void)?
    init(_ viewModel: HomeViewCellViewModel, completion: (()-> Void)? = nil) {
        self.viewModel = viewModel
        self.completion = completion
        super.init(nibName: nil, bundle: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        provider.tapHandler = { [weak self] tap in
            guard let images = self?.viewModel.images
                .compactMap({SKPhoto.photoWithImage($0)}) else {return}
            let browser = SKPhotoBrowser(photos: images)
            browser.initializePageIndex(tap.index)
            UIApplication.shared.sf.navigationController?.present(browser, animated: true, completion: {})
        }
    }
    override func configureSubviews() {
        view.backgroundColor = ColorHelper.default.background
        contentLabel.snp.makeConstraints({
            $0.top.equalTo(navigation.bar.snp.bottom).offset(20)
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
        })
        
        collectionView.snp.makeConstraints({
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(contentLabel.snp.bottom)
        })
        contentLabel.attributedText = viewModel.attributedText
        dataSource.data = viewModel.images
    
    }
    override func configureNavigationBar() {
        navigation.item.title = viewModel.title
        navigation.item.rightBarButtonItem = UIBarButtonItem(title: "删除")
    }
    override func configureSignal() {
        let input = HomeViewCellViewModel.Input(deleteTap: navigation.item.rightBarButtonItem!.rx.tap.asObservable())
        let output = viewModel.transform(input: input)
        output.result.drive(deleteSuccess).disposed(by: rx.disposeBag)
        output.deleteState.drive(SFToast.rx.state).disposed(by: rx.disposeBag)
    }
    
}

extension DetailViewController {
    var deleteSuccess: Binder<Bool> {
        return Binder(self) {this, _ in
            /// 发出删除通知,
            NotificationCenter.default.post(name: NotifyName.deleteCompleteNotification, object: nil)
            /// 回调上个页面
            this.completion?()
            this.sf.goBack()
        }
    }
}

