//
//  PublishViewController.swift
//  LTY
//
//  Created by 花菜 on 2019/3/6.
//  Copyright © 2019 Coder.flower. All rights reserved.
//

import CollectionKit
import IQKeyboardManagerSwift
import RxCocoa
import RxSwift
import TZImagePickerController
import UIKit
class PublishViewController: NiblessViewController {
    private let viewModel = PublishViewModel()
    /// 用户输入标题
    private lazy var titleField: UITextField = {
        let tf = UITextField()
        view.addSubview(tf)
        tf.placeholder = "在这里输入标题"
        tf.textColor = ColorHelper.default.blackText
        tf.attributedPlaceholder = NSAttributedString(string: "在这里输入标题", attributes: [.foregroundColor: UIColor.gray.withAlphaComponent(0.5)])
        tf.font = FontHelper.regular(14)
        tf.maxLength = 15
        view.addSubview(tf)
        tf.backgroundColor = UIColor.white
        tf.borderStyle = .none
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        tf.leftViewMode = .always
        return tf
    }()

    /// 输入内容
    private lazy var contentTextView: IQTextView = {
        let textView = IQTextView()
        textView.placeholder = "在这里编辑内容,最多1000字"
        textView.placeholderTextColor = UIColor.gray.withAlphaComponent(0.5)
        textView.maxLength = 1000
        textView.textColor = ColorHelper.default.blackText
        textView.font = FontHelper.regular(14)
        view.addSubview(textView)
        return textView
    }()

    private lazy var collectionView: CollectionView = {
        let tmpView = CollectionView()
        view.addSubview(tmpView)
        tmpView.keyboardDismissMode = UIScrollView.KeyboardDismissMode.onDrag
        tmpView.provider = provider
        return tmpView
    }()

    /// 此处如果不用NSMutableArray,用swift 的 array 会闪退
    private(set) var photos: NSMutableArray = NSMutableArray()
    private(set) var assets: NSMutableArray = NSMutableArray()
    private lazy var imageHeight = (UIScreen.width - 30) / 3
    private let imagesSubject = BehaviorRelay<[Data]?>(value: nil)
    /// 添加图片
    private lazy var provider: BasicProvider<PhotoModel, AddPhotoViewCell> = {
        let dataSource = ArrayDataSource<PhotoModel>(data: [PhotoModel()])
        let viewSource = ClosureViewSource<PhotoModel, AddPhotoViewCell>(viewUpdater: { (view: AddPhotoViewCell, data: PhotoModel, at: Int) in
            view.index = at
            view.update(data)
            view.completion = { index in
                self.photos.removeObject(at: index)
                self.assets.removeObject(at: index)
                self.updateCollectionView(photos: self.photos, assets: self.assets, originCount: self.photos.count)
            }
        })
        let sizeSource = { (_: Int, _: PhotoModel, _: CGSize) -> CGSize in
            CGSize(width: self.imageHeight, height: self.imageHeight)
        }
        let provider = BasicProvider<PhotoModel, AddPhotoViewCell>(
            dataSource: dataSource,
            viewSource: viewSource,
            sizeSource: sizeSource
        )
        provider.layout = FlowLayout(spacing: 5)
        return provider
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        titleField.becomeFirstResponder()
        // Do any additional setup after loading the view.
        /// 图片点击事件
        provider.tapHandler = { [weak self] tap in
            self?.view.endEditing(true)
            guard let self = self else {
                return
            }
            // 如果只有一个. 跳转添加图片
            let imagePicker: TZImagePickerController
            if self.photos.count == 0 || tap.index == self.photos.count {
                imagePicker = TZImagePickerController(maxImagesCount: 9, delegate: self)!
                if self.assets.count > 0 {
                    imagePicker.selectedAssets = self.assets
                }
            } else {
                imagePicker = TZImagePickerController(selectedAssets: self.assets, selectedPhotos: self.photos, index: tap.index)
            }
            imagePicker.showPhotoCannotSelectLayer = true
            imagePicker.sortAscendingByModificationDate = false
            imagePicker.showSelectedIndex = true
            self.navigationController?.present(imagePicker, animated: true, completion: nil)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }

    override func configureSubviews() {
        view.backgroundColor = ColorHelper.default.background
        titleField.snp.makeConstraints({
            $0.top.equalTo(navigation.bar.snp.bottom).offset(10)
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.height.equalTo(40)
        })
        contentTextView.snp.makeConstraints({
            $0.top.equalTo(titleField.snp.bottom).offset(10)
            $0.left.right.equalTo(titleField)
            $0.height.equalTo(120)
        })
        collectionView.snp.makeConstraints({
            $0.left.right.equalTo(titleField)
            $0.top.equalTo(contentTextView.snp.bottom).offset(10)
            $0.bottom.equalToSuperview()
        })
    }

    override func configureNavigationBar() {
        //        navigation.item.title = "编辑记录"
        navigation.item.title = "添加日记"
        navigation.item.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "dismiss"))
        navigation.item.rightBarButtonItem = UIBarButtonItem(title: "发布")
    }

    override func configureSignal() {
        guard let leftBarButtonItem = navigation.item.leftBarButtonItem,
            let rightBarButtonItem = navigation.item.rightBarButtonItem else {
            return
        }
        leftBarButtonItem.rx.tap
            .bind(to: rx.goBack)
            .disposed(by: rx.disposeBag)

        let input = PublishViewModel
            .Input(title: titleField.rx.text.orEmpty.asObservable(),
                   content: contentTextView.rx.text.asObservable(),
                   images: imagesSubject.asObservable(),
                   publishTap: rightBarButtonItem.rx.tap.asObservable())

        let output = viewModel.transform(input: input)

        output.isPublishEnabled
            .bind(to: rightBarButtonItem.rx.isEnabled)
            .disposed(by: rx.disposeBag)

        output.uploadState
            .drive(SFToast.rx.state)
            .disposed(by: rx.disposeBag)
        output.result.map({ (_) -> Void in
            NotificationCenter.default
                .post(name: NotifyName.userUploadCompleteNotification, object: nil)
        }).drive(rx.goBack).disposed(by: rx.disposeBag)
    }
}

// MARK: - TZImagePickerControllerDelegate

extension PublishViewController: TZImagePickerControllerDelegate {
    func imagePickerController(_: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!, isSelectOriginalPhoto _: Bool) {
        let originCount = self.photos.count
        self.photos.removeAllObjects()
        self.assets.removeAllObjects()
        self.photos.addObjects(from: photos)
        self.assets.addObjects(from: assets)
        updateCollectionView(photos: self.photos, assets: self.assets, originCount: originCount)
    }

    private func updateCollectionView(photos: NSMutableArray, assets _: NSMutableArray, originCount _: Int) {
        if let photos = photos as? [UIImage] {
            /// 完成添加图片 , compactMap 过滤 nil
            imagesSubject.accept(photos.compactMap { $0.pngData() })
        }

        var models = photos.map({ PhotoModel(image: $0 as? UIImage) })
        if models.count < 9 {
            models.append(PhotoModel())
        }
        provider.dataSource = ArrayDataSource(data: models)
    }
}
