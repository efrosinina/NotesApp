//
//  NoteViewModel.swift
//  NotesApp
//
//  Created by Елизавета Ефросинина on 21/05/2023.
//

import UIKit
//MARK: -- Protocol
protocol NoteViewModelProtocol  {
    var text: String { get }
    var image: UIImage? { get }
    
    func save(with text: String, and image: UIImage?, imageName: String?)
    func delete()
}

final class NoteViewModel: NoteViewModelProtocol {
    //MARK: -- Properties
    let note: Note?
    var text: String {
        let text = (note?.title ?? "") + "\n\n" + (note?.description ?? "")
        return text
    }
    
    var image: UIImage? {
        guard let  url = note?.imageURL else { return nil }
        return FileManagerPersistant.read(from: url)
    }
    
    //MARK: -- Initialization
    init(note: Note?) {
        self.note = note
    }
    
    //MARK: -- Methods
    func save(with text: String, and image: UIImage?, imageName: String?) {
        var url: URL? = note?.imageURL
        if let image = image,
           let name = imageName {
            url = FileManagerPersistant.save(image, with: name)
        }
        
        let date = note?.date ?? Date()
        let (title, description) = createTitleAndDescription(from: text.trimmingCharacters(in: .whitespacesAndNewlines))
        let note = Note(title: title,
                        description: description,
                        date: date,
                        imageURL: url)
        NotePersistant.save(note)
    }
    
    func delete() {
        guard let note = note else { return }
        if let url = note.imageURL {
            FileManagerPersistant.delete(from: url)
        }
        NotePersistant.delete(note)
    }
    
    //MARK: -- Private Methods
    private func createTitleAndDescription(from text: String) -> (String, String?) {
            var description = text
            
        guard let index = description.firstIndex(where: { $0 == "." ||
            $0 == "!" ||
            $0 == "?" ||
            $0 == "\n"})
            else {
            return (text, nil)
            }
            
        let title = String(description[...index])
            description.removeSubrange(...index)
            return (title, description)
    }
}
