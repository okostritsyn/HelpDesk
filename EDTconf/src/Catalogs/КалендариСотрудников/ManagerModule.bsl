#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	ДоступныеКалендари = ДоступныеСотрудникуКалендари().ВыгрузитьКолонку("Календарь");
	Параметры.Отбор.Вставить("Ссылка", ДоступныеКалендари);
	
КонецПроцедуры

#КонецОбласти

#Область ПрограммныйИнтерфейс

Функция ДоступныеКалендариГруппеСотрудников(ГруппаПользователей) Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ГруппыПользователейСостав.Пользователь КАК Пользователь,
	|	ГруппыПользователейСостав.Пользователь.ФизическоеЛицо КАК Сотрудник
	|ИЗ
	|	Справочник.ГруппыПользователей.Состав КАК ГруппыПользователейСостав
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ГруппыПользователей КАК ГруппыПользователей
	|		ПО ГруппыПользователейСостав.Ссылка = ГруппыПользователей.Ссылка
	|ГДЕ
	|	ГруппыПользователей.Ссылка = &ГруппаПользователей";
	
	Запрос.УстановитьПараметр("ГруппаПользователей", ГруппаПользователей);
	
	СотрудникиГруппы = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Сотрудник");

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	КалендариСотрудников.Ссылка КАК Календарь,
		|	КалендариСотрудников.Наименование КАК Наименование,
		|	ИСТИНА КАК ЯвляетсяВладельцем
		|ИЗ
		|	Справочник.КалендариСотрудников КАК КалендариСотрудников
		|ГДЕ
		|	НЕ КалендариСотрудников.Предопределенный
		|	И КалендариСотрудников.ПометкаУдаления = ЛОЖЬ
		|	И КалендариСотрудников.ВладелецКалендаря В(&СотрудникиПользователя)
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	КалендариСотрудниковДоступ.Ссылка,
		|	КалендариСотрудниковДоступ.Ссылка.Наименование,
		|	ЛОЖЬ
		|ИЗ
		|	Справочник.КалендариСотрудников.Доступ КАК КалендариСотрудниковДоступ
		|ГДЕ
		|	НЕ КалендариСотрудниковДоступ.Ссылка.Предопределенный
		|	И КалендариСотрудниковДоступ.Ссылка.ПометкаУдаления = ЛОЖЬ
		|	И КалендариСотрудниковДоступ.Сотрудник В(&СотрудникиПользователя)
		|
		|УПОРЯДОЧИТЬ ПО
		|	ЯвляетсяВладельцем УБЫВ,
		|	Наименование";
	
	Запрос.УстановитьПараметр("СотрудникиПользователя", СотрудникиГруппы);
	Таблица = Запрос.Выполнить().Выгрузить();
	
	Возврат Таблица;

	
КонецФункции

Функция ДоступныеСотрудникуКалендари(Сотрудник = Неопределено) Экспорт
	
	Если Сотрудник = Неопределено Тогда
		СотрудникиПользователя = ЗаполнениеОбъектовCRM.ПолучитьСотрудниковПользователя();
	Иначе
		СотрудникиПользователя = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Сотрудник);
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	КалендариСотрудников.Ссылка КАК Календарь,
		|	КалендариСотрудников.Наименование КАК Наименование,
		|	ИСТИНА КАК ЯвляетсяВладельцем
		|ПОМЕСТИТЬ ТаблицаКалендарей
		|ИЗ
		|	Справочник.КалендариСотрудников КАК КалендариСотрудников
		|ГДЕ
		|	НЕ КалендариСотрудников.Предопределенный
		|	И КалендариСотрудников.ПометкаУдаления = ЛОЖЬ
		|	И КалендариСотрудников.ВладелецКалендаря В(&СотрудникиПользователя)
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	КалендариСотрудниковДоступ.Ссылка,
		|	КалендариСотрудниковДоступ.Ссылка.Наименование,
		|	ЛОЖЬ
		|ИЗ
		|	Справочник.КалендариСотрудников.Доступ КАК КалендариСотрудниковДоступ
		|ГДЕ
		|	НЕ КалендариСотрудниковДоступ.Ссылка.Предопределенный
		|	И КалендариСотрудниковДоступ.Ссылка.ПометкаУдаления = ЛОЖЬ
		|	И КалендариСотрудниковДоступ.Сотрудник В(&СотрудникиПользователя)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТаблицаКалендарей.Календарь КАК Календарь,
		|	ТаблицаКалендарей.Наименование КАК Наименование,
		|	МАКСИМУМ(ТаблицаКалендарей.ЯвляетсяВладельцем) КАК ЯвляетсяВладельцем
		|ИЗ
		|	ТаблицаКалендарей КАК ТаблицаКалендарей
		|
		|СГРУППИРОВАТЬ ПО
		|	ТаблицаКалендарей.Календарь,
		|	ТаблицаКалендарей.Наименование";
	
	Запрос.УстановитьПараметр("СотрудникиПользователя", СотрудникиПользователя);
	Таблица = Запрос.Выполнить().Выгрузить();
	
	Возврат Таблица;
	
КонецФункции

Функция СсылкаПоИдентификатору(Идентификатор, Пользователь) Экспорт
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	КалендариСотрудников.Ссылка
	|ИЗ
	|	Справочник.КалендариСотрудников КАК КалендариСотрудников
	|ГДЕ
	|	КалендариСотрудников.Пользователь = &Пользователь
	|	И КалендариСотрудников.key = &key");
	Запрос.УстановитьПараметр("Пользователь", Пользователь);
	Запрос.УстановитьПараметр("key","");
	//ОбменСGoogle.КлючИзИдентификатора(Идентификатор, ТипЗнч(Справочники.КалендариСотрудников)));
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Справочники.КалендариСотрудников.ПустаяСсылка();
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	Выборка.Следующий();
	Возврат Выборка.Ссылка;
	
КонецФункции

Процедура ПроверитьСоздатьКалендарьСотрудника(Сотрудник, Пользователь = Неопределено) Экспорт
	
	Если Пользователь = Неопределено Тогда
		Пользователь = Пользователи.АвторизованныйПользователь();
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
		|	КалендариСотрудников.Ссылка
		|ИЗ
		|	Справочник.КалендариСотрудников КАК КалендариСотрудников
		|ГДЕ
		|	КалендариСотрудников.ВладелецКалендаря = &ВладелецКалендаря
		|	И КалендариСотрудников.Пользователь = &Пользователь";
	
	Запрос.УстановитьПараметр("ВладелецКалендаря", Сотрудник);
	Запрос.УстановитьПараметр("Пользователь", Пользователь);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если Не РезультатЗапроса.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеЗаполнения = Новый Структура;
	ДанныеЗаполнения.Вставить("ВладелецКалендаря", Сотрудник);
	ДанныеЗаполнения.Вставить("Пользователь", Пользователь);
	ДанныеЗаполнения.Вставить("Наименование", Строка(Сотрудник));
	
	НовыйКалендарь = Справочники.КалендариСотрудников.СоздатьЭлемент();
	НовыйКалендарь.УстановитьНовыйКод();
	НовыйКалендарь.Заполнить(ДанныеЗаполнения);
	НовыйКалендарь.Записать();
	
	РаботаССистемойCRMСервер.УстановитьНастройкуПользователя(НовыйКалендарь.Ссылка, "ОсновнойКалендарь", Пользователь);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли