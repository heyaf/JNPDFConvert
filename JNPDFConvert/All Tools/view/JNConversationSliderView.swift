//
//  JNConversationSliderView.swift
//  JNPDFConvert
//
//  Created by hebert on 2024/9/23.
//

import UIKit

class JNConversationSliderView: UIView {

    
    // MARK: - Properties

    // 滑动结果回调闭包
    var valueChanged: ((Float) -> Void)?

    // 自定义的 UISlider
    private let slider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumTrackTintColor = MainColor  // 默认滑动条颜色
        slider.maximumTrackTintColor = .lightGray  // 默认未滑动部分的颜色
        return slider
    }()

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupConstraints()
    }

    // MARK: - UI Setup

    private func setupUI() {
        // 添加滑动条到视图
        addSubview(slider)
        
        // 设置滑动条行为
        slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
    }

    private func setupConstraints() {
        // 布局滑动条
        NSLayoutConstraint.activate([
            slider.leadingAnchor.constraint(equalTo: leadingAnchor),
            slider.trailingAnchor.constraint(equalTo: trailingAnchor),
            slider.topAnchor.constraint(equalTo: topAnchor),
            slider.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    // MARK: - Slider Value Change Handler

    @objc private func sliderValueChanged(_ sender: UISlider) {
        // 将滑动结果通过闭包传递出去
        valueChanged?(sender.value)
    }

    // MARK: - Public Methods

    // 配置滑动条参数
    func configure(minimumValue: Float, maximumValue: Float, initialValue: Float, thumbImage: UIImage?) {
        slider.minimumValue = minimumValue
        slider.maximumValue = maximumValue
        slider.value = initialValue
        if let image = thumbImage {
            slider.setThumbImage(image, for: .normal)
        }
    }

    // 配置滑动条颜色
    func setSliderColor(minimumTrackColor: UIColor, maximumTrackColor: UIColor) {
        slider.minimumTrackTintColor = minimumTrackColor
        slider.maximumTrackTintColor = maximumTrackColor
    }

    // 外部方法：设置滑动条的值
        func setSliderValue(_ value: Float, animated: Bool = true) {
            slider.setValue(value, animated: animated)
            // 手动触发 valueChanged 闭包
//            valueChanged?(slider.value)
        }


}
// 自定义 UISlider 类来修改 trackRect
class CustomSlider: UISlider {
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        // 修改滑动条的高度为 4
        let customBounds = CGRect(origin: bounds.origin, size: CGSize(width: bounds.width, height: 6))
        return customBounds
    }
}
