//
//  TableViewController.swift
//  TableBootCamps_KC
//
//  Created by Marco Muñoz on 5/11/23.
//

import UIKit
import Combine

final class TableViewController: UITableViewController {
    
    @IBOutlet weak var bootcampsTableView: UITableView!
    
    var viewModel: TableViewModel = TableViewModel()
    private var suscriptor: Set<AnyCancellable> = []
    
    init(viewModel: TableViewModel = TableViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        updateData()
    }
    
    func initViews() {
        viewModel.onViewAppear()
    }
    
    func updateData() {
        viewModel.$bootcampsModel
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] data in
                self?.bootcampsTableView.reloadData()})
            .store(in: &suscriptor)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        viewModel.bootcampsModel.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = self.viewModel.bootcampsModel[indexPath.row].name
        return cell
    }
}
