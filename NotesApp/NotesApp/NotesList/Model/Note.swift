//
//  Note.swift
//  NotesApp
//
//  Created by Елизавета Ефросинина on 19/05/2023.
//

import Foundation

struct Note: TableViewItemsProtocol {
    let title: String
    let description: String?
    let date: Date
    let imageURL: URL?
    let image: Data? = nil
}
