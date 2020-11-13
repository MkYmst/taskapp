//
//  CategoryViewController.swift
//  taskapp
//
//  Created by MikaYamashita on 2020/11/11.
//  Copyright © 2020 mika.yamashita. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    // Realmインスタンスを取得する
    let realm = try! Realm()
    var category = Category()
    var calistID:Int = 1
    
    var uiTextField = UITextField()

    // DB内のタスクが格納されるリスト。
    // 日付の近い順でソート：昇順
    // 以降内容をアップデートするとリスト内は自動的に更新される。
    var catArray = try! Realm().objects(Category.self)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // データの数（＝セルの数）を返すメソッド
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catArray.count
    }

    // 各セルの内容を返すメソッド
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 再利用可能な cell を得る
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        // Cellに値を設定する.  --- ここから ---
        let catn = catArray[indexPath.row]
        cell.textLabel?.text = catn.name

        return cell
    }

    // 各セルを選択した時に実行されるメソッド
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }

    // セルが削除が可能なことを伝えるメソッド
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath)-> UITableViewCell.EditingStyle {
        return .delete
    }

    // Delete ボタンが押された時に呼ばれるメソッド
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    }
    
    //Realmでデータを追加
    func write(){
        
        if catArray.count != 0 {
            //category.id = catArray.max(ofProperty: "id")! + 1
            //print(catArray.count)
            calistID = catArray.count

        }else{
            calistID = 0
        }
       
        let cat = Category(value: ["name":uiTextField.text!,"id":calistID])
        
        try! realm.write{
            self.category = cat
            self.realm.add(self.category, update: .modified)
        }
        tableView.reloadData()
    }
    
    @IBAction func addBtn(_ sender: Any) {
        
        //アラートコントローラー
        let alert = UIAlertController(title: "追加したいカテゴリ名", message:nil, preferredStyle: .alert)
        
        //OKボタンを生成
        let okAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
            
            if (self.uiTextField.text != "" && self.uiTextField.text != nil){
                
                    self.write()
            }
            
            //print(uiTextField.text!)
        }
        //OKボタンを追加
        alert.addAction(okAction)
        
        //Cancelボタンを生成
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        //Cancelボタンを追加
        alert.addAction(cancelAction)
        
        //TextFieldを追加
        alert.addTextField { (text:UITextField!) in
            text.placeholder = "テキストを入力してください"
            self.uiTextField = text
        }
        
        //アラートを表示
        present(alert, animated: true, completion: nil)
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
