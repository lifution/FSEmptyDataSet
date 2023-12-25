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
//            make.centerX.equalToSuperview()
//            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
//            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
        do {
//            emptyView.content = FSEmptyContent(type: .loading(title: "加载中...", tintColor: .darkGray))
            emptyView.content = FSEmptyContent(type: .noContent(title: "暂无数据"))
            do {
//                let content = FSEmptyContent(type: .reload(title: "重新加载", tintColor: .red))
//                emptyView.content = content
//                content.onDidPressButton = { _ in
//                    print("did press reload button")
//                }
            }
        }
    }
}

