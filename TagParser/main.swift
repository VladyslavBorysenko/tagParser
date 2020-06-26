//
//  main.swift
//  TagParser
//
//  Created by Владислав on 18.03.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

struct Stack<T>{
    private var array: [T] = []
    
    mutating func push( _ stackElement: T) -> (){
        array.append(stackElement)
    }
    mutating func pop() -> T?{
         return array.removeLast()
    }
    func peak() -> T?{
        return array.last
    }
    func isEmply()->Bool{
      return array.isEmpty
    }
    func count()-> Int{
        return array.count
    }
}


func matches(for regex: String, in text: String) -> [String]{
    //Return array of divided <tags> without any text between them
    do {
        let regex = try NSRegularExpression(pattern: regex)
        let results = regex.matches(in: text, range: NSRange(text.startIndex..., in: text))
        return results.map {
            String(text[Range($0.range, in: text)!])
        }
        
    } catch let error {
        print("invalid regex: \(error.localizedDescription)")
        return []
    }
}

func compare(_ first: String, with second: String) -> Bool{
    //Checks to see if tags are open/closing tag pairs
    if Array(first)[1...] == Array(second)[2...]{
        return true
    } else {
        return false
    }
}


func checkTags(in text: String?) -> String{
    var tagsFromText = Stack<String>()
    if let tags = text{
        let regex = try! NSRegularExpression(pattern: "</[^>]*>")
        for tag in matches(for: "<[^>]*>", in: tags){
            if (regex.firstMatch(in: tag, range: NSRange(tag.startIndex..., in: tag)) != nil){
                guard let _ = tagsFromText.peak() else {return "There is unclosed tag1 \(tag)"}
                guard compare(tagsFromText.peak()!, with: tag) else {return "Tags are not corresponding"}
                tagsFromText.pop()
            } else {
                tagsFromText.push(tag)
            }
        }
    }
    if tagsFromText.isEmply(){
        return "All tags are closed"
    } else {
        return "There are unclosed tags"
    }
}

let inputText = readLine()

print(checkTags(in: inputText))


