//
//  ViewController.swift
//  FSEmptyDataSet
//
//  Created by Sheng on 12/25/2023.
//  Copyright (c) 2023 Sheng. All rights reserved.
//

import UIKit
import SnapKit
import FSEmptyDataSet

class ViewController: UIViewController {
    
    private let emptyView = FSEmptyView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(emptyView)
        emptyView.snp.makeConstraints { make in
            make.width.lessThanOrEqualToSuperview().offset(-30.0)
            make.center.equalToSuperview()
        }
        startLoading()
    }
    
    private func startLoading() {
        emptyView.content = FSEmptyContent(type: .loading(title: "Loading...", tintColor: .darkGray))
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            let content = FSEmptyContent(type: .reload(title: "Reload", tintColor: .red))
            self.emptyView.content = content
            content.onDidPressButton = { [unowned self] _ in
                self.startLoading()
            }
        }
    }
}

