//
//  JerseyApp.swift
//  Jersey
//
//  Created by Andy Yu on 2023/3/28.
//

import SwiftUI

@main
struct JerseyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class Jersey: Identifiable {
    var id = UUID()
    var team: String
    var player: String
    var year: String
    var image: UIImage
    
    init(team: String, player: String, year: String, image: UIImage) {
        self.team = team
        self.player = player
        self.year = year
        self.image = image
    }
}



struct ContentView: View {
    @State var jerseys = [Jersey]()

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    if jerseys.count > 0 {
                        ForEach(jerseys) { jersey in
                            JerseyRow(jersey: jersey)
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                .padding(.vertical, 10)
                        }
                    } else {
                        Text("You haven't added any jerseys yet.")
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                            .padding(.vertical, 300)
                    }
                }
            }
            .navigationBarTitle(Text("Jersey Collection"))
            .navigationBarItems(trailing: Button(action: {
                let newJersey = Jersey(team: "New Team", player: "New Player", year: "New Year", image: UIImage(named: "defaultJersey")!)
                jerseys.append(newJersey)
            }) {
                Image(systemName: "plus")
            })
        }
    }
}


struct JerseyRow: View {
    var jersey: Jersey

    var body: some View {
        NavigationLink(destination: DetailView(jersey: jersey)) {
            HStack {
                Image(uiImage: jersey.image)
                    .resizable()
                    .frame(width: 50, height: 50)
                VStack(alignment: .leading) {
                    Text(jersey.team)
                        .font(.headline)
                    Text(jersey.player)
                        .font(.subheadline)
                    Text(jersey.year)
                        .font(.subheadline)
                }
            }
        }
    }
}

struct DetailView: View {
    var jersey: Jersey

    var body: some View {
        VStack {
            Image(uiImage: jersey.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding()
            Text(jersey.team)
                .font(.title)
            Text(jersey.player)
                .font(.headline)
                .padding(.bottom, 16)
            Text(jersey.year)
                .font(.subheadline)
        }
        .navigationBarTitle(Text(jersey.team), displayMode: .inline)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView() // Initialize your struct
    }
}
