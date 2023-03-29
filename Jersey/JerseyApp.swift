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
    @State private var isShowingAddJerseyModal = false

    var body: some View {
        NavigationView {
            List {
                if jerseys.count > 0 {
                    ForEach(jerseys) { jersey in
                        JerseyRow(jersey: jersey)
                    }
                    .onDelete(perform: deleteJersey)
                } else {
                    Text("You haven't added any jerseys yet.")
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                        .padding(.vertical, 300)
                }
            }
            .navigationBarTitle(Text("Jersey Collection"))
            .navigationBarItems(trailing: Button(action: {
                isShowingAddJerseyModal = true
            }) {
                Image(systemName: "plus")
            })
            .sheet(isPresented: $isShowingAddJerseyModal) {
                AddJerseyView(jerseys: $jerseys)
            }
        }
    }

    private func deleteJersey(at offsets: IndexSet) {
        jerseys.remove(atOffsets: offsets)
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


struct AddJerseyView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var jerseys: [Jersey]

    @State private var team: String = ""
    @State private var player: String = ""
    @State private var year: String = ""
    @State private var image: UIImage? = UIImage()
    @State private var isShowingImagePicker = false

    var body: some View {
        NavigationView {
            Form {
                // Other sections

                Section(header: Text("Image")) {
                    Button(action: {
                        isShowingImagePicker = true
                    }) {
                        Text("Choose Image")
                    }
                    if let image = image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .cornerRadius(10)
                            .padding()
                    }
                }
                Section(header: Text("Team")) {
                    TextField("Enter team name", text: $team)
                }

                Section(header: Text("Player")) {
                    TextField("Enter player name", text: $player)
                }

                Section(header: Text("Year")) {
                    TextField("Enter year", text: $year)
                }
            }
            .navigationBarTitle("Add Jersey")
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            }, trailing: Button("Save") {
                let newJersey = Jersey(team: team, player: player, year: year, image: image!)
                jerseys.append(newJersey)
                presentationMode.wrappedValue.dismiss()
            })
            .sheet(isPresented: $isShowingImagePicker, content: {
                ImagePicker(selectedImage: $image, sourceType: .photoLibrary)
            })
        }
    }
}





struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedImage: UIImage?

    var sourceType: UIImagePickerController.SourceType

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = context.coordinator
        imagePicker.sourceType = sourceType
        return imagePicker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            parent.presentationMode.wrappedValue.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}







struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView() // Initialize your struct
    }
}
