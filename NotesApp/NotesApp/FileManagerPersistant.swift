//
//  FileManagerPersistant.swift
//  NotesApp
//
//  Created by Елизавета Ефросинина on 25/05/2023.
//

import UIKit

final class FileManagerPersistant {
    //MARK: -- Methods
    static func save(_ image: UIImage, with name: String) -> URL? {
        let data = image.jpegData(compressionQuality: 1)
        let url = getDocumentDirectory().appending(path: name)
        
        do {
            try data?.write(to: url)
            print("Image was saved")
            return url
        } catch {
            print("Saving image error: \(error)")
            return nil
        }
    }
    
    static func read(from url: URL) -> UIImage? {
        UIImage(contentsOfFile: url.path)
    }
    
    static func delete(from url: URL) {
        do {
            try FileManager.default.removeItem(at: url)
            print("Image was deleted")
        } catch {
            print("Saving image error: \(error)")
        }
    }
    
    //MARK: -- Private Methods
    private static func getDocumentDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory,
                                        in: .userDomainMask)[0]
    }
}
