//
//  SolvesTableViewController.swift
//  Rubik's-Timer
//
//  Created by Hamdan Javeed on 2018-07-18.
//  Copyright © 2018 Hamdan Javeed. All rights reserved.
//

import UIKit
import CoreData

class SolvesTableViewController: FetchedResultsTableViewController {
    var container: NSPersistentContainer? = AppDelegate.persistentContainer {
        didSet {
            updateUI()
        }
    }

    var fetchedResultsController: NSFetchedResultsController<Solve>?

    override func viewDidLoad() {
        updateUI()
    }

    private func updateUI() {
        if let context = container?.viewContext {
            let request: NSFetchRequest<Solve> = Solve.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
            fetchedResultsController = NSFetchedResultsController<Solve>(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        }

        fetchedResultsController?.delegate = self
        try? fetchedResultsController?.performFetch()
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Solve Cell", for: indexPath)

        if let solve = fetchedResultsController?.object(at: indexPath) {
            cell.textLabel?.text = String(solve.time)
        }

        return cell
    }
}
