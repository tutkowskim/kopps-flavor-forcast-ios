//
//  ContentView.swift
//  kopps-flavor-forcast-ios
//
//  Created by Mark Tutkowski on 1/2/21.
//

import SwiftUI

struct ContentView: View {
    @State var flavorForecasts = [FlavorForecast]()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(self.flavorForecasts, id: \.date, content: { flavorForecast in
                    Section(header: Text(flavorForecast.date).font(.title3)) {
                        ForEach(flavorForecast.flavors, id: \.flavor, content: { flavor in
                            NavigationLink(
                                destination: VStack {
                                    RemoteImage(url: flavor.image, height: 128.0, width: 128.0)
                                    Text(flavor.flavor)
                                        .font(.title3)
                                    Text(flavor.description.replacingOccurrences(of: "\n", with: "", options: .literal, range: nil))
                                        .multilineTextAlignment(.center)
                                        .font(.subheadline)
                                },
                                label: {
                                    HStack {
                                        RemoteImage(url: flavor.image, height: 32.0, width: 32.0)
                                        Text(flavor.flavor)
                                    }
                                })
                        })
                    }
                })
            }
            .listStyle(GroupedListStyle())
            .navigationTitle("Flavor Forecast")
            .onAppear(perform: loadData)
        }
    }
    
    func loadData() {
        guard let url = URL(string: "https://kopps-flavor-forecast-api.azurewebsites.net") else {
            print("Invalid API Endpoint")
            return
        }
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let flavorForecast = try? JSONDecoder().decode([FlavorForecast].self, from: data) {
                    DispatchQueue.main.async {
                        self.flavorForecasts = flavorForecast
                    }
                }
            }
        }.resume()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
