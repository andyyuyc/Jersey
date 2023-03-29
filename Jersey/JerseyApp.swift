import SwiftUI

@main
struct JerseyApp: App {
    @AppStorage("appLanguage") private var appLanguage: String = AppLanguage.chinese.rawValue

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.locale, Locale(identifier: appLanguage))
        }
    }
}

class Jersey: Identifiable {
    var id = UUID()
    var team: String
    var player: String
    var year: String
    var brand: String
    var itemNumber: String
    var image: UIImage

    init(team: String, player: String, year: String, brand: String, itemNumber: String, image: UIImage) {
        self.team = team
        self.player = player
        self.year = year
        self.brand = brand
        self.itemNumber = itemNumber
        self.image = image
    }
}


struct ContentView: View {
    @State var jerseys = [Jersey]()
    @State private var isShowingAddJerseyModal = false
    @State private var isShowingSettingsView = false

    var body: some View {
        NavigationView {
            List {
                if jerseys.count > 0 {
                    ForEach(jerseys) { jersey in
                        JerseyRow(jersey: jersey)
                    }
                    .onDelete(perform: deleteJersey)
                } else {
                    Text(LocalizedStringKey("noJerseysAdded"))
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                        .padding(.vertical, 300)
                }
            }
            .navigationBarTitle(Text(LocalizedStringKey("jerseyCollection")))
            .navigationBarItems(leading: Button(action: {
                isShowingSettingsView = true
            }) {
                Image(systemName: "gear")
            }, trailing: Button(action: {
                isShowingAddJerseyModal = true
            }) {
                Image(systemName: "plus")
            })
            .sheet(isPresented: $isShowingAddJerseyModal) {
                AddJerseyView(jerseys: $jerseys)
            }
            .sheet(isPresented: $isShowingSettingsView) {
                SettingsView()
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
                    Text(jersey.brand)
                        .font(.subheadline)
                    Text(jersey.itemNumber)
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
    @State private var brand: String = ""
    @State private var itemNumber: String = ""
    @State private var image: UIImage? = UIImage()
    @State private var isShowingImagePicker = false

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text(LocalizedStringKey("Image"))) {
                    Button(action: {
                        isShowingImagePicker = true
                    }) {
                        Text(LocalizedStringKey("Choose Image"))
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
                Section(header: Text(LocalizedStringKey("Team"))) {
                    TextField(LocalizedStringKey("Enter team name"), text: $team)
                }

                Section(header: Text(LocalizedStringKey("Player"))) {
                    TextField(LocalizedStringKey("Enter player name"), text: $player)
                }

                Section(header: Text(LocalizedStringKey("Year"))) {
                    TextField(LocalizedStringKey("Enter year"), text: $year)
                }

                Section(header: Text(LocalizedStringKey("Brand"))) {
                    TextField(LocalizedStringKey("Enter brand"), text: $brand)
                }

                Section(header: Text(LocalizedStringKey("Item Number"))) {
                    TextField(LocalizedStringKey("Enter item number"), text: $itemNumber)
                }
            }
            .navigationBarTitle(LocalizedStringKey("Add Jersey"))
            .navigationBarItems(leading: Button(LocalizedStringKey("Cancel")) {
                presentationMode.wrappedValue.dismiss()
            }, trailing: Button(LocalizedStringKey("Save")) {
                let newJersey = Jersey(team: team, player: player, year: year, brand: brand, itemNumber: itemNumber, image: image!)
                jerseys.append(newJersey)
                presentationMode.wrappedValue.dismiss()
            })
            .sheet(isPresented: $isShowingImagePicker, content: {
                ImagePicker(selectedImage: $image, sourceType: UIImagePickerController.SourceType.photoLibrary)
            })
        }
    }
}


enum AppLanguage: String, CaseIterable, Identifiable {
    case english = "en"
    case chinese = "zh-Hans"
    
    var id: String { self.rawValue }
    var displayName: String {
        switch self {
        case .english:
            return "English"
        case .chinese:
            return "中文"
        }
    }
}


struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @AppStorage("appLanguage") private var appLanguage: String = AppLanguage.english.rawValue
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text(LocalizedStringKey("App Language"))) {
                    Picker(LocalizedStringKey("Select language"), selection: $appLanguage) {
                        ForEach(AppLanguage.allCases) { language in
                            Text(language.displayName).tag(language.rawValue)
                        }
                    }
                }
            }
            .navigationBarTitle(LocalizedStringKey("Settings"))
            .navigationBarItems(trailing: Button(LocalizedStringKey("Done")) {
                presentationMode.wrappedValue.dismiss()
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
            parent.presentationMode         .wrappedValue.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}





struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


