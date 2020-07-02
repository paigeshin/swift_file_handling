# swift_file_handling

# Notion
[File Handling](https://www.notion.so/Swift-File-Handling-795e48b7d2294caf95bae11283442d43)


# Other Resources

[https://medium.com/swlh/file-handling-using-swift-f27895b19e22](https://medium.com/swlh/file-handling-using-swift-f27895b19e22)

[https://www.hackingwithswift.com/example-code/system/how-to-find-the-users-documents-directory](https://www.hackingwithswift.com/example-code/system/how-to-find-the-users-documents-directory)

### Terminology

- **Atomic file operations:** Methods that can't be interrupted or partially completed.
- **File System:** Handles the persistent storage of data files, apps, and the files associated with the operating system itself.
- **SearchPathDirectory:** The location of significant folders on iOS devices.
- **Sandbox:** A set of fine-grained controls that limit the app's access to files, preferences, network resources, hardware.

### Sandbox

- You also have restrictions.

> For security purposes, an iOS app’s interactions with the file system are limited to the directories inside the app’s sandbox directory. During installation of a new app, the installer creates a number of container directories for the app inside the sandbox directory. Each container directory has a specific role. The bundle container directory holds the app’s bundle, whereas the data container directory holds data for both the app and the user. The data container directory is further divided into a number of subdirectories that the app can use to sort and organize its data. The app may also request access to additional container directories — for example, the iCloud container–at runtime.

- The bundle container directory holds the app's bundle.
- The data container directory is further divided into a number of subdirectories.
- The app may also request access to additional container directories. (the iCloud container)

### Seeing your files

# **Seeing your files**

Using the simulator you can see the files that are currently within your App bundle. Where?

```
User>Library>Developer>CoreSimulator>Devices
```

```
“/Users/user/Library/Developer/CoreSimulator/Devices/37A85B0B-F2B7–4A0C-BAA7-E05A831FFAE0/data/Containers/Data/Application/AC630F5A-71D2–4DE4–82E2-D7CF328015C8"
```

# Object

### `func appendingPathComponent(_ pathComponent: String) -> URL`

- Returns a URL constructed by appending the given path component to self.
- **This function performs a file system operation to determine if the path component is a directory.** If so, it will append a trailing /. If you know in advance that the path component is a directory or not, then use func appendingPathComponent(_:isDirectory:).

### `FileManager.SearchPathDirectory` ⇒ enum

- The location of significant directories.

### `applcaitionSupportDirectory`  ⇒ Int

- 기본적으로 applicationSupportDirectory는 app의 핵심이 되는 user directory를 의미.
- A place to store files that will be used within your App.
- Application support files (Library/Application Support).

### `.userDomainMask`

- The user’s home directory—the place to install user’s personal items (~).

### `fileManager.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true`  ⇒ `appropriate For`

`appropriate for` ⇒ 어디다가 저장할지 path를 적는다.

# SearchPathDirectory

- These are the significant directories that are used.
- **applicationSupportDirectory:** A place to store files that will be used within your App.
- **cachesDirectory:** A good place to store the cashes that can be removed in your App.
- **itemReplacementDirectory:** A temporary directory.

### Paths or URLs

- A **path** is of the following format, and in this case is to file.json

```
/Users/user/Library/Developer/CoreSimulator/Devices/37A85B0B-F2B7–4A0C-BAA7-E05A831FFAE0/data/Containers/Data/Application/9FC4F273–2AD5–48E1-BCEC-5A2CCDD6CD7F/Library/Application Support/file.json
```

- A **URL** may be of the following format

```
file:///Users/user/Library/Developer/CoreSimulator/Devices/37A85B0B-F2B7–4A0C-BAA7-E05A831FFAE0/data/Containers/Data/Application/9EE0E3F2-CC53–4462-B63C-949B8C98A3BD/Library/Application%20Support/StagingBundle.bundle/Version.json
```

⇒ Absolute Path `file://`

⇒ It gives the full path of a file.

### iOS file system

![https://s3-us-west-2.amazonaws.com/secure.notion-static.com/05c74eb1-b859-43e9-9eab-53866c4dc412/Untitled.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/05c74eb1-b859-43e9-9eab-53866c4dc412/Untitled.png)

- Application Support
- Caches
- Preferences
- Saved Application State
- SplashBoard

### Get Document Directory

```swift
func getDocumentsDirectory() -> URL {
    let urls: [URL] = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let documentsDirectory: URL = urls[0]
    print(documentsDirectory.absoluteString)
    return documentsDirectory
}
//Output
/*
file:///Users/grosso/Library/Developer/CoreSimulator
/Devices/A52259F4-9D94-44BE-BC0B-36B8905F9A10/data/Containers
/Data/Application/3EAC1346-F357-4FB0-A1A4-89C35C0206E2/Documents/
*/
```

⇒ Every iOS app gets a slice of storage just for itself, meaning that you can read and write your app's files there without worrying about colliding with other apps. This is called the user's documents directory, and it's exposed both in code (as you'll see in a moment) and also through iTunes file sharing.

Unfortunately, the code to find the user's documents directory isn't very memorable, so I nearly always use this helpful function – and now you can too

### Create Directory

```swift
func createDirectory(withFolderName dest: String, toDirectory directory: FileManager.SearchPathDirectory = .applicationSupportDirectory) {
    let fileManager: FileManager = FileManager.default //get FileManager
    /* userDomainMask: The user’s home directory—the place to install user’s personal items (~). */
    let urls: [URL] = fileManager.urls(for: directory, in: .userDomainMask) //getURLs
    if let applicationSupportURL: URL = urls.last {
        do {
            var newURL: URL = applicationSupportURL
            newURL = newURL.appendingPathComponent(dest, isDirectory: true)
            try fileManager.createDirectory(at: newURL, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print("error \(error)")
        }
    }
}
```

```swift
/*
file:///Users/grosso/Library/Developer/CoreSimulator
/Devices/A52259F4-9D94-44BE-BC0B-36B8905F9A10/data/Containers
/Data/Application/3EAC1346-F357-4FB0-A1A4-89C35C0206E2/Documents/
*/
```

- Result

![https://s3-us-west-2.amazonaws.com/secure.notion-static.com/a94fd6c9-8ff5-4188-b653-cddb38b69276/Screen_Shot_2020-07-02_at_14.16.54.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/a94fd6c9-8ff5-4188-b653-cddb38b69276/Screen_Shot_2020-07-02_at_14.16.54.png)

### ℹ️ String을 data로 만드는 방법

```swift
let dataToWrite: Data = "My Interesting Data".data(using: .utf8)
```

### Writing Files

```swift
func createFileToURL(withData data: Data?, withName name: String, toDirectory directory: FileManager.SearchPathDirectory = .applicationSupportDirectory) {
    let fileManager: FileManager = FileManager.default
    let destPath: URL? = try? fileManager.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    if let fullDestPath = destPath?.appendingPathComponent(name), let data: Data = data {
        do {
            try data.write(to: fullDestPath, options: .atomic) //.atomic => gaurantees `writing operation`
        } catch let error {
            print("error \(error)")
        }
    }
}
```

- result

![https://s3-us-west-2.amazonaws.com/secure.notion-static.com/9b160e4d-8b84-4769-bf4a-0a181c88ff25/Screen_Shot_2020-07-02_at_14.58.29.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/9b160e4d-8b84-4769-bf4a-0a181c88ff25/Screen_Shot_2020-07-02_at_14.58.29.png)

### Writing File with Subdir

```swift
//with subdirectory
func createFileToURL(withData data: Data?, withName name: String, withSubDirectory subdir: String, toDirectory directory: FileManager.SearchPathDirectory = .applicationSupportDirectory)  {
    let fileManager = FileManager.default
    let destPath = try? fileManager.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    createDirectory(withFolderName: subdir, toDirectory: directory)
    if let fullDestPath = destPath?.appendingPathComponent(subdir + "/" + name), let data = data {
        do{
            try data.write(to: fullDestPath, options: .atomic)
        } catch let error {
            print ("error \(error)")
        }
    }
}
```

- result

![https://s3-us-west-2.amazonaws.com/secure.notion-static.com/7ed155b0-9ab4-465b-a591-902b95ac7224/Screen_Shot_2020-07-02_at_15.03.36.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/7ed155b0-9ab4-465b-a591-902b95ac7224/Screen_Shot_2020-07-02_at_15.03.36.png)

### writeStringToDirectory

```swift
func writeStringToDirectory(string: String, withDestinationFileName dest: String, toDirectory directory: FileManager.SearchPathDirectory = .applicationSupportDirectory, withSubDirectory: String = "") {
        if let destPath: String = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true).first {
            createDirectory(withFolderName: withSubDirectory, toDirectory: directory)
            let fullDestPath = NSURL(fileURLWithPath: destPath + "/" + withSubDirectory + "/" + dest)
            do {
                
                try string.write(to: fullDestPath as URL, atomically: true, encoding: .utf8)
            } catch let error {
                print ("error\(error)")
            }
        }
    }
```

# Copy Items

### copy direct

```swift
//it does not guarantee the success of the operation
//This file copy operation is not atomic. That means we can’t guarantee it completes.
func copyDirect(withOriginName originName: String, withDestinationName destinationName: String) {
    let fileManager: FileManager = FileManager.default
    let path: [URL]? = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)
    if let originURL: URL = path?.first?.appendingPathComponent(originName) {
        if let destinationURL: URL = path?.first?.appendingPathComponent(destinationName) {
            do {
                try fileManager.copyItem(at: originURL, to: destinationURL)
            } catch {
                print("\(error) error")
            }
        }
    }
}
```

⇒ This file copy operation is not atomic. That means we can't guarantee it completes .

### createDataTempFile

- A better way is to read the contents of a file into a temporary file (and, indeed directory as `.itemReplacementDirectory` is a good choice here.

```swift
//A better way is to read the contents of a file into a temporary file (and, indeed directory as .itemReplacementDirectory is a good choice here).
    func createDataTempFile(withData data: Data?, withFileName name: String) -> URL? {
        if let destinationURL: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileManager: FileManager = FileManager.default
            var itemReplacementDirectoryURL: URL?
            do {
                //Pass this constant to the FileManager method url(for:in:appropriateFor:create:) in order to create a temporary directory.
                //TEMP file에서 파일을 쓰고 난 뒤에, appropriateFor에 destURL을 넣어줌
                try itemReplacementDirectoryURL = fileManager.url(for: .itemReplacementDirectory, in: .userDomainMask, appropriateFor: destinationURL, create: true)
            } catch let error {
                print("error \(error)")
            }
            guard let destURL: URL = itemReplacementDirectoryURL else {return nil}
            guard let data: Data = data else {return nil}
            let tempFileURL: URL = destURL.appendingPathComponent(name)
            do {
                try data.write(to: tempFileURL, options: .atomic)
                return tempFileURL
            } catch let error {
                print ("error \(error)")
                return nil
            }
        }
        return nil
    }
```

### replaceExisitingFile

```swift
func replaceExistingFile(withTempFile fileURL: URL?, existingFileName: String, withSubDirectory: String) {
    guard let fileURL: URL = fileURL else {return}
    let fileManager: FileManager = FileManager.default
    let destPath = try? fileManager.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    if let fullDestPath = destPath?.appendingPathComponent(withSubDirectory + "/" + existingFileName) {
        do {
            let dta = try Data(contentsOf: fileURL)
            createDirectory(withFolderName: "\(withSubDirectory)", toDirectory: .applicationSupportDirectory)
            try dta.write(to: fullDestPath, options: .atomic)
        }
        catch let error {
            print ("\(error)")
        }
    }
}
```

# Move Items

```swift
//Moving Items, these operations are not atomic
extension ViewController {
    
    func moveItems(originURL: URL, destinationURL: URL, originPath: String, destinationPath: String) {
        let fileManager: FileManager = FileManager.default
        try! fileManager.moveItem(at: originURL, to: destinationURL)
        try! fileManager.moveItem(atPath: originPath, toPath: destinationPath)
    }
    
    
}
```

⇒ These operations are not atomic
