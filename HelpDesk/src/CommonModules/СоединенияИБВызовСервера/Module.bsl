////////////////////////////////////////////////////////////////////////////////
// Подсистема "Завершение работы пользователей".
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Получить параметры блокировки соединений ИБ для использования на стороне клиента.
//
// Параметры:
//  ПолучитьКоличествоСеансов - Булево - если Истина, то в возвращаемой структуре
//                                       заполняется поле КоличествоСеансов.
//
// Возвращаемое значение:
//   Структура – с полями:
//     Установлена - Булево - Истина, если установлена блокировка, Ложь - Иначе. 
//     Начало - Дата - дата начала блокировки. 
//     Конец - Дата - дата окончания блокировки. 
//     Сообщение - Строка - сообщение пользователю. 
//     ИнтервалОжиданияЗавершенияРаботыПользователей - Число - интервал в секундах.
//     КоличествоСеансов  - 0, если параметр ПолучитьКоличествоСеансов = Ложь
//     ТекущаяДатаСеанса - Дата - текщая дата сеанса.
//
Функция ПараметрыБлокировкиСеансов(ПолучитьКоличествоСеансов = Ложь) Экспорт
	
	Возврат СоединенияИБ.ПараметрыБлокировкиСеансов(ПолучитьКоличествоСеансов);
	
КонецФункции

// Устанавливает блокировку соединений ИБ.
// Если вызывается из сеанса с установленными значениями разделителей,
// то устанавливает блокировку сеансов области данных.
//
// Параметры
//  ТекстСообщения  – Строка – текст, который будет частью сообщения об ошибке
//                             при попытке установки соединения с заблокированной
//                             информационной базой.
// 
//  КодРазрешения - Строка -   строка, которая должна быть добавлена к параметру
//                             командной строки "/uc" или к параметру строки
//                             соединения "uc", чтобы установить соединение с
//                             информационной базой несмотря на блокировку.
//                             Не применимо для блокировки сеансов области данных.
//
// Возвращаемое значение:
//   Булево   – Истина, если блокировка установлена успешно.
//              Ложь, если для выполнения блокировки недостаточно прав.
//
Функция УстановитьБлокировкуСоединений(ТекстСообщения = "",
	КодРазрешения = "КодРазрешения") Экспорт
	
	Возврат СоединенияИБ.УстановитьБлокировкуСоединений(ТекстСообщения, КодРазрешения);
	
КонецФункции

// Установить блокировку сеансов области данных.
// 
// Параметры:
//   Параметры         – Структура – см. НовыеПараметрыБлокировкиСоединений
//   ПоМестномуВремени - Булево - время начала и окончания блокировки указаны в местном (поясном) времени сеанса.
//                                Если Ложь, то в универсальном времени.
//
Процедура УстановитьБлокировкуСеансовОбластиДанных(Параметры, ПоМестномуВремени = Истина) Экспорт
	
	СоединенияИБ.УстановитьБлокировкуСеансовОбластиДанных(Параметры, ПоМестномуВремени);
	
КонецПроцедуры

// Снять блокировку информационной базы.
//
// Возвращаемое значение:
//   Булево   – Истина, если операция выполнена успешно.
//              Ложь, если для выполнения операции недостаточно прав.
//
Функция РазрешитьРаботуПользователей() Экспорт
	
	Возврат СоединенияИБ.РазрешитьРаботуПользователей();
	
КонецФункции

// Получить число активных сеансов ИБ.
//
// Параметры:
//   УчитыватьКонсоль               - Булево - если Ложь, то исключить сеансы консоли кластера серверов.
//                                             сеансы консоли кластера серверов не препятствуют выполнению 
//                                             административных операций (установке монопольного режима и т.п.).
//   СообщенияДляЖурналаРегистрации - СписокЗначений - пакета сообщения для журнала регистрации
//                                                     сформированных на клиенте.
//
// Возвращаемое значение:
//   Число   – количество активных сеансов ИБ.
//
Функция КоличествоСеансовИнформационнойБазы(УчитыватьКонсоль = Истина, 
	СообщенияДляЖурналаРегистрации = Неопределено) Экспорт
	
	Возврат СоединенияИБ.КоличествоСеансовИнформационнойБазы(УчитыватьКонсоль, СообщенияДляЖурналаРегистрации);
	
