//
//  extensionUIView.swift
//  SmsTask
//
//  Created by Valerii Petrychenko on 10/20/19.
//  Copyright © 2019 Valerii Petrychenko. All rights reserved.
//

import UIKit

extension UIView {
    @discardableResult
    func fromNib<T : UIView>() -> T? {
        guard let contentView = Bundle(for: type(of: self)).loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?.first as? T else {
            return nil
        }
        self.backgroundColor = .clear
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return contentView
    }
}
