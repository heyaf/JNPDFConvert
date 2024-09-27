//
//  JNImageAdjustSliderView.swift
//  JNPDFConvert
//
//  Created by hebert on 2024/9/27.
//

import UIKit

class JNImageAdjustSliderView: UIView {
    
    // MARK: - Properties
    private var sliderWidth: CGFloat = 0
    private var thumbView = UIView()        // 滑块
    private var progressbgview = UIView()   // 进度条背景
    private var progressLayer = CALayer()   // 用 CALayer 实现的进度条
    private let label = UILabel()           // 进度显示Label
    private var currentValue: Int = 0       // 当前的滑动值
    
    // 配置滑动范围
    private let minValue = -100
    private let maxValue = 100
    // 记录是否已经震动
    private var hasFeedbackOccurred = false
    
    // 用于延迟发送当前值的 DispatchWorkItem
       private var valueDispatchWorkItem: DispatchWorkItem?
       
       // 回调，供外部接收进度值
       var onValueChanged: ((Int) -> Void)?
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupGesture()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        setupGesture()
    }
    
    // MARK: - Setup Views
    private func setupViews() {
        // 配置进度条背景
        progressbgview.backgroundColor = .hex("#DFDFDF")
        progressbgview.layer.cornerRadius = 3
        progressbgview.layer.masksToBounds = true
        addSubview(progressbgview)
        
        // 配置进度条使用 CALayer
        progressLayer.backgroundColor = MainColor.cgColor
        progressLayer.cornerRadius = 1
        progressbgview.layer.addSublayer(progressLayer)
        
        // 配置滑块
        thumbView.backgroundColor = .white
        thumbView.layer.cornerRadius = 13
        thumbView.layer.borderColor = UIColor.red.cgColor
        thumbView.layer.borderWidth = 2
        addSubview(thumbView)
        
        // 配置进度Label
        label.textColor = .red
        label.textAlignment = .center
        label.font = boldSystemFont(ofSize: 18)
        label.isHidden = true
        addSubview(label)
    }
    
    // MARK: - Setup Gesture Recognizer
    private func setupGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        thumbView.addGestureRecognizer(panGesture)
        thumbView.isUserInteractionEnabled = true
    }
    
    // MARK: - Layout Subviews
    override func layoutSubviews() {
        super.layoutSubviews()
        sliderWidth = progressbgview.bounds.width  // 使用 progressbgview 的宽度作为滑动条宽度
        
        progressbgview.frame = CGRect(x: 20, y: 0, width: bounds.width - 40, height: 6)
        
        // 设置初始滑块位置居中
        let thumbSize = CGSize(width: 26, height: 26)
        thumbView.frame = CGRect(x: (progressbgview.frame.width - thumbSize.width) / 2 + progressbgview.frame.minX, y: bounds.height - thumbSize.height, width: thumbSize.width, height: thumbSize.height)
        
        // 设置进度条的初始位置（默认居中，宽度为0）
        progressLayer.frame = CGRect(x: progressbgview.frame.width / 2, y: bounds.height - 16, width: 0, height: progressbgview.frame.height)
        label.frame = CGRect(x: 0, y: thumbView.frame.minY - 25 , width: 40, height: 20)
        progressbgview.centerY = bounds.height - 13
        
        thumbView.centerY = bounds.height - 13
    }
    
    // MARK: - Handle Pan Gesture
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        let point = gesture.location(in: self)
        // 更新滑块位置，限制在 progressbgview 的宽度范围内
        let newX = point.x
        let minX = progressbgview.frame.minX
        let maxX = progressbgview.frame.maxX
        
        // 限制滑块的中心点位置在 progressbgview 的左右边界内
        let thumX = min(max(newX, minX), maxX)
        thumbView.center.x = thumX
        
        // 计算当前值
        let progress = (thumbView.center.x - progressbgview.frame.minX) / progressbgview.frame.width
        currentValue = Int(progress * CGFloat(maxValue - minValue) + CGFloat(minValue))
        
        // 更新进度条和label
        updateProgress(thumX)
        label.text = "\(currentValue)"
        label.center.x =  thumX
        // 增加震感反馈
        handleHapticFeedback()
        // 拖动时显示label
        if gesture.state == .began || gesture.state == .changed {
            label.isHidden = false
        } else if gesture.state == .ended {
            label.isHidden = true
            handleSnapToCenter()
            scheduleDelayedValueTransmission()
        }
        
        gesture.setTranslation(.zero, in: self)
    }
    
    // MARK: - Update Progress with CALayer
    private func updateProgress(_ thumX: CGFloat) {
        let centerX = kScreenWidth / 2
        
        // 使用 CALayer 动画来平滑更新进度条的宽度
        CATransaction.begin()
        CATransaction.setAnimationDuration(0.1) // 设置动画持续时间
        if thumX >= centerX {
            // 更新右侧进度条
            progressLayer.frame = CGRect(x: centerX - 20, y: 0, width: thumX - centerX + 10, height: progressbgview.frame.height)
            print("---\(thumX - 20)")
        } else {
            // 更新左侧进度条
            progressLayer.frame = CGRect(x: thumX - 20, y: 0, width: centerX - thumX, height: progressbgview.frame.height)
            print("121212---\(centerX - 20)")
        }
        CATransaction.commit()
    }
    // MARK: - Snap to Center
    private func handleSnapToCenter() {
        // 当 currentValue 在 -10 到 10 之间时，吸附到 0
        if currentValue > -10 && currentValue < 10 {
            UIView.animate(withDuration: 0.2) {
                self.thumbView.center.x = self.progressbgview.frame.midX
                self.updateProgress(self.progressbgview.frame.midX)
                self.currentValue = 0
                self.label.text = "0"
                self.label.center.x = self.thumbView.center.x
            }
        }
    }
    
    // MARK: - Haptic Feedback
    private func handleHapticFeedback() {
        // 当经过 0 位置时，生成震动反馈
        if currentValue == 0  {
            let feedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
            feedbackGenerator.impactOccurred()
            hasFeedbackOccurred = true
        } else if currentValue != 0 {
            hasFeedbackOccurred = false
        }
    }
    // MARK: - Delayed Value Transmission
        private func scheduleDelayedValueTransmission() {
            cancelDelayedValueTransmission() // 取消任何已有的任务
            
            valueDispatchWorkItem = DispatchWorkItem { [weak self] in
                guard let self = self else { return }
                self.onValueChanged?(self.currentValue)
            }
            
            // 0.2秒后执行任务
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: valueDispatchWorkItem!)
        }
        
        private func cancelDelayedValueTransmission() {
            valueDispatchWorkItem?.cancel()
            valueDispatchWorkItem = nil
        }
        
        // MARK: - Public Method to Reset Value
        func resetValue() {
            UIView.animate(withDuration: 0.2) {
                self.thumbView.center.x = self.progressbgview.frame.midX
                self.updateProgress(self.progressbgview.frame.midX)
                self.currentValue = 0
                self.label.text = "0"
                self.label.center.x = self.thumbView.center.x
            }
        }
}
