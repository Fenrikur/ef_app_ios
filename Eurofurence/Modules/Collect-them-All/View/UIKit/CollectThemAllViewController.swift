//
//  CollectThemAllViewController.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 24/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import UIKit
import WebKit

class CollectThemAllViewController: UIViewController, CollectThemAllScene {

    // MARK: Properties

    private var webView: WKWebView?

    // MARK: Overrides

    override func viewDidLoad() {
        super.viewDidLoad()

        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.preferences.javaScriptEnabled = true
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView?.allowsLinkPreview = false
        view = webView
    }

    // MARK: CollectThemAllScene

    func setShortCollectThemAllTitle(_ shortTitle: String) {
        tabBarItem.title = shortTitle
    }

    func setCollectThemAllTitle(_ title: String) {
        navigationItem.title = title
    }

}