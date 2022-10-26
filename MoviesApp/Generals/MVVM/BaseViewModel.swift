class BaseViewModel<State: ViewModelStateType>: ViewModelType {

    /// View model's state.
    var state: State = .idle {
        didSet { didChange?() }
    }

    /// A closure that is invoked after the object has changed.
    var didChange: (() -> Void)? {
        didSet { didChange?() }
    }

    func start() {
        // Does nothing
    }
}
