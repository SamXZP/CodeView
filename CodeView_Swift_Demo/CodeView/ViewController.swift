//
//  ViewController.swift
//  CodeView
//
//  Created by zksz on 2019/9/2.
//  Copyright © 2019 zksz. All rights reserved.
//

import UIKit
let SCREEN_WIDTH = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let view = CodeView.init(frame: CGRect.init(x: 50, y: 160, width: SCREEN_WIDTH-100, height: 50),codeNumber: 6,style: .CodeStyle_border)
        view.codeBlock = { [weak self] code in
            print("\n\n=======>您输入的验证码是：\(code)")
        }
        self.view.addSubview(view)
    }
}


