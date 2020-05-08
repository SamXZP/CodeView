# CodeView

## 新增cocoapods支持

点击 [CodeViewPod](https://github.com/Mebsunny/CodeViewPod) 用swift来编写的

### 预览图

![line](https://github.com/Mebsunny/CodeView/blob/master/Screenshot/line.png?raw=true)

![border](https://github.com/Mebsunny/CodeView/blob/master/Screenshot/border.png?raw=true)

### 说明

`CodeView` 是一个可以高度自定义手机验证码输入的控件。

项目有 [swift](https://github.com/Mebsunny/CodeView/tree/master/CodeView_Swift_Demo) 和 [Objective-C ](https://github.com/Mebsunny/CodeView/tree/master/CodeView_OC_Demo) 两个版本,可根据自己的项目语言引入工程。

下面介绍下`CodeView`**swift版本**的原理和用法，**Objective-C 版本**原理一样就不单独介绍了，[CodeView_OC_Demo](https://github.com/Mebsunny/CodeView/tree/master/CodeView_OC_Demo)里面很详细的介绍了Objective-C 的用法和原理。

**原理：** 基于UITextField，使用UILabel来代替验证码的显示，使用CAShapeLayer代替光标的显示，使用CALayer绘制底部线条。根据UITextField的文字变化的监听，去改变光标的显示位置和验证码的下划线或边框的风格。

### 使用方法 

**Clone或者download到本地，然后把CodeView.swift文件拖到自己的项目，下面是使用方法:**

```swift
let view = CodeView.init(frame: CGRect.init(x: 50, y: 160, width: SCREEN_WIDTH-100, height: 50),codeNumber: 4,style: .CodeStyle_line)
view.codeBlock = { [weak self] code in
    print("\n\n=======>您输入的验证码是：\(code)")
}
self.view.addSubview(view)
```

自定义属性介绍：

`codeNumber`  验证码的长度，一般是4/6位 默认6位

`margin` CodeView 两个验证码之间的间距，可以自定义，默认12

 `style`  验证码输入的风格，可根据自己的需求选择

 `labelFont`  验证码字体大小

 `labelTextColor`  验证码字体颜色

 `mainColor`  光标颜色和输入验证码的边框、线条颜色

 `normalColor`  未选中的颜色

### 主要代码

**根据UITextField的text改变，移动光标**

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
