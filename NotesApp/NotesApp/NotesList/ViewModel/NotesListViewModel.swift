//
//  NotesListViewModel.swift
//  NotesApp
//
//  Created by Елизавета Ефросинина on 19/05/2023.
//

import UIKit

protocol NotesListViewModelProtocol {
    var section: [TableViewSection] { get }
}

final class NotesListViewModel: NotesListViewModelProtocol {
    private(set) var section: [TableViewSection] = [] // Нельзя изменить за пределами этого класса
    
    init() {
        getNotes()
        setMocks()
    }
    
    private func getNotes() {
        
    }
    
    private func setMocks() {
        let section = TableViewSection(title: "23.04.2023" ,items: [
                                        Note(title: "First", description: "First Note", date: Date(),
                                              imageURL: nil, image: nil),
                                         Note(title: "First", description: "First Note", date: Date(),
                                               imageURL: nil, image: nil)
                                        ])
        self.section.append(section)
    }
}
