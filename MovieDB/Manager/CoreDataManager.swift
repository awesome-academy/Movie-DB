//
//  CoreDataManager.swift
//  MovieDB
//
//  Created by le.n.t.trung on 03/11/2022.
//

import Foundation
import CoreData

struct CoreDataManager {
    
    static let shared = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MovieDB")
        container.loadPersistentStores { (_, err) in
            if let err = err {
                fatalError("Loading of store failed: \(err)")
            }
        }
        return container
    }()
    
    func addFilmToCoreData(filmInfo: DomainInfoFilm?, completion: @escaping (Error?) -> Void) {
        let managedContext = persistentContainer.viewContext
        
        guard let filmInfo = filmInfo else {
            completion(CoreDataError.badData)
            return
        }
        
        guard let entity = NSEntityDescription.entity(forEntityName: "FilmEntity", in: managedContext) else {
            completion(CoreDataError.badEntity)
            return
        }
        let user = NSManagedObject(entity: entity, insertInto: managedContext)
        user.setValue(filmInfo.id, forKey: "id")
        user.setValue(filmInfo.title, forKey: "nameFilm")
        user.setValue(filmInfo.genresString, forKey: "genres")
        user.setValue(filmInfo.posterImageURL, forKey: "imageUrlString")
        do {
            try managedContext.save()
            completion(nil)
        } catch let error as NSError {
            completion(error)
        }
    }
    
    func addFilmToCoreDataByDetailFilm(filmInfo: DetailInfoFilm?, completion: @escaping (Error?) -> Void) {
        let managedContext = persistentContainer.viewContext
        
        guard let filmInfo = filmInfo else {
            completion(CoreDataError.badData)
            return
        }
        
        guard let entity = NSEntityDescription.entity(forEntityName: "FilmEntity", in: managedContext) else {
            completion(CoreDataError.badData)
            return
        }
        let user = NSManagedObject(entity: entity, insertInto: managedContext)
        user.setValue(filmInfo.id, forKey: "id")
        user.setValue(filmInfo.title, forKey: "nameFilm")
        user.setValue(filmInfo.genresString, forKey: "genres")
        user.setValue(filmInfo.backdropPath, forKey: "imageUrlString")
        do {
            try managedContext.save()
            completion(nil)
        } catch let error as NSError {
            completion(error)
        }
    }
    
    func deleteFilmFromCoreData(filmId: Int, completion: @escaping (Error?) -> Void) {
        let managedContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FilmEntity")
        fetchRequest.includesPropertyValues = false
        do {
            let items = try managedContext.fetch(fetchRequest)
            for item in items.filter({ $0.value(forKey: "id") as? Int == filmId }) {
                managedContext.delete(item)
            }
            try managedContext.save()
            completion(nil)
        } catch let error as NSError {
            completion(error)
            return
        }
    }
    
    func deleteAllFilmFromCoreData(completion: @escaping (Error?) -> Void) {
        let managedContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FilmEntity")
        fetchRequest.includesPropertyValues = false
        do {
            let items = try managedContext.fetch(fetchRequest)
            for item in items {
                managedContext.delete(item)
            }
            try managedContext.save()
            completion(nil)
        } catch let error as NSError {
            completion(error)
            return
        }
    }
    
    func getFavoriteFilmList(completion: @escaping ([NSManagedObject], Error?) -> Void) {
        let managedContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FilmEntity")
        fetchRequest.includesPropertyValues = false
        do {
            let items = try managedContext.fetch(fetchRequest)
            completion(items, nil)
        } catch let error as NSError {
            completion([], error)
        }
    }
}
