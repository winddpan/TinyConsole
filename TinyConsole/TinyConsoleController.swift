//
//  TinyConsoleController.swift
//  TinyConsole
//
//  Created by Devran Uenal on 28.11.16.
//
//

import UIKit

/// This UIViewController holds both, the `rootViewController`
/// of your application and the `consoleViewController`.
open class TinyConsoleController: UIViewController {
    /// The kind of window modes that are supported by TinyConsole
    ///
    /// - collapsed: the console is hidden
    /// - expanded: the console is shown
    public enum WindowMode {
        case collapsed
        case expanded
    }

    // MARK: - Private Properties

    private var animationDuration = 0.25

    private var consoleViewController: TinyConsoleViewController = {
        TinyConsoleViewController()
    }()

    private var window: UIWindow?

    private func updateHeightConstraint() {
        let keyWindow = UIApplication.shared.keyWindow
        if consoleWindowMode == .collapsed {
            keyWindow?.frame = UIScreen.main.bounds
            window?.isHidden = true
            window = nil
        } else {
            let windowHeight = consoleHeight

            let window = UIWindow(frame: UIScreen.main.bounds)
            window.windowLevel = .statusBar
            window.rootViewController = self
            window.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - windowHeight, width: UIScreen.main.bounds.width, height: windowHeight)
            window.makeKeyAndVisible()
            view.layoutIfNeeded()
            window.resignKey()
            self.window = window

            keyWindow?.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - windowHeight)
            keyWindow?.makeKeyAndVisible()
        }
    }

    // MARK: - Public Properties

    public var consoleHeight: CGFloat = 200 {
        didSet {
            UIView.animate(withDuration: animationDuration) {
                self.updateHeightConstraint()
                self.view.layoutIfNeeded()
            }
        }
    }

    public var consoleWindowMode: WindowMode = .collapsed {
        didSet {
            updateHeightConstraint()
        }
    }

    // MARK: - Initializer

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    public required init?(coder aDecoder: NSCoder) {
        assertionFailure("Interface Builder is not supported")
        super.init(coder: aDecoder)
    }

    // MARK: - Public Methods

    override open func viewDidLoad() {
        super.viewDidLoad()

        setupViewControllers()
    }

    override open func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            toggleWindowMode()
        }
    }

    // MARK: - Private Methods

    internal func toggleWindowMode() {
        consoleWindowMode = consoleWindowMode == .collapsed ? .expanded : .collapsed
        UIView.animate(withDuration: animationDuration) {
            self.view.layoutIfNeeded()
        }
    }

    private func setupViewControllers() {
        removeAllChildren()

        addChild(consoleViewController)
        view.addSubview(consoleViewController.view)

        consoleViewController.view.translatesAutoresizingMaskIntoConstraints = false
        consoleViewController.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        consoleViewController.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        consoleViewController.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        if #available(iOS 11.0, *) {
            consoleViewController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        } else {
            consoleViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        }

        consoleViewController.didMove(toParent: self)
    }
}
