//
//  SendMessageView.swift
//  SmsTask
//
//  Created by Valerii Petrychenko on 10/20/19.
//  Copyright © 2019 Valerii Petrychenko. All rights reserved.
//

import UIKit

protocol SendMessageViewDelegate: class {
    func sendMessage(message: Message)
}

class SendMessageView: UIView {
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var characterCountLabel: UILabel!
    @IBOutlet weak var sendButton: UIButton!

    weak var delegate: SendMessageViewDelegate?

    let sendIcon = UIImage(named: "send")

    var kMinLenghtOfMessage = 0
    let kMaxLenghtOfMessage = 12  //Changable const for max characters lenght

    override init(frame: CGRect) {
        super.init(frame: frame)
        fromNib()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fromNib()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupUI()
    }

    private func setupUI() {
        setupMessageTextField()
        setupCharacterCountLabel()
        setupSendButton()
    }

    private func setupMessageTextField() {
        messageTextField.layer.cornerRadius = 10
        messageTextField.backgroundColor = .white
        messageTextField.placeholder = "Enter message..."
        messageTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        kMinLenghtOfMessage = textField.text?.count ?? 0
        characterCountLabel.text = "\(kMinLenghtOfMessage)/\(kMaxLenghtOfMessage)"
    }

    private func setupCharacterCountLabel() {
        characterCountLabel.textAlignment = .center
        characterCountLabel.textColor = .gray
        characterCountLabel.text = "\(kMinLenghtOfMessage)/\(kMaxLenghtOfMessage)"
    }

    private func setupSendButton() {
        sendButton.setTitle("", for: .normal)
        sendButton.setBackgroundImage(sendIcon, for: .normal)
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
    }

    @objc func handleSend() {
        if let fullMessage = messageTextField.text, fullMessage.count > 0 {
            let message = solution(sFullMessage: fullMessage, kMaxLenghtOfMessage: kMaxLenghtOfMessage)
            delegate?.sendMessage(message: message)
            clearInput()
        }
    }

    private func clearInput() {
        kMinLenghtOfMessage = 0
        messageTextField.text = nil
        characterCountLabel.text = "\(kMinLenghtOfMessage)/\(kMaxLenghtOfMessage)"
    }

    private func solution(sFullMessage: String, kMaxLenghtOfMessage: Int) -> Message {

        ///check input condition
        if (1...500).contains(kMaxLenghtOfMessage), (1...500) ~= sFullMessage.count {

            ///init array of messages to send
            var arrayOfSendingMessages: [String] = []

            ///get separate words from full message and create array
            let arrayOfWords = sFullMessage.split(separator: " ")

            ///check if at least one word longer than acceptable single message length
            for word in arrayOfWords {
                if word.count > kMaxLenghtOfMessage {
                    return Message(createdOn: currentDate(), subMessages: ["-1"])
                }
            }

            ///init single message to send
            var singleMessage = ""

            ///kind of separation for words in single message
            let wordDivider = " "

            ///form an array of sub messages
            arrayOfWords.forEach { (word) in
                if singleMessage.count == 0 {
                    singleMessage.append(contentsOf: word)
                } else {
                    if singleMessage.count + wordDivider.count + word.count <= kMaxLenghtOfMessage {
                        singleMessage.append(contentsOf: wordDivider)
                        singleMessage.append(contentsOf: word)
                    } else {
                        arrayOfSendingMessages.append(singleMessage)
                        singleMessage.removeAll()
                        singleMessage.append(contentsOf: word)
                    }
                }
            }

            ///at the end, check if there are any messages not added into main array
            if singleMessage.count > 0 {
                arrayOfSendingMessages.append(singleMessage)
            }

            ///final answer
            return Message(createdOn: currentDate(), subMessages: arrayOfSendingMessages)

        } else {
            return Message(createdOn: currentDate(), subMessages: ["-1"])
        }
    }

    func currentDate() -> String {
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .short
        return formatter.string(from: currentDateTime)
    }
}
