//
//  NiblessView.swift
//  LTY
//
//  Created by 花菜 on 2019/3/8.
//  Copyright © 2019 Coder.flower. All rights reserved.
//

import UIKit

public class NiblessView: UIView {

    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    public override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
    func initialize()  {
        
    }
    @available(*, unavailable, message: "loading this view from nib is unsupported")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
