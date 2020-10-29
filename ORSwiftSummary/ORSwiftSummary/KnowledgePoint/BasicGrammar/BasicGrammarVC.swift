//
//  BasicGrammarVC.swift
//  ORSwiftSummary
//
//  Created by orilme on 2020/2/27.
//  Copyright © 2020 orilme. All rights reserved.
//

import UIKit

class BasicGrammarVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor.white
        
        basicKnowledge()
        normalDataType()
        
        let implicitInteger = 70
        let implicitDouble = 70.0
        let explicitDouble: Double = 70
        print(implicitInteger, implicitDouble, explicitDouble)
        
        let label = "The width is"
        let width = 94
        let widthLabel = label + String(width)
        print(widthLabel)
        
        let apples = 3
        let oranges = 5
        let appleSummary = "I have \(apples) apples."
        let fruitSummary = "I have \(apples + oranges) pieces of fruit."
        print(appleSummary, fruitSummary)
        
        var shoppingList = ["catfish", "water", "tulips", "blue paint"]
        shoppingList[1] = "bottle of water"
        print( shoppingList[0],shoppingList[1])
        
        
        var occupations = [
            "Malcolm": "Captain",
            "Kaylee": "Mechanic",
            ]
        occupations["Jayne"] = "Public Relations"
//        print(occupations["Jayne"], occupations["Malcolm"], occupations)
        
        
        let individualScores = [75, 43, 103, 87, 12]
        var teamScore = 0
        for score in individualScores {
            if score > 50 {
                teamScore += 3
            } else {
                teamScore += 1
            }
        }
        print(teamScore)
        
        
        var optionalString: String? = "Hello"
        print(optionalString == nil)
        
        var optionalName: String? = "John Appleseed"
        var greeting = "Hello!"
        if let name = optionalName {
            greeting = "Hello, \(name)"
        }
        print(greeting)
        
        optionalName = nil;
        if let name = optionalName {
            greeting = "Hello, \(name)"
        }else {
            greeting = greeting + "Hello"
        }
        print(greeting)
        
        let nickName: String? = nil
        let fullName: String = "John Appleseed"
        let informalGreeting = "Hi \(nickName ?? fullName)"
        print(informalGreeting)
        
        let nickName2: String? = "Join"
        let fullName2: String = "John Appleseed"
        let informalGreeting2 = "Hi \(nickName2 ?? fullName2)"
        print(informalGreeting2)
        
        
        let vegetable = "red pepper"
        switch vegetable {
        case "celery":
            print("Add some raisins and make ants on a log.")
        case "cucumber", "watercress":
            print("That would make a good tea sandwich.")
        case let x where x.hasSuffix("pepper"):
            print("Is it a spicy \(x)?")
        default:
            print("Everything tastes good in soup.")
        }
        
        let interestingNumbers = [
            "Prime": [2, 3, 5, 7, 11, 13],
            "Fibonacci": [1, 1, 2, 3, 5, 8],
            "Square": [1, 4, 9, 16, 25],
            ]
        var largest = 0
