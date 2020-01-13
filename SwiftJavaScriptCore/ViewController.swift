//
//  ViewController.swift
//  SwiftJavaScriptCore
//
//  Created by myl on 16/6/8.
//  Copyright © 2016年 Mayanlong. All rights reserved.
//

import UIKit
import JavaScriptCore



class ViewController: UIViewController, UIWebViewDelegate {
    
    var webView: UIWebView!
    var jsContext: JSContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        testJSContext()
        
        addWebView()
    }
    
    func testJSContext() {
        
        // 通过JSContext执行js代码
        let context: JSContext = JSContext()
        let result1: JSValue = context.evaluateScript("1 + 3")
        print(result1)  // 输出4
        
        // 定义js变量和函数
        context.evaluateScript("var num1 = 10; var num2 = 20;")
        context.evaluateScript("function sum(param1, param2) { return param1 + param2; }")
        
        // 通过js方法名调用方法
        let result2 = context.evaluateScript("sum(num1, num2)")
        print(result2 as AnyObject)  // 输出30
        
        // 通过下标来获取js方法并调用方法
        let squareFunc = context.objectForKeyedSubscript("sum")
        let result3 = squareFunc?.call(withArguments: [10, 20]).toString()
        print(result3 as AnyObject)  // 输出30
        
    }
    
    func addWebView() {
        
        self.webView = UIWebView(frame: self.view.bounds)
        self.view.addSubview(self.webView)
        self.webView.delegate = self
        self.webView.scalesPageToFit = true
        
        // 加载本地Html页面
        let url = Bundle.main.url(forResource: "demo", withExtension: "html")
        let request = URLRequest(url: url!)
        
        // 加载网络Html页面 请设置允许Http请求
        //let url = NSURL(string: "http://www.mayanlong.com");
        //let request = NSURLRequest(URL: url!)
        
        self.webView.loadRequest(request)
    }
    
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        guard let ctx = webView.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as? JSContext else {
            return
        }
        jsContext = ctx
        let model = SwiftJavaScriptModel()
        model.controller = self
        model.jsContext = self.jsContext
        
        // 这一步是将SwiftJavaScriptModel模型注入到JS中，在JS就可以通过WebViewJavascriptBridge调用我们暴露的方法了。
        self.jsContext.setObject(model, forKeyedSubscript: "WebViewJavascriptBridge" as NSCopying & NSObjectProtocol)
        
        // 注册到本地的Html页面中
        let url = Bundle.main.url(forResource: "demo", withExtension: "html")
        self.jsContext.evaluateScript(try? String(contentsOf: url!, encoding: String.Encoding.utf8))
        
 
        
        self.jsContext.exceptionHandler = { (context, exception) in
            print("exception：", exception as Any)
        }
    }
    
    
}

