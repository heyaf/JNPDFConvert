//
//  JNDrawingBoardView.swift
//  JNPDFConvert
//
//  Created by hebert on 2024/9/27.
//

import UIKit

class JNDrawingBoardView: UIView {
    // 存储绘制路径和撤销的路径
    private var paths: [(color: UIColor, path: UIBezierPath)] = []
    private var undonePaths: [(color: UIColor, path: UIBezierPath)] = []
    
    // 当前绘制的颜色和宽度
    var lineColor: UIColor = .black
    var lineWidth: CGFloat = 5.0
    
    // 是否有撤销或者恢复操作的回调
    var undoAction: (() -> Void)?
    var redoAction: (() -> Void)?

    // 是否已经编辑了
    var isEdit: Bool {
        return !paths.isEmpty
    }
    // 是否可以撤销
        var canUndo: Bool {
            return !paths.isEmpty
        }

        // 是否可以恢复
        var canRedo: Bool {
            return !undonePaths.isEmpty
        }
    // 初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        self.backgroundColor = .white
        self.isUserInteractionEnabled = true
    }
    
    // 清除画板
    func drawingClean() {
        paths.removeAll()
        undonePaths.removeAll()
        setNeedsDisplay()
        undoAction?()
        redoAction?()
    }
    
    // 撤销操作
    func drawingUndo() {
        guard let lastPath = paths.popLast() else { return }
        undonePaths.append(lastPath)
        setNeedsDisplay()
        undoAction?()
    }
    
    // 恢复操作
    func drawingRedo() {
        guard let redoPath = undonePaths.popLast() else { return }
        paths.append(redoPath)
        setNeedsDisplay()
        redoAction?()
    }
    
    // 将所有路径颜色更改为指定颜色
    func changeAllPathsColor(to color: UIColor) {
        for i in 0..<paths.count {
            paths[i].color = color
        }
        setNeedsDisplay()
    }
    
    // 触摸开始事件
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let point = touch.location(in: self)
        
        // 创建一条新路径
        let newPath = UIBezierPath()
        newPath.lineWidth = lineWidth
        newPath.lineCapStyle = .round
        newPath.lineJoinStyle = .round
        newPath.move(to: point)
        
        // 将新路径添加到路径数组
        paths.append((color: lineColor, path: newPath))
        setNeedsDisplay()
        
        // 清除撤销的路径（新画的线会清除之前的redo路径）
        undonePaths.removeAll()
        redoAction?()
    }
    
    // 触摸移动事件
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let point = touch.location(in: self)
        
        // 更新当前路径
        paths.last?.path.addLine(to: point)
        setNeedsDisplay()
    }
    
    // 绘制方法
    override func draw(_ rect: CGRect) {
        for (color, path) in paths {
            color.setStroke()
            path.stroke()
        }
    }
}
