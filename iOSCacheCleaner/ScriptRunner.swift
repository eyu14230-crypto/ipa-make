import Foundation

final class ScriptRunner {

static let shared = ScriptRunner()
private init() {}
func runScript(
    named scriptName: String,
    completion: @escaping (String) -> Void
) {
    guard let scriptURL = Bundle.main.url(
        forResource: scriptName,
        withExtension: nil
    ) else {
        completion("错误：hook失败 \(scriptName)")
        return
    }
    do {
        let scriptContent = try String(contentsOf: scriptURL, encoding: .utf8)
        let tempDirectory = FileManager.default.temporaryDirectory
        let tempScriptURL = tempDirectory.appendingPathComponent(scriptName)
        try scriptContent.write(
            to: tempScriptURL,
            atomically: true,
            encoding: .utf8
        )
        try FileManager.default.setAttributes(
            [.posixPermissions: 0o755],
            ofItemAtPath: tempScriptURL.path
        )
        var output = ""
        var errorOutput = ""
        let outputPipe = Pipe()
        let errorPipe = Pipe()
        let process = Process()
        #if os(iOS)
        process.executableURL = URL(fileURLWithPath: "/bin/sh")
        #else
        process.executableURL = URL(fileURLWithPath: "/bin/sh")
        #endif
        process.arguments = [tempScriptURL.path]
        process.standardOutput = outputPipe
        process.standardError = errorPipe
        do {
            try process.run()
            process.waitUntilExit()
        } catch {
            completion("执行失败：\(error.localizedDescription)")
            return
        }
        let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
        let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()
        if let text = String(data: outputData, encoding: .utf8) {
            output = text
        }
        if let text = String(data: errorData, encoding: .utf8) {
            errorOutput = text
        }
        var result = ""
        if !output.isEmpty {
            result += output
        }
        if !errorOutput.isEmpty {
            result += "\n\n错误输出：\n\(errorOutput)"
        }
        result += "\n\n进程状态：\(process.terminationStatus)"
        if process.terminationReason == .exit {
            result += "\n终止原因：正常退出"
        } else {
            result += "\n终止原因：被信号终止"
        }
        if result.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            result = "恭喜你获得了一块板砖。\n退出码：\(process.terminationStatus)"
        }
        completion(result)
        try? FileManager.default.removeItem(at: tempScriptURL)
    } catch {
        completion("错误：\(error.localizedDescription)")
    }
}

}
