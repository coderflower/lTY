//
//  WebViewController.swift
//  记吧
//
//  Created by 花菜 on 2018/7/15.
//  Copyright © 2018年 Coder.flower. All rights reserved.
//

import UIKit

class WebViewController: NiblessViewController {
    lazy var webView: UIWebView = {
        let tmpView = UIWebView()
        tmpView.delegate = self
        sf.disablesAdjustScrollViewInsets(tmpView.scrollView)
        view.addSubview(tmpView)
        return tmpView
    }()

    private let url: String
    init(url: String) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let url = self.url.asurl() {
            let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 5.0)
            //        webView.load(request)
            webView.loadRequest(request)
        } else {
            SFToast.show(info: "url访问错误")
        }
    }

    func loadLocal(html: String) {
        webView.loadHTMLString(html, baseURL: nil)
    }

    override func configureSubviews() {
        webView.snp.makeConstraints({
            $0.top.equalTo(navigation.bar.snp.bottom)
            $0.left.right.bottom.equalToSuperview()
        })
    }
}

extension WebViewController: UIWebViewDelegate {
    func webViewDidStartLoad(_: UIWebView) {
        myLog("开始加载")
        SFToast.loading()
    }

    func webViewDidFinishLoad(_ webView: UIWebView) {
        myLog("加载完成")
        SFToast.hideActivity()
        let title = webView.stringByEvaluatingJavaScript(from: "document.title")
        navigation.item.title = title
    }

    func webView(_: UIWebView, didFailLoadWithError error: Error) {
        SFToast.hideActivity()
        SFToast.show(info: "网络加载失败")
        myLog("加载失败\(error.localizedDescription)")
    }
}
