//
//  RxViewController.swift
//  RxSwiftPractice
//
//  Created by 竹影 on 2023/07/26.
//

import UIKit
import RxSwift
import RxCocoa

class RxViewController: UIViewController {

    fileprivate lazy var bag = DisposeBag()
    
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var button5: UIButton!
    @IBOutlet weak var button6: UIButton!
    
    @IBOutlet weak var textField1: UITextField!
    @IBOutlet weak var textField2: UITextField!
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // MARK: - self.view
        
        // 将背景 View 和点击事件绑定
        let tapGesture = UITapGestureRecognizer()
        self.view.addGestureRecognizer(tapGesture)
        // 使用 rx.event 方法将 UITapGestureRecognizer 转换为可观察序列
        tapGesture.rx.event
            .subscribe(onNext: { [weak self] _ in
                // 点击自己的空白 View 让 TextField 的键盘消失
                self?.textField1.resignFirstResponder()
                self?.textField2.resignFirstResponder()
            })
            .disposed(by: bag)
        
        // MARK: - Buttons
        
        // Button 点击可以响应
        button1.rx.tap
            .subscribe { [weak self] (event: Event<()>) in
                print("tap button 1")
                // 跳转
                self?.performSegue(
                    withIdentifier: "ToRxObservableViewController",
                    sender: self)
            }.disposed(by: bag)
        
        // Button 点击可以响应
        button2.rx.tap
            .subscribe { [weak self] (event: Event<()>) in
                print("tap button 2")
                // 跳转
                self?.performSegue(
                    withIdentifier: "ToRxSubjectViewController",
                    sender: self)
            }.disposed(by: bag)
        
        // Button 点击可以响应
        button3.rx.tap
            .subscribe { [weak self] (event: Event<()>) in
                print("tap button 3")
                // 跳转
                self?.performSegue(
                    withIdentifier: "ToRxFunctorViewController",
                    sender: self)
            }.disposed(by: bag)
        
        // Button 点击可以响应
        button4.rx.tap
            .subscribe { [weak self] (event: Event<()>) in
                print("tap button 4")
                // 跳转
                self?.performSegue(
                    withIdentifier: "ToRxTableViewController",
                    sender: self)
            }.disposed(by: bag)
        
        // Button 点击可以响应
        button5.rx.tap
            .subscribe { [weak self] (event: Event<()>) in
                print("tap button 5")
                // 跳转
                self?.performSegue(
                    withIdentifier: "ToRxNetworkViewController",
                    sender: self)
            }.disposed(by: bag)
        
        // Button 点击可以响应
        button6.rx.tap
            .subscribe { [weak self] (event: Event<()>) in
                print("tap button 6")
                // 跳转
                self?.performSegue(
                    withIdentifier: "ToRxCasesViewController",
                    sender: self)
            }.disposed(by: bag)
        
        // MARK: - textField and Label
        
        // TextField 输入可以及时捕获输入
        textField1.rx.text
            .subscribe(onNext: { (text: String?) in
                print("text field 1 : " + (text ?? ""))
            }).disposed(by: bag)
        
        // TextField 输入可以反应到 label 里
        textField2.rx.text
            .bind(to: label.rx.text) // 绑定协议
            .disposed(by: bag)

        // 对 Label 输入的内容进行监听
        label.rx.observe(String.self, "text")
            .subscribe(onNext: { (text: String?) in
                print("label text : " + (text ?? ""))
            }).disposed(by: bag)
        
        // 对 Label 的 Frame 进行监听
        label.rx.observe(CGRect.self, "frame")
            .subscribe(onNext: { (frame: CGRect?) in
                print(frame?.width ?? 0)
            }).disposed(by: bag)
        
        // MARK: - scrollview
        
        // 监听 ScrollView 的滚动
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: 200)
        scrollView.rx.contentOffset
            .subscribe(onNext: { (point: CGPoint) in
                print(point)
            }).disposed(by: bag)
        
    }
    
}

