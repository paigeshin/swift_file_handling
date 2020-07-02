//
//  ViewController.swift
//  FileHandling
//
//  Created by shin seunghyun on 2020/07/02.
//  Copyright © 2020 shin seunghyun. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
      
    }

    /**
     Every iOS app gets a slice of storage just for itself, meaning that you can read and write your app's files there without worrying about colliding with other apps. This is called the user's documents directory, and it's exposed both in code (as you'll see in a moment) and also through iTunes file sharing.

     Unfortunately, the code to find the user's documents directory isn't very memorable, so I nearly always use this helpful function – and now you can too
     **/
    func getDocumentsDirectory() -> URL {
        let paths: [URL] = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory: URL = paths[0]
        print(documentsDirectory.absoluteString)
        return documentsDirectory
    }
    
    
    func createDirectory(withFolderName dest: String, toDirectory directory: FileManager.SearchPathDirectory = .applicationSupportDirectory) {
        let fileManager: FileManager = FileManager.default //get FileManager
        print("applcaitionSupportDirectory: \(directory)") //기본적으로 applicationSupportDirectory는 app의 핵심이 되는 user directory를 의미.
        /* userDomainMask: The user’s home directory—the place to install user’s personal items (~). */
        let urls: [URL] = fileManager.urls(for: directory, in: .userDomainMask) //getURLs, .userDomainMask => 유저의 파일을 의미.
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
    
    func removeDirectory(withDirectoryName originName: String, toDirectory directory: FileManager.SearchPathDirectory = .applicationSupportDirectory) {
        let fileManager: FileManager = FileManager.default //FileManager 가져옴
        let path: [URL] = FileManager.default.urls(for: directory, in: .userDomainMask) //현재 유저의 모든 directory url을 가져옴
        if let originURL: URL = path.first?.appendingPathComponent(originName) { //해당 이름의 file이 존재하는지 안하는지 확인하고 해당 directory의 URL을 반납함.
            do {
                try fileManager.removeItem(at: originURL)
            } catch {
                print("\(error) error")
            }
        }
    }
    
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

}


//Remove Item
extension ViewController {
    
    //Delete Items
    //FileManager has a .removeItem method that does have a choice of either using URL or filepath
    func removeItem(withItemName originName: String, toDirectory directory: FileManager.SearchPathDirectory = .applicationSupportDirectory) {
        let fileManager: FileManager = FileManager.default
        let urls: [URL]? = FileManager.default.urls(for: directory, in: .userDomainMask)
        if let originURL: URL = urls?.first?.appendingPathComponent(originName) {
            do {
                try fileManager.removeItem(at: originURL)
            } catch {
                print("\(error) error")
            }
        }
    }
    
    //Delete Items with Subfolder
    func removeItem(withItemName originName: String, withSubDirectory dir: String, toDirectory directory: FileManager.SearchPathDirectory = .applicationSupportDirectory) {
        let fileManger: FileManager = FileManager.default
        let urls: [URL] = FileManager.default.urls(for: directory, in: .userDomainMask)
        if let originURL: URL = urls.first?.appendingPathComponent(dir + "/" + originName) {
            do {
                try fileManger.removeItem(at: originURL)
            }
            catch let error {
                print ("\(error) error")
            }
        }
    }
    
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
    
}

//Copy Items
extension ViewController {
    
    //it does not guarantee the success of operation
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
    
}

//Moving Items, these operations are not atomic
extension ViewController {
    
    func moveItems(originURL: URL, destinationURL: URL, originPath: String, destinationPath: String) {
        let fileManager: FileManager = FileManager.default
        try! fileManager.moveItem(at: originURL, to: destinationURL)
        try! fileManager.moveItem(atPath: originPath, toPath: destinationPath)
    }
    
    
}
