//
//  NoteViewController.swift
//  NotesApp
//
//  Created by Елизавета Ефросинина on 19/05/2023.
//

import UIKit
import SnapKit

final class NoteViewController: UIViewController {
    //MARK: -- GUI Variables
    private let attachmentView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.contentMode = .scaleAspectFill
        
        return view
    }()
    
    private let textView: UITextView = {
        let view = UITextView()
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.cornerRadius = 10
        
        return view
    }()
    
    //MARK: -- Properties
    var viewModel: NoteViewModelProtocol?
    
    //MARK: -- Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.delegate = self
        configure()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    //MARK: -- Private Methods
    private func configure() {
        textView.text = viewModel?.text
        //  guard let imageData = note.image,
        //         let image = UIImage(data: imageData) else { return }
        //   attachmentView.image = image
    }
    
    @objc
    private func saveAction() {
        viewModel?.save(with: textView.text)
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func deleteAction() {
        viewModel?.delete()
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func addImageButton() {
        //Add realization
    }
    
    private func setupUI() {
        view.addSubview(attachmentView)
        view.addSubview(textView)
        view.backgroundColor = .white
        let recognizer = UITapGestureRecognizer(target: self,
                                                action: #selector(hideKeyboard))
        view.addGestureRecognizer(recognizer)
        textView.layer.borderWidth = textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 1 : 0
        
        setupConstraints()
        setImageHeight()
        setupBars()
    }
    
    private func setImageHeight() {
        let height = attachmentView.image != nil ? 200 : 0
        attachmentView.snp.makeConstraints { make in
            make.height.equalTo(height)
        }
    }
    
    private func setupConstraints() {
        attachmentView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
        
        textView.snp.makeConstraints { make in
            make.top.equalTo(attachmentView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(10)
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top).inset(-10)
        }
    }
    
    @objc
    private func hideKeyboard() {
        textView.resignFirstResponder()
    }
    
    private func setupBars() {
        let addImage = UIBarButtonItem(barButtonSystemItem: .camera,
                                       target: self, action: #selector(addImageButton))
        let spacing = UIBarButtonItem(systemItem: .flexibleSpace)
        setToolbarItems([spacing, addImage], animated: true)
    }
}

//MARK: -- UITextViewDelegate
extension NoteViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if !textView.text.isEmpty && !textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save,
                                                                target: self, action: #selector(saveAction))
            let trashButton = UIBarButtonItem(barButtonSystemItem: .trash,
                                              target: self, action: #selector(deleteAction))
            let spacing = UIBarButtonItem(systemItem: .flexibleSpace)
            setToolbarItems([trashButton, spacing], animated: true)
        }
    }
}
