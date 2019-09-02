//
//  CodeView.swift
//  CodeView
//
//  Created by zksz on 2019/9/2.
//  Copyright © 2019 zksz. All rights reserved.
//

import UIKit

let per_width:CGFloat = 50

class CodeView: UIView {
    
    fileprivate var shapeArray:[CAShapeLayer] = Array()
    fileprivate var labelArray:[UILabel] = Array()
    fileprivate var layerArray:[CALayer] = Array()
    open var codeNumber:Int = 0
    open var mainColor:UIColor?
    open var normalColor:UIColor?
    open var labelTextColor:UIColor?
    open var codeBlock: ((String) -> Void)?
    open lazy var textField: UITextField = {
            let view = UITextField.init()
            view.tintColor = UIColor.clear
            view.backgroundColor = UIColor.clear
            view.textColor = UIColor.clear
            view.keyboardType = .numberPad
            if #available(iOS 12.0, *) {
                view.textContentType =  .oneTimeCode  //验证码自动填充
            }
            view.addTarget(self, action: #selector(textChage( _:)), for: .editingChanged)
            return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    init(frame:CGRect,codeNumber:Int = 6,labelTextColor:UIColor = UIColor.black, mainColor:UIColor = UIColor.orange,normalColor:UIColor = UIColor.gray) {
        super.init(frame: frame)
        self.codeNumber = codeNumber
        self.labelTextColor = labelTextColor
        self.mainColor = mainColor
        self.normalColor = normalColor
        setUpSubview()
    }

    open func setUpSubview() {
        let margin = (self.bounds.width - CGFloat(codeNumber)*per_width)/CGFloat(codeNumber-1)
        self.addSubview(textField)
        textField.frame = self.bounds
        for index in 0..<codeNumber  {
            let subView = UIView.init()
            subView.frame = CGRect.init(x: (per_width+margin)*CGFloat(index), y: 0, width: per_width, height: per_width)
            subView.isUserInteractionEnabled = false
            self.addSubview(subView)
            
            //底部线条
            let layer = CALayer.init()
            layer.frame = CGRect.init(x: 6, y: per_width-1, width: per_width-12, height: 1)
            if index == 0 {
                layer.backgroundColor = mainColor?.cgColor
            }else{
                layer.backgroundColor = normalColor?.cgColor
            }
            subView.layer.addSublayer(layer)
            
            //验证码文字
            let label = UILabel.init()
            label.frame = CGRect.init(x: 0, y: 0, width: per_width, height: per_width)
            label.textAlignment = .center
            label.textColor = labelTextColor
            label.backgroundColor = UIColor.clear  //widgetBackColor
            label.font = UIFont.systemFont(ofSize: 20)
            subView.addSubview(label)
            
            //光标
            let path  = UIBezierPath.init(rect: CGRect.init(x: per_width/2, y: 15, width: 2, height:per_width-30)) //(K_W - 20)/2, y: K_W/2, width: 20, height:1)
            let line = CAShapeLayer.init()
            line.path = path.cgPath
            line.fillColor = mainColor?.cgColor
            subView.layer.addSublayer(line)
            if index == 0 {
                line.add(opacityAnimation(), forKey: "kOpacityAnimation")
                line.isHidden = false
            }
            else{
                line.isHidden = true
            }
            shapeArray.append(line)
            labelArray.append(label)
            layerArray.append(layer)
        }
        startEdit()
    }
}

extension CodeView{
    
    @objc func textChage(_ textField: UITextField) {
        var verStr:String = textField.text ?? ""
        if verStr.count > codeNumber {
            textField.text = String(textField.text![..<textField.text!.index(textField.text!.startIndex, offsetBy: codeNumber)])
            verStr = textField.text ?? ""
        }
        if  verStr.count >= codeNumber {
            // endEdit()
            if (self.codeBlock != nil) {
                self.codeBlock?(textField.text ?? "")
            }
        }
        
        for index in 0..<codeNumber {
            let bgLabel:UILabel = labelArray[index]
            
            if (index < verStr.count){
                changeOpacityAnimalForShapeLayerWithIndex(index: index, hidden: true)
                let str : NSString = verStr as NSString
                bgLabel.text = str.substring(with: NSMakeRange(index, 1))
            }
            else{
                changeOpacityAnimalForShapeLayerWithIndex(index: index, hidden: index == verStr.count ? false : true)
                if ( verStr.count == 0) {
                    changeOpacityAnimalForShapeLayerWithIndex(index: 0, hidden: false)
                }
                bgLabel.text = ""
            }
        }
        
        for index in 0..<layerArray.count {
            if (index > verStr.count) {
                changeColorForLayerWithIndex(index: index, hidden: false)
            }else{
                changeColorForLayerWithIndex(index: index, hidden: true)
            }
        }
    }

    //设置底部layer的颜色
    func changeColorForLayerWithIndex(index:NSInteger, hidden:Bool) {
        let layer = layerArray[index];
        if (hidden) {
            layer.backgroundColor = mainColor?.cgColor;
        }else{
            layer.backgroundColor = normalColor?.cgColor;
        }
    }

    func clearAllData() {
        textField.text = ""
        for index in 0..<codeNumber {
            let bgLabel:UILabel = labelArray[index]
            
            if (index < textField.text?.count ?? 0){
                changeOpacityAnimalForShapeLayerWithIndex(index: index, hidden: true)
                let str : NSString = textField.text! as NSString
                bgLabel.text = str.substring(with: NSMakeRange(index, 1))
            }
            else{
                changeOpacityAnimalForShapeLayerWithIndex(index: index, hidden: index == textField.text?.count ? false : true)
                if ( textField.text?.count == 0) {
                    changeOpacityAnimalForShapeLayerWithIndex(index: 0, hidden: false)
                }
                bgLabel.text = ""
            }
        }
    }
    
    func changeOpacityAnimalForShapeLayerWithIndex(index:Int, hidden:Bool) {
        let line = shapeArray[index]
        if hidden {
            line.removeAnimation(forKey: "kOpacityAnimation")
        }
        else{
            line.add(opacityAnimation(), forKey: "kOpacityAnimation")
        }
        UIView.animate(withDuration: 0.25) {
            line.isHidden = hidden
        }
    }
    
    func startEdit() {
        textField.becomeFirstResponder()
    }
    func endEdit() {
        textField.resignFirstResponder()
    }
    
    func opacityAnimation() -> CABasicAnimation {
        let animation = CABasicAnimation.init(keyPath: "opacity")
        animation.fromValue = 1.0
        animation.toValue = 0.0
        animation.duration = 0.9
        animation.repeatCount = HUGE
        animation.isRemovedOnCompletion = true
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeIn)
        return animation
    }
}

