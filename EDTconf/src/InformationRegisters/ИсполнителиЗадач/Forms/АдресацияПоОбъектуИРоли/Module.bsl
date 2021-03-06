////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Роль = Параметры.Роль;
	ОсновнойОбъектАдресации = Параметры.ОсновнойОбъектАдресации;
	Если ОсновнойОбъектАдресации = Неопределено ИЛИ ОсновнойОбъектАдресации = "" Тогда
		Элементы.ДополнительныйОбъектАдресации.Видимость = Ложь;
		Элементы.ОсновнойОбъектАдресации.Видимость = Ложь;
	Иначе	                                
		Элементы.ОсновнойОбъектАдресации.Заголовок = ОсновнойОбъектАдресации.Метаданные().ПредставлениеОбъекта;
		ДополнительныйОбъектАдресации = Параметры.Роль.ТипыДополнительногоОбъектаАдресации;
		Элементы.ДополнительныйОбъектАдресации.Видимость = НЕ ДополнительныйОбъектАдресации.Пустая();
		Элементы.ДополнительныйОбъектАдресации.Заголовок = ДополнительныйОбъектАдресации.Наименование;
		ТипыДополнительногоОбъектаАдресации = ДополнительныйОбъектАдресации.ТипЗначения;
	КонецЕсли;
	НаборЗаписейОбъект = РеквизитФормыВЗначение("НаборЗаписей");
	НаборЗаписейОбъект.Отбор.ОсновнойОбъектАдресации.Установить(ОсновнойОбъектАдресации);
	НаборЗаписейОбъект.Отбор.РольИсполнителя.Установить(Роль);
	НаборЗаписейОбъект.Прочитать();
	ЗначениеВРеквизитФормы(НаборЗаписейОбъект, "НаборЗаписей");
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_РолеваяАдресация", ПараметрыЗаписи, НаборЗаписей);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ Список

&НаКлиенте
Процедура СписокПередОкончаниемРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования, Отказ)
	Если Роль <> Неопределено Тогда
		Элемент.ТекущиеДанные.РольИсполнителя = Роль;
	КонецЕсли;
	Если ОсновнойОбъектАдресации <> Неопределено Тогда
		Элемент.ТекущиеДанные.ОсновнойОбъектАдресации = ОсновнойОбъектАдресации;
	КонецЕсли;
КонецПроцедуры
                               
&НаКлиенте
Процедура СписокПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если Элементы.ДополнительныйОбъектАдресации.Видимость Тогда
		Элементы.ДополнительныйОбъектАдресации.ОграничениеТипа = ТипыДополнительногоОбъектаАдресации;
	КонецЕсли;
	
КонецПроцедуры

