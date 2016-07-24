//
//  NewUserResisterViewController.swift
//  MachingApp
//
//  Created by YUMAKOMORI on 2016/07/06.
//  Copyright © 2016年 YUMAKOMORI. All rights reserved.
//

import UIKit
import NCMB

class NewUserResisterViewController: UIViewController {
    
    
// 変数など、宣言するものはこの下に書く
    
    @IBOutlet var usernameField:UITextField!
    @IBOutlet var passwordField:UITextField!
    
    var UserName:String!
    var PassWord:String!
    var MailAddress:String!
    let Domain:String = /*"g.chuo-u.ac.jp"*/ "ezweb.ne.jp"
    
    
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
        if(usernameField.isFirstResponder()){
            usernameField.resignFirstResponder()
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
    
    //メール認証を行うメソッド
    func MailVerify (mail:String) {
        var error : NSError? = nil
        NCMBUser.requestAuthenticationMail(mail, error: &error)
    }
    
    func Alert(mail:String!) {
        // ① UIAlertControllerクラスのインスタンスを生成
        // タイトル, メッセージ, Alertのスタイルを指定する
        // 第3引数のpreferredStyleでアラートの表示スタイルを指定する
        let alert: UIAlertController = UIAlertController(title: "メールを送信しました。", message: mail+"にメールを送信しました。", preferredStyle:  UIAlertControllerStyle.Alert)
        
        // ② Actionの設定
        // Action初期化時にタイトル, スタイル, 押された時に実行されるハンドラを指定する
        // 第3引数のUIAlertActionStyleでボタンのスタイルを指定する
        // OKボタン
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            print("OK")
            
        })
        // キャンセルボタン
        
        
        // ③ UIAlertControllerにActionを追加
        alert.addAction(defaultAction)
        
        // ④ Alertを表示
        presentViewController(alert, animated: true, completion: nil)
    }
    
    
    
    
    
// ボタン関連はこの下に書く
    
    @IBAction func Resister(){
        MailAddress = usernameField.text!
        //PassWord = passwordField.text!
        
       
        if self.EmailJudge(self.MailAddress, domain: self.Domain) == true {
            
            self.MailVerify(self.MailAddress)
            
            NSLog("jack daniel")
            
            Alert(MailAddress)
            
        }else {
            //メールアドレスが正しくない時の処理
            
            NSLog("メールアドレスが不正です")
        }
        
        
        
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
