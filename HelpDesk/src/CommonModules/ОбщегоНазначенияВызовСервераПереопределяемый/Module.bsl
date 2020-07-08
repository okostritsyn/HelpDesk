////////////////////////////////////////////////////////////////////////////////
// Подсистема "Базовая функциональность".
//  
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Возвращает структуру параметров, необходимых для работы клиентского кода
// при запуске конфигурации, т.е. в обработчиках событий
// - ПередНачаломРаботыСистемы,
// - ПриНачалеРаботыСистемы
//
// Важно: при запуске недопустимо использовать команды сброса кэша
// повторно используемых модулей, иначе запуск может привести
// к непредсказуемым ошибкам и лишним серверным вызовам
//
// Пример реализации:
//   Для установки параметров работы клиента можно использовать шаблон:
//
//     Параметры.Вставить(<ИмяПараметра>, <код получения значения параметра>);
//
// Возвращаемое значение:
//   Структура - структура параметров работы клиента при запуске.
//
Функция ПараметрыРаботыКлиентаПриЗапуске() Экспорт
	
	Параметры = Новый Структура();
	
	Возврат Параметры;
	
КонецФункции

// Возвращает структуру параметров, необходимых для работы клиентского кода
// конфигурации. 
//
// Пример реализации:
//   Для установки параметров работы клиента можно использовать шаблон:
//
//     Параметры.Вставить(<ИмяПараметра>, <код получения значения параметра>);
//
// Возвращаемое значение:
//   Структура - структура параметров работы клиента.
//
Функция ПараметрыРаботыКлиента() Экспорт
	
	Параметры = Новый Структура();
	
	Возврат Параметры;
	
КонецФункции

// Вызывается при необходимости переопределить минимально необходимую версию платформы для запуска.
//
// Параметры: 
//   ПараметрыПроверки - ФиксированнаяСтруктура - 
//     МинимальноНеобходимаяВерсияПлатформы   - Строка - номер версии платформы для запуска программы
//     РаботаВПрограммеЗапрещена              - Булево - по умолчанию Ложь
//							
Процедура ПолучитьМинимальноНеобходимуюВерсиюПлатформы(ПараметрыПроверки) Экспорт
		
КонецПроцедуры	

