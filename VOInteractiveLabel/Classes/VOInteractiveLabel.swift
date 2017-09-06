//
//  VOInteractiveLabel.swift
//  Pods
//
//  Created by Val Osipenko on 9/5/17.
//
//

import UIKit

public protocol VOInteractiveLabelDelegate: class {
    
    func clickedOnBlankAtIndex(_ index: Int, inLabel label: VOInteractiveLabel)
    func clickedOnLinkAtIndex(_ index: Int, inLabel label: VOInteractiveLabel)
    func clickedOnHashtagAtIndex(_ index: Int, inLabel label: VOInteractiveLabel)
    func clickedOnMentionAtIndex(_ index: Int, inLabel label: VOInteractiveLabel)
}

public class VOInteractiveLabel: UILabel {
    
    public weak var delegate: VOInteractiveLabelDelegate?
    
    public var alertTextField: UITextField!
    public var blankArray: [BlankModel] = [BlankModel]()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTapped(_:)))
        self.addGestureRecognizer(tapGesture)
        self.isUserInteractionEnabled = true
        self.numberOfLines = 0
        self.lineBreakMode = .byWordWrapping
        
    }
    
    public func labelTapped(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            guard let label = sender.view as? VOInteractiveLabel else { return }
            guard let labelText = label.text else { return }
            
            let tapLocation = sender.location(in: label)
            
            
            let attributedString = NSMutableAttributedString(string: labelText)
            let textRange = NSRange(location: 0, length: attributedString.length)
            attributedString.addAttributes([NSFontAttributeName: label.font], range: textRange)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = label.textAlignment
            attributedString.addAttributes([NSParagraphStyleAttributeName: paragraphStyle], range: textRange)
            
            
            let textStorage = NSTextStorage(attributedString: attributedString)
            let layoutManager = NSLayoutManager()
            let textContainer = NSTextContainer(size: label.bounds.size)
            
            textContainer.lineFragmentPadding = 0
            textContainer.lineBreakMode = label.lineBreakMode
            textContainer.maximumNumberOfLines = label.numberOfLines
            
            textStorage.addLayoutManager(layoutManager)
            layoutManager.addTextContainer(textContainer)
            
            
            let characterIndex = layoutManager.glyphIndex(for: tapLocation, in: textContainer,
                                                          fractionOfDistanceThroughGlyph: nil)
            let glyphRect = layoutManager.boundingRect(forGlyphRange: NSRange(location: characterIndex, length: 1), in: textContainer)
            
            if glyphRect.contains(tapLocation) {
                for index in 0..<label.blankArray.count where NSLocationInRange(characterIndex, label.blankArray[index].range!){
                    switch label.blankArray[index].type! {
                    case .link:
                        delegate?.clickedOnLinkAtIndex(index, inLabel: label)
                    case .mention:
                        delegate?.clickedOnMentionAtIndex(index, inLabel: label)
                    case .hashtag:
                        delegate?.clickedOnHashtagAtIndex(index, inLabel: label)
                    default:
                        delegate?.clickedOnBlankAtIndex(index, inLabel: label)
                    }
                }
            }
        }
    }
    
    public func setupLabelAttributes() {
        let underlineAttriString = NSMutableAttributedString(string: self.text!)
        
        for index in 0..<blankArray.count {
            let range = (self.text! as NSString).range(of: blankArray[index].text!)
            underlineAttriString.addAttributes(blankArray[index].attributes ?? [:], range: range)
            blankArray[index].range = range
        }
        
        self.attributedText = underlineAttriString
    }
    
    public func updateBlankAtIndex(_ index: Int, withValue value: String) {
        let mutableString = NSMutableAttributedString(attributedString: self.attributedText!)
        mutableString.replaceCharacters(in: self.blankArray[index].range!, with: value)
        
        self.blankArray[index].text = value
        self.attributedText = mutableString
        updateAllRanges()
    }
    
    private func updateAllRanges() {
        for index in 0..<blankArray.count {
            let range = (self.text! as NSString).range(of: blankArray[index].text!)
            blankArray[index].range = range
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
