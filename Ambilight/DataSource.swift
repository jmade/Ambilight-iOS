//
//  DataSource.swift
//  Ambilight
//
//  Created by Justin Madewell on 7/3/18.
//  Copyright © 2018 Jmade. All rights reserved.
//

import UIKit

struct DataSource<T> {
    
    struct Section {
        let title: String
        let rows:[T]
    }
    
    let title: String
    let sections: [Section]
    
    init(_ title:String="",_ sections:[Section]=[]) {
        self.title = title
        self.sections = sections
    }
    
    var numberOfSections: Int {
        get {
            return sections.count
        }
    }
    
    func numberOfRowsInSection(_ section:Int) -> Int {
        return sections[section].rows.count
    }
    
    func itemForRowAtIndexPath(_ indexPath:IndexPath) -> T {
        return sections[indexPath.section].rows[indexPath.row]
    }
    
    func titleForHeaderInSection(_ section:Int) -> String {
        return sections[section].title
    }
    
}

extension DataSource {
    
    init(ambilightOptions:[AmbilightOption]) {
        typealias Section = DataSource<AmbilightOption>.Section
        
        let sectionTitles = Array(Set(ambilightOptions.map({$0.catagory.rawValue})))
        
        var sections: [Section] = []
        for title in sectionTitles {
            let rows = ambilightOptions.filter({ $0.catagory.rawValue == title })
            let title = (rows.first?.catagory.displayValue() ?? "=")
            sections.append(Section(title:title, rows: rows))
        }
        
        self.title = "Ambilight"
        self.sections = sections as! [DataSource<T>.Section]
    }
}
