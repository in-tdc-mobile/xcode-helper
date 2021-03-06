
import UIKit

let EntityName = "AllotmentSupportData"

let ElementList = ["ID",
                   "APPROVAL_STATUS",
                   "PAYMENT_STATUS",
                  "TRANSACTION_DATE","PERIOD","MONTH", "YEAR"
]
var result: [String] = []
for index in 0 ... (ElementList.count - 1) {
	result.append("var " + ElementList[index] + ": String = \"\"")
}

result.append ("static let TableName = \"" + EntityName + "\"")

result.append("")

result.append("static func CreateTable(){")
result.append("")
result.append("let table = Table("+EntityName+".TableName)")
result.append("")
result.append("try! DataManager.con.run(table.drop(ifExists: true))")
for i in 0 ... (ElementList.count - 1) {
	let a = "let " + ElementList[i] + " = Expression<String?>(\"" + ElementList[i] + "\")"
	result.append(a)
}
result.append("")
result.append("try! DataManager.con.run(table.create { t in")
for i in 0 ... (ElementList.count - 1) {
	result.append("t.column(" + ElementList[i] + ")")
}
result.append("})")
result.append("}")
result.append("")
result.append("static func Insert(entity :JSON){")
result.append("if entity.count == 0{")
result.append("return")
result.append("}")

var str1 = "let bindStmt = try! DataManager.con.prepare(\"INSERT INTO " + EntityName + " ("
var str2 = ""
for i in 0 ... (ElementList.count - 1) {
	str1 = str1 + ElementList[i] + ","
	str2 = str2 + "?,"
}
result.append(str1.substring(to: str1.endIndex)+") values (" + str2.substring(to:str2.endIndex)+")\")")
result.append("")
result.append("try! DataManager.con.transaction(block: {_ in")
result.append("")
result.append("for index in 0...(entity.count-1) {")

result.append("var bindings:[Binding?] = []")
for i in 0 ... (ElementList.count - 1) {
	result.append("bindings.append(entity[index][\"" + ElementList[i] + "\"].string)")
}
result.append("try! bindStmt.run(bindings)")
result.append("}")
result.append("})")
result.append("}")

result.append("")

result.append("static func deleteData() {")
    
result.append("_ = try! DataManager.con.run(Table("+EntityName+".TableName).delete())")
result.append("}")

result.append("static func GetAll() -> [" + EntityName + "]{")
result.append("if try! DataManager.con.tableExists("+EntityName+".TableName){")
result.append("CreateTable()")
result.append("}")
result.append("let table = Table("+EntityName+".TableName)")
for i in 0 ... (ElementList.count - 1) {
	let a = "let " + ElementList[i] + " = Expression<String?>(\"" + ElementList[i] + "\")"
	result.append(a)
}
result.append("")
result.append("var list:[" + EntityName + "] = []")

result.append("for row in try! DataManager.con.prepare(table) {")
result.append("let obj: " + EntityName + " = " + EntityName + "()")
for i in 0 ... (ElementList.count - 1) {
	var a = "obj." + ElementList[i] + " = (row[" + ElementList[i] + "]) == nil ? \"\" "
	
	var b = " : (row[" + ElementList[i] + "])!"
	result.append(a + b)
}
result.append("list.append(obj)")
result.append("}")
result.append("return list")
result.append("}")

for index in 0 ... (result.count - 1) {
	print(result[index]) // result[index])
}

result
