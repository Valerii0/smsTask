//
//  MessageCollectionViewCell.swift
//  SmsTask
//
//  Created by Valerii Petrychenko on 10/20/19.
//  Copyright © 2019 Valerii Petrychenko. All rights reserved.
//

import UIKit

class MessageCollectionViewCell: UICollectionViewCell {
    let textBubbleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()

    let bubbleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "bubble_blue")!.resizableImage(withCapInsets: UIEdgeInsets(top: 22, left: 26, bottom: 22, right: 26)).withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor(red: 0, green: 137/255.0, blue: 249/255.0, alpha: 1)
        return imageView
    }()

    let messageTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.textColor = .white
        textView.backgroundColor = .clear
        textView.isEditable = false
        return textView
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
        addSubview(textBubbleView)
        addSubview(messageTextView)

        textBubbleView.addSubview(bubbleImageView)

        NSLayoutConstraint.activate([
            bubbleImageView.leftAnchor.constraint(equalTo: textBubbleView.leftAnchor),
            bubbleImageView.topAnchor.constraint(equalTo: textBubbleView.topAnchor),
            bubbleImageView.rightAnchor.constraint(equalTo: textBubbleView.rightAnchor),
            bubbleImageView.bottomAnchor.constraint(equalTo: textBubbleView.bottomAnchor)
            ])
    }

    func configure(message: String) {
        messageTextView.text = message

        let size = CGSize(width: 250, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let estimatedFrame = NSString(string: message).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18)], context: nil)

        messageTextView.frame = CGRect(x: self.frame.width - estimatedFrame.width - 16 - 8 - 8, y: 0, width: estimatedFrame.width + 16, height: estimatedFrame.height + 20)

        textBubbleView.frame = CGRect(x: self.frame.width - estimatedFrame.width - 16 - 8 - 8 - 8, y: 0, width: estimatedFrame.width + 16 + 8 + 16, height: estimatedFrame.height + 20)

        bubbleImageView.frame = CGRect(x: 0, y: 0, width: textBubbleView.frame.width, height: textBubbleView.frame.height)
    }
}
