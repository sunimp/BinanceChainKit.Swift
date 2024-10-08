//
//  WordsController.swift
//  BinanceChainKit-Example
//
//  Created by Sun on 2024/8/21.
//

import UIKit

import SnapKit
import HDWalletKit
import UIExtensions

class WordsController: UIViewController {
    private let textView = UITextView()

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "BinanceChainKit Demo"

        let wordsDescriptionLabel = UILabel()

        view.addSubview(wordsDescriptionLabel)
        wordsDescriptionLabel.snp.makeConstraints { maker in
            maker.leading.trailing.equalToSuperview().inset(16)
            maker.top.equalToSuperview().offset(100)
        }

        wordsDescriptionLabel.text = "Enter your words separated by space:"
        wordsDescriptionLabel.font = .systemFont(ofSize: 14)

        view.addSubview(textView)
        textView.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.leading.trailing.equalToSuperview().inset(16)
            maker.top.equalTo(wordsDescriptionLabel.snp.bottom).offset(16)
            maker.height.equalTo(85)
        }

        textView.font = UIFont.systemFont(ofSize: 13)
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        textView.layer.cornerRadius = 8
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.black.withAlphaComponent(0.1).cgColor

        textView.text = Configuration.shared.defaultWords

        let generateButton = UIButton()

        view.addSubview(generateButton)
        generateButton.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.top.equalTo(textView.snp.bottom).offset(12)
        }

        generateButton.titleLabel?.font = .systemFont(ofSize: 13)
        generateButton.setTitleColor(.systemBlue, for: .normal)
        generateButton.setTitle("Generate New Words", for: .normal)
        generateButton.addTarget(self, action: #selector(generateNewWords), for: .touchUpInside)

        let loginButton = UIButton()

        view.addSubview(loginButton)
        loginButton.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.top.equalTo(generateButton.snp.bottom).offset(12)
        }

        loginButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .medium)
        loginButton.setTitleColor(.systemBlue, for: .normal)
        loginButton.setTitle("Login", for: .normal)
        loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)

        view.endEditing(true)
    }

    @objc func generateNewWords() {
        if let generatedWords = try? Mnemonic.generate() {
            textView.text = generatedWords.joined(separator: " ")
        }
    }

    @objc func login() {
        let words = textView.text.components(separatedBy: .whitespacesAndNewlines).filter { !$0.isEmpty }

        do {
            try Mnemonic.validate(words: words)

            try Manager.shared.login(words: words)

            if let window = UIWindow.keyWindow {
                UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
                    window.rootViewController = MainController()
                })
            }
        } catch {
            let alert = UIAlertController(title: "Login Error", message: "\(error)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            present(alert, animated: true)
        }
    }

}
