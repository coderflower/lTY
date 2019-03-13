//
//  UIViewControllerExt.swift
//  LightCloud
//
//  Created by GorXion on 2018/5/2.
//

import RxCocoa
import RxSwift

extension Reactive where Base: UIViewController {
    func push(_ viewController: @escaping @autoclosure () -> UIViewController,
              animated: Bool = true)
        -> Binder<Void> {
        return Binder(base) { this, _ in
            this.navigationController?.pushViewController(viewController(), animated: animated)
        }
    }

    func pop(animated: Bool = true) -> Binder<Void> {
        return Binder(base) { this, _ in
            this.navigationController?.popViewController(animated: animated)
        }
    }

    func popToRoot(animated: Bool = true) -> Binder<Void> {
        return Binder(base) { this, _ in
            this.navigationController?.popToRootViewController(animated: animated)
        }
    }

    func present(_ viewController: @escaping @autoclosure () -> UIViewController,
                 animated: Bool = true,
                 completion: (() -> Void)? = nil)
        -> Binder<Void> {
        return Binder(base) { this, _ in
            this.present(viewController(), animated: animated, completion: completion)
        }
    }

    func dismiss(animated: Bool = true, completion: (() -> Void)? = nil) -> Binder<Void> {
        return Binder(base) { this, _ in
            this.dismiss(animated: animated, completion: completion)
        }
    }

    var goBack: Binder<Void> {
        return Binder(base) { vc, _ in
            vc.sf.goBack()
        }
    }
}

extension Reactive where Base: UIViewController {
    var viewDidLoad: Observable<Void> {
        return sentMessage(#selector(Base.viewDidLoad)).map { _ in Void() }
    }

    var viewWillAppear: Observable<Void> {
        return sentMessage(#selector(Base.viewWillAppear)).map { _ in Void() }
    }

    var viewDidAppear: Observable<Void> {
        return sentMessage(#selector(Base.viewDidAppear)).map { _ in Void() }
    }

    var viewWillDisappear: Observable<Void> {
        return sentMessage(#selector(Base.viewWillDisappear)).map { _ in Void() }
    }

    var viewDidDisappear: Observable<Void> {
        return sentMessage(#selector(Base.viewDidDisappear)).map { _ in Void() }
    }

    var viewWillLayoutSubviews: Observable<Void> {
        return sentMessage(#selector(Base.viewWillLayoutSubviews)).map { _ in Void() }
    }

    var viewDidLayoutSubviews: Observable<Void> {
        return sentMessage(#selector(Base.viewDidLayoutSubviews)).map { _ in Void() }
    }
}
