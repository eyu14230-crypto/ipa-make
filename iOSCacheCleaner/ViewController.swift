import UIKit

final class ViewController: UIViewController {

    private let titleLabel = UILabel()
    private let logView = UITextView()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        titleLabel.text = "正在hook你的设备……"
        titleLabel.font = .boldSystemFont(ofSize: 24)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        logView.font = .monospacedSystemFont(ofSize: 13, weight: .regular)
        logView.isEditable = false
        logView.isSelectable = true
        logView.layer.cornerRadius = 12
        logView.backgroundColor = .secondarySystemBackground
        logView.text = "[初始化] 正在准备hook……"
        logView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(titleLabel)
        view.addSubview(logView)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 24
            ),
            titleLabel.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 20
            ),
            titleLabel.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -20
            ),

            logView.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor,
                constant: 20
            ),
            logView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: 16
            ),
            logView.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -16
            ),
            logView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: -20
            )
        ])

        startCleaning()
    }

    private func startCleaning() {
        appendLog("[开始] 正在hook你的设备……")

        DispatchQueue.global(qos: .userInitiated).async {
            let result = CacheCleaner.clean { message in
                DispatchQueue.main.async {
                    self.appendLog(message)
                }
            }

            DispatchQueue.main.async {
                self.titleLabel.text = "hook完成"
                self.appendLog("")
                self.appendLog(result)
            }
        }
    }

    private func appendLog(_ text: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"

        let timestamp = formatter.string(from: Date())

        if text.isEmpty {
            logView.text += "\n"
        } else {
            logView.text += "[\(timestamp)] \(text)\n"
        }

        let range = NSRange(
            location: max(logView.text.count - 1, 0),
            length: 1
        )

        if range.location < logView.text.utf16.count {
            logView.scrollRangeToVisible(range)
        }
    }

    func showResult(_ result: String) {
        titleLabel.text = "hook完成"
        appendLog(result)
    }
}
