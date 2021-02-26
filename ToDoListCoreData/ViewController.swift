//
//  ViewController.swift
//  ToDoListCoreData
//
//  Created by Ruthlyn Huet on 2/26/21.
//

import UIKit

class ViewController: UIViewController {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private var toDoListModel = [ToDoList]()
    
    var tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        getAllItems()
        setupUI()
    }
    
    //Mark: - Setup ui interface..
    func setupUI(){
        self.title = "ToDoList"
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.frame = view.bounds
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
    }
    
    //Mark: - Right Button Tap
    @objc func didTapAdd(){
        let alert = UIAlertController(title: "New Item", message: "Enter new Item", preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "Submit", style: .cancel, handler: { _ in
            guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty else{
                return
            }
            
            self.createItem(name: text)
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    func getAllItems(){
        do{
            toDoListModel = try context.fetch(ToDoList.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }catch{
            //Error
        }
    }
    
    func createItem(name: String){
        let newItem = ToDoList(context: context)
        newItem.name = name
        newItem.date = Date()
        contextSave()
    }
    
    func updateItem(item: ToDoList, newName: String){
        item.name = newName
        contextSave()
    }
    
    func deleteItem(item: ToDoList){
        context.delete(item)
        contextSave()
    }
    
    func contextSave(){
        do{
            try context.save()
            getAllItems()
        }catch{
            //error
        }
    }


}


extension ViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoListModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = toDoListModel[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = model.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let modelItem = toDoListModel[indexPath.row]
        let sheet = UIAlertController(title: "Action", message: nil, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        sheet.addAction(UIAlertAction(title: "Edit", style: .default, handler: {[weak self] _ in
            let alert = UIAlertController(title: "Edit", message: "Edit new item", preferredStyle: .alert)
            alert.addTextField(configurationHandler: nil)
            alert.textFields?.first?.text = modelItem.name
            alert.addAction(UIAlertAction(title: "Save", style: .cancel, handler: {
                [weak self] _ in
                guard let field = alert.textFields?.first, let newName = field.text, !newName.isEmpty else{
                    return
                }
                self?.updateItem(item: modelItem, newName: newName)
            }))
            self?.present(alert, animated: true, completion: nil)
        }))
        sheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: {
            [weak self] _ in
            self?.deleteItem(item: modelItem)
        }))
        
        self.present(sheet, animated: true, completion: nil)
    }
    
    
}

