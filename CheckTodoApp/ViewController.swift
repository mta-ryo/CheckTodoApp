//
//  ViewController.swift
//  CheckTodoApp
//
//  Created by morita on 2016/07/01.
//  Copyright © 2016年 morita. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var todoList = [YourTodo]()

    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func tapAddButton(sender: AnyObject) {
        
        let alertController = UIAlertController(title: "TODO追加",
                                                message: "TODOを追加してください",
                                                preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addTextFieldWithConfigurationHandler{
            (todotitle) -> Void in
            todotitle.placeholder = "<Your TodoTask here>"
        }
        
        let okAction = UIAlertAction(title: "追加", style: UIAlertActionStyle.Default) {
            (action:UIAlertAction) -> Void in
            
            if let textField = alertController.textFields?.first {
                
                let yourTodo = YourTodo()
                yourTodo.todoTitle = textField.text
                self.todoList.insert(yourTodo, atIndex: 0)
                
                
                self.tableView.insertRowsAtIndexPaths(
                    [NSIndexPath(forRow: 0, inSection: 0)],
                    withRowAnimation: UITableViewRowAnimation.Left)
                
                let data :NSData = NSKeyedArchiver.archivedDataWithRootObject(self.todoList)
                let userDefaults = NSUserDefaults.standardUserDefaults()
                userDefaults.setObject(data, forKey: "todoList")
                userDefaults.synchronize()
            }
        }
        
        alertController.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "キャンセル",
                                         style: UIAlertActionStyle.Cancel, handler: nil)
        
        alertController.addAction(cancelAction)
        presentViewController(alertController, animated: true, completion: nil)
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 0.7, alpha:1.0)
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if let todoListData = userDefaults.objectForKey("todoList") as? NSData {
            if let storedTodoList = NSKeyedUnarchiver.unarchiveObjectWithData(todoListData) as? [YourTodo] {
                todoList.appendContentsOf(storedTodoList)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.count
    }
    
    //cellタッップaction
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("todoCell", forIndexPath: indexPath)
        
        cell.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 0.7, alpha:1.0)
        
        let todo = todoList[indexPath.row]
        //TOOD
        cell.accessoryType = UITableViewCellAccessoryType.DetailButton
    
        if todo.todoDone {
            //チェックマーク
            //TODO
            //cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            //取り消し線
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: todo.todoTitle!)
            attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: 1, range: NSMakeRange(0, attributeString.length))
            cell.textLabel!.attributedText = attributeString

        } else {
            //cell.accessoryType = UITableViewCellAccessoryType.None
            cell.textLabel!.text = todo.todoTitle
            
        }
        
        return cell
    }
    
    //チェックマークをクリックAction
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let todo = todoList[indexPath.row]
        if todo.todoDone {
            todo.todoDone = false
        } else {
            todo.todoDone = true
        }
        
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        
        
        let data :NSData = NSKeyedArchiver.archivedDataWithRootObject(todoList)
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setObject(data, forKey: "todoList")
        userDefaults.synchronize()
        
    }
    
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    //削除Action
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            
            todoList.removeAtIndex(indexPath.row)
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
            let data :NSData = NSKeyedArchiver.archivedDataWithRootObject(todoList)
            
            let userDefaults = NSUserDefaults.standardUserDefaults()
            userDefaults.setObject(data, forKey: "todoList")
            userDefaults.synchronize()
        }
    }
    
    //informationボタンタップ処理
    func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
    
        //let cell = tableView.dequeueReusableCellWithIdentifier("todoCell", forIndexPath: indexPath)
        
        let todo = todoList[indexPath.row]
        let alertController = UIAlertController(title: "TODO編集",
                                                message: "TODOを編集してください",
                                                preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addTextFieldWithConfigurationHandler{
            (todotitle) -> Void in
            todotitle.text = todo.todoTitle
        }
        
        let okAction = UIAlertAction(title: "変更", style: UIAlertActionStyle.Default) {
            (action:UIAlertAction) -> Void in
            
            if let textField = alertController.textFields?.first {
                let yourTodo = YourTodo()
                
                //cellを削除
                self.todoList.removeAtIndex(indexPath.row)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                let data :NSData = NSKeyedArchiver.archivedDataWithRootObject(self.todoList)
                let userDefaults = NSUserDefaults.standardUserDefaults()
                userDefaults.setObject(data, forKey: "todoList")
                userDefaults.synchronize()
                
                //追加
                yourTodo.todoTitle = textField.text
                yourTodo.todoDone = todo.todoDone
                self.todoList.insert(yourTodo, atIndex: indexPath.row)
                self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: indexPath.row, inSection: 0)],withRowAnimation: UITableViewRowAnimation.Left)

                let cdata1 :NSData = NSKeyedArchiver.archivedDataWithRootObject(self.todoList)
                let userDefaults1 = NSUserDefaults.standardUserDefaults()
                userDefaults1.setObject(cdata1, forKey: "todoList")
                userDefaults1.synchronize()
            }
        }
        
        alertController.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "キャンセル",
                                         style: UIAlertActionStyle.Cancel, handler: nil)
        
        alertController.addAction(cancelAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
}

class YourTodo: NSObject, NSCoding {
    
    var todoTitle :String?
    
    var todoDone :Bool = false
    
    override init() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        todoTitle = aDecoder.decodeObjectForKey("todoTitle") as? String
        todoDone = aDecoder.decodeBoolForKey("todoDone")
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(todoTitle, forKey: "todoTitle")
        aCoder.encodeBool(todoDone, forKey: "todoDone")
    }
}


