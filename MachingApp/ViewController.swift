//
//  ViewController.swift
//  MachingApp
//
//  Created by YUMAKOMORI on 2016/07/06.
//  Copyright © 2016年 YUMAKOMORI. All rights reserved.
//

import UIKit
import NCMB

class ViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    
// 変数など宣言するものはこの下に書く
    
    //テーブルビューインスタンス作成
    var tableView: UITableView  =   UITableView()
    
    
    var userInfo = [AnyObject]()
    
    var userArray:NCMBQuery = NCMBUser.query()
    
    
    
    let x = CGFloat(DeviseSize.DeviseSize.screenWidth())
    let y = CGFloat(DeviseSize.DeviseSize.screenHeight())
    let statusBar = CGFloat(DeviseSize.DeviseSize.statusBarHeight())
    
    
    //@IBOutlet var searchButton: UITabBar!

// viewDidLoadなどはこの下に書く
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
        
        
        //テーブルビュー初期化、関連付け
        tableView.frame         =   CGRectMake(0, statusBar, x, y)
        tableView.delegate      =   self
        tableView.dataSource    =   self
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(tableView)
        
        loadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.loadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userInfo.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        
        cell.textLabel?.text = userInfo[indexPath.row].objectForKey("mailAddress") as? String
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("セルを選択しました！ #\(indexPath.row)!")
        
        NSLog("%@",String(userInfo[indexPath.row].mailAddress))
        
        
        //ユーザーがすでにフォローしているかどうかの判定
        
        let followObj = NCMBObject(className: "Follow")
        
        let followQuery = NCMBQuery(className: "Follow")
        
        followQuery.whereKey("user", equalTo: NCMBUser.currentUser())
        
        followQuery.whereKey("follow", equalTo: userInfo[indexPath.row])
        
        
        followQuery.findObjectsInBackgroundWithBlock({(results, error) in
            
            
            //データ読み込みの処理
            if error != nil {
                //読み込みに失敗したのとき
                print(error)
            
            } else {
                
                NSLog("hoge")
                
                
                if results.count > 0 {
                    //すでにフォローしていた時
                    
                    NSLog("すでにフォローしています。")
                            
                }else {
                    //まだフォローしていない時
                    
                    NSLog("新しくフォローします。")
                    
                    
                    followObj.setObject(NCMBUser.currentUser(), forKey: "user")
                    
                    
                    
                    followObj.setObject(self.userInfo[indexPath.row], forKey: "follow")
                    
                    
                    
                    followObj.saveInBackgroundWithBlock({(error) in
                        if error != nil {print("Save error : ",error)}
                    })
                }
            }
        })
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        
        return 70
    }
    
    
    
    
    

// メソッドなどはこの下に書く
    
    //データの読み込み
    func loadData() {
        userInfo.removeAll()
        
        let query = NCMBUser.query()
        query.whereKeyExists("mailAddress")
        query.whereKey("mailAddress", notEqualTo: NCMBUser.currentUser().mailAddress)
        query.orderByDescending("createDate")
        query.findObjectsInBackgroundWithBlock({(objects, error) in
            //データ読み込みの処理
            if error != nil {
                //読み込みに失敗したのとき
                print(error)
                
            } else {
                //読み込みに成功したとき
                if objects.count > 0 {
                    NSLog("%d",objects.count)
                    
                    self.userInfo = objects
                    self.tableView.reloadData()
                }
            }
        })
    }
    
    
    //検索
    func search(keyword:String!) {
        userInfo.removeAll()
        
        let elem1 = NCMBUser.query()
        elem1.whereKey("mailAddress", equalTo: keyword)
        let elem2 = NCMBUser.query()
        elem2.whereKey("name", equalTo: keyword)
        let elem3 = NCMBUser.query()
        elem3.whereKey("faculty", equalTo: keyword)
        
        let query = NCMBQuery.orQueryWithSubqueries([elem1,elem2,elem3])
        query.orderByAscending("createDate")
        
        
        
        
        
//        query1.orderByDescending("createDate")
        
        query.findObjectsInBackgroundWithBlock({(objects, error) in
            //データ読み込みの処理
            if error != nil {
                //読み込みに失敗したのとき
                print(error)
            } else {
                //読み込みに成功したとき
                if objects.count > 0 {
                    self.userInfo = objects
                    self.tableView.reloadData()
                }
            }
        })
    }
    
    @IBAction func searchButton() {
        let alert:UIAlertController = UIAlertController(title:"検索画面",
                                                        message: "検索したいワードを入力してください",
                                                        preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addTextFieldWithConfigurationHandler({(text:UITextField!) -> Void in
            
        })
        
        
        let cancelAction:UIAlertAction = UIAlertAction(title: "キャンセル",
                                                       style: .Cancel,
                                                       handler:{
                                                        (action:UIAlertAction!) -> Void in
                                                        print("キャンセル")
                                                        
        })
        
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: .Default) { action -> Void in
            let textFields:Array<UITextField>? =  alert.textFields as Array<UITextField>?
            if textFields != nil {
                for textField:UITextField in textFields! {
                    self.search(textField.text!)
                    
                    
                    self.tableView.reloadData()
                }
            }
        }
        
        
        
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        
        
        
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func toProfile() {
        
        
//        //let MainViewController: UIViewController = ViewController()
//        let toProfile = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Main") as! UIViewController
////        
////        // アニメーションを設定する.
//        //toProfile.modalTransitionStyle = UIModalTransitionStyle.PartialCurl
//        
////        toProfile.
//        
//        // Viewの移動する.
//        self.presentViewController(toProfile, animated: true, completion: nil)

        
    
    }


}

