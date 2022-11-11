//
//  CoreDataManager.swift
//  MovieDB
//
//  Created by le.n.t.trung on 03/11/2022.
//

import Foundation
import CoreData

final class PersistentContainer {

    static let shared = PersistentContainer()
    private var persistentContainer: NSPersistentContainer?

    private init() {
        persistentContainer = NSPersistentContainer(name: "Model")
        persistentContainer?.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }

    func saveContext() {
        let context = persistentContainer?.viewContext
        if context?.hasChanges != nil {
            do {
                try context?.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
