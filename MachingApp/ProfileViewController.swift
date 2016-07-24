//
//  ProfileViewController.swift
//  MachingApp
//
//  Created by YUMAKOMORI on 2016/07/08.
//  Copyright © 2016年 YUMAKOMORI. All rights reserved.
//

import UIKit
import NCMB


let kWindowHeight: CGFloat = 205.5

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource ,UINavigationControllerDelegate{
    
    
// 変数など宣言するものはこの下に書く
    
    //テーブルビューインスタンス作成
    //var tableView: UITableView  =   UITableView()
    
    let x = CGFloat(DeviseSize.DeviseSize.screenWidth())
    let y = CGFloat(DeviseSize.DeviseSize.screenHeight())
    let statusBar = CGFloat(DeviseSize.DeviseSize.statusBarHeight())
    
    var tableView:UITableView!
    var headerView: CoolNavi?
    
    
// viewDidLoadなどこの下に書く

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView()
        tableView.backgroundColor = UIColor.clearColor()
        tableView.delegate = self
        tableView.dataSource = self
        tableView?.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView?.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        self.view.addSubview(tableView!)
        
        headerView = CoolNavi()
        headerView!.myInit(CGRectMake(0,0,self.view.frame.size.width,kWindowHeight), backImageName: "background", headerImageURL: "http://d.hiphotos.baidu.com/image/pic/item/0ff41bd5ad6eddc4f263b0fc3adbb6fd52663334.jpg", title: String(NCMBUser.currentUser().objectForKey("name")), subTitle: NCMBUser.currentUser().mailAddress)
        headerView?.scrollView = tableView
        headerView?.initWithClosure({ () -> Void in
            print("headerImageAction")
        })
        self.view.addSubview(headerView!)
        
        //テーブルビュー初期化、関連付け
//        tableView.frame         =   CGRectMake(0, statusBar, x, y)
//        tableView.delegate      =   self
//        tableView.dataSource    =   self
//        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
//        self.view.addSubview(tableView)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //ここからtableview関連
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let lst = ["名前","性別","生年月日","学部","学年"]
        
        return lst[section]
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        let secs = [
//            1,1,1,music.fileNameArray.count
//        ]
        
        return 1
        
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        
        switch indexPath.section {
        case 0:
            
            cell.textLabel?.text = "hoge1"
        case 1:
            cell.textLabel?.text = "hoge2"
            
        case 2:
            cell.textLabel?.text = "hoge3"
            
        case 3:
            cell.textLabel?.text = "hoge4"
        case 4:
            cell.textLabel?.text = "hoge5"
            
            
            
        default: break
        }
        
        
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        //ここでcellの選択を解除
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
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
