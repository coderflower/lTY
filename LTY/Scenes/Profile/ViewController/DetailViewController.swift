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
        view.backgroundColor = ColorHelper.default.background
        let layout = FlowLayout().inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        tmpView.provider = ComposedProvider(layout: layout, sections: [textProvider, imageProvider])
        return tmpView
    }()
    private let imageDataSource = ArrayDataSource<UIImage>(data: [])
    private lazy var imageProvider = createImageProvider(dataSource: imageDataSource)
    private let textDataSource = ArrayDataSource<HomeViewCellViewModel>(data: [])
    private lazy var textProvider = createTextProvider(dataSource: textDataSource)
   
    
    private let completion: (()-> Void)?
    init(_ viewModel: HomeViewCellViewModel, completion: (()-> Void)? = nil) {
        self.viewModel = viewModel
        self.completion = completion
        super.init(nibName: nil, bundle: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func configureSubviews() {
        view.backgroundColor = ColorHelper.default.theme
        collectionView.snp.makeConstraints({
            $0.top.equalTo(navigation.bar.snp.bottom)
            $0.bottom.left.right.equalToSuperview()
        })
       
        imageDataSource.data = viewModel.images
        textDataSource.data = [viewModel]
    
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
    
    func createTextProvider(dataSource: ArrayDataSource<HomeViewCellViewModel>) -> BasicProvider<HomeViewCellViewModel, UILabel> {
        let viewSource = ClosureViewSource<HomeViewCellViewModel, UILabel>(viewUpdater: { (view: UILabel, data: HomeViewCellViewModel, at: Int) in
            view.textColor = ColorHelper.default.lightText
            view.attributedText = data.attributedText
        })
        let sizeSource = { (index: Int, data: HomeViewCellViewModel, collectionSize: CGSize) -> CGSize in
            return CGSize(width: collectionSize.width, height: data.textHeight)
        }
        let provider = BasicProvider<HomeViewCellViewModel, UILabel>(
            dataSource: dataSource,
            viewSource: viewSource,
            sizeSource: sizeSource)
        provider.layout = FlowLayout(spacing:0).inset(by: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
        return provider
    }
    
    func createImageProvider(dataSource: ArrayDataSource<UIImage>) ->  BasicProvider<UIImage, UIImageView>{
        
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
            sizeSource: sizeSource) {[weak self] tap in
                guard let images = self?.viewModel.images
                    .compactMap({SKPhoto.photoWithImage($0)}) else {return}
                let browser = SKPhotoBrowser(photos: images)
                browser.initializePageIndex(tap.index)
                UIApplication.shared.sf.navigationController?.present(browser, animated: true, completion: {})
        }
        
        provider.layout = FlowLayout(spacing: 5).inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        return provider
    
    }
}

