
import Foundation
import Darwin

enum ScriptRunner {
    static func run(script: String) -> String {
        let shellCandidates = ["/bin/sh", "/bin/bash"]
        let shell = shellCandidates.first { FileManager.default.isExecutableFile(atPath: $0) }

        guard let shell else {
            return "失败：设备环境没有可用的 /bin/sh 或 /bin/bash。\n"
        }

        var outPipe: Int32 = -1
        var errPipe: Int32 = -1
        var outFD = [Int32](repeating: -1, count: 2)
        var errFD = [Int32](repeating: -1, count: 2)

        guard pipe(&outFD) == 0, pipe(&errFD) == 0 else {
            return "失败：无法创建输出管道。\n"
        }

        var argv: [UnsafeMutablePointer<CChar>?] = []
        argv.append(strdup(shell))
        argv.append(strdup(script))
        argv.append(nil)

        var pid: pid_t = 0
        let rc = argv.withUnsafeMutableBufferPointer { buffer in
            posix_spawn(&pid, shell, nil, nil, buffer.baseAddress, environ)
        }

        for p in argv where p != nil { free(p) }

        if rc != 0 {
            close(outFD[0]); close(outFD[1])
            close(errFD[0]); close(errFD[1])
            return "执行失败，posix_spawn 错误码：\(rc)\n"
        }

        close(outFD[1])
        close(errFD[1])

        let stdoutData = FileHandle(fileDescriptor: outFD[0], closeOnDealloc: true).readDataToEndOfFile()
        let stderrData = FileHandle(fileDescriptor: errFD[0], closeOnDealloc: true).readDataToEndOfFile()

        var status: Int32 = 0
        waitpid(pid, &status, 0)

        let stdoutText = String(data: stdoutData, encoding: .utf8) ?? ""
        let stderrText = String(data: stderrData, encoding: .utf8) ?? ""

        var result = stdoutText
        if !stderrText.isEmpty {
            result += "\n[stderr]\n" + stderrText
        }

        if WIFEXITED(status) {
            result += "\n\n退出码：\(WEXITSTATUS(status))"
        } else {
            result += "\n\n进程未正常退出。"
        }

        return result
    }
}
