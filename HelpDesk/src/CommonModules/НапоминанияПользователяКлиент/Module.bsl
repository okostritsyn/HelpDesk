////////////////////////////////////////////////////////////////////////////////
// Подсистема "Напоминания пользователя".
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Запускает периодическую проверку текущих напоминаний пользователя.
Процедура Включить() Экспорт
	ПроверитьТекущиеНапоминания();
КонецПроцедуры

// Отключает периодическую проверку текущих напоминаний пользователя.
Процедура Выключить() Экспорт
	ОтключитьОбработчикОжидания("ПроверитьТекущиеНапоминания");
КонецПроцедуры

// Активизирует обработчик ожидания, проверяющий текущие напоминания пользователя.
Процедура ПриНачалеРаботыСистемы() Экспорт
	
	ПараметрыРаботыКлиента = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиентаПриЗапуске();
	Если НЕ ПараметрыРаботыКлиента.ДоступноИспользованиеРазделенныхДанных Тогда
		Возврат;
	КонецЕсли;
	
	Если ПараметрыРаботыКлиента.НастройкиНапоминаний.ИспользоватьНапоминания Тогда
		ПроверитьТекущиеНапоминанияПриЗапуске();
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Открывает форму оповещения
Процедура ОткрытьФормуОповещения() Экспорт
	ФормаОповещения = НапоминанияПользователяКлиентПовтИсп.ПолучитьФормуОповещения();
	ФормаОповещения.Открыть();
КонецПроцедуры

// Возвращает кэшированные оповещения текущего пользователя, исключив из результата ненаступившие оповещения.
//
// Параметры
//  ВремяБлижайшего - Дата - в этот параметр возвращается время ближайшего будущего напоминания. Если
//                           ближайшее напоминание за пределами выборки кэша, то возвращается Неопределено.
Функция ПолучитьТекущиеОповещения(ВремяБлижайшего = Неопределено) Экспорт
	
	ТаблицаОповещений = НапоминанияПользователяКлиентПовтИсп.ПолучитьНапоминанияТекущегоПользователя();
	Результат = Новый Массив;
	
	ВремяБлижайшего = Неопределено;
	
	Для Каждого Оповещение из ТаблицаОповещений Цикл
		Если Оповещение.СрокНапоминания <= ОбщегоНазначенияКлиент.ДатаСеанса() Тогда
			Результат.Добавить(Оповещение);
		Иначе                                                           
			Если ВремяБлижайшего = Неопределено Тогда
				ВремяБлижайшего = Оповещение.СрокНапоминания;
			Иначе
				ВремяБлижайшего = Мин(ВремяБлижайшего, Оповещение.СрокНапоминания);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;		
	
	Возврат Результат;
	
КонецФункции

// Обновляет запись в кэше результата выполения функции ПолучитьНапоминанияТекущегоПользователя()
Процедура ОбновитьЗаписьВКэшеОповещений(ПараметрыОповещения) Экспорт
	КэшОповещений = НапоминанияПользователяКлиентПовтИсп.ПолучитьНапоминанияТекущегоПользователя();
	Запись = НайтиЗаписьВКэшеОповещений(КэшОповещений, ПараметрыОповещения);
	Если Запись <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(Запись, ПараметрыОповещения);
	Иначе
		КэшОповещений.Добавить(ПараметрыОповещения);
	КонецЕсли;
КонецПроцедуры

// Удаляет запись из кэша результата выполения функции ПолучитьНапоминанияТекущегоПользователя()
Процедура УдалитьЗаписьИзКэшаОповещений(ПараметрыОповещения) Экспорт
	КэшОповещений = НапоминанияПользователяКлиентПовтИсп.ПолучитьНапоминанияТекущегоПользователя();
	Запись = НайтиЗаписьВКэшеОповещений(КэшОповещений, ПараметрыОповещения);
	Если Запись <> Неопределено Тогда
		КэшОповещений.Удалить(КэшОповещений.Найти(Запись));
	КонецЕсли;
КонецПроцедуры

Функция НайтиЗаписьВКэшеОповещений(КэшОповещений, ПараметрыОповещения)
	Для Каждого Запись Из КэшОповещений Цикл
		Если Запись.Источник = ПараметрыОповещения.Источник
		   И Запись.ВремяСобытия = ПараметрыОповещения.ВремяСобытия Тогда
			Возврат Запись;
		КонецЕсли;
	КонецЦикла;
	Возврат Неопределено;
КонецФункции