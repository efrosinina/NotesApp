//
//  TableViewSection.swift
//  NotesApp
//
//  Created by Елизавета Ефросинина on 19/05/2023.
//

import UIKit

protocol TableViewItemsProtocol { }

struct TableViewSection {
    var title: String?
    var items: [TableViewItemsProtocol]
}
