//
//  Task.swift
//  taskapp
//
//  Created by MikaYamashita on 2020/11/08.
//  Copyright © 2020 mika.yamashita. All rights reserved.
//

import RealmSwift

class Task: Object{
    //管理用 ID。プライマリーキー
    @objc dynamic var id = 0
    
    //カテゴリ
    @objc dynamic var category = ""
    
    //タイトル
    @objc dynamic var title = ""
    
    //内容
    @objc dynamic var contents = ""
    
    //日時
    @objc dynamic var date = Date()
    
    //idをプライマリーキーとして設定
    override static func primaryKey() -> String?{
        return "id"
    }
}
