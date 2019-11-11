//
//  ViewController.swift
//  SmsTask
//
//  Created by Valerii Petrychenko on 10/19/19.
//  Copyright © 2019 Valerii Petrychenko. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var chatCollectionView: UICollectionView!
    @IBOutlet weak var sendMessageView: SendMessageView!

    let messageCollectionViewCell = "MessageCollectionViewCell"
    let messageSectionHeaderFooterCollectionReusableView = "MessageSectionHeaderFooterCollectionReusableView"
    let heightForHeaderFooter: CGFloat = 30.0

    var messages = [Message]()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        configure()
        hideKeyboardWhenTappedAround()
        setupChatCollectionView()
        handleKeyboard()
    }

    private func setupUI() {
        self.navigationItem.title = "someone"
    }

    private func configure() {
        sendMessageView.delegate = self
    }

    ///hide keyboard on tap
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    private func setupChatCollectionView() {
        chatCollectionView.delegate = self
        chatCollectionView.dataSource = self

        chatCollectionView.register(MessageCollectionViewCell.self, forCellWithReuseIdentifier: messageCollectionViewCell)
        chatCollectionView.register(MessageSectionHeaderFooterCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: messageSectionHeaderFooterCollectionReusableView)
        chatCollectionView.register(MessageSectionHeaderFooterCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: messageSectionHeaderFooterCollectionReusableView)
    }

    private func handleKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func handleKeyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
            let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification
            var kOffset = keyboardFrame!.height
            if #available(iOS 11.0, *) {
                kOffset -= view.safeAreaInsets.bottom
            }
            if isKeyboardShowing {
                sendMessageView.transform = CGAffineTransform(translationX: 0, y: -kOffset)
            } else {
                sendMessageView.transform = CGAffineTransform(translationX: 0, y: 0)
            }
            UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }) { (completed) in
                if !isKeyboardShowing {
                    UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
                        self.chatCollectionView.contentInset = .zero
                        self.chatCollectionView.scrollIndicatorInsets = .zero
                    })
                } else {
                    let insets = UIEdgeInsets(top: 0, left: 0, bottom: kOffset + self.heightForHeaderFooter, right: 0)
                    self.chatCollectionView.contentInset = insets
                    self.chatCollectionView.scrollIndicatorInsets = insets
                    self.scrollToBottom()
                }
            }
        }
    }

    private func scrollToBottom() {
        if self.messages.count > 0 {
            let lastSection = self.messages.count - 1
            let lastRow = self.messages[lastSection].subMessages.count - 1
            let indexPath = IndexPath(row: lastRow, section: lastSection)
            self.chatCollectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
        }
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return messages.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages[section].subMessages.count
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let section = indexPath.section
        let sectionView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: messageSectionHeaderFooterCollectionReusableView, for: indexPath) as! MessageSectionHeaderFooterCollectionReusableView
        if (kind == UICollectionView.elementKindSectionHeader) {
            sectionView.configure(title: messages[section].createdOn, textAlignment: .center)
        } else {
            sectionView.configure(title: messages[section].delivered, textAlignment: .right)
        }
        return sectionView
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = indexPath.section
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: messageCollectionViewCell, for: indexPath) as! MessageCollectionViewCell
        cell.configure(message: messages[section].subMessages[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: heightForHeaderFooter)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: heightForHeaderFooter)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let section = indexPath.section
        let messageText = messages[section].subMessages[indexPath.row]
        let size = CGSize(width: 250, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let estimatedFrame = NSString(string: messageText).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18)], context: nil)

        return CGSize(width: collectionView.frame.width, height: estimatedFrame.height + 20)
    }
}

extension ViewController: SendMessageViewDelegate {
    func sendMessage(message: Message) {
        messages.append(message)
        chatCollectionView.reloadData()
        scrollToBottom()
    }
}
