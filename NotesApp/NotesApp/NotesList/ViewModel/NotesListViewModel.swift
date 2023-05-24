//
//  NotesListViewModel.swift
//  NotesApp
//
//  Created by Елизавета Ефросинина on 19/05/2023.
//

import UIKit
//MARK: -- Protocol
protocol NotesListViewModelProtocol {
    var section: [TableViewSection] { get }
    var reloadTable: (() -> Void)? { get set}
    
    func getNotes()
}

final class NotesListViewModel: NotesListViewModelProtocol {
    //MARK: -- Properties
    var reloadTable: (() -> Void)?
    
    private(set) var section: [TableViewSection] = [] {
        didSet {
            reloadTable?()
        }
    }
    
    //MARK: -- Initialization
    init() {
        getNotes()
    }
    
    //MARK: -- Methods
    func getNotes() {
        let notes = NotePersistant.fetchAll()
        section = []
        
        let groupedObjects = notes.reduce(into: [Date: [Note]]()) { result, note in
            let date = Calendar.current.startOfDay(for: note.date)
            result[date, default: []].append(note)
        }
        
        let keys = groupedObjects.keys
        keys.forEach { key in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "d  MMM yyyy"
            let stringDate = dateFormatter.string(from: key)
            section.append(TableViewSection(title: stringDate, items: groupedObjects[key] ?? []))
        }
    }
    //MARK: -- Private Methods
    private func setMocks() {
        let section = TableViewSection(title: "23.04.2023" ,items: [
            Note(title: "First", description: "First Note", date: Date(),
                 imageURL: nil),
            Note(title: "First", description: "First Note", date: Date(),
                 imageURL: nil)
        ])
        self.section.append(section)
    }
}