КонецФункции

// Записать в журнал регистрации список сеансов ИБ.
//
// Параметры:
//   ТекстСообщения - Строка - опциональный текст с пояснениями.
//
Процедура ЗаписатьНазванияСоединенийИБ(ТекстСообщения) Экспорт
	
	СоединенияИБ.ЗаписатьНазванияСоединенийИБ(ТекстСообщения);
	
КонецПроцедуры

// Отключает сеанс по номеру сеанса.
//
// Параметры
//  НомерСеанса - Число - номер сеанса для отключения
//  СообщениеОбОшибке - Строка - в этом параметре возвращается текст сообщения об ошибке в случае неудачи
// 
// Возвращаемое значение:
//  Булево – результат отключения сеанса.
//
Функция ОтключитьСеанс(НомерСеанса, СообщениеОбОшибке) Экспорт
	
	Возврат СоединенияИБ.ОтключитьСеанс(НомерСеанса, СообщениеОбОшибке);
	
КонецФункции

// Отключить все активные соединения ИБ (кроме текущего сеанса).
//
// Параметры
//  ПараметрыАдминистрированияИБ – Структура – параметры администрирования ИБ.  
//
// Возвращаемое значение:
//   Булево   – результат отключения соединений.
//
Функция ОтключитьСоединенияИБ(ПараметрыАдминистрированияИБ) Экспорт
	
	Возврат СоединенияИБ.ОтключитьСоединенияИБ(ПараметрыАдминистрированияИБ);
	
КонецФункции

// Осуществляет попытку подключиться к кластеру серверов и получить список 
// активных соединений к ИБ и использованием указанных параметров администрирования.
//
// Параметры
//  ПараметрыАдминистрированияИБ  – Структура – параметры администрирования ИБ
//  ВыдаватьСообщения             – Булево    – разрешить вывод интерактивных сообщений.
//
// Возвращаемое значение:
//   Булево – Истина, если проверка завершена успешно.
//
Процедура ПроверитьПараметрыАдминистрированияИБ(ПараметрыАдминистрированияИБ,
	ПодробноеСообщениеОбОшибке = Ложь) Экспорт
	
	СоединенияИБ.ПроверитьПараметрыАдминистрированияИБ(ПараметрыАдминистрированияИБ, ПодробноеСообщениеОбОшибке);
	
КонецПроцедуры

// Установить или снять блокировку регламентных заданий.
//
// Параметры
//   Значение – Булево - Истина, если устанавливать, Ложь - Иначе.
//
Процедура УстановитьБлокировкуРегламентныхЗаданий(Значение) Экспорт
	
	СоединенияИБ.УстановитьБлокировкуРегламентныхЗаданий(Значение);
	
КонецПроцедуры

// Получить текущее состояние блокировки регламентных заданий.
//
// Возвращаемое значение:
//   Булево – Истина, если блокировка установлена.
//
Функция БлокировкаРегламентныхЗаданийУстановлена() Экспорт
	
	Возврат СоединенияИБ.БлокировкаРегламентныхЗаданийУстановлена();
	
КонецФункции

// Получить информацию о блокировке сеансов области данных.
// 
// Параметры:
//   ПоМестномуВремени - Булево - время начала и окончания блокировки необходимо вернуть 
//                                в местном (поясном) времени сеанса. Если Ложь, то 
//                                возвращается в универсальном времени.
//
// Возвращаемое значение:
//   Структура – см. НовыеПараметрыБлокировкиСоединений
//
Функция ПолучитьБлокировкуСеансовОбластиДанных(ПоМестномуВремени = Истина) Экспорт
	
	Возврат СоединенияИБ.ПолучитьБлокировкуСеансовОбластиДанных(ПоМестномуВремени);
	
КонецФункции