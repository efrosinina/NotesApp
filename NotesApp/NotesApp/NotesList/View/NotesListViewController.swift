//
//  NotesListViewController.swift
//  NotesApp
//
//  Created by Елизавета Ефросинина on 17/05/2023.
//

import UIKit

class NotesListViewController: UITableViewController {
    //MARK: -- Properties
    var viewModel: NotesListViewModelProtocol?
    
    //MARK: -- Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Notes"
        
        setupTableView()
        setupToolBar()
        registerObserver()
        
        viewModel?.reloadTable = { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    //MARK: -- Private Methods
    private func setupTableView() {
        tableView.register(SimpleNoteTableViewCell.self, forCellReuseIdentifier: "SimpleNoteTableViewCell")
        tableView.register(ImageNoteTableViewCell.self, forCellReuseIdentifier: "ImageNoteTableViewCell")
        tableView.separatorStyle = .none
    }
    
    private func setupToolBar() {
        let addNoteButton = UIBarButtonItem(title: "Add note", style: .done, target: self, action: #selector(addAction))
        let spacing = UIBarButtonItem(systemItem: .flexibleSpace)
        setToolbarItems([spacing, addNoteButton], animated: true)
        navigationController?.isToolbarHidden = false
    }
    
    @objc
    private func addAction() {
        let noteVC = NoteViewController()
        let viewModel = NoteViewModel(note: nil)
        noteVC.viewModel = viewModel
        navigationController?.pushViewController(noteVC, animated: true)
    }
    
    private func registerObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateData),
                                               name: NSNotification.Name("Update"),
                                               object: nil)
    }
    
    @objc
    private func updateData() {
        viewModel?.getNotes()
    }
}
//MARK: -- UITableViewDataSource
extension NotesListViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.section.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        viewModel?.section[section].title
    }
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return viewModel?.section[section].items.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let note = viewModel?.section[indexPath.section].items[indexPath.row] as? Note
        else { return UITableViewCell() }
        
        if indexPath.row == 0,
           let cell = tableView.dequeueReusableCell(withIdentifier: "SimpleNoteTableViewCell", for: indexPath) as? SimpleNoteTableViewCell {
            cell.set(note: note)
            return cell
        } else if let cell = tableView.dequeueReusableCell(withIdentifier: "ImageNoteTableViewCell", for: indexPath) as? ImageNoteTableViewCell {
            cell.set(note: note)
            return cell
        }
        
        return UITableViewCell()
    }
}

//MARK: -- UITableViewDelegate
extension NotesListViewController {
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        guard let note = viewModel?.section[indexPath.section].items[indexPath.row] as? Note else { return }
        let noteVC = NoteViewController()
        let viewModel = NoteViewModel(note: note)
        noteVC.viewModel = viewModel
        navigationController?.pushViewController(noteVC, animated: true)
    }
}
