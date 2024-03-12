//
//  ContentView.swift
//  restaurant1
//
//  Created by Szymon Perz on 27/01/2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(colors: [.red, .gray], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                VStack {
                    NavigationLink(destination: MenuView()) {
                        Text("Menu")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding()

                    NavigationLink(destination: PracownikView()) {
                        Text("Pracownicy")
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding()
                }
                .navigationTitle("Restauracja u Fukiera")
            }
        }
    }
}

struct MenuView: View {
    @ObservedObject var daniaManager = DaniaClass()
    @State private var ukryjPrzystawki = false
    @State private var ukryjDesery = false

    var body: some View {
        NavigationView {
                    VStack {
                        HStack {
                            Toggle(isOn: $ukryjPrzystawki) {
                                Text("Ukryj przystawki")
                            }
                            .padding()

                            Toggle(isOn: $ukryjDesery) {
                                Text("Ukryj desery")
                            }
                            .padding()

                            Spacer()
                        }

                        HStack {
                            Button(action: {
                                daniaManager.wybraneSortowanie = .alfabetycznie
                            }) {
                                Text("Sortuj alfabetycznie")
                            }
                            .padding()

                            Button(action: {
                                daniaManager.wybraneSortowanie = .cenaMal
                            }) {
                                Text("Sortuj według ceny")
                            }
                            .padding()

                            Button(action: {
                                daniaManager.wybraneSortowanie = .popularnosc
                            }) {
                                Text("Sortuj według popularności")
                            }
                            .padding()

                            Spacer()
                        }

                List(daniaManager.dania) { danie in
                    if  !(ukryjPrzystawki && danie.kategoria == "przystawki") &&
                        !(ukryjDesery && danie.kategoria == "deser") {
                        VStack(alignment: .leading) {
                            Text("\(danie.nazwa)")
                            Text(String(format: "Cena: %.2f zł", danie.cena))
                            Text("Popularność: \(danie.popularnosc)")
                            Text("Zamówienia: \(danie.zamowienia)")
                            Image(danie.image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                                        }
                            
                            HStack {
                                Button(action: {
                                    daniaManager.zamowienieDania(danie)
                                }) {
                                    Text("Zamów")
                                }
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        .padding()
                    }
                }
                .navigationBarTitle("Wszystkie dania")
            }
        }
    }
}

struct PracownikView: View {
    @ObservedObject var daniaManager2 = DaniaClass()
    var body: some View {
        List(daniaManager2.dania) { danie in
                VStack(alignment: .leading) {
                    Text("\(danie.nazwa)")
                    Text(String(format: "Cena: %.2f zł", danie.cena))
                    ForEach(danie.skladniki, id: \.self) { skladnik in
                                        Text("Składnik: \(skladnik.rawValue)")
                }
            }
        }
    }
}

protocol DanieProtocol: Identifiable {
    var id: UUID { get }
    var nazwa: String { get }
    var cena: Double { get }
    var popularnosc: Int { get }
    var kategoria: String { get }
    var image: String { get }
    var zamowienia: Int { get set }
    var skladniki: [Skladnik] { get set }
}

class Danie: ObservableObject, DanieProtocol {
    let id = UUID()
    let nazwa: String
    let cena: Double
    let popularnosc: Int
    let kategoria: String
    let image: String
    @Published var zamowienia: Int
    var skladniki: [Skladnik]

    init(nazwa: String, cena: Double, popularnosc: Int, kategoria: String, image: String, zamowienia: Int, skladniki: [Skladnik]) {
        self.nazwa = nazwa
        self.cena = cena
        self.popularnosc = popularnosc
        self.kategoria = kategoria
        self.image = image
        self.zamowienia = zamowienia
        self.skladniki = skladniki
    }
}

enum Skladnik: String, CaseIterable {
    case ser
    case sosPomidorowy
    case pieczarki
    case mieso
    case bulkaTarta
    case jajko
    case salata
    case kotlet
    case bulka
    case pomidor
    case serCheddar
    case serPlesniowy
    case serBialy
    case sledz
    case cebula
    case ocet
    case burak
    case serSolan
    case rukola
    case bialko
    case cukier
    case owoceSezonowe
    case jablka
    case cynamon
    case ciasto
    case lodyWaniliowe
    case czekolada
    case maliny
}

enum Kategoria: String, CaseIterable {
    case dania
    case przystawki
    case deser
}

enum Sortowanie: String, CaseIterable {
    case cenaMal = "Ceny malejąco"
    case cenaRos = "Ceny rosnąco"
    case alfabetycznie = "Alfabetycznie"
    case popularnosc = "Popularność"
}

class DaniaClass: ObservableObject {
    @Published var dania: [Danie] = [
        Danie(nazwa: "Pizza", cena: 18.99, popularnosc: 3, kategoria: "dania", image: "pizza_image", zamowienia: 0, skladniki: [.ser, .sosPomidorowy, .pieczarki]),
                Danie(nazwa: "Kotlet", cena: 21.99, popularnosc: 2, kategoria: "dania", image: "kotlet_image", zamowienia: 3, skladniki: [.mieso, .bulkaTarta, .jajko]),
                Danie(nazwa: "Burger", cena: 24.99, popularnosc: 4, kategoria: "dania", image: "burger_image", zamowienia: 0, skladniki: [.kotlet, .bulka, .salata, .pomidor]),
                Danie(nazwa: "Deska polskich serów", cena: 21.99, popularnosc: 3, kategoria: "przystawki", image: "deskaSerow_image", zamowienia: 0, skladniki: [.serCheddar, .serPlesniowy, .serBialy]),
                Danie(nazwa: "Śledź zagrycha", cena: 17.99, popularnosc: 1, kategoria: "przystawki", image: "sledz_image", zamowienia: 5, skladniki: [.sledz, .cebula, .ocet]),
                Danie(nazwa: "Carpaccio z buraka z serem Solan na rukoli", cena: 31.99, popularnosc: 5, kategoria: "przystawki", image: "carpaccio_image", zamowienia: 0, skladniki: [.burak, .serSolan, .rukola]),
                Danie(nazwa: "Sezonowa beza", cena: 19.99, popularnosc: 4, kategoria: "deser", image: "beza_image", zamowienia: 0, skladniki: [.bialko, .cukier, .owoceSezonowe]),
                Danie(nazwa: "Szarlotka", cena: 14.99, popularnosc: 5, kategoria: "deser", image: "szarlotka_image", zamowienia: 0, skladniki: [.jablka, .cynamon, .ciasto]),
                Danie(nazwa: "Lody", cena: 12.99, popularnosc: 2, kategoria: "deser", image: "lody_image", zamowienia: 0, skladniki: [.lodyWaniliowe, .czekolada, .maliny]),
            ]

    
    @Published var wybraneSortowanie: Sortowanie = .alfabetycznie {
        didSet {        // didSet - wykonuje natychmiast gdy wybraneSortowanie zostanie ustawione
            sortuj()
        }
    }

    func zamowienieDania(_ danie: Danie) {
           if let index = dania.firstIndex(where: { $0.id == danie.id }) {
               dania[index].zamowienia += 1
               objectWillChange.send()
           }
       }
    
    
    func sortuj() {
        switch wybraneSortowanie {
        case .cenaMal:
            dania.sort { $0.cena < $1.cena }
        case .cenaRos:
            dania.sort{ $0.cena > $1.cena }
        case .alfabetycznie:
            dania.sort { $0.nazwa < $1.nazwa }
        case .popularnosc:
            dania.sort { $0.popularnosc > $1.popularnosc }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

