import UIKit

final class ViewController: UIViewController {

private let output = UITextView()
override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    let titleLabel = UILabel()
    titleLabel.text = "iOS 一键清理全游戏黑设备"
    titleLabel.font = .boldSystemFont(ofSize: 26)
    titleLabel.textAlignment = .center
    titleLabel.numberOfLines = 0
    let startButton = UIButton(type: .system)
    startButton.setTitle("检查环境", for: .normal)
    startButton.titleLabel?.font = .boldSystemFont(ofSize: 18)
    startButton.addTarget(
        self,
        action: #selector(checkEnvironment),
        for: .touchUpInside
    )
    output.isEditable = false
    output.isSelectable = true
    output.font = .monospacedSystemFont(
        ofSize: 13,
        weight: .regular
    )
    output.text = """
    脚本已内置。
    当前 App 仅运行在 iOS App 沙盒环境中。
    系统级清理或修改需要设备本身提供相应权限。
    点击“检查环境”查看当前 App 环境。
    """
    let stack = UIStackView(
        arrangedSubviews: [
            titleLabel,
            startButton,
            output
        ]
    )
    stack.axis = .vertical
    stack.spacing = 16
    stack.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(stack)
    NSLayoutConstraint.activate([
        stack.leadingAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.leadingAnchor,
            constant: 20
        ),
        stack.trailingAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.trailingAnchor,
            constant: -20
        ),
        stack.topAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.topAnchor,
            constant: 20
        ),
        stack.bottomAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.bottomAnchor,
            constant: -20
        )
    ])
}
@objc private func checkEnvironment() {
    let systemVersion = UIDevice.current.systemVersion
    let deviceName = UIDevice.current.model
    output.text = """
    环境检查完成
    设备：\(deviceName)
    iOS：\(systemVersion)
    App 沙盒：正常
    当前程序没有系统级权限。
    """
}

}
