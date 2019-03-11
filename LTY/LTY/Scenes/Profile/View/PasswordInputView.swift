//
//  PasswordInputView.swift
//  LTY
//
//  Created by 花菜 on 2018/12/17.
//  Copyright © 2018 Coder.flower. All rights reserved.
//

import UIKit
protocol PasswordInputViewDelegate: class {
    func passwordInputViewBeginEditing(_ inputView: PasswordInputView)
    func passwordInputViewEditChanged(_ inputView: PasswordInputView)
    func passwordInputViewCompletedEdited(_ inputView: PasswordInputView)
}
extension PasswordInputViewDelegate {
    func passwordInputViewBeginEditing(_ inputView: PasswordInputView){}
    func passwordInputViewEditChanged(_ inputView: PasswordInputView){}
    func passwordInputViewCompletedEdited(_ inputView: PasswordInputView){}
}

class PasswordInputView: UIView, UIKeyInput{
    private let numbers = "0123456789"
    private (set) var text: String = ""
    private let squareWidth: CGFloat
    private let passwordLength: Int
    private let pointRadius: CGFloat
    private let rectColor: UIColor
    weak var delegate: PasswordInputViewDelegate?
    private var textCount: Int {
        return text.count
    }
    
    enum InputTyep {
        case line
        case box
    }
    private let inputType: InputTyep
    private let lineWidth: CGFloat
    private let boxRadius: CGFloat
    init(inputType:InputTyep = .line, squareWidth: CGFloat = 40, passwordLength: Int = 6, pointRadius: CGFloat = 6, rectColor: UIColor = UIColor.darkGray, backgroundColor: UIColor = .clear, lineWidth: CGFloat = 2, boxRadius: CGFloat = 5) {
        self.inputType = inputType
        self.squareWidth = squareWidth
        self.passwordLength = passwordLength
        self.pointRadius = pointRadius
        self.rectColor = rectColor
        self.lineWidth = lineWidth
        self.boxRadius = boxRadius
        super.init(frame: CGRect.zero)
        self.backgroundColor = backgroundColor
    }
    
    var keyboardType: UIKeyboardType {
        set {
            
        }
        get {
            return .numberPad
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var hasText: Bool {
        return textCount > 0
    }
    func reset() {
        text = ""
        setNeedsDisplay()
    }
    func insertText(_ text: String) {
        if self.textCount < self.passwordLength {
            let numSet = NSCharacterSet(charactersIn: numbers).inverted
            let filtered = text.components(separatedBy: numSet).joined(separator: "")
            if text == filtered {
                self.text.append(text)
                delegate?.passwordInputViewEditChanged(self)
                if self.textCount == passwordLength {
                    delegate?.passwordInputViewCompletedEdited(self)
                }
                setNeedsDisplay()
            }
        }
    }
    
    func deleteBackward() {
        if textCount > 0 {
            _ = text.popLast()
            delegate?.passwordInputViewEditChanged(self)
        }
        setNeedsDisplay()
    }
    override var canBecomeFirstResponder: Bool {
        return true
    }
    override func becomeFirstResponder() -> Bool {
        delegate?.passwordInputViewBeginEditing(self)
        return super.becomeFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !self.isFirstResponder {
            _ = self.becomeFirstResponder()
        }
    }
    
    /// 画圆点
    ///
    /// - Parameters:
    ///   - centerPoint: <#centerPoint description#>
    ///   - radius: <#radius description#>
    ///   - startAngle: <#startAngle description#>
    ///   - endAngle: <#endAngle description#>
    ///   - clockwise: <#clockwise description#>
    private func drawDot(at centerPoint: CGPoint, radius: CGFloat, startAngle: CGFloat = 0, endAngle: CGFloat = CGFloat.pi * 2, clockwise: Bool = true) {
        let path = UIBezierPath(arcCenter: centerPoint, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: clockwise)
        rectColor.setFill()
        path.fill()
    }
    
    /// 画线条
    ///
    /// - Parameters:
    ///   - formPoint: <#formPoint description#>
    ///   - toPoint: <#toPoint description#>
    ///   - lineWidth: <#lineWidth description#>
    ///   - lineColor: <#lineColor description#>
    private func drawLine(from formPoint: CGPoint, to toPoint: CGPoint, lineWidth: CGFloat, lineColor: UIColor) {
        let path = UIBezierPath()
        path.move(to: formPoint)
        path.addLine(to: toPoint)
        path.lineWidth = lineWidth
        lineColor.setStroke()
        path.stroke()
    }
    
    override func draw(_ rect: CGRect) {
        let height = rect.size.height
        let width = rect.size.width
        let x = (width - squareWidth * CGFloat(passwordLength)) * 0.5
        let y = (height - squareWidth) * 0.5
        /// 是否需要外宽
        if inputType == .line {
            /// 画横线
            for index in 0..<passwordLength {
                if index < textCount {
                    /// 画圆点
                    let x = x +  CGFloat(index + 1) * squareWidth - squareWidth * 0.5
                    let y = y + squareWidth * 0.5
                    let center = CGPoint(x: x, y: y)
                    drawDot(at: center, radius: pointRadius)
                } else {
                    /// 画横线
                    let fromPoint = CGPoint(x: x + CGFloat(index) * squareWidth + 10, y: y + squareWidth * 0.5)
                    let toPoint = CGPoint(x: x + CGFloat(index) * squareWidth + squareWidth - 10, y: y + squareWidth * 0.5)
                    drawLine(from: fromPoint, to: toPoint, lineWidth: lineWidth, lineColor: rectColor)
                }
            }
        } else {
            
            // 画外框
            let boxRect = CGRect(x: x, y: y, width: squareWidth * CGFloat(passwordLength), height: squareWidth)
            let path = UIBezierPath(roundedRect: boxRect, cornerRadius: boxRadius)
            path.lineWidth = lineWidth
            UIColor.white.setFill()
            rectColor.setStroke()
            path.fill()
            path.stroke()
            /// 画竖条
            for index in 1..<passwordLength {
                let fromPoint = CGPoint(x: x + CGFloat(index) * squareWidth, y: y)
                let toPoint = CGPoint(x: x + CGFloat(index) * squareWidth, y: y + squareWidth)
                drawLine(from: fromPoint, to: toPoint, lineWidth: lineWidth, lineColor: rectColor)
            }
            if textCount > 0 {
                for index in 1...textCount {
                    /// 画圆点
                    let x = x +  CGFloat(index) * squareWidth - squareWidth * 0.5
                    let y = y + squareWidth * 0.5
                    let center = CGPoint(x: x, y: y)
                    drawDot(at: center, radius: pointRadius)
                }
            }
        }
        
    }
}
