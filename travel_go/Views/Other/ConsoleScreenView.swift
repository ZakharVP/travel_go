//
//  MainAppView.swift
//  travel_go
//
//  Created by Захар Панченко on 11.08.2025.
//

import SwiftUI
import OpenAPIURLSession

struct ConsoleScreenView: View {
   
    @State private var copyrightInfo: String = "Загрузка..."
    @State private var stationsInfo: String = ""
    
    var body: some View { 
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("🟢  Hello, World!")
        }
        .padding()
        .onAppear() {
            // Расписание рейсов между станциями +
            fetchSearch()
            
            // Расписание рейсов по станции +
            fetchSchedule()
            
            // Список станций следования +
            //fetchThreadManually()
            fetchThread()
            
            // Список ближайших станций +
            testFetchStations()
            
            // Ближайший город +
            fetchNearestCity()
            
            // Информация о перевозчике +
            //testCarrierRequest()
            fetchCarrier()
            
            // Список всех доступных станций +
            fetchAllStations()
            
            // Копирайт +
            fetchCopyright()
    
        }
    }
    
    //Упрощенная версия получения списка данных
    func fetchAllStationsOld() {
        let urlString = "https://api.rasp.yandex.net/v3.0/stations_list/?apikey=\(APIKeys.yandexStationKey)&lang=ru_RU&format=json"
        
        guard let url = URL(string: urlString) else {
            print("🔴 Неверный URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("🔴 Ошибка: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("🔴 Нет данных в ответе")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let stationsResponse = try decoder.decode(AllStationsResponse.self, from: data)
                
                print("🟢 Успешно получены данные")
                
                var first10Stations: [Components.Schemas.Station] = []
                var stationCount = 0
                
                if let countries = stationsResponse.countries {
                    for country in countries {
                        if let regions = country.regions {
                            for region in regions {
                                if let settlements = region.settlements {
                                    for settlement in settlements {
                                        if let stations = settlement.stations {
                                            for station in stations {
                                                if stationCount < 10 {
                                                    first10Stations.append(station)
                                                    stationCount += 1
                                                } else {
                                                    break
                                                }
                                            }
                                        }
                                        if stationCount >= 10 { break }
                                    }
                                }
                                if stationCount >= 10 { break }
                            }
                        }
                        if stationCount >= 10 { break }
                    }
                }
                
                print("\n🟢 Первые 10 станций:")
                print("========================")
                
                for (index, station) in first10Stations.enumerated() {
                    print("\(index + 1). \(station.title ?? "Без названия")")
                    print("   🆔 Код: \(station.codes?.yandex_code ?? "нет кода")")
                    print("   🚊 Тип: \(station.transport_type ?? "не указан")")
                    print("   📍 Координаты: \(station.lat ?? 0), \(station.lng ?? 0)")
                    print("   🏷️ Тип станции: \(station.station_type ?? "не указан")")
                    print("========================")
                }
                
            } catch {
                print("🔴 Ошибка декодирования: \(error.localizedDescription)")
                if let rawResponse = String(data: data, encoding: .utf8) {
                    print("Сырой ответ сервера:")
                    print(rawResponse)
                }
            }
        }.resume()
    }
    
    func fetchAllStations() {
        Task {
            do {
                
                let client = Client(
                    serverURL: try Servers.Server1.url(),
                    transport: URLSessionTransport()
                )
                
                print("🟡 Запрашиваем список всех станций...")
                
                let service = AllStationsService(
                    client: client,
                    apiKey: APIKeys.yandexStationKey
                )
                
                let stationsResponse = try await service.getAllStations()
                
                // Остальной код остается без изменений
                var first10Stations: [Components.Schemas.Station] = []
                var stationCount = 0
                
                if let countries = stationsResponse.countries {
                    for country in countries {
                        if let regions = country.regions {
                            for region in regions {
                                if let settlements = region.settlements {
                                    for settlement in settlements {
                                        if let stations = settlement.stations {
                                            for station in stations {
                                                if stationCount < 10 {
                                                    first10Stations.append(station)
                                                    stationCount += 1
                                                } else {
                                                    break
                                                }
                                            }
                                        }
                                        if stationCount >= 10 { break }
                                    }
                                }
                                if stationCount >= 10 { break }
                            }
                        }
                        if stationCount >= 10 { break }
                    }
                }
                
                print("\n🟢 Первые 10 станций:")
                print("========================")
                
                for (index, station) in first10Stations.enumerated() {
                    print("\(index + 1). \(station.title ?? "Без названия")")
                    print("   🆔 Код: \(station.codes?.yandex_code ?? "нет кода")")
                    print("   🚊 Тип: \(station.transport_type ?? "не указан")")
                    print("   📍 Координаты: \(station.lat ?? 0), \(station.lng ?? 0)")
                    print("   🏷️ Тип станции: \(station.station_type ?? "не указан")")
                    print("========================")
                }
                
            } catch let error as URLError where error.code == .timedOut {
                print("🔴 Таймаут запроса: сервер не ответил вовремя")
            } catch {
                print("\n🔴 Ошибка при получении списка станций:")
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchCarrier() {
        Task {
            do {
                let client = Client(
                    serverURL: try Servers.Server1.url(),
                    transport: URLSessionTransport()
                )
                
                print("🟡 Запрашиваем информацию о перевозчике...")
                
                let service = CarrierService(
                    client: client,
                    apiKey: APIKeys.yandexStationKey
                )
                
                let carrierCode = "SU"
                let system = "iata"
                
                let carrier = try await service.getCarrierInfo(
                    code: carrierCode,
                    system: system
                )
                
                print("\n🟢 Информация о перевозчике:")
                print("🏢 Название: \(carrier.title)")
                print("🆔 Код: \(carrier.code)")
                print("✈️ IATA код: \(carrier.codes.iata)")
                
                if let phone = carrier.phone {
                    print("📞 Телефон: \(phone)")
                }
                
                if let url = carrier.url {
                    print("🌐 Сайт: \(url)")
                }
                
                if let address = carrier.address {
                    print("🏠 Адрес: \(address)")
                }
                
                if let logo = carrier.logo {
                    print("🖼️ Логотип: \(logo)")
                }
                
            } catch {
                print("\n🔴 Ошибка при запросе информации о перевозчике:")
                print(error.localizedDescription)
            }
        }
    }
    
    func testCarrierRequest() {
        let urlString = "https://api.rasp.yandex.net/v3.0/carrier/?format=json&apikey=d7da3fd8-3adb-459e-8cf8-13283ad0685d&lang=ru_RU&code=TK&system=iata"
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("🔴 Ошибка: \(error)")
                return
            }
            
            if let data = data {
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("🟢 Raw response:\n\(jsonString)")
                }
            }
        }.resume()
    }
    
    func fetchNearestCity() {
        Task {
            do {
                let client = Client(
                    serverURL: try Servers.Server1.url(),
                    transport: URLSessionTransport()
                )
                
                print("🟡 Запрашиваем ближайший город...")
                
                let service = SettlementService(
                    client: client,
                    apiKey: APIKeys.yandexStationKey
                )
                
                // Координаты для примера (Санкт-Петербург)
                let latitude = 59.934280
                let longitude = 30.335098
                let distance = 50 // Радиус поиска в км (опционально)
                
                let cityResponse = try await service.getNearestCity(
                    latitude: latitude,
                    longitude: longitude,
                    distance: distance
                )
                
                // Выводим информацию о городе
                print("\n🟢 Найден ближайший город:")
                print("========================")
                
                if let distance = cityResponse.distance {
                    print("📍 Расстояние: \(String(format: "%.1f", distance)) км")
                }
                
                print("🏙️ Название: \(cityResponse.title ?? "не указано")")
                
                if let popularTitle = cityResponse.popular_title {
                    print("🏙️ Общепринятое название: \(popularTitle)")
                }
                
                if let shortTitle = cityResponse.short_title {
                    print("🏙️ Краткое название: \(shortTitle)")
                }
                
                print("🆔 Код: \(cityResponse.code ?? "не указан")")
                
                if let lat = cityResponse.lat, let lng = cityResponse.lng {
                    print("🌐 Координаты: \(lat), \(lng)")
                }
                
                print("========================")
                
            } catch let error as DecodingError {
                print("\n🔴 Ошибка декодирования:")
                switch error {
                case .typeMismatch(let type, let context):
                    print("Несоответствие типа \(type) в пути: \(context.codingPath)")
                case .valueNotFound(let type, let context):
                    print("Не найдено значение \(type) в пути: \(context.codingPath)")
                case .keyNotFound(let key, let context):
                    print("Не найден ключ \(key) в пути: \(context.codingPath)")
                case .dataCorrupted(let context):
                    print("Данные повреждены: \(context)")
                @unknown default:
                    print("Неизвестная ошибка декодирования")
                }
            } catch {
                print("\n🔴 Ошибка при запросе ближайшего города:")
                print(error.localizedDescription)
            }
        }
    }
    
    func testFetchStations() {
        Task {
            do {
                let client = Client(
                    serverURL: try Servers.Server1.url(),
                    transport: URLSessionTransport()
                )
                let service = NearestStationsService(
                    client: client,
                    apiKey: APIKeys.yandexStationKey
                )
                print("🟡 Fetching stations ...")
                let stations = try await service.getNearestStations(
                    latitude: 59.75222,
                    longitude: 30.61556,
                    distance: 50
                )
                
                let encoder = JSONEncoder()
                encoder.outputFormatting = .prettyPrinted
                let jsonData = try encoder.encode(stations)
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    DispatchQueue.main.async {
                        self.stationsInfo = jsonString
                    }
                }
                
            } catch {
                print("🔴 Error fetchinf stations: \(error)")
            }
        }
    }
    
    func fetchCopyright() {
        print("🟢 Начало запроса информации о копирайте...")
        Task {
            do {
                let client = Client(
                    serverURL: try Servers.Server1.url(),
                    transport: URLSessionTransport()
                )
                print("🔵 Клиент API успешно создан")
                let service = CopyrightService(
                    client: client,
                    apiKey: APIKeys.yandexStationKey
                )
                print("🔵 Сервис копирайта инициализирован")
                print("🟡 Отправка запроса к API...")
                let info = try await service.getCopyrightInfo()
                print("🟢 Успешно получена информация о копирайте: \(info)")
                DispatchQueue.main.async {
                    self.copyrightInfo = info
                    print("🟢 Информация обновлена в UI")
                }
            } catch {
                print("🔴 Ошибка при запросе копирайта: \(error)")
                print("🔴 Подробности ошибки: \(error.localizedDescription)")
                let errorMessage = "Ошибка: \(error.localizedDescription)"
                DispatchQueue.main.async {
                    self.copyrightInfo = errorMessage
                    print("🔴 Ошибка отображена в UI")
                }
            }
        }
    }
    
    func fetchSchedule() {
        Task {
            do {
                let client = Client(
                    serverURL: try Servers.Server1.url(),
                    transport: URLSessionTransport()
                )
                print("🟡 Получаем расписание...")
                
                let service = ScheduleService(
                    client: client,
                    apiKey: APIKeys.yandexStationKey
                )
                
                let scheduleResponse = try await service.getStationSchedule(
                    station: "s2000006", // Код станции (Белорусский вокзал)
                    date: "2025-07-28", // Дата
                    transportTypes: "suburban", // Тип транспорта (электрички)
                    event: "departure", // Событие (отправление)
                    direction: "на Москву" // Направление
                )
                
                // Создаем форматтер для даты
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "HH:mm"
                dateFormatter.timeZone = TimeZone(identifier: "Europe/Moscow")
                
                // Выводим информацию о станции
                if let station = scheduleResponse.station {
                    print("\n🚉 Информация о станции:")
                    print("""
                    📍 Название: \(station.title ?? "не указано")
                    🚦 Тип: \(station.station_type_name ?? "не указан")
                    🏷️ Код: \(station.code ?? "не указан")
                    🚊 Тип транспорта: \(station.transport_type ?? "не указан")
                    """)
                }
                
                // Проверяем наличие расписания
                if let schedule = scheduleResponse.schedule, !schedule.isEmpty {
                    print("\n📅 Расписание на \(scheduleResponse.date ?? "неизвестную дату"):")
                    print("🛤️ Найдено рейсов: \(schedule.count)")
                    
                    for (index, item) in schedule.prefix(10).enumerated() {
                        let thread = item.thread
                        print("\n\(index + 1). \(thread?.title ?? "Рейс без названия")")
                        
                        if let departureDate = item.departure {
                            print("   🕒 Отправление: \(dateFormatter.string(from: departureDate))")
                        }
                        
                        print("   🔢 Номер: \(thread?.number ?? "не указан")")
                        print("   🚦 Платформа: \(item.platform ?? "не указана")")
                        
                        // Добавлено: Проверка на служебный рейс
                        if let number = thread?.number, number.hasPrefix("0") || number.contains("x") {
                            print("   ⚠️ Это служебный/технический рейс")
                        }
                        
                        // Добавлено: UID рейса
                        if let uid = thread?.uid {
                            print("   🔑 UID: \(uid)")
                        }
                        
                        // Информация о перевозчике
                        if let carrier = thread?.carrier {
                            print("   🏢 Перевозчик: \(carrier.title ?? "не указан")")
                            if let phone = carrier.phone {
                                print("   📞 Телефон: \(phone)")
                            }
                        }
                        
                        // Дни следования
                        if let days = item.days {
                            print("   📅 Дни: \(days)")
                        }
                        
                        // Остановки
                        if let stops = item.stops {
                            print("   🛑 Остановки: \(stops)")
                        }
                        
                        // Направление станции
                        if let stationDirection = scheduleResponse.station?.direction {
                            print("   🚉 Направление станции: \(stationDirection)")
                        }
                    }
                    
                    if schedule.count > 10 {
                        print("\n... и ещё \(schedule.count - 10) рейсов")
                    }
                } else {
                    print("\nℹ️ На выбранную дату расписания нет")
                }
                
                // Выводим информацию о пагинации
                if let pagination = scheduleResponse.pagination {
                    print("\n📊 Пагинация:")
                    print("Всего рейсов: \(pagination.total)")
                    print("Лимит: \(pagination.limit)")
                    print("Смещение: \(pagination.offset)")
                }
                
            } catch {
                print("\n🔴 Ошибка при получении расписания:")
                print("\(error.localizedDescription)")
            }
        }
    }
    
    func fetchSearch() {
        Task {
            do {
                let client = Client(
                    serverURL: try Servers.server1(),
                    transport: URLSessionTransport()
                )
                print("🟡 Поиск расписания между станциями...")
                
                let service = SearchService(
                    client: client,
                    apiKey: "d7da3fd8-3adb-459e-8cf8-13283ad0685d" // Ваш API ключ
                )
                
                let segments = try await service.getScheduleBetweenStations(
                    from: "c146",       // Код станции отправления
                    to: "c213",         // Код станции прибытия
                    date: "2025-09-02", // Дата в формате YYYY-MM-DD
                    lang: "ru_RU",      // Язык ответа
                    format: "json",     // Формат ответа
                    limit: 100          // Лимит результатов
                )
                
                // Вывод результатов
                print("\n🔍 Результаты поиска:")
                
                if let segmentsList = segments.segments, !segmentsList.isEmpty {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "HH:mm"
                    dateFormatter.timeZone = TimeZone(identifier: "Europe/Moscow")
                    
                    for (index, segment) in segmentsList.enumerated() {
                        print("\n\(index + 1). \(segment.thread?.title ?? "Рейс без названия")")
                        
                        // Основная информация о рейсе
                        if let threadUid = segment.thread?.uid {
                            print("   🔑 UID: \(threadUid)")
                        }
                        if let number = segment.thread?.number {
                            print("   🔢 Номер: \(number)")
                        }
                        if let transportType = segment.thread?.transport_type {
                            print("   🚊 Тип: \(transportType)")
                        }
                        
                        // Информация о перевозчике
                        if let carrier = segment.thread?.carrier {
                            print("   🏢 Перевозчик: \(carrier.title ?? "не указан")")
                            print("   🔠 Код перевозчика: \(carrier.code ?? 0)")
                            if let phone = carrier.phone {
                                print("   📞 Телефон: \(phone)")
                            }
                        }
                        
                        // Станции
                        if let fromStation = segment.from {
                            print("   🚉 Отправление: \(fromStation.title ?? "не указано") (\(fromStation.code ?? "нет кода"))")
                        }
                        if let toStation = segment.to {
                            print("   🏁 Прибытие: \(toStation.title ?? "не указано") (\(toStation.code ?? "нет кода"))")
                        }
                        
                        // Время и длительность
                        if let departure = segment.departure {
                            print("   🕒 Отправление: \(dateFormatter.string(from: departure))")
                        }
                        if let arrival = segment.arrival {
                            print("   🕓 Прибытие: \(dateFormatter.string(from: arrival))")
                        }
                        if let duration = segment.duration {
                            let hours = duration / 3600
                            let minutes = (duration % 3600) / 60
                            print("   ⏱️ В пути: \(hours)ч \(minutes)м")
                        }
                        
                        // Информация о билетах (если есть)
                        if let tickets = segment.tickets_info {
                            print("   🎫 Билеты: \(tickets.et_marker == true ? "Электронные доступны" : "Электронные недоступны")")
                        }
                        
                        // Дни следования
                        if let days = segment.thread?.days {
                            print("   📅 Дни: \(days)")
                        }
                        
                        // Интервалы (для регулярных рейсов)
                        if let interval = segment.thread?.interval {
                            print("   🔄 Интервал: \(interval.density ?? "не указан")")
                        }
                    }
                } else {
                    print("ℹ️ Рейсов не найдено")
                }
                
            } catch {
                print("\n🔴 Ошибка при поиске расписания:")
                print("\(error.localizedDescription)")
            }
        }
    }
    
    func fetchThreadManually() {
        let urlString = "https://api.rasp.yandex.net/v3.0/thread/?apikey=d7da3fd8-3adb-459e-8cf8-13283ad0685d&format=json&uid=7376x6076_4_9600721_g25_4&lang=ru_RU&show_systems=all"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("🔴 Error: \(error)")
                return
            }
            if let data = data {
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("🟢 Raw response:\n\(jsonString)")
                }
                do {
                    let decodedResponse = try JSONDecoder().decode(ThreadStationsResponse.self, from: data)
                    print("🟢 Decoded response: \(decodedResponse)")
                } catch {
                    print("🔴 Decoding error: \(error)")
                }
            }
        }.resume()
    }
    
    func fetchThread() {
        Task {
            do {
                let client = Client(
                    serverURL: try Servers.Server1.url(),
                    transport: URLSessionTransport()
                )
                
                print("🟡 Запрашиваем данные о маршруте...")
                
                let service = ThreadService(
                    client: client,
                    apiKey: APIKeys.yandexStationKey
                )
                
                let uid = "7376x6076_4_9600721_g25_4"
                
                let response = try await client.getRouteStations(.init(
                    query: .init(
                        apikey: APIKeys.yandexStationKey,
                        uid: uid,
                        format: "json",
                        lang: "ru_RU",
                        show_systems: "all"
                    )
                ))
                
                let threadResponse = try response.ok.body.json
                
                // Создаем форматтер для даты и времени
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                dateFormatter.timeZone = TimeZone(identifier: "Europe/Moscow")
                
                let timeFormatter = DateFormatter()
                timeFormatter.dateFormat = "HH:mm"
                timeFormatter.timeZone = TimeZone(identifier: "Europe/Moscow")
                
                // Вывод основной информации о маршруте
                print("\n🟢 Успешно получены данные о маршруте:")
                print("======================================")
                print("🚂 \(threadResponse.title ?? "Маршрут без названия")")
                print("🔢 Номер: \(threadResponse.number ?? "не указан")")
                print("🆔 UID: \(threadResponse.uid ?? "не указан")")
                print("🚦 Тип транспорта: \(threadResponse.transport_type ?? "не указан")")
                
                if let transportSubtype = threadResponse.transport_subtype {
                    print("🚆 Подтип: \(transportSubtype.title ?? "") (\(transportSubtype.code ?? ""))")
                }
                
                if let days = threadResponse.days {
                    print("📅 Дни следования: \(days)")
                }
                
                if let exceptDays = threadResponse.except_days, !exceptDays.isEmpty {
                    print("🚫 Исключенные дни: \(exceptDays)")
                }
                
                if let startDate = threadResponse.start_date, let startTime = threadResponse.start_time {
                    print("⏱ Начало движения: \(startDate) в \(startTime)")
                }
                
                // Информация о перевозчике
                if let carrier = threadResponse.carrier {
                    print("\n🏢 Перевозчик:")
                    print("  - Название: \(carrier.title ?? "не указано")")
                    print("  - Код: \(carrier.code ?? 0)")
                    if let phone = carrier.phone {
                        print("  - Телефон: \(phone)")
                    }
                }
                
                // Вывод информации об остановках
                if let stops = threadResponse.stops, !stops.isEmpty {
                    print("\n🛑 Остановки (\(stops.count)):")
                    print("--------------------------------------------------")
                    print("№  | Время  | Станция                     | Платформа")
                    print("--------------------------------------------------")
                    
                    for (index, stop) in stops.enumerated() {
                        let stationName = stop.station?.title ?? "Без названия"
                        let shortStationName = String(stationName.prefix(25)).padding(toLength: 25, withPad: " ", startingAt: 0)
                        let platform = stop.platform ?? "—"
                        
                        // Форматируем время
                        var timeInfo = ""
                        if let departure = stop.departure, let departureDate = dateFormatter.date(from: departure) {
                            timeInfo += "➡️\(timeFormatter.string(from: departureDate))"
                        }
                        if let arrival = stop.arrival, let arrivalDate = dateFormatter.date(from: arrival) {
                            if !timeInfo.isEmpty { timeInfo += " " }
                            timeInfo += "⬇️\(timeFormatter.string(from: arrivalDate))"
                        }
                        
                        // Форматируем номер остановки
                        let stopNumber = "\(index + 1)".padding(toLength: 2, withPad: " ", startingAt: 0)
                        
                        print("\(stopNumber) | \(timeInfo.padding(toLength: 12, withPad: " ", startingAt: 0)) | \(shortStationName) | \(platform)")
                    }
                }
                
                // Общая информация о маршруте
                if let firstStop = threadResponse.stops?.first,
                   let lastStop = threadResponse.stops?.last {
                    print("\nℹ️ Общая информация:")
                    
                    if let departure = firstStop.departure,
                       let arrival = lastStop.arrival,
                       let departureDate = dateFormatter.date(from: departure),
                       let arrivalDate = dateFormatter.date(from: arrival) {
                        
                        let duration = arrivalDate.timeIntervalSince(departureDate)
                        let hours = Int(duration) / 3600
                        let minutes = (Int(duration) % 3600) / 60
                        
                        print("  - Отправление: \(timeFormatter.string(from: departureDate)) (\(firstStop.station?.title ?? "начальная станция"))")
                        print("  - Прибытие: \(timeFormatter.string(from: arrivalDate)) (\(lastStop.station?.title ?? "конечная станция"))")
                        print("  - В пути: \(hours) ч \(minutes) мин")
                    }
                }
                
                print("======================================")
                
            } catch let error as DecodingError {
                print("\n🔴 Ошибка декодирования:")
                switch error {
                case .typeMismatch(let type, let context):
                    print("Несоответствие типа \(type) в пути: \(context.codingPath)")
                case .valueNotFound(let type, let context):
                    print("Не найдено значение \(type) в пути: \(context.codingPath)")
                case .keyNotFound(let key, let context):
                    print("Не найден ключ \(key) в пути: \(context.codingPath)")
                case .dataCorrupted(let context):
                    print("Данные повреждены: \(context)")
                @unknown default:
                    print("Неизвестная ошибка декодирования")
                }
            } catch {
                print("\n🔴 Ошибка:")
                print(error.localizedDescription)
            }
        }
    }
}

#Preview {
    ConsoleScreenView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}

