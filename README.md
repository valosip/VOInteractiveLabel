# VOInteractiveLabel

[![CI Status](http://img.shields.io/travis/valosip/VOInteractiveLabel.svg?style=flat)](https://travis-ci.org/valosip/VOInteractiveLabel)
[![Version](https://img.shields.io/cocoapods/v/VOInteractiveLabel.svg?style=flat)](http://cocoapods.org/pods/VOInteractiveLabel)
[![License](https://img.shields.io/cocoapods/l/VOInteractiveLabel.svg?style=flat)](http://cocoapods.org/pods/VOInteractiveLabel)
[![Platform](https://img.shields.io/cocoapods/p/VOInteractiveLabel.svg?style=flat)](http://cocoapods.org/pods/VOInteractiveLabel)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Introduction
<p align='center'>
  <img src='https://thumbs.gfycat.com/PlushScratchyLeveret-size_restricted.gif' alt='VOInteractiveLabel example'/>
</p>

## Usage

```swift
import VOInteractive
class ViewController: UIViewController, VOInteractiveLabelDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myLabel = FillInBlankLabel3()
        myLabel.delegate = self
        myLabel.text = "My name is enter name here"
        myLabel.blankArray.append(FillInBlankModel1(type: .string, 
                                    text: "enter name here", 
                                    hint: "Please enter your name", 
                                    placeholder: "Name", 
                                    attributes: [NSForegroundColorAttributeName: UIColor.black,
                                                NSUnderlineColorAttributeName: UIColor.black,
                                                NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue]))

        self.view.addSubview(myLabel)
        myLabel.setupLabelAttributes()
    }
    
    // MARK: - VOInteractiveLabel 
    func clickedOnLinkAtIndex(_ index: Int, inLabel label: FillInBlankLabel3) {
        print("Clicked on link")
    }
    func clickedOnBlankAtIndex(_ index: Int, inLabel label: FillInBlankLabel3) {
        print("Clicked on blank")
    }
    func clickedOnHashtagAtIndex(_ index: Int, inLabel label: FillInBlankLabel3) {
        print("Clicked on hashtag")
    }
    func clickedOnMentionAtIndex(_ index: Int, inLabel label: FillInBlankLabel3) {
        print("Clicked on mention")
    }
}
```

## Requirements
iOS 7+

## Installation

VOInteractiveLabel is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "VOInteractiveLabel"
```
## Changelog
### 0.0.3
- Additional documentation

### 0.0.2
- Add documentation and screenshots

### 0.0.1
- Initial beta release

## License

VOInteractiveLabel is available under the MIT license. See the LICENSE file for more info.
