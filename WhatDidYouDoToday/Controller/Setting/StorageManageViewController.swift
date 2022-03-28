//
//  StorageManageViewController.swift
//  TimeTodoPlanner
//
//  Created by Taehoon Kim on 2022/01/24.
//

import UIKit
import RealmSwift

class StorageManageViewController: UITableViewController {
    
    // 데이터 저장, 복원에 사용될 FileManager
    let fileManager = FileManager.default
    // realm이 저장된 위치
    let defaultURL = Realm.Configuration.defaultConfiguration.fileURL!
    // Document 기본위치
    let localDocumentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    // 백업 위치, 이름
    
    enum StorageManageOption: Int, CaseIterable {
        case backup
        case restore
    }
    
    struct StorageManageViewModel {
        var option: StorageManageOption
        var title:String {
            switch option {
            case .backup:
                return I18NStrings.Setting.backUp
            case .restore:
                return I18NStrings.Setting.restore
            }
        }
        
        init(option: StorageManageOption) {
            self.option = option
        }
    }
    //MARK: - lifeCycle
    override func viewDidLoad() {
        navigationItem.title = I18NStrings.Setting.iCloud
        tableView.backgroundColor = .white
        tableView.separatorStyle = .singleLine
        tableView.tableFooterView = UIView()
    }
}



// MARK: - UITableViewDataSource
extension StorageManageViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StorageManageOption.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        
        guard let option = StorageManageOption(rawValue: indexPath.row) else {
            return cell
        }
        
        let viewModel = StorageManageViewModel(option: option)
        
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = viewModel.title
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension StorageManageViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let option = StorageManageOption(rawValue: indexPath.row) else {
            return
        }
        
        switch option {
        
        case .backup:
            uploadDatabaseToDrive()
        case .restore:
            AlertHelper.showAlert(title: I18NStrings.Setting.restoreMessageTitle, message: I18NStrings.Setting.restoreMessage, type: .delete, over: self) { (_) in
                let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.data])
                documentPicker.delegate = self
                documentPicker.allowsMultipleSelection = false
                self.present(documentPicker, animated: true, completion: nil)
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

// MARK: - UIDocumentPickerDelegate

extension StorageManageViewController: UIDocumentPickerDelegate {
    
    // 파일을 선택했을 때 동작한 함수
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
        guard  let url = urls.first else { return }
        downloadDatabaseFromDrive(url: url)
        
        controller.dismiss(animated: true) {
            AlertHelper.showAlert(title: I18NStrings.Setting.restoreCompleteTitle, message: I18NStrings.Setting.restoreCompleteMessage, type: .basic, over: self, handler: nil)
        }
    }
    
    // 취소를 눌렀을 때 동작하는 함수
    public func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        controller.dismiss(animated: true)
    }
}

extension StorageManageViewController {
    func uploadDatabaseToDrive() {
        let documentToCheckURL = localDocumentsURL.appendingPathComponent("todo_default.realm", isDirectory: false)
        let realmArchiveURL = documentToCheckURL
        
        if(fileManager.fileExists(atPath: realmArchiveURL.path))
        {
            do
                {
                    try fileManager.removeItem(at: realmArchiveURL)
                    let realm = try! Realm()
                    try! realm.writeCopy(toFile: realmArchiveURL)
                    
                }catch
                {
                    print("DEBUG: uploadDatabaseToDrive ERR is \(error)")
                }
        }
        else
        {
            let realm = try! Realm()
            try! realm.writeCopy(toFile: realmArchiveURL)
        }
        
        let documentController = UIDocumentPickerViewController(forExporting: [realmArchiveURL], asCopy: true)
        present(documentController, animated: true, completion: nil)
        
    }
    
    func downloadDatabaseFromDrive(url backupURL: URL) {
        autoreleasepool {
            try! FileManager.default.removeItem(at: defaultURL)
            try! FileManager.default.copyItem(at: backupURL, to: defaultURL)
        }
    }
}
