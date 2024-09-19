import UIKit

protocol PopupSelectionDelegate: AnyObject {
    func didSelectOption(_ option: Int)
}

class PopupSelectionView: UIView, UITableViewDelegate, UITableViewDataSource {

    weak var delegate: PopupSelectionDelegate?

    private let options: [String] = ["Sort by Newest", "Sort by Name (A to Z)", "Sort by Size"]
    private let Icons: [String] = ["Group_Hnewest", "Group_Hname", "Group_HSize"]

    private var selectedOption: Int
    private let tableView = UITableView()

    // 遮罩层
    private var customMaskView: UIView!

    init(frame: CGRect, selectedOption: Int) {
        self.selectedOption = selectedOption
        super.init(frame: frame)

        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // 初始化视图
    private func setupView() {
        self.backgroundColor = .clear

        // 遮罩层
        customMaskView = UIView(frame: UIScreen.main.bounds)
        customMaskView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissPopup))
        customMaskView.addGestureRecognizer(tapGesture)
        self.addSubview(customMaskView)

        // 弹窗视图
        let popupView = UIView(frame: CGRect(x: kScreenWidth - 238 - 20, y: kNavBarHeight + 60, width: 238, height: 46 * 3 + 20))
        popupView.backgroundColor = .white
        popupView.layer.cornerRadius = 20
        popupView.layer.masksToBounds = true
        self.addSubview(popupView)

        // 配置 UITableView
        tableView.frame = CGRect(x: 10, y: 10, width: popupView.width - 10, height: popupView.height - 10)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        tableView.register(popCustomTableViewCell.self, forCellReuseIdentifier: "popCustomTableViewCell")
        popupView.addSubview(tableView)
    }

    // 隐藏弹窗
    @objc private func dismissPopup() {
        self.removeFromSuperview()
    }

    // MARK: - UITableView DataSource & Delegate

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 46
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "popCustomTableViewCell", for: indexPath) as? popCustomTableViewCell else {
            return UITableViewCell()
        }
        
        let icon = UIImage(named: Icons[indexPath.row]) // 设置图标，这里用系统图标作为示例
        
        // 配置 Cell
        cell.configure(with: options[indexPath.row], icon: icon, isSelected: indexPath.row == selectedOption)
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 更新选中项
        selectedOption = indexPath.row


        // 调用代理方法，将选择结果传回控制器
        delegate?.didSelectOption(selectedOption)

        // 刷新表格以更新勾选状态
        tableView.reloadData()

        // 隐藏弹窗
        dismissPopup()
    }
}


class popCustomTableViewCell: UITableViewCell {
    
    // 左侧图标
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    // 标题
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    // 右侧对号图标
    private let checkmarkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Group_HChoose")
        imageView.isHidden = true // 初始状态隐藏
        return imageView
    }()
    
    // 初始化
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupCellLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 设置 Cell 布局
    private func setupCellLayout() {
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(checkmarkImageView)
        
        // 使用 SnapKit 布局
        iconImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(15)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconImageView.snp.trailing).offset(12)
            make.centerY.equalToSuperview()
        }
        
        checkmarkImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(18)
        }
    }
    
    // 配置 Cell 的数据
    func configure(with title: String, icon: UIImage?, isSelected: Bool) {
        titleLabel.text = title
        iconImageView.image = icon
        checkmarkImageView.isHidden = !isSelected
    }
}
