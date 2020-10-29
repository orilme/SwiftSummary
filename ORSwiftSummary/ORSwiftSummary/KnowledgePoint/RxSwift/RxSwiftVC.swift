//
//  RxSwiftVC.swift
//  ORSwiftSummary
//
//  Created by orilme on 2020/7/24.
//  Copyright © 2020 orilme. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RxSwiftVC: UIViewController {
    
    @IBOutlet weak var rxBtn: UIButton!
    @IBOutlet weak var rxTextField: UITextField!
    @IBOutlet weak var rxScrollView: UIScrollView!
    @IBOutlet weak var rxGestureLabel: UILabel!
    
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupButton()
        setupTextFiled()
        setupScrollerView()
        setupNotification()
        //setupTimer()
        setupGestureRecognizer()
        
        // 高阶函数
        /// 组合操作符
        merge()
        zip()
        combineLatest()
        switchLatest()
        /// 映射操作符
        map()
        scan()
        /// 过滤条件操作符
        filter()
        distinctUntilChanged()
        elementAt()
        single()
        take()
        takeLast()
        takeWhile()
        takeUntil()
        skip()
        skipUntil()
        /// 集合控制操作符
        toArray()
        reduce()
        concat()
    }
    
    //MARK: - RxSwift应用-button响应
    func setupButton() {
        /// 传统UI事件
        //self.rxBtn.addTarget(self, action: #selector(didClickButton), for: .touchUpInside)
        /// RxSwift
        rxBtn.rx.tap.subscribe(onNext: { [weak self] in
            print("点了,小鸡炖蘑菇")
            self?.view.backgroundColor = UIColor.orange
        }).disposed(by: disposeBag)
    }


    //MARK: - RxSwift应用-textfiled
    func setupTextFiled() {
        /// 我们如果要对输入的文本进行操作 - 比如输入的的内容 然后我们获取里面的偶数
        /// self.textFiled.delegate = self
        /// 感觉是不是特别恶心
        /// 下面我们来看看Rx
        rxTextField.rx.text.orEmpty.changed.subscribe(onNext: { (text) in
            print("监听到了 - \(text)")
        }).disposed(by: disposeBag)
        
        rxTextField.rx.text.bind(to: self.rxBtn.rx.title()).disposed(by: disposeBag)
    }
    
    //MARK: - RxSwift应用-scrollView
    func setupScrollerView() {
        rxScrollView.rx.contentOffset.subscribe(onNext: { [weak self] (content) in
            self?.view.backgroundColor = UIColor.init(red: content.y/255.0*0.6, green: content.y/255.0*0.8, blue: content.y/255.0*0.3, alpha: 1);
            print(content.y)
        }).disposed(by: disposeBag)
    }

    //MARK: - 通知
    func setupNotification() {
        NotificationCenter.default.rx
            .notification(UIResponder.keyboardWillShowNotification)
            .subscribe { (event) in
                print(event)
        }.disposed(by: disposeBag)
    }
    
    //MARK: - 手势
    func setupGestureRecognizer() {
        let tap = UITapGestureRecognizer()
        rxGestureLabel.addGestureRecognizer(tap)
        rxGestureLabel.isUserInteractionEnabled = true
        tap.rx.event.subscribe { (event) in
            print("点了label")
        }.disposed(by: disposeBag)
    }
    
    //MARK: - RxSwift应用-timer定时器
    func setupTimer() {
        let rxTimer = Observable<Int>.interval(RxTimeInterval.seconds(2), scheduler: MainScheduler())
        rxTimer.subscribe(onNext: { (num) in
            print("hello word \(num)")
        }).disposed(by: disposeBag)
    }
    
    func merge() {
        // 将源可观察序列中的元素组合成一个新的可观察序列，并将像每个源可观察序列发出元素一样发出每个元素
        print("*****merge*****")
        let subject1 = PublishSubject<String>()
        let subject2 = PublishSubject<String>()
        // merge subject1和subject2
        Observable.of(subject1, subject2)
            .merge()
            .subscribe(onNext: { print("rz merge \($0)") })
            .disposed(by: disposeBag)

        subject1.onNext("C")
        subject1.onNext("o")
        subject2.onNext("o")
        subject2.onNext("o")
        subject1.onNext("c")
        subject2.onNext("i")
    }
    
    func zip() {
        // 将多达8个源可观测序列组合成一个新的可观测序列，并将从组合的可观测序列中发射出对应索引处每个源可观测序列的元素
        print("*****zip*****")
        let stringSubject = PublishSubject<String>()
        let intSubject = PublishSubject<Int>()

        Observable.zip(stringSubject, intSubject) { stringElement, intElement in
                "\(stringElement) \(intElement)"
            }
            .subscribe(onNext: { print("rx zip \($0)") })
            .disposed(by: disposeBag)

        stringSubject.onNext("C")
        stringSubject.onNext("o") // 到这里存储了 C o 但是不会响应除非;另一个响应

        intSubject.onNext(1) // 勾出一个
        intSubject.onNext(2) // 勾出另一个
        stringSubject.onNext("i") // 存一个
        intSubject.onNext(3) // 勾出一个
    }
    
    func combineLatest() {
        // 将8源可观测序列组合成一个新的观测序列,并将开始发出联合观测序列的每个源的最新元素可观测序列一旦所有排放源序列至少有一个元素,并且当源可观测序列发出的任何一个新元素
        print("*****combineLatest*****")
        let stringSub = PublishSubject<String>()
        let intSub = PublishSubject<Int>()
        Observable.combineLatest(stringSub, intSub) { strElement, intElement in
                "\(strElement) \(intElement)"
            }
            .subscribe(onNext: { print("rx combineLatest \($0)") })
            .disposed(by: disposeBag)

        stringSub.onNext("L") // 存一个 L
        stringSub.onNext("G") // 存了一个覆盖 - 和zip不一样
        intSub.onNext(1)      // 发现strOB也有G 响应 G 1
        intSub.onNext(2)      // 覆盖1 -> 2 发现strOB 有值G 响应 G 2
        stringSub.onNext("Cooci") // 覆盖G -> Cooci 发现intOB 有值2 响应 Cooci 2
    }
    
    func switchLatest() {
        // 将可观察序列发出的元素转换为可观察序列，并从最近的内部可观察序列发出元素
        print("*****switchLatest*****")
        let switchLatestSub1 = BehaviorSubject(value: "L")
        let switchLatestSub2 = BehaviorSubject(value: "1")
        let switchLatestSub  = BehaviorSubject(value: switchLatestSub1)// 选择了 switchLatestSub1 就不会监听 switchLatestSub2

        switchLatestSub.asObservable()
            .switchLatest()
            .subscribe(onNext: { print("rx switchLatest \($0)") })
            .disposed(by: disposeBag)

        switchLatestSub1.onNext("G")
        switchLatestSub1.onNext("_")
        switchLatestSub2.onNext("2")
        switchLatestSub2.onNext("3") // 2-3都会不会监听,但是默认保存由 2覆盖1 3覆盖2
        switchLatestSub.onNext(switchLatestSub2) // 切换到 switchLatestSub2
        switchLatestSub1.onNext("*")
        switchLatestSub1.onNext("Cooci") // 原理同上面 下面如果再次切换到 switchLatestSub1会打印出 Cooci
        switchLatestSub2.onNext("4")
    }
    
    func map() {
        // 转换闭包应用于可观察序列发出的元素，并返回转换后的元素的新可观察序列。
        print("*****map*****")
        let ob = Observable.of(1, 2, 3, 4)
        ob.map { (number) -> Int in
            return number+2
        }.subscribe{
            print("rx map \($0)")
        }.disposed(by: disposeBag)
    }
    
    func scan() {
        // 从初始就带有一个默认值开始，然后对可观察序列发出的每个元素应用累加器闭包，并以单个元素可观察序列的形式返回每个中间结果
        print("*****scan*****")
        Observable.of(10, 100, 1000).scan(2) { aggregateValue, newValue in
            aggregateValue + newValue // 10 + 2 , 100 + 10 + 2 , 1000 + 100 + 10 + 2
        }.subscribe(onNext: {
            print("rx scan \($0)")
        }).disposed(by: disposeBag)
    }
    
    func filter() {
        // 仅从满足指定条件的可观察序列中发出那些元素
        print("*****filter*****")
        Observable.of(1,2,3,4,5,6,7,8,9,0)
            .filter { $0 % 2 == 0 }
            .subscribe(onNext: { print("rx filter \($0)") })
            .disposed(by: disposeBag)
    }
    
    func distinctUntilChanged() {
        // 抑制可观察序列发出的顺序重复元素
        print("*****distinctUntilChanged*****")
        Observable.of("1", "2", "2", "2", "3", "3", "4")
            .distinctUntilChanged()
            .subscribe(onNext: { print("rx distinctUntilChanged \($0)") })
            .disposed(by: disposeBag)
    }
    
    func elementAt() {
        // 仅在可观察序列发出的所有元素的指定索引处发出元素
        print("*****elementAt*****")
        Observable.of("C", "o", "o", "c", "i")
            .elementAt(3)
            .subscribe(onNext: { print("rx elementAt \($0)") })
            .disposed(by: disposeBag)
    }
    
    func single() {
        // 只发出可观察序列发出的第一个元素(或满足条件的第一个元素)。如果可观察序列发出多个元素，将抛出一个错误。
        print("*****single*****")
        Observable.of("Cooci", "Kody")
            .single()
            .subscribe(onNext: { print("rx single \($0)") })
            .disposed(by: disposeBag)

        Observable.of("Cooci", "Kody")
            .single { $0 == "Kody" }
            .subscribe { print("rx single2 \($0)") }
            .disposed(by: disposeBag)
    }
    
    func take() {
        // 只从一个可观察序列的开始发出指定数量的元素。 上面signal只有一个序列 在实际开发会受到局限 这里引出 take 想几个就几个
        print("*****take*****")
        Observable.of("Hank", "Kody","Cooci", "CC")
            .take(2)
            .subscribe(onNext: { print("rx take \($0)") })
            .disposed(by: disposeBag)
    }
    
    func takeLast() {
        // 仅从可观察序列的末尾发出指定数量的元素
        print("*****takeLast*****")
        Observable.of("Hank", "Kody","Cooci", "CC")
            .takeLast(3)
            .subscribe(onNext: { print("rx takeLast \($0)") })
            .disposed(by: disposeBag)
    }
    
    func takeWhile() {
        // 只要指定条件的值为true，就从可观察序列的开始发出元素
        print("*****takeWhile*****")
        Observable.of(1, 2, 3, 4, 5, 6)
            .takeWhile { $0 < 3 }
            .subscribe(onNext: { print("rx takeWhile \($0)") })
            .disposed(by: disposeBag)
    }
    
    func takeUntil() {
        // 从源可观察序列发出元素，直到参考可观察序列发出元素
        // 这个要重点,应用非常频繁 比如我页面销毁了,就不能获取值了(cell重用运用)
        print("*****takeUntil*****")
        let sourceSequence = PublishSubject<String>()
        let referenceSequence = PublishSubject<String>()

        sourceSequence
            .takeUntil(referenceSequence)
            .subscribe { print("rx takeUntil \($0)") }
            .disposed(by: disposeBag)

        sourceSequence.onNext("Cooci")
        sourceSequence.onNext("Kody")
        sourceSequence.onNext("CC")

        referenceSequence.onNext("Hank") // 条件一出来,下面就走不了

        sourceSequence.onNext("Lina")
        sourceSequence.onNext("小雁子")
        sourceSequence.onNext("婷婷")
    }
    
    func skip() {
        // 从源可观察序列发出元素，直到参考可观察序列发出元素
        // 这个要重点,应用非常频繁 不用解释 textfiled 都会有默认序列产生
        print("*****skip*****")
        Observable.of(1, 2, 3, 4, 5, 6)
            .skip(2)
            .subscribe(onNext: { print("rx skip \($0)") })
            .disposed(by: disposeBag)

        print("*****skipWhile*****")
        Observable.of(1, 2, 3, 4, 5, 6)
            .skipWhile { $0 < 4 }
            .subscribe(onNext: { print("rx skipWhile \($0)") })
            .disposed(by: disposeBag)
    }
    
    func skipUntil() {
        // 抑制从源可观察序列发出元素，直到参考可观察序列发出元素
        print("*****skipUntil*****")
        let sourceSeq = PublishSubject<String>()
        let referenceSeq = PublishSubject<String>()

        sourceSeq
            .skipUntil(referenceSeq)
            .subscribe(onNext: { print("rx skipUntil \($0)") })
            .disposed(by: disposeBag)

        // 没有条件命令 下面走不了
        sourceSeq.onNext("Cooci")
        sourceSeq.onNext("Kody")
        sourceSeq.onNext("CC")

        referenceSeq.onNext("Hank") // 条件一出来,下面就可以走了

        sourceSeq.onNext("Lina")
        sourceSeq.onNext("小雁子")
        sourceSeq.onNext("婷婷")
    }
    
    func toArray() {
        // 将一个可观察序列转换为一个数组，将该数组作为一个新的单元素可观察序列发出，然后终止
        print("*****toArray*****")
        Observable.range(start: 1, count: 10)
            .toArray()
            .subscribe { print("rx toArray \($0)") }
            .disposed(by: disposeBag)
    }
    
    func reduce() {
        // 从一个设置的初始化值开始，然后对一个可观察序列发出的所有元素应用累加器闭包，并以单个元素可观察序列的形式返回聚合结果 - 类似scan
        print("*****reduce*****")
        Observable.of(10, 100, 1000)
            .reduce(1, accumulator: +) // 1 + 10 + 100 + 1000 = 1111
            .subscribe(onNext: { print("rx reduce \($0)") })
            .disposed(by: disposeBag)
    }
    
    func concat() {
        // 以顺序方式连接来自一个可观察序列的内部可观察序列的元素，在从下一个序列发出元素之前，等待每个序列成功终止
        print("*****concat*****")
        let subject1 = BehaviorSubject(value: "Hank")
        let subject2 = BehaviorSubject(value: "1")

        let subjectsSubject = BehaviorSubject(value: subject1)

        subjectsSubject.asObservable()
            .concat()
            .subscribe { print("rx concat \($0)") }
            .disposed(by: disposeBag)

        subject1.onNext("Cooci")
        subject1.onNext("Kody")

        subjectsSubject.onNext(subject2)

        subject2.onNext("打印不出来")
        subject2.onNext("2")
        subject2.onNext("3")

        subject1.onCompleted() // 必须要等subject1 完成了才能订阅到! 用来控制顺序 网络数据的异步
        subject2.onNext("4")
        subject2.onNext("5")
    }

}
