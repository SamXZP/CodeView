# CodeView



### 预览图

![未输入效果](https://github.com/Mebsunny/CodeView/blob/master/Screenshot/default.png?raw=true)

![验证码输入](https://github.com/Mebsunny/CodeView/blob/master/Screenshot/input.png?raw=true)

### 说明

`CodeView` 是**纯swift**编写的一个可以高度自定义手机验证码输入的控件。

**原理： **基于UITextField，使用UILabel来代替验证码的显示，使用CAShapeLayer代替光标的显示，使用CALayer绘制底部线条

首先创建三个数组

* **lineArray：**  自定义底部线条存放的数组，如果需求是带边框的输入格式，只需修改这个数组里面元素的格式即可

* **layerArray：** 自定义的光标数组

* **labelArray：** 自定义文字存放的数组

### 使用方法

```swift
let view = CodeView.init(frame: CGRect.init(x: 50, y: 160, width: SCREEN_WIDTH-100, height: 50),codeNumber: 4)
view.beginEdit()
view.codeBlock = { [weak self] code in
print("\n\n=======>验证码是：\(code)")
}
self.view.addSubview(view)
```

### 主要代码

**根据UITextField的text改变，移动光标和底部线条**

```swift
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
            changeViewLayerIndex(index: index, hidden: true)
            let str : NSString = verStr as NSString
            bgLabel.text = str.substring(with: NSMakeRange(index, 1))
        }
        else{
            changeViewLayerIndex(index: index, hidden: index == verStr.count ? false : true)
            if ( verStr.count == 0) {
                changeViewLayerIndex(index: 0, hidden: false)
            }
            bgLabel.text = ""
        }
    }
    
    for index in 0..<layerArray.count {
        if (index > verStr.count) {
            changeLayerColorIndex(index: index, hidden: false)
        }else{
            changeLayerColorIndex(index: index, hidden: true)
        }
    }
}

```

### 输入框需求

如果需求是输入框则需要修改下面代码，设置CALayer的边框、圆角即可。

```swift
//底部线条
let layer = CALayer.init()
layer.frame = CGRect.init(x: 6, y: K_W-1, width: K_W-12, height: 1)
if index == 0 {
    layer.backgroundColor = mainColor?.cgColor
}else{
    layer.backgroundColor = normalColor?.cgColor
}
subView.layer.addSublayer(layer)
```

### 其他

如果遇到问题可以联系我的邮箱：gztzxzp@gmail.com
