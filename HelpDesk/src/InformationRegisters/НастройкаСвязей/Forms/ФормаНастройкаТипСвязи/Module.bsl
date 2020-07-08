
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор,
			"ТипСвязи",
			Параметры.ТипСвязи);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	
	ТекущаяСтрока = Элементы.Список.ТекущаяСтрока;
	Если ТекущаяСтрока = Неопределено Тогда 
		Возврат;
	КонецЕсли;	
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные.Предопределенная Тогда 
		ПоказатьПредупреждение(Неопределено, "Нельзя удалить предопределенную настройку связей!");
		Возврат;
	КонецЕсли;	
	
	Результат = Неопределено;
	
	
	ПоказатьВопрос(Новый ОписаниеОповещения("СписокПередУдалениемЗавершение", ЭтотОбъект, Новый Структура("ТекущаяСтрока", ТекущаяСтрока)), "Удалить запись?", РежимДиалогаВопрос.ДаНет,,КодВозвратаДиалога.Да);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередУдалениемЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	ТекущаяСтрока = ДополнительныеПараметры.ТекущаяСтрока;
	
	
	Результат = РезультатВопроса;
	Если Результат <> КодВозвратаДиалога.Да Тогда 
		Возврат;
	КонецЕсли;	
	
	УдалитьЗаписи(ТекущаяСтрока);
	Элементы.Список.Обновить();

КонецПроцедуры

&НаСервере 
Процедура УдалитьЗаписи(ТекущаяСтрока)
	
	МенеджерЗаписи = РегистрыСведений.НастройкаСвязей.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.ТипСвязи = ТекущаяСтрока.ТипСвязи;
	МенеджерЗаписи.СсылкаИз = ТекущаяСтрока.СсылкаИз;
	МенеджерЗаписи.СсылкаНа = ТекущаяСтрока.СсылкаНа;
	МенеджерЗаписи.Прочитать();
	
	Если ЗначениеЗаполнено(МенеджерЗаписи.ТипОбратнойСвязи) Тогда 
		МенеджерОбратнойЗаписи = РегистрыСведений.НастройкаСвязей.СоздатьМенеджерЗаписи();
		МенеджерОбратнойЗаписи.ТипСвязи = МенеджерЗаписи.ТипОбратнойСвязи;
		МенеджерОбратнойЗаписи.СсылкаИз = МенеджерЗаписи.СсылкаНа;
		МенеджерОбратнойЗаписи.СсылкаНа = МенеджерЗаписи.СсылкаИз;
		МенеджерОбратнойЗаписи.Удалить();
	КонецЕсли;	
	МенеджерЗаписи.Удалить();
	
КонецПроцедуры
