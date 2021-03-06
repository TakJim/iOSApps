//
//  AddTaskViewController.swift
//  ToDoCoreToDo
//
//  Created by T. Jimbo on 2018/07/15.
//  Copyright © 2018年 TakJim. All rights reserved.
//

import UIKit

class AddTaskViewController: UIViewController {

    // MARK: - Properties
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var task: Task?
    
    @IBOutlet weak var taskTextField: UITextField!
    @IBOutlet weak var categorySegmentedControl: UISegmentedControl!
    
    // MARK: -
    var taskCategory = "TODO"
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //taskに値が代入されていたら、textFieldとsegmentedControlにそれを表示
        if let task = task {
            taskTextField.text = task.name
            taskCategory = task.category!
            switch task.category! {
            case "TODO":
                categorySegmentedControl.selectedSegmentIndex = 0
            case "Shopping":
                categorySegmentedControl.selectedSegmentIndex = 1
            case "Assignment":
                categorySegmentedControl.selectedSegmentIndex = 2
            default:
                categorySegmentedControl.selectedSegmentIndex = 0
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Actions of Buttons
    
    @IBAction func categoryChosen(_ sender: UISegmentedControl) {
        // choose category of task
        switch sender.selectedSegmentIndex{
        case 0:
            taskCategory = "TODO"
        case 1:
            taskCategory = "Shopping"
        case 2:
            taskCategory = "Assignment"
        default:
            taskCategory = "TODO"
        }
    }
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func plusButtonTapped(_ sender: Any) {
        // TextFieldに何も入力されていない場合は何もせずに1つ目のビューに戻る
        let taskName = taskTextField.text
        if taskName == "" {
            dismiss(animated: true, completion: nil)
            return
        }
        // 受け取った値が空であれば、新しいTaskオブジェクトを作る
        if task == nil {
            task = Task(context: context)
        }
        //　受けとったオブジェクト、または先程新しく作成したオブジェクトそのタスクのnameとcategoryに入力データを代入する
        if let task = task {
            task.name = taskName
            task.category = taskCategory
        }
        // 変更内容を保存する
        
        
        // context（データベースを扱うのに必要）を定義
        //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        // taskにTask（データベースのエンティティ）型オブジェクトを代入する．
        // このとき，Taskがサジェストされない（エラーになる）場合がある
        // 詳しい原因はわからないが，Runするか，すべてのファイルを保存してXcodeを再起動すると直るのでいろいろ試す．
        //let task = Task(context: context)
        
        // 先ほど定義したTask型データのname, categoryプロパティに入力，選択したデータを代入
        //task.name = taskName
        //#task.category = taskCategory
        
        // 上で作成したデータをデータベースに保存します
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        dismiss(animated: true, completion: nil)
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
