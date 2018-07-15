//
//  ViewController.swift
//  ToDoCoreToDo
//
//  Created by T. Jimbo on 2018/07/15.
//  Copyright © 2018年 TakJim. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - Properties
    @IBOutlet weak var taskTableView: UITableView!
    
    // MARK: - Properties for table view
    
    var tasks:[Task] = []
    var tasksToShow:[String:[String]] = ["TODO":[], "Shopping":[], "Assignment":[]]
    let taskCategories:[String] = ["TODO", "Shopping", "Assignment"]
    
    // MARK: - Viwe Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        taskTableView.dataSource = self
        taskTableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // CoreDataからデータをfetchしてくる
        getData()
        
        // taskTableViewを再読み込みする
        taskTableView.reloadData()
    }
    
    // MARK: - Method of Getting data from Core Data
    
    func getData() {
        // データ保存時と同様にcontextを定義
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            // CoreDataからデータをfetchしてtasksに格納
            let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
            tasks = try context.fetch(fetchRequest)
            
            // tasksToShow配列を初期化（同じデータを複数表示しないため）
            for key in tasksToShow.keys {
                tasksToShow[key] = []
            }
            //　先程fetchしたデータをtasksToShow配列に格納する
            for task in tasks {
                tasksToShow[task.category!]?.append(task.name!)
            }
        } catch {
            print("Fetching Failed.")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table View Data Source
    
    // taskCategories[]に格納されている文字列がTableViweのセクションになる
    func numberOfSections(in tableView: UITableView) -> Int {
        return taskCategories.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return tasksToShow[taskCategories[section]]!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        let sectionData = tasksToShow[taskCategories[indexPath.section]]
        let cellData = sectionData?[indexPath.row]
        
        cell.textLabel?.text = "\(cellData!)"
        
        return cell
    }


}

