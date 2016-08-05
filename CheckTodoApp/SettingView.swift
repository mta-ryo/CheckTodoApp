//
//  SettingView.swift
//  CheckTodoApp
//
//  Created by morita on 2016/07/18.
//  Copyright © 2016年 morita. All rights reserved.
//

import Foundation


import UIKit

class SettingView: UIViewController {
    
    var backColar: String = "yellow"
    
    
    @IBOutlet weak var yellowImage: UIImageView!

    @IBOutlet weak var blueImage: UIImageView!
    
    @IBOutlet weak var greenImage: UIImageView!
    
    @IBOutlet weak var whiteImage: UIImageView!
    
    
    override func viewWillDisappear(animated: Bool) {

    }
    
    override func viewDidLoad() {
        //タップ検知用
        addTapRecognizer()
    }
    
    
    /**
     * タップ検知用に登録
     */
    func addTapRecognizer(){
        
        var yellowImageTap = UITapGestureRecognizer(target: self, action: "didClickImageViewYellow:")

        var blueImageTap = UITapGestureRecognizer(target: self, action: "didClickImageViewblue:")
        
        var greenImageTap = UITapGestureRecognizer(target: self, action: "didClickImageViewGreen:")
        
        var whiteImageTap = UITapGestureRecognizer(target: self, action: "didClickImageViewWhite:")
        
        yellowImage.addGestureRecognizer(yellowImageTap)
        blueImage.addGestureRecognizer(blueImageTap)
        greenImage.addGestureRecognizer(greenImageTap)
        whiteImage.addGestureRecognizer(whiteImageTap)
        
    }
    
    
    func backMainView(){
        //背景色保存
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setObject(backColar, forKey: "backGroundColar")
        userDefaults.synchronize()
        
        //画面遷移
        let pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("mainVIew") as! ViewController
        self.navigationController?.pushViewController(pageViewController, animated: true)
        
    }
    
    //画像クリックアクション
    func didClickImageViewYellow(gesture: UIGestureRecognizer) {
        backColar = "yellow"
        backMainView()
    }
    
    func didClickImageViewblue(gesture: UIGestureRecognizer) {
        backColar = "blue"
        backMainView()
    }
    func didClickImageViewGreen(gesture: UIGestureRecognizer) {
        backColar = "green"
        backMainView()
    }
    func didClickImageViewWhite(gesture: UIGestureRecognizer) {
        backColar = "white"
        backMainView()
    }

}
