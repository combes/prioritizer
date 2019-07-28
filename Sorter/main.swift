//
//  main.swift
//  Sorter
//
//  Created by Christopher Combes on 7/28/19.
//  Copyright © 2019 Christopher Combes. All rights reserved.
//

import Foundation

func loadItems() -> [String]? {
    let currentDirectoryURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
    let bundleURL = URL(fileURLWithPath: "Data.bundle", relativeTo: currentDirectoryURL)
    
    guard let path = Bundle(url: bundleURL)?.path(forResource: "item_list", ofType: "txt"),
        let items = try? String(contentsOfFile: path, encoding: String.Encoding.utf8) else {
            print("Could not load items")
            return nil
    }
    
    var array = items.components(separatedBy: "\n")
    array = array.filter({ $0 != "" })

    return array
}

func promptUser(itemOne: String, itemTwo: String) -> String? {
    print(String(repeating: "\n", count: 20))
    print("Which is more important?")
    print("1. \(itemOne)\n2. \(itemTwo)")
    print("> ", separator: "", terminator: "")
    
    return readLine()
}

func sortItems() {
    guard let items = loadItems() else {
        return
    }
    
    var array: [String] = []
    var compared: [(String, String)] = []
    
    // Iterate through items comparing each only once
    for itemOne in items {
        for itemTwo in items.filter({ (value) -> Bool in
            if itemOne == value {
                return false
            }
            // We compared these two items already
            return true
        }) {
            
            // Check if we compared these two items already
            if compared.contains(where: { (values) -> Bool in
                if values.0 == itemOne && values.1 == itemTwo ||
                    values.0 == itemTwo && values.1 == itemOne {
                    return true
                }
                return false
            }) {
                continue
            }
            
            guard let response = promptUser(itemOne: itemOne, itemTwo: itemTwo) else {
                continue
            }
            
            if !array.contains(itemOne) {
                array.append(itemOne)
            }
            
            if !array.contains(itemTwo) {
                array.append(itemTwo)
            }
            
            if let indexOne = array.firstIndex(of: itemOne),
                let indexTwo = array.firstIndex(of: itemTwo) {
                
                if response == "1" {
                    
                    if indexOne > indexTwo {
                        let item = array.remove(at: indexOne)
                        array.insert(item, at: indexTwo)
                    }
                } else {
                    
                    if indexTwo > indexOne {
                        let item = array.remove(at: indexTwo)
                        array.insert(item, at: indexOne)
                    }
                }
            }
            
            // Save items we compared so we don't compare again
            compared.append((itemOne, itemTwo))            
        }
    }
    
    print(String(repeating: "\n", count: 20))
    print("Here are your prioritized items...\n")
    for item in array {
        print(item)
    }
}

sortItems()
