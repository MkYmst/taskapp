//
//  InputViewController.swift
//  taskapp
//
//  Created by MikaYamashita on 2020/11/08.
//  Copyright © 2020 mika.yamashita. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications

class InputViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var categoryPicker: UIPickerView!
    
    
    let realm = try! Realm()
    var task: Task!
    var taskArray = try! Realm().objects(Task.self)
    
    var category:Category!
    var catArray = try! Realm().objects(Category.self)
    var calist:Array<String> = []
    var calistID:Int = 1
    var cateName:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 背景をタップしたらdismisskeyborardメソッドを呼ぶように設定する
        let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)

        titleTextField.text = task.title
        contentsTextView.text = task.contents
        datePicker.date = task.date
        
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        calist = []
        for cate in catArray{
            calist.append(cate.name)
        }

        //UIPickerViewの初期値
        if taskArray.count != 0{
            categoryPicker.selectRow(taskArray[0].categorys!.id, inComponent: 0, animated: false)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        try! realm.write{
            self.task.title = self.titleTextField.text!
            self.task.contents = self.contentsTextView.text
            self.task.date = self.datePicker.date
            if cateName != ""{
            let somecate = catArray.filter("name = %@", cateName)
            self.task.categorys = somecate[0]
            }
            self.realm.add(self.task, update: .modified)
        }
        if cateName != ""{
            let somecate = catArray.filter("name = %@", cateName)
            try! realm.write{
                somecate[0].tasks.append(task)
            }
        }
        setNotification(task: task)
        
        super.viewWillDisappear(animated)
    }
    
    // UIPickerViewの列の数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // UIPickerViewの行数、要素の全数
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return catArray.count
    }
    
    // UIPickerViewに表示する配列
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //return catArray[row]
        return calist[row]
        
    }
    // UIPickerViewのRowが選択された時の挙動
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        cateName = calist[row]
        calistID = row
        //print(cateName)
    }
    
    
    //タスクのローカル通知を登録する
    func setNotification(task:Task){
        let content = UNMutableNotificationContent()
        //タイトルと内容を設定（中身がない場合メッセージ無しで音だけの通知になるので「（××なし）」を表示する）
        if task.title == ""{
            content.title = "（タイトルなし）"
        }else{
            content.title = task.title
        }
        if task.contents == ""{
            content.body = "（内容なし）"
        }else{
            content.body = task.contents
        }
        content.sound = UNNotificationSound.default
        
        //ローカル通知が発動するtrigger(日付マッチ)を作成
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year,.month,.day,.hour,.minute], from: task.date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        //identifier, content,triggerからローカル通知を作成（identifierが同じだとローカル通知を上書き保存）
        let request = UNNotificationRequest(identifier: String(task.id), content: content, trigger: trigger)
        
        //ローカル通知を登録
        let center = UNUserNotificationCenter.current()
        center.add(request){
            (error) in print(error ?? "ローカル通知登録OK") //errorがnilならローカル通知の登録に成功したと表示します。errorが存在すればerooerを表示します。
        }
        
        //未通知のローカル通知一覧をログ出力
        center.getPendingNotificationRequests{
            (requests:[UNNotificationRequest]) in for request in requests{
                print("/---------------")
                print(request)
                print("---------------/")
            }
        }
    }
    
    @objc func dismissKeyboard(){
        //キーボードを閉じる
        view.endEditing(true)
    }
    
    // 入力画面から戻ってきた時に UIPickerViewを更新させる
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        calist = []
        for cate in catArray{
            calist.append(cate.name)
        }
        categoryPicker.reloadAllComponents()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
