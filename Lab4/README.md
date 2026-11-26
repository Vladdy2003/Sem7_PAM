# Laborator 3 – Health App (Flutter + Cubit)

Extinderea aplicatiei din Lab 2 cu **State Management (flutter_bloc / Cubit)**,
**programare asincrona** si date incarcate dintr-un **fisier JSON**.

## Structura proiectului

```
assets/data/lab.json            datele aplicatiei (incarcate asincron)
lib/
  main.dart                     RepositoryProvider + BlocProvider(HomeCubit)
  models/                       modele de date cu fromJson (Equatable)
    app_data.dart, home_data.dart, doctor.dart, appointment_details.dart
  data/health_repository.dart   HealthRepository (abstract) + JsonHealthRepository
  cubits/
    home/home_cubit.dart        incarcare, cautare, filtrare, sortare, favorite
    home/home_state.dart        Initial / Loading / Success / Empty / Error
    appointment/appointment_cubit.dart   selectie ora/data + rezervare async
  screens/
    home_screen.dart            ecranul principal (lista de doctori)
    appointment_screen.dart     pagina de detalii / programare
  widgets/                      componente UI reutilizabile
    avatar_image, appointment_card, doctor_tile, favorite_button,
    filter_chips_bar, health_service_item, search_field, section_header,
    slot_selector, primary_button, contact_button, sort_filter_sheet,
    state_views (LoadingView, ErrorView, EmptyView)
  theme/app_colors.dart
test/widget_test.dart           teste pentru HomeCubit si pentru UI
```

## Functionalitati

- **Incarcare asincrona**: `rootBundle.loadString` + `jsonDecode` (cu o intarziere
  simulata de 1.2 s ca sa se vada starea Loading). Pull-to-refresh reincarca datele.
- **Stari**: Loading (spinner), Success (lista), Empty (nimic gasit / lista goala),
  Error (mesaj + buton „Try again”).
- **Cautare** dupa nume, specialitate sau adresa.
- **Filtrare** dupa specialitate (chip-uri sau apasand un „Health Service”)
  si „Favorites only”.
- **Sortare**: Default, Name A-Z, Name Z-A, Nearest first (distanta extrasa din text).
- **Favorite**: inimioara in lista si pe pagina de detalii; starea este comuna
  (HomeCubit e furnizat deasupra `MaterialApp`).
- **Navigare la detalii**: cardul „Appointment” sau orice doctor din lista.
  Pe pagina de detalii: selectie ora/data si rezervare asincrona (loader + SnackBar).

## Rulare

```
flutter pub get
flutter run
flutter test
```
