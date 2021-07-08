//
//  AutomaticallyFinish.swift
//  
//
//  Created by Sergej Jaskiewicz on 08.07.2021.
//

#if OPENCOMBINE_COMPATIBILITY_TEST
import Combine
#else
import OpenCombine
#endif

final class AutomaticallyFinish<Output, Failure: Error> {

    let subscription: CustomSubscription
    let publisher: CustomPublisherBase<Output, Failure>

    init() {
        subscription = .init()
        publisher = .init(subscription: subscription)
    }

    deinit {
        publisher.send(completion: .finished)
    }

    func notify(_ value: Output) {
        _ = publisher.send(value)
    }

    func listen(receiveCompletion: @escaping (Subscribers.Completion<Failure>) -> Void,
                receiveValue: @escaping (Output) -> Void) -> AnyCancellable {
        return publisher.sink(receiveCompletion: receiveCompletion,
                            receiveValue: receiveValue)
    }
}