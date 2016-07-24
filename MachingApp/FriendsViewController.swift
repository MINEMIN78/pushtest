//
//  FriendsViewController.swift
//  MachingApp
//
//  Created by YUMAKOMORI on 2016/07/14.
//  Copyright © 2016年 YUMAKOMORI. All rights reserved.
//

import UIKit
import NCMB

class FriendsViewController: UIViewController ,UITableViewDelegate ,UITableViewDataSource {
    
    @IBOutlet var tableView:UITableView! = UITableView()
    
    var userInfo = [AnyObject]()
    
    var followInfo = [AnyObject]()
    
    var followerInfo = [AnyObject]()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self

        //friendsJudge()
        
        loadData()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        loadData()
        
        //friendsJudge()
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        NSLog("followcount%d",followInfo.count)
        
        return followInfo.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        
        cell.textLabel?.text = followInfo[indexPath.row].objectForKey("follow").mailAddress
        
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        
        print("セルを選択しました！ #\(indexPath.row)!")
        
        NSLog("%@",String(followInfo[indexPath.row]))
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        
        return 70
    }
    
    
    
// メソッドなどはこの下に書く
    
    
    func loadData() {
        userInfo.removeAll()
        
        followInfo.removeAll()
        
        
        let user = NCMBUser.currentUser()
        
        
        let query = NCMBQuery(className: "Follow")
        
        query.includeKey = "follow"
        
        query.whereKey("user", equalTo: user)
        
        query.orderByDescending("createDate")
        
        query.findObjectsInBackgroundWithBlock({(results, error) in
            
            
            //データ読み込みの処理
            if error != nil {
                //読み込みに失敗したのとき
                print(error)
                
                NSLog("hogehoge")
                
            } else {
                
                //NSLog("hoge")
                
                //読み込みに成功したとき
                
                if results.count > 0 {
                    
                    self.followInfo = results
                    
                    self.tableView.reloadData()
                    
                    
                }
            }
        })
    }
    
    
    
    
    
    
    
    func loadData2() {
        userInfo.removeAll()
        
        followerInfo.removeAll()
        
        
        let user = NCMBUser.currentUser()
        
        
        let innerQuery = NCMBUser.query()
        
        innerQuery.whereKeyExists("objectId")
        
        innerQuery.whereKey("objectId", notEqualTo: user.objectId)
        
        
        NSLog("hoge%@hoge",String(innerQuery))
        
        
        let query = NCMBQuery(className: "Follow")
        
        query.whereKey("follow", equalTo: user)
        
        query.findObjectsInBackgroundWithBlock({(results, error) in
            
            
            //データ読み込みの処理
            if error != nil {
                //読み込みに失敗したのとき
                print(error)
                
                NSLog("hogehoge")
                
            } else {
                
                //NSLog("hoge")
                
                //読み込みに成功したとき
                
                if results.count > 0 {
                    
                    self.userInfo = results
                    
                    let tmpquery = NCMBUser.query()
                    
                    var objectIdArray = [AnyObject]()
                    
                    for (var i=0;i<results.count;i++){
                        objectIdArray.append(self.userInfo[i].objectForKey("user").objectId)
                    }
                    
                    
                    tmpquery.whereKey("objectId", containedInArray: objectIdArray)
                    
                    
                    tmpquery.findObjectsInBackgroundWithBlock({(results2, error) in
                        
                        //データ読み込みの処理
                        if error != nil {
                            //読み込みに失敗したのとき
                            print(error)
                        } else {
                            
                            
                            if results2.count > 0 {
                                
                                self.followerInfo = results2
                                
                                //NSLog("%@",self.followInfo)
                                
                                self.tableView.reloadData()
     
                            }
                        }
                    })
                }
            }
        })
    }
    
    //データの読み込み
    func loadData3() {
        userInfo.removeAll()
        
        followInfo.removeAll()
        
        
        let user = NCMBUser.currentUser()
        
        
        let innerQuery = NCMBUser.query()
        
        innerQuery.whereKeyExists("objectId")
        
        innerQuery.whereKey("objectId", notEqualTo: user.objectId)
        
        
        NSLog("hoge%@hoge",String(innerQuery))
        
        
        let query = NCMBQuery(className: "Follow")
        
        query.whereKey("user", equalTo: user)
        
        query.whereKey("follow", matchesQuery: innerQuery)
        
        
        query.findObjectsInBackgroundWithBlock({(results, error) in
            
            
            //データ読み込みの処理
            if error != nil {
                //読み込みに失敗したのとき
                print(error)
                
                 NSLog("hogehoge")
                
            } else {
                
                //NSLog("hoge")
                
                //読み込みに成功したとき
                
                if results.count > 0 {

                    self.userInfo = results
                    
                    let tmpquery = NCMBUser.query()

                    var objectIdArray = [AnyObject]()
                    
                    for (var i=0;i<results.count;i++){
                        objectIdArray.append(self.userInfo[i].objectForKey("follow").objectId)
                    }
                    
                    
                    tmpquery.whereKey("objectId", containedInArray: objectIdArray)

                    
                    tmpquery.findObjectsInBackgroundWithBlock({(results2, error) in
                        
                        //データ読み込みの処理
                        if error != nil {
                            //読み込みに失敗したのとき
                            print(error)
                        } else {
                          
                            
                            if results2.count > 0 {
                                
                                //NSLog("%@",results2)
                                
                                self.followInfo = results2
                                
                                //NSLog("%@",self.followInfo)
                                
                                self.tableView.reloadData()
                                
        
                                
                            }
                            
                        }
                    })
                    
                    
                    
                }
            }
        })
        
        
        
    }
    
    
    
    func friendsJudge() {
        userInfo.removeAll()
        
        followerInfo.removeAll()
        
        
        let user = NCMBUser.currentUser()
        
        
        let query = NCMBQuery(className: "Follow")
        
        query.includeKey = "user"
        
        query.whereKey("follow", equalTo: user)
        
        query.orderByDescending("createDate")
        
        query.findObjectsInBackgroundWithBlock({(results, error) in
            
            
            //データ読み込みの処理
            if error != nil {
                //読み込みに失敗したのとき
                print(error)
                
                NSLog("hogehoge")
                
            } else {
                
                //NSLog("hoge")
                
                //読み込みに成功したとき
                
                if results.count > 0 {
                    
                    self.followerInfo = results
                    
                    self.tableView.reloadData()
                    
                    
                }
            }
        })
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
