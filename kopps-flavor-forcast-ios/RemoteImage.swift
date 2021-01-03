//
//  RemoteImage.swift
//  kopps-flavor-forcast-ios
//
//  Created by Mark Tutkowski on 1/2/21.
//

import SwiftUI

struct RemoteImage: View {
    private enum LoadState {
        case loading, success, failure
    }

    private class Loader: ObservableObject {
        var data = Data()
        var state = LoadState.loading

        init(url: String) {
            guard let escapedString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
                fatalError("Invalid URL: \(url)")
            }
            guard let parsedURL = URL(string: escapedString) else {
                fatalError("Invalid URL: \(escapedString)")
            }

            URLSession.shared.dataTask(with: parsedURL) { data, response, error in
                if let data = data, data.count > 0 {
                    self.data = data
                    self.state = .success
                } else {
                    self.state = .failure
                }

                DispatchQueue.main.async {
                    self.objectWillChange.send()
                }
            }.resume()
        }
    }

    @StateObject private var loader: Loader
    let height: CGFloat
    let width: CGFloat
    var loading: Image
    var failure: Image

    var body: some View {
        selectImage()
            .resizable()
            .frame(width: self.width, height: self.height)
    }

    init(url: String, height: CGFloat, width: CGFloat, loading: Image = Image(systemName: "photo"), failure: Image = Image(systemName: "multiply.circle")) {
        _loader = StateObject(wrappedValue: Loader(url: url))
        self.loading = loading
        self.failure = failure
        self.height = height
        self.width = width
    }

    private func selectImage() -> Image {
        switch loader.state {
        case .loading:
            return loading
        case .failure:
            return failure
        default:
            if let image = UIImage(data: loader.data) {
                return Image(uiImage: image)
            } else {
                return failure
            }
        }
    }
}
