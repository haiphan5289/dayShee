//
//  ActivityIndicator.swift
//  Dayshee
//
//  Created by haiphan on 11/12/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import RxSwift
import RxCocoa
import SVProgressHUD

private struct ActivityToken<E> : ObservableConvertibleType, Disposable {
    private let _source: Observable<E>
    private let _dispose: Cancelable

    init(source: Observable<E>, disposeAction: @escaping () -> Void) {
        _source = source
        _dispose = Disposables.create(with: disposeAction)
    }

    func dispose() {
        _dispose.dispose()
    }

    func asObservable() -> Observable<E> {
        _source
    }
}

/**
Enables monitoring of sequence computation.
If there is at least one sequence computation in progress, `true` will be sent.
When all activities complete `false` will be sent.
*/
public class ActivityProgressIndicator : SharedSequenceConvertibleType {
    public typealias Element = Bool
    public typealias SharingStrategy = DriverSharingStrategy

    private let _lock = NSRecursiveLock()
    private let _relay = BehaviorRelay(value: 0)
    private let _loading: SharedSequence<SharingStrategy, Bool>

    public init() {
        _loading = _relay.asDriver()
            .map { $0 > 0 }
            .distinctUntilChanged()
    }

    fileprivate func trackActivityOfObservable<Source: ObservableConvertibleType>(_ source: Source) -> Observable<Source.Element> {
        return Observable.using({ () -> ActivityToken<Source.Element> in
            self.increment()
            return ActivityToken(source: source.asObservable(), disposeAction: self.decrement)
        }) { t in
            return t.asObservable()
        }
    }

    private func increment() {
        _lock.lock()
        _relay.accept(_relay.value + 1)
        _lock.unlock()
    }

    private func decrement() {
        _lock.lock()
        _relay.accept(_relay.value - 1)
        _lock.unlock()
    }

    public func asSharedSequence() -> SharedSequence<SharingStrategy, Element> {
        _loading
    }
}

public extension ObservableConvertibleType {
    /// Disclaimer
    /// __________
    /// This code is not original. Fiision Studio only copied and pasted base on
    /// Fiision Studio's project management structure.
    ///
    /// If you are looking for original, please:
    /// - seealso:
    ///   [The RxSwift Library Reference]
    ///   (https://github.com/ReactiveX/RxSwift/blob/master/RxExample/RxExample/Services/ActivityIndicator.swift)
    func trackProgressActivity(_ activityIndicator: ActivityProgressIndicator) -> Observable<Element> {
        return activityIndicator.trackActivityOfObservable(self)
    }
}

extension ObservableConvertibleType {
    public func trackActivity(_ activityIndicator: ActivityProgressIndicator) -> Observable<Element> {
        activityIndicator.trackActivityOfObservable(self)
    }
}
public protocol ActivityTrackingProgressProtocol: AnyObject {
    var indicator: ActivityProgressIndicator! { get set }
}

public extension ActivityTrackingProgressProtocol {
    var indicator: ActivityProgressIndicator! {
        get {
            guard let r = objc_getAssociatedObject(self, &Loading.name) as? ActivityProgressIndicator else {
                let new = ActivityProgressIndicator()
                // set for next
                objc_setAssociatedObject(self, &Loading.name, new, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return new
            }
            return r
        }
        set {
            objc_setAssociatedObject(self, &Loading.name, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

private struct Loading {
    static var name = "indicatorProgress"
}

extension ActivityTrackingProgressProtocol {
    var loadingProgress: Observable<ActivityProgressIndicator.Element> {
        return indicator.asObservable().observeOn(MainScheduler.asyncInstance)
    }
}

final class LoadingManager: NSObject, ManageListenerProtocol {
    internal var listenerManager: [Disposable] = []
    private (set) lazy var lock: NSRecursiveLock = NSRecursiveLock()
    
    static let instance = LoadingManager()
    
    func show() {
//        var current: Float = 0
//        let disposeProgress = Observable<Int>.interval(0.3, scheduler: MainScheduler.instance).subscribe(onNext: { (_) in
//            current += 1
//            let p = min(current / 100, 1)
//            SVProgressHUD.showProgress(current / 100, status: "\(Int(p * 100))%")
//            SVProgressHUD.show()
//        }, onDisposed: {
//           SVProgressHUD.dismiss()
//        })
//        add(disposeProgress)
        SVProgressHUD.show()
    }
    
    func dismiss() {
//        cleanUpListener()
        SVProgressHUD.dismiss()
    }
    
}
protocol ManageListenerProtocol: AnyObject, SafeAccessProtocol {
    var listenerManager: [Disposable] { get set }
}

extension ManageListenerProtocol {
    func cleanUpListener() {
        excute(block: { [unowned self] in
            self.listenerManager.forEach({ $0.dispose() })
            self.listenerManager.removeAll()
        })
    }
    
    func add(_ disposable: Disposable) {
        excute(block: { [unowned self] in
            self.listenerManager.append(disposable)
        })
    }
}

//protocol ManageListenerProtocol: AnyObject, SafeAccessProtocol {
//    var listenerManager: [Disposable] { get set }
//}
//
//extension ManageListenerProtocol {
//    func cleanUpListener() {
//        excute(block: { [unowned self] in
//            self.listenerManager.forEach({ $0.dispose() })
//            self.listenerManager.removeAll()
//        })
//    }
//
//    func add(_ disposable: Disposable) {
//        excute(block: { [unowned self] in
//            self.listenerManager.append(disposable)
//        })
//    }
//}
//
//protocol SafeAccessProtocol {
//    var lock: NSRecursiveLock { get }
//}
//
//extension SafeAccessProtocol {
//    @discardableResult
//    func excute<T>(block: () -> T) -> T {
//        lock.lock()
//        defer { lock.unlock() }
//        return block()
//    }
//}

