//
//  MessageSectionHeaderFooterCollectionReusableView.swift
//  SmsTask
//
//  Created by Valerii Petrychenko on 10/29/19.
//  Copyright © 2019 Valerii Petrychenko. All rights reserved.
//

import UIKit

class MessageSectionHeaderFooterCollectionReusableView: UICollectionReusableView {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor(red: 58/255.0, green: 82/255.0, blue: 114/255.0, alpha: 1)
        label.backgroundColor = .clear
        return label
    }()


    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {
        setUpUI()
    }

    private func setUpUI() {
        titleLabel.frame = CGRect(x: 10, y: 0, width: self.frame.width - 20, height: self.frame.height)
        addSubview(titleLabel)
    }

    func configure(title: String, textAlignment: NSTextAlignment) {
        titleLabel.text = title
        titleLabel.textAlignment = textAlignment
    }
}