//        for (kind, numbers) in interestingNumbers {
        for (_, numbers) in interestingNumbers {
            for number in numbers {
                if number > largest {
                    largest = number
                }
            } }
        print(largest)
        
        
        var n = 2
        while n < 100 {
            n=n * 2
        }
        print(n)
        
        var m = 2
        repeat {
            m=m * 2
        } while m < 100
        print(m)
        
        var total = 0
        for i in 0..<4 {
            total += i }
        print(total)
        
        var total2 = 0
        for i in 0...4 {
            total2 += i }
        print(total2)
        
        func greet(person: String, day: String) -> String {
            return "Hello \(person), today is \(day)."
        }
        print(greet(person:"Bob", day: "Tuesday"))
        
        // 默认情况下，函数使用它们的参数名称作为它们参数的标签，在参数名称前可以自定义参数标签，或者使用 _ 表示不使用参数标签。
        func greet2(_ person: String, on day: String) -> String {
            return "Hello \(person), today is \(day)."
        }
        print(greet2("John", on: "Wednesday"))
        
        func calculateStatistics(scores: [Int]) -> (min: Int, max: Int, sum: Int) {
            var min = scores[0]
            var max = scores[0]
            var sum = 0
            for score in scores {
                if score > max {
                    max = score
                } else if score < min {
                    min = score
                }
                sum += score
            }
            return (min, max, sum)
        }
        let statistics = calculateStatistics(scores:[5, 3, 100, 3, 9])
        print(statistics.sum)
        print(statistics.1)
        
        
        func sumOf(numbers: Int...) -> Int {
            var sum = 0
            for number in numbers {
                sum += number
            }
            return sum }
        print(sumOf())
        print(sumOf(numbers: 42, 597, 12))
        
        
        // 函数也可以当做参数传入另一个函数。
        func hasAnyMatches(list: [Int], condition: (Int) -> Bool) -> Bool {
            for item in list {
                if condition(item) {
                    return true
                } }
            return false
        }
        func lessThanTen(number: Int) -> Bool {
            return number < 10
        }
        let numbers = [20, 19, 7, 12]
        print(hasAnyMatches(list: numbers, condition: lessThanTen))
        
        
        // 函数实际上是一种特殊的闭包:它是一段能之后被调取的代码。闭包中的代码能访问闭包所建作用域中能得到的变量和函数，即使闭包是在一个不同的作用域被执行的 - 你已经在嵌套函数例子中所看到。你可以使用 {} 来创建 一个匿名闭包。使用 in 将参数和返回值类型声明与闭包函数体进行分离。
        numbers.map({
            (number: Int) -> Int in
            let result = 3 * number
            return result
        })
        print(numbers.map({ number in 3 * number }))
        
        // 有很多种创建更简洁的闭包的方法。如果一个闭包的类型已知，比如作为一个回调函数，你可以忽略参数的类型和返回值。单个语句闭包会把它语句的值当做结果返回。
        let mappedNumbers = numbers.map({ number in 3 * number })
        print(mappedNumbers)

        let sortedNumbers = numbers.sorted { $0 > $1 }
        print(sortedNumbers)
        
        
        
        
        class Shape {
            var numberOfSides = 0
            func simpleDescription() -> String {
                return "A shape with \(numberOfSides) sides."
            }
        }
        
        // 要创建一个类的实例，在类名后面加上括号。使用点语法来访问实例的属性和方法。
        let shape = Shape()
        shape.numberOfSides = 7
        let shapeDescription = shape.simpleDescription()
        print(shapeDescription)
        
        
        class NamedShape {
            var numberOfSides: Int = 0
            var name: String
            init(name: String) {
                self.name = name
            }
            func simpleDescription() -> String {
                return "A shape with \(numberOfSides) sides. " + name
            }
        }
        let test = NamedShape(name: "my test square")
        test.numberOfSides = 5;
        print(test.simpleDescription())
        
        class Square: NamedShape {
            var sideLength: Double
            init(sideLength: Double, name: String) {
                self.sideLength = sideLength
                super.init(name: name)
                numberOfSides = 4
            }
            func area() ->  Double {
                return sideLength * sideLength
            }
            override func simpleDescription() -> String {
                return "A square with sides of length \(sideLength)."
            }
        }
        let test2 = Square(sideLength: 5.2, name: "my test square")
        print(test2.area())
        print(test2.simpleDescription())
        
        
    }
    
    func basicKnowledge() {
        // 外部参数名
        print("外部参数名1---", sum(number1: 10, number2: 20))
        // 默认参数值
        addStudent(name: "老马", 20)
        // 输入输出参数
        var a = 20, b = 10
        swap(num1: &a, num2: &b)
        print("输入输出参数1---", a, "---", b)
        var sum = 0, minus = 0
        sumAndMinus(num1: 20, num2: 5, sum: &sum, minus: &minus)
        print("输入输出参数2---", sum, "---", minus)
        // 范围运算符
        swifttest1()
        // 求余运算符，求余结果的正负跟%左边数值的正负一样
        // 9  %  4  // 1
        // -9 %  4  // -1
        // 9  % -4  // 1
        //-9  % -4  // -1
        print("求余运算符---", 9 % 4, "---", -9 % 4, "---", 9 % -4, "---", -9 % -4)
    }
    
    // 外部参数名
    func sum(number1 num1: Int, number2 num2: Int) -> Int {
        return num1 + num2
    }
    
    // 默认参数值
    func addStudent(name: String, _ age: Int = 20) {
        print("addStudent---",name, "---", age)
    }
    
    // 输入输出参数
    // 在 C 语言中，利用指针可以在函数内部修改外部变量的值
    // 在 Swift 中，利用输入输出参数，也可以在函数内部修改外部变量的值
    // 输入输出参数的定义，在参数前面加一个 inout 关键字即可
    // 注意： 1. 传入实参时，x必须在实参前面加&
    //       2. 不能传入常量或者字面量（比如10）作为参数值（因为他们都不可改）
    //       3. 输入参数不能有默认值
    // 价值：可以实现函数的多返回值（其实让函数返回元组类型，也能实现返回多个值）
    func swap(num1: inout Int, num2: inout Int) {
        let temp = num1
        num1 = num2
        num2 = temp
    }
    func sumAndMinus(num1: Int, num2: Int, sum: inout Int, minus: inout Int) {
        sum = num1 + num2
        minus = num1 - num2
    }
    
    
    // 范围运算符
    // 范围运算符用来表示一个范围，有2种类型的范围运算符
    // 闭合范围运算符：a...b，表示[a, b]，包含a和b
    // 半闭合范围运算符：a..<b，表示[a, b)，包含a，不包含b
    func swifttest1() {
        for index in 1...5 {
            print("闭合范围运算符---", index)
        }
        for index in 1..<5 {
            print("半闭合范围运算符---", index)
        }
    }

    
    func  normalDataType() {
        // Swift中常用的数据类型有
        // Int、Float、Bool、Character、String
        // Array、Dictionary、元组类型（Tuple）、可选类型（Optional）
        
        // 每种数据类型都有各自的存储范围
        // Int8的存储范围是：-128~127
        // UInt8的存储范围是：0~255
        
        // 浮点数，就是小数。Swift提供了两种d浮点数类型
        // Double：64位浮点数，当浮点数值非常大或需要非常精确时使用此类型
        // Float：32位浮点数，当浮点数值不需要使用Double的时候使用此类型
        // 精确程度：Double（至少15位小数）， Float(至少6位小数)
        
        // 如果没有明确说明类型，浮点数就是Double类型
        // let nun = 0.14 // num是Double类型
        
        // 浮点数的表示形式：十进制、十六进制两种形式
        // 十进制（没有前缀）
        // 没有指数：let d1 = 12.5
        // 有指数：let d2 = 0.125e2
        
        // 十六进制（以0x为前缀，且一定要有指数）
        // let d3 = 0xC.8p0 // 0xC.8p0 == 0xC.8 * 2的0次方 == 12.5 * 1
        // let d4 = 0xC.8p1 // 0xC.8p0 == 0xC.8 * 2的1次方 == 12.5 * 2 == 25.0
        
        // 类型别名(原类型名称能用在什么地方，别名就能用在什么地方)
        // typealias MyInt = Int
        // let num:MyInt = 20
        // 类型转换
        // let num = MyInt(3.14) // 3
        
        
        // 数字格式
        // 数字可以增加额外的格式，是他们更容易阅读，并不会影响原来的数值大小
        // 可以增加额外的零0
        let money = 001999 // 1999
        let money2 = 001999.000 // 1999.0
        // 可以增加额外的下划线_，增强可读性
        let onMillion1 = 1_000_000 //1000000
        let onMillion2 = 100_0000 //1000000
        let overOneMillion = 1_000_000.000_001 //1000000.000001
        
        // 整数分为2种类型
        // 有符号signed：正、负、零(Int8、Int16、Int32、Int64)
        // 无符号unsigned：正、零(UInt8、UInt16、UInt32、UInt64)
        // 整数的四种表现形式
        // 十进制数
        let i1 = 10         // 10
        // 二制数数：以0b为前缀
        let i2 = 0b1010     // 10
        // 八制数数：以0o为前缀
        let i3 = 0o12       // 10
        // 十六进制数数：以0x为前缀
        let i4 = 0xa        // 10
        print("十进制数---\(i1)、二制数数---\(i2)、八制数数---\(i3)、十六进制数数---\(i4)")
        
        // 值得上溢出
        let x3 = UInt8.max
        let y3 = x3 &+ 1
        // 值得下溢出
        let x4 = UInt8.min
        let y4 = x4 &- 1
        print("值得上溢出---\(y3)、值得下溢出---\(y4)")
        
        // 元组类型，由N个任意类型的数据组成（N>=0）
        let position = (x: 10.5, y: 20) // position有两个元素，x、y是元素的名称
        let person = ("jack") // person只有一个元素
        let data = ()
        print("元组类型---\(position)---\(person)---\(data)")
        
        // 元素的访问(用let来定义一个元组，那么他就是常量，就无法修改它的元素)
        var position2 = (x: 10.5, y: 20) // position2有两个元素，x、y是元素的名称
        position2.0 = 1
        print("position2---\(position2)")
        
        // 可以省略元素名称
        let position3 = (10, 20)
        // 可以明确地指定元素的类型
        let person4:(Int, String) = (23, "jack")
        // 注意在明确指定元素类型的情况下不能加上元素名称
        //let person4:(Int, String) = (age: 23, name: "jack")
        // 可以使用下划线_忽略某个元素的值，取出其他元素的值
        var (_, name) = person4
        print("使用下划线_忽略某个元素的值---\(name)")
        
        // Switch
        // 在Swift中，不需要再每一个case后面增加break，执行完case对应的代码后默认会自动退出switch语句
        // 在Swift中，每一个case后面必须有一个可执行语句
        let score = 95
        switch score {
        case 100:
            print("优秀等级")
        case 99, 98:
            print("99,98分")
        case 90...98:
            print("良好等级")
        default:
            print("未知等级")
        }
        
        // case匹配元组
        let point = (1, 1)
        switch point {
        case (0, 0):
            print("case匹配元组---这个点在原点上")
        case (_, 0):
            print("case匹配元组---这个点在X轴上")
        case (0, _):
            print("case匹配元组---这个点在Y轴上")
        case (-2...2, -2...2):
            print("case匹配元组---这个点在矩形框内")
        default:
            print("case匹配元组---这个点在其他位置")
        }
        
        // case的数值绑定
        let point2 = (10, 0)
        switch point2 {
        case (let x, 0):
            print("case的数值绑定---这个点在X轴上，x值是\(x)")
        case (0, let y):
            print("case的数值绑定---这个点在Y轴上，y值是\(y)")
        case let (x, y):
            print("case的数值绑定---这个点X轴值是\(x)，y值是\(y)")
        }
        
        // fallthrough: 作用，执行完当前case后，会接着执行fallthrough后面的case或者default语句
        let fallthroughNum = 20
        var str = "\(fallthroughNum)是个"
        switch fallthroughNum {
        case 0...50:
            str += "0~50之间的"
            fallthrough
        default:
            str += "整数"
        }
        print("fallthrough---", str)
        
        // switch语句使用where来增加判断条件
        let fallthroughPoint = (10, -10)
        switch fallthroughPoint {
        case let(x, y) where x == y:
            print("这个点在45度角的线上")
        case let(x, y) where x == -y:
            print("这个点在135度角的线上")
        default:
            print("这个点不在这2l条线上")
        }

        
        // 使用标签的其中一个作用，可以明确指出要退出哪个循环
        // 做两个俯卧撑，每组三个，做完一组就休息一会
        group:
        for _ in 1...2 {
            for item in 1...3 {
                print("做一个俯卧撑")
                if item == 2 {
                    break group
                }
            }
            print("休息一会")
        }
        
    }
    
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
