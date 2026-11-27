# Laborator 4 – Health App (Flutter + REST API + Clean Architecture)

Acelasi design ca in laboratoarele anterioare, dar datele vin de la un
serviciu Web REST (HTTP + JSON), iar codul este organizat dupa
**Clean Architecture**: Presentation → Domain ← Data.

API folosit:

| Endpoint | Ecran |
|---|---|
| `GET https://test-api-jlbn.onrender.com/lab2026/v2/feed` | ecranul principal |
| `GET https://test-api-jlbn.onrender.com/lab2026/v2/feed/details` | ecranul de programare |

## Structura proiectului

```
lib/
  main.dart                       pornirea aplicatiei, furnizeaza use case-urile + HomeCubit
  injection_container.dart        DI: http.Client -> DataSource -> RepositoryImpl

  core/                           cod comun, folosit de toate straturile
    network/api_config.dart       baseUrl, endpoint-uri, timeout
    error/exceptions.dart         ServerException, NetworkException, ParsingException (Data)
    error/failures.dart           ServerFailure, NetworkFailure, ParsingFailure (Domain/UI)
    result.dart                   Result<T> = ResultSuccess | ResultFailure
    usecase/usecase.dart          contractul UseCase<T, Params>

  domain/                         logica de business, fara Flutter / HTTP / JSON
    entities/                     Doctor, HomeFeed (+UserProfile, HealthService...),
                                  AppointmentDetails (+Payment, SlotGroup...)
    repositories/health_repository.dart   interfata (contractul) repository-ului
    usecases/get_home_feed.dart           GetHomeFeed
    usecases/get_appointment_details.dart GetAppointmentDetails

  data/                           accesul la date (REST API)
    datasources/health_remote_data_source.dart  cererile HTTP GET + jsonDecode
    models/                       DTO-uri: fromJson (deserializare), toJson
                                  (serializare), toEntity (conversie spre Domain)
    repositories/health_repository_impl.dart    DTO -> entitate, exceptie -> Failure

  presentation/                   interfata utilizatorului
    cubits/home/                  HomeCubit + stari (Loading/Success/Empty/Error)
    cubits/appointment/           AppointmentDetailsCubit (Loading/Loaded/Error)
                                  AppointmentCubit (selectie ora/data + rezervare)
    screens/                      home_screen.dart, appointment_screen.dart
    widgets/                      componente UI reutilizabile (DoctorTile, SlotSelector,
                                  LoadingView / ErrorView / EmptyView ...)
    theme/app_colors.dart

test/
  fixtures/                       copii ale raspunsurilor API (doar pentru teste)
  helpers.dart                    MockClient + repository-uri false
  data_layer_test.dart            JSON <-> model, mapare erori -> Failure
  widget_test.dart                HomeCubit + UI (Loading/Success/Empty/Error)
```

### Regula dependentelor

- `domain` nu importa nimic din `data` sau `presentation` (nici Flutter, nici `http`).
- `presentation` foloseste doar `domain` (use case-uri si entitati), nu stie de HTTP.
- `data` implementeaza interfata din `domain`.

## Fluxul datelor (UI → server → UI)

```
HomeScreen ── HomeCubit.loadData() ── emit(HomeLoading)
                │
                ▼
        GetHomeFeed()                         (Domain – use case)
                │
                ▼
        HealthRepository.getHomeFeed()        (Domain – interfata)
                │  implementat de
                ▼
        HealthRepositoryImpl                  (Data)
                │
                ▼
        HealthRemoteDataSourceImpl            (Data)
          GET /feed  →  status 200?  →  jsonDecode  →  HomeFeedModel.fromJson
                │
                ▼
        HomeFeedModel.toEntity()  →  ResultSuccess(HomeFeed)
           (sau exceptie  →  ResultFailure(ServerFailure/NetworkFailure/ParsingFailure))
                │
                ▼
        HomeCubit: emit(HomeSuccess / HomeEmpty / HomeError)  →  HomeScreen se redeseneaza
```

Ecranul de programare urmeaza acelasi drum cu `GetAppointmentDetails` si
`GET /feed/details`, cu propriile stari Loading / Loaded / Error.

## Functionalitati

- **Operatii asincrone**: cereri HTTP cu `async/await`, timeout 60 s (serverul de pe
  Render porneste greu la prima cerere). Pull-to-refresh reincarca datele.
- **Stari**: Loading (spinner), Success, Empty, Error (mesaj + „Try again”) pe ambele ecrane.
- **Cautare, filtrare, sortare, favorite**: locale, in `HomeCubit`, fara cereri noi.
- **Rezervare**: selectie ora/data si rezervare simulata (loader + SnackBar).

## Rulare

```
flutter pub get
flutter run
flutter test
```

Pe web, browserul blocheaza cererile (API-ul nu trimite antete CORS);
pe Android/iOS functioneaza normal.
