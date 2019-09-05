# CodeView



### 预览图

![line](https://github.com/Mebsunny/CodeView/blob/master/Screenshot/line.png?raw=true)

![border](https://github.com/Mebsunny/CodeView/blob/master/Screenshot/border.png?raw=true)

### 说明

`CodeView` 是纯`swift`编写的一个可以高度自定义手机验证码输入的控件。

**原理：** 基于UITextField，使用UILabel来代替验证码的显示，使用CAShapeLayer代替光标的显示，使用CALayer绘制底部线条

首先创建三个数组

* **shapeArray：**  自定义底部线条存放的数组，如果需求是带边框的输入格式，只需修改这个数组里面元素的格式即可

* **layerArray：** 自定义的光标数组

* **labelArray：** 自定义文字存放的数组

### 使用方法 

 `style`  验证码输入的风格，可根据自己的需求选择

 `codeNumber`  验证码的长度，一般是4/6位 默认6位

* **CodeStyle_line**          底部线条风格
* **CodeStyle_border**    带边框的风格

```swift
let view = CodeView.init(frame: CGRect.init(x: 50, y: 160, width: SCREEN_WIDTH-100, height: 50),codeNumber: 4,style: .CodeStyle_line)
view.codeBlock = { [weak self] code in
    print("\n\n=======>您输入的验证码是：\(code)")
}
self.view.addSubview(view)
```

### 主要代码

**根据UITextField的text改变，移动光标和底部线条**

```swift
@objc func textChage(_ textField: UITextField) {
    var verStr:String = textField.text ?? ""
    if verStr.count > codeNumber {
        let substring = textField.text?.prefix(codeNumber)
        textField.text = String(substring ?? "")
        verStr = textField.text ?? ""
    }
    if  verStr.count >= codeNumber {
        if (self.codeBlock != nil) {
            self.codeBlock?(textField.text ?? "")
        }
    }
    
    for index in 0..<codeNumber {
        let label:UILabel = labelArray[index]
        if (index < verStr.count){
            let str : NSString = verStr as NSString
            label.text = str.substring(with: NSMakeRange(index, 1))
        }
        else{
            label.text = ""
        }
        changeOpacityAnimalForShapeLayerWithIndex(index: index, hidden: index == verStr.count ? false : true)
        changeColorForLayerWithIndex(index: index, hidden: index > verStr.count ? false : true)
    }
}
```

### 其他

如果遇到问题可以联系我的邮箱：gztzxzp@gmail.com
