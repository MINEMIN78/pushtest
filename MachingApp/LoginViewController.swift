//
//  LoginViewController.swift
//  MachingApp
//
//  Created by YUMAKOMORI on 2016/07/06.
//  Copyright © 2016年 YUMAKOMORI. All rights reserved.
//

import UIKit
import NCMB

class LoginViewController: UIViewController{
    
    
// 変数など、宣言するものはこの下に書く
    
    @IBOutlet var userameField:UITextField!
    @IBOutlet var passwordField:UITextField!
    
    var UserName:String!
    var PassWord:String!
    var MailAddress:String!
    let Domain:String = "gmail.com"/*"g.chuo-u.ac.jp"*/
    
    
// viewDidLoadなどはこの下に書く

    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //非表示にする。
        if(passwordField.isFirstResponder()){
            passwordField.resignFirstResponder()
        }else if(passwordField.isFirstResponder()){
            passwordField.resignFirstResponder()
        }
        
    }
    
// メソッドなどはこの下に書く
    
    //メールアドレスが正しいか判定するメソッド
    func EmailJudge (mail: String , domain: String) -> Bool {
        NSLog("validate calendar: \(mail)")
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@"+domain
        var emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluateWithObject(mail)
        return result
    }
    
    

    
    
// ボタン関連はこの下に書く
    
    @IBAction func login() {
        
        MailAddress = userameField.text!
        PassWord = passwordField.text!
        
        // メールアドレスとパスワードでログイン
        NCMBUser.logInWithMailAddressInBackground(MailAddress, password: PassWord, block:{(user: NCMBUser!, error: NSError!) in
            if error != nil {
                // ログイン失敗時の処理
                NSLog("ログインに失敗しました")
                
            }else{
                // ログイン成功時の処理
                NSLog("ログインに成功しました")
                
                let currentUser = NCMBUser.currentUser()
                
                
                let followObj = NCMBObject(className: "Follow")
                
                NSLog("%@",String(followObj.objectForKey("userName")))
                
                var tmpArray = [AnyObject?]()
                
                
                
                
                let followQuery = NCMBQuery(className: "Follow")
                
                
                followQuery.whereKey(currentUser.userName, equalTo: "userName")
                
                NSLog("%@",followQuery)
                
            
                
                if followQuery == nil {
                    // NCMBACLのインスタンスを作成
                    let groupACL = NCMBACL()
                    
                    groupACL.setPublicReadAccess(true)
                    //groupACL.setPublicWriteAccess(true)
                    
                    
                    
                    currentUser.ACL = groupACL
                    
                    currentUser.save(nil)
                    
                    NSLog("%@",String(currentUser.ACL.isPublicReadAccess()))
                    NSLog("%@",String(currentUser.ACL.isPublicWriteAccess()))
                    
                    followObj.setObject(currentUser.userName, forKey: "userName")
                    
                    followObj.setObject(true, forKey: "firstLogin")
                    
                    followObj.saveEventually { (error: NSError!) -> Void in
                        if error != nil {
                            // 保存に失敗した場合の処理
                        }else{
                            // 保存に成功した場合の処理
                            
                            NSLog("保存に成功しました")
                        }
                    }
                }else {
                    NSLog("ログイン済みです")
                }
                
                
               
                
                // ユーザー全員への読み込み権限を設定する
                //groupACL.setPublicReadAccess(true)
                
                // 遷移するViewを定義する.
                //let MainViewController: UIViewController = ViewController()
                let MainViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MainView") as! UINavigationController
                
                // アニメーションを設定する.
                //MainViewController.modalTransitionStyle = UIModalTransitionStyle.PartialCurl
                
                // Viewの移動する.
                self.presentViewController(MainViewController, animated: true, completion: nil)
                
                
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
