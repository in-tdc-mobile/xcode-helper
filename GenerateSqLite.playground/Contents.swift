//: Playground - noun: a place where people can play

import UIKit

let EntityName = "VesselPosition"

let ElementList = ["VesselObjectId","PositionDateTime" ,"Latitude","Longitude","Speed","AverageSpeed","Heading"]

var result:[String] = []
for index in 0...(ElementList.count-1){
    result.append("var " + ElementList[index] + ": String = \"\"")
}

result.append("")

result.append("static func CreateTable(){")
result.append("")
result.append("let table = DataManager.db[\"" + EntityName + "\"]")
result.append("")
result.append("DataManager.db.drop(table: table, ifExists: true)")
for i in 0...(ElementList.count-1){
    let a = "let " + ElementList[i] + " = Expression<String?>(\"" + ElementList[i] + "\")"
    result.append(a)
}
result.append("")
result.append("DataManager.db.create(table: table, ifNotExists: true) { t in")
for i in 0...(ElementList.count-1){
    result.append("t.column(" + ElementList[i] + ")")
}
result.append("}")
result.append("}")
result.append("")
result.append("static func Insert(entity :JSON){")
result.append("if entity.count == 0{")
result.append("return")
result.append("}")

var str1 = "var bindStmt = DataManager.db.prepare(\"INSERT INTO " + EntityName + " ("
var str2 = ""
for i in 0...(ElementList.count-1){
    str1 = str1 + ElementList[i] + ","
    str2 = str2 + "?,"
}
result.append(str1.substringToIndex(str1.endIndex.predecessor()) + ") values (" + str2.substringToIndex(str2.endIndex.predecessor()) + ")\")")
result.append("")
result.append("let statement = DataManager.db.transaction { _ in")
result.append("")
result.append("for index in 0...(entity.count-1) {")

result.append("var bindings:[Binding?] = []")
for i in 0...(ElementList.count-1){
    result.append("bindings.append(entity[index][\"" + ElementList[i] + "\"].string)")
}
result.append("bindStmt.run(bindings)")
result.append("}")
result.append("return .Commit")
result.append("}")
result.append("if statement.failed {")
result.append("// query failed")
result.append("}")
result.append("}")


result.append("")

result.append("static func GetAll() -> [" + EntityName + "]{")
result.append("if !DataManager.db.tableExists(\"" + EntityName + "\"){")
result.append("CreateTable()")
result.append("}")
result.append("let table = DataManager.db[\"" + EntityName + "\"]")
for i in 0...(ElementList.count-1){
    let a = "let " + ElementList[i] + " = Expression<String?>(\"" + ElementList[i] + "\")"
    result.append(a)
}
result.append("")
result.append("var list:[" + EntityName + "] = []")

result.append("for row in table {")
result.append("let obj: " + EntityName + " = " + EntityName + "()")
for i in 0...(ElementList.count-1){
    var a = "obj." + ElementList[i] + " = (row[" + ElementList[i] + "]) == nil ? \"\" "
    
    var b = " : (row[" + ElementList[i] + "])!"
    result.append(a+b)
}
result.append("list.append(obj)")
result.append("}")
result.append("return list")
result.append("}")


for index in 0...(result.count-1){
    println(result[index])
}
