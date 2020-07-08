////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИК РЕГЛАМЕНТНОГО ЗАДАНИЯ

// Процедура - обработчик регламентного задания КонтрольОшибокВЖурналеРегистрации.
//
Процедура ОбработкаРегламентногоЗадания_КонтрольОшибокВЖурналеРегистрации() Экспорт
	
	ЗаписьЖурналаРегистрации(СобытиеЖурналаРегистрации(),
		УровеньЖурналаРегистрации.Информация, , ,
		НСтр("ru='Начат регламентный контроль ошибок и предупреждений в журнале регистрации';uk='Почато регламентний контроль помилок і попереджень у журналі реєстрації'"));
	
	Попытка
		Обработки.КонтрольЖурналаРегистрации.СформироватьОтчетПоОшибкамИПослатьОтчет();
		ЗаписьЖурналаРегистрации(СобытиеЖурналаРегистрации(),
			УровеньЖурналаРегистрации.Информация, , ,
			НСтр("ru='Завершен регламентный контроль ошибок и предупреждений в журнале регистрации';uk='Завершено регламентний контроль помилок і попереджень у журналі реєстрації'"));
	Исключение
		ЗаписьЖурналаРегистрации(СобытиеЖурналаРегистрации(),
			УровеньЖурналаРегистрации.Ошибка, , ,
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Во время регламентного контроля ошибок и предупреждений в журнале регистрации, произошла неизвестная ошибка."
"%1';uk='Під час регламентного контролю помилок і попереджень у журналі реєстрації, відбулася невідома помилка."
"%1'"), ОписаниеОшибки()));
	КонецПопытки;
	
КонецПроцедуры

// Получает строку - адресатов получения отчета по контролю журнала регистрации
//
Функция ПолучитьАдресатовПолученияОтчетаПоЖурналуРегистрации() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Возврат Константы.АдресатыПолученияОтчетаПоЖурналуРегистрации.Получить();
КонецФункции

// Устанавливает константу АдресатыПолученияОтчетаПоЖурналуРегистрации
// адресатами получения отчета по контролю журнала регистрации
//
Процедура УстановитьАдресатовПолученияОтчетаПоЖурналуРегистрации(Адресаты) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Константы.АдресатыПолученияОтчетаПоЖурналуРегистрации.Установить(Адресаты);
	
КонецПроцедуры

Функция СобытиеЖурналаРегистрации()
	
	Возврат "Контроль журнала регистрации";
	
КонецФункции
