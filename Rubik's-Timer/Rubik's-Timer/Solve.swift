//
//  Solve.swift
//  Rubik's-Timer
//
//  Created by Hamdan Javeed on 2018-07-21.
//  Copyright © 2018 Hamdan Javeed. All rights reserved.
//

import CoreData

class Solve: NSManagedObject {
    class func allSolves(in context: NSManagedObjectContext) throws -> Array<Solve> {
        let request: NSFetchRequest<Solve> = Solve.fetchRequest()

        do {
            return try context.fetch(request)
        } catch {
            throw error
        }
    }
}
