
import UIKit

final class ViewController: UIViewController {
    private let output = UITextView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        let title = UILabel()
        title.text = "iOS 缓存清理器"
        title.font = .boldSystemFont(ofSize: 26)

        let start = UIButton(type: .system)
        start.setTitle("开始执行", for: .normal)
        start.titleLabel?.font = .boldSystemFont(ofSize: 18)
        start.addTarget(self, action: #selector(runScript), for: .touchUpInside)

        output.isEditable = false
        output.font = .monospacedSystemFont(ofSize: 13, weight: .regular)
        output.text = "脚本已内置：ios终端清理垃圾.sh\n\n注意：iOS 沙盒通常不允许 App 直接访问系统目录。是否能够执行取决于设备当前环境。\n"

        let stack = UIStackView(arrangedSubviews: [title, start, output])
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }

    @objc private func runScript() {
        guard let script = Bundle.main.path(forResource: "ios终端清理垃圾", ofType: "sh") else {
            output.text = "错误：找不到内置脚本。"
            return
        }

        output.text = "正在尝试执行脚本...\n\n"

        DispatchQueue.global(qos: .userInitiated).async {
            let result = ScriptRunner.run(script: script)

            DispatchQueue.main.async {
                self.output.text += result
            }
        }
    }
}
