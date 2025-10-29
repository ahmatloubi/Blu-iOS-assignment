//
//  RefereshableListView.swift
//  BluProject
//
//  Created by Amir Hossein on 27/10/2025.
//

import SwiftUI

struct RefreshableList<Content: View>: View {
    let content: () -> Content
    let onRefresh: () -> Void

    @State private var isRefreshing = false

    var body: some View {
        List {
            content()
        }
        .background(RefreshControl(isRefreshing: $isRefreshing, onRefresh: onRefresh))
    }
}

struct RefreshControl: UIViewRepresentable {
    @Binding var isRefreshing: Bool
    let onRefresh: () -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(isRefreshing: $isRefreshing, onRefresh: onRefresh)
    }

    func makeUIView(context: Context) -> some UIView {
        let view = UIView(frame: .zero)
        DispatchQueue.main.async {
            guard let scrollView = view.superview(of: UIScrollView.self) else { return }
            let refreshControl = UIRefreshControl()
            refreshControl.addTarget(context.coordinator,
                                     action: #selector(Coordinator.handleRefresh),
                                     for: .valueChanged)
            scrollView.refreshControl = refreshControl
            context.coordinator.refreshControl = refreshControl
        }
        return view
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
        if isRefreshing {
            context.coordinator.refreshControl?.beginRefreshing()
        } else {
            context.coordinator.refreshControl?.endRefreshing()
        }
    }

    class Coordinator: NSObject {
        @Binding var isRefreshing: Bool
        let onRefresh: () -> Void
        weak var refreshControl: UIRefreshControl?

        init(isRefreshing: Binding<Bool>, onRefresh: @escaping () -> Void) {
            _isRefreshing = isRefreshing
            self.onRefresh = onRefresh
        }

        @objc func handleRefresh() {
            isRefreshing = true
            onRefresh()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { 
                self.isRefreshing = false
            }
        }
    }
}

extension UIView {
    func superview<T>(of type: T.Type) -> T? {
        if let superview = superview as? T {
            return superview
        }
        return superview?.superview(of: type)
    }
}

