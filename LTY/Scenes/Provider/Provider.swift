//
//  Provider.swift
//  LTY
//
//  Created by 花菜 on 2019/3/11.
//  Copyright © 2019 Coder.flower. All rights reserved.
//

import UIKit
import CollectionKit
struct Provider {
    static let shared = Provider()

    func homeProvider(dataSource: ArrayDataSource<HomeViewCellViewModel>) -> BasicProvider<HomeViewCellViewModel, HomeItemViewCell> {
        let viewSource = ClosureViewSource<HomeViewCellViewModel, HomeItemViewCell>(viewGenerator: { (_, _) -> HomeItemViewCell in
            let view = HomeItemViewCell.xibView()
            view.cornerRadius = 5
            return view
        }, viewUpdater: { (view: HomeItemViewCell, data: HomeViewCellViewModel, at: Int) in
            view.update(data)
        })
        let sizeSource = { (index: Int, data: HomeViewCellViewModel, collectionSize: CGSize) -> CGSize in
            return CGSize(width: collectionSize.width, height: data.cellHeight)
        }
        let provider = BasicProvider<HomeViewCellViewModel, HomeItemViewCell>(
            dataSource: dataSource,
            viewSource: viewSource,
            sizeSource: sizeSource)
        provider.layout = FlowLayout(spacing: 10).inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        return provider
    }
    
    
    func profileProvider(dataSource: ArrayDataSource<ProfileModel>) -> BasicProvider<ProfileModel, ProfileViewCell> {
        
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
            return provider
    }
    
    func photoWallProvider(dataSource: ArrayDataSource<PhotoWallViewCellViewModel>) -> BasicProvider<PhotoWallViewCellViewModel, PhotoWallViewCell> {
        let viewSource = ClosureViewSource<PhotoWallViewCellViewModel, PhotoWallViewCell>(viewUpdater: { (view: PhotoWallViewCell, data: PhotoWallViewCellViewModel, at: Int) in
            view.update(data)
        })
        let sizeSource = { (index: Int, data: PhotoWallViewCellViewModel, collectionSize: CGSize) -> CGSize in
            return CGSize(width: collectionSize.width, height: collectionSize.width * 0.5)
        }
        let provider = BasicProvider<PhotoWallViewCellViewModel, PhotoWallViewCell>(
            dataSource: dataSource,
            viewSource: viewSource,
            sizeSource: sizeSource)
        provider.layout = FlowLayout(spacing: 10).inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        return provider
    }
    
    
}
