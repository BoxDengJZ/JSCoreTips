//
//  Model.swift
//  SwiftJavaScriptCore
//
//  Created by Jz D on 2020/1/13.
//  Copyright © 2020 Mayanlong. All rights reserved.
//

import UIKit
import JavaScriptCore


// 定义协议SwiftJavaScriptDelegate 该协议必须遵守JSExport协议
@objc protocol SwiftJavaScriptDelegate: JSExport {
    
    // js调用App的微信支付功能 演示最基本的用法
    func createOrder(_ orderNo: String)
    
    // js调用App的微信分享功能 演示字典参数的使用
    func shareInfo(_ dict: [String: AnyObject])
    
    // js调用App方法时传递多个参数 并弹出对话框 注意js调用时的函数名
    func showDialog(_ title: String, message: String)
    
    // js调用App的功能后 App再调用js函数执行回调
    func callHandler(_ handleFuncName: String)
    
}



// 定义一个模型 该模型实现SwiftJavaScriptDelegate协议
@objc class SwiftJavaScriptModel: NSObject, SwiftJavaScriptDelegate {
    
    weak var controller: UIViewController?
    weak var jsContext: JSContext?
    
    func createOrder(_ orderNo: String) {
        
        print("订单号：", orderNo)
        
        // 调起微信支付逻辑
    }
    
    func shareInfo(_ dict: [String: AnyObject]) {
        
        print("分享信息：", dict)
        
        // 调起微信分享逻辑
    }
    
    func showDialog(_ title: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "确定", style: .default, handler: nil))
            self.controller?.present(alert, animated: true, completion: nil)
        }
        
    }
    
    func callHandler(_ handleFuncName: String) {
        
        let jsHandlerFunc = self.jsContext?.objectForKeyedSubscript("\(handleFuncName)")
        let dict = ["name": "sean", "age": 18] as [String : Any]
        let _ = jsHandlerFunc?.call(withArguments: [dict])
    }
}
