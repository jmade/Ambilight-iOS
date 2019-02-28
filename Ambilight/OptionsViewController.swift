//
//  OptionsViewController.swift
//  Ambilight
//
//  Created by Justin Madewell on 7/4/18.
//  Copyright © 2018 Jmade. All rights reserved.
//

import UIKit

final class OptionsViewController: UIViewController {
    private let tableView = UITableView(frame: .zero, style: .plain)
    
    var dataSource: DataSource<AmbilightOption> = .init() {
        didSet {
            tableView.reloadData()
            removeLoadingView(view)
        }
    }
    
    var response: AmbilightResponse = .init() {
        didSet {
            dataSource = DataSource<AmbilightOption>(ambilightOptions: response.options)
        }
    }
    
    deinit { }
    required init?(coder aDecoder: NSCoder) {fatalError()}
    init() {super.init(nibName: nil, bundle: nil); title = "Options"}
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(done))
        setupUI()
        makeRequest()
    }
    
    @objc func done() {dismiss(animated: true, completion: nil)}
    
    func setupUI() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UITableViewCell.self, forCellReuseIdentifier:"cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            ])
    }
    
    
    //: MARK: - Networking -
    func makeRequest(){
        addLoadingView(view)
        makeAPIRequestWith(APIRequest("ambi_app",nil)
        { [weak self] in
            if $0.isUsable {
                print("App Response:\n\($0.value)")
                self?.response = AmbilightResponse($0.value["options"] as? [String:Any] ?? [:])
            }
        })
    }
    
    
}

//: MARK: - UITableViewDelegate -
extension OptionsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //makeActionRequest(dataSource.itemForRowAtIndexPath(indexPath).title)
        let action = dataSource.itemForRowAtIndexPath(indexPath).title
        dismiss(animated: true) {
            APIRequest("chosen_action", ["action": action],{_ in}).perform()
        }
    }
    
    func makeActionRequest(_ action:String){
        makeAPIRequestWith(APIRequest("chosen_action", ["action": action],{_ in}))
    }
    
}

//: MARK: - UITableViewDataSource -
extension OptionsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.font = UIFont.preferredFont(forTextStyle: .body)
        cell.textLabel?.text = dataSource.itemForRowAtIndexPath(indexPath).title
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dataSource.titleForHeaderInSection(section)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int { return dataSource.numberOfSections }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {return dataSource.numberOfRowsInSection(section)}
}

