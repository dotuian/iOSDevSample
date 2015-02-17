//
//  01TextFieldViewController.swift
//  BaseUsageSample
//
//  Created by 鐘紀偉 on 15/2/16.
//  Copyright (c) 2015年 鐘紀偉. All rights reserved.
//

import Foundation
import UIKit

// http://iphone-tora.sakura.ne.jp/uitextfield.html
// https://developer.apple.com/library/ios/documentation/UIKit/Reference/UITextField_Class/


class _TextFieldViewController : UIViewController, UITextFieldDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        
        // UITextField 的继承关系
        // UITextField : UIControl : UIView : UIResponder : NSObject
        
        
        var textfield1 = UITextField()
        textfield1.frame = CGRectMake(30, 100, 200, 25)
        // 边框的风格
        textfield1.borderStyle = UITextBorderStyle.RoundedRect
        //设置字体
        textfield1.font = UIFont.systemFontOfSize(15)
        //设置背景图片
        //textfield.background = UIImage(named: nil)
        //设置文字对齐方式
        // NSTextAlignment.Left
        // NSTextAlignment.Center
        // NSTextAlignment.Right
        textfield1.textAlignment = NSTextAlignment.Right
        //
        textfield1.placeholder = "test word."
        // 设置键盘类型
//        UIKeyboardType.Default // Default type for the current input method.
//        UIKeyboardType.ASCIICapable // Displays a keyboard which can enter ASCII characters, non-ASCII keyboards remain active
//        UIKeyboardType.NumbersAndPunctuation // Numbers and assorted punctuation.
//        UIKeyboardType.URL // A type optimized for URL entry (shows . / .com prominently).
//        UIKeyboardType.NumberPad // A number pad (0-9). Suitable for PIN entry.
//        UIKeyboardType.PhonePad // A phone pad (1-9, *, 0, #, with letters under the numbers).
//        UIKeyboardType.NamePhonePad // A type optimized for entering a person's name or phone number.
//        UIKeyboardType.EmailAddress // A type optimized for multiple email address entry (shows space @ . prominently).
//        UIKeyboardType.DecimalPad // A number pad with a decimal point.
//        UIKeyboardType.Twitter // A type optimized for twitter text entry (easy access to @ #)
//        UIKeyboardType.WebSearch // A default keyboard type with URL-oriented addition (shows space . prominently).
        textfield1.keyboardType = UIKeyboardType.NumberPad
        // 设置清除按钮显示的时刻
        textfield1.clearButtonMode = UITextFieldViewMode.Always
        
        
        // 设置代理
        textfield1.delegate = self
        // 添加到视图上
        self.view.addSubview(textfield1)
        

        // 通过代理获取多个UITextField的方式
        // 通过设置tag值
        var textfield2 = UITextField()
        textfield2.frame = CGRectMake(30, 150, 200, 25)
        textfield2.borderStyle = UITextBorderStyle.Line
        textfield2.backgroundColor = UIColor.yellowColor()
        textfield2.delegate = self
        // 添加到视图上
        self.view.addSubview(textfield2)
        
        
        textfield1.tag = 1
        textfield2.tag = 2
        
    }
    
    
    
    // return NO to disallow editing.
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return true
    }
    
    // became first responder
    func textFieldDidBeginEditing(textField: UITextField){
    }
    
    // return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
    func textFieldShouldEndEditing(textField: UITextField) -> Bool{
        return true
    }

    // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
    func textFieldDidEndEditing(textField: UITextField){
    }
    
    // return NO to not change text
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        return true
    }
    
    // called when clear button pressed. return NO to ignore (no notifications)
    func textFieldShouldClear(textField: UITextField) -> Bool {
        return true
    }
    
    // called when 'return' key pressed. return NO to ignore.
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        switch textField.tag {
            case 1:
                println("第一个文本框的值：\(textField.text)")
                break
            case 2:
                println("第二个文本框的值：\(textField.text)")
                break
            default:
                break
        }
        
        // 点击RETURN之后，隐藏键盘
        textField.resignFirstResponder()
        
        return true
    }


}