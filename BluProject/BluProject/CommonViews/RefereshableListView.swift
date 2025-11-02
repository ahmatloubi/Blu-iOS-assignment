//
//  RefereshableListView.swift
//  BluProject
//
//  Created by Amir Hossein on 27/10/2025.
//

import SwiftUI

struct RefreshableScrollView<Content: View>: UIViewRepresentable {
    var onRefresh: () -> Void
    @Binding var isRefreshing: Bool
    var content: () -> Content

    func makeCoordinator() -> Coordinator {
        Coordinator(onRefresh: onRefresh, isRefreshing: $isRefreshing)
    }

    func makeUIView(context: Context) -> UIScrollView {
        let scrollView = UIScrollView()

        let hostingController = UIHostingController(rootView: content())
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(hostingController.view)

        NSLayoutConstraint.activate([
            hostingController.view.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            hostingController.view.topAnchor.constraint(equalTo: scrollView.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            hostingController.view.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])

        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(context.coordinator, action: #selector(Coordinator.handleRefresh), for: .valueChanged)
        scrollView.refreshControl = refreshControl
        context.coordinator.refreshControl = refreshControl
        context.coordinator.hostingController = hostingController

        return scrollView
    }

    func updateUIView(_ scrollView: UIScrollView, context: Context) {
        context.coordinator.hostingController?.rootView = content()

        if isRefreshing {
            context.coordinator.refreshControl?.beginRefreshing()
        } else {
            context.coordinator.refreshControl?.endRefreshing()
        }
    }

    class Coordinator: NSObject {
        var onRefresh: () -> Void
        @Binding var isRefreshing: Bool
        weak var refreshControl: UIRefreshControl?
        weak var hostingController: UIHostingController<Content>?

        init(onRefresh: @escaping () -> Void, isRefreshing: Binding<Bool>) {
            self.onRefresh = onRefresh
            _isRefreshing = isRefreshing
        }

        @objc func handleRefresh() {
            guard !isRefreshing else { return }
            isRefreshing = true
            onRefresh()
        }
    }
}
