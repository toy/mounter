import Foundation
import Security

func getPassword(uuid: String) -> String? {
  let query: [String: Any] = [
    kSecClass as String: kSecClassGenericPassword,
    kSecAttrDescription as String: "Encrypted Volume Password",
    kSecAttrService as String: uuid,
    kSecAttrAccount as String: uuid,
    kSecReturnData as String: true
  ]

  var item: CFTypeRef?
  let status = SecItemCopyMatching(query as CFDictionary, &item)

  guard status == errSecSuccess
  else {
    print("Error: \(status)")
    return nil
  }

  guard let data = item as? Data,
        let password = String(data: data, encoding: .utf8)
  else {
    return nil
  }

  return password
}

func unlockNMount(uuid: String, password: String) -> Bool {
  let process = Process()
  process.executableURL = URL(fileURLWithPath: "/usr/sbin/diskutil")
  process.arguments = ["apfs", "unlockVolume", uuid, "-stdinpassphrase"]

  let inputPipe = Pipe()
  process.standardInput = inputPipe

  do {
    try process.run()
  } catch {
    print("Failed to run process: \(error)")
    return false
  }

  let fileHandleForWriting = inputPipe.fileHandleForWriting
  if let data = password.data(using: .utf8) {
    fileHandleForWriting.write(data)
  }
  fileHandleForWriting.closeFile()

  process.waitUntilExit()

  return process.terminationStatus == 0
}

if CommandLine.arguments.count != 2 {
  print("Usage: \(CommandLine.arguments[0]) <uuid>")
  exit(1)
}

let uuid = CommandLine.arguments[1]

guard let password = getPassword(uuid: uuid)
else {
  print("Got no password for uuid \(uuid)")
  exit(1)
}

if !unlockNMount(uuid: uuid, password: password) {
  print("Failed to unlock the volume")
  exit(1)
}
