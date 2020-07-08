&НаКлиенте
Процедура ПометитьНаУдаление(Команда)
	ТекДок = Элементы.Список.ТекущаяСтрока;
	Если ТипЗнч(ТекДок) = Тип("ДокументСсылка.Заявка") тогда
		РаботаСЗаявками.ОбработатьУдалениеЗаявки(ТекДок);
	КонецЕсли;
	Элементы.Список.Обновить();
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если ПолучитьФункциональнуюОпцию("ВестиУчетПоОрганизациям") Тогда
		ИспользоватьУчетПоОрганизациям = Истина;
	Иначе
		ИспользоватьУчетПоОрганизациям = Ложь;
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("ВестиУчетПоКонтрагентам") Тогда
		ИспользоватьУчетПоКонтрагентам = Истина;
	Иначе
		ИспользоватьУчетПоКонтрагентам = Ложь;
	КонецЕсли;

	ИсточникСписка = Параметры.Источник;
	
	Если ТипЗнч(Параметры.Источник) = Тип("СправочникСсылка.Проекты") Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор,
		"Проект",
		Параметры.Источник,,,Истина);
	ИначеЕсли ТипЗнч(Параметры.Источник) = Тип("СправочникСсылка.ПроектныеЗадачи") Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор,
		"ПроектнаяЗадача",
		Параметры.Источник,,,Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОжидания()
   ОбновитьСписок();
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ПодключитьОбработчикОжидания("ОбработкаОжидания", 300);
КонецПроцедуры

&НаСервере
Функция ПроверкаДоступностиРоли(ИмяРоли)
	Возврат РольДоступна(ИмяРоли);
КонецФункции

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	ОбновитьСписок();
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСписок()
	Элементы.Список.Обновить();
КонецПроцедуры


&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	Если ТипЗнч(ВыбраннаяСтрока) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
		СтандартнаяОбработка = Ложь;
		Если Элементы.Список.Развернут(ВыбраннаяСтрока) Тогда
            Элементы.Список.Свернуть(ВыбраннаяСтрока);
        иначе
            Элементы.Список.Развернуть(ВыбраннаяСтрока);
        КонецЕсли;
	КонецЕсли;
КонецПроцедуры


