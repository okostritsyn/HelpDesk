// Возвращает настройку пользователя отложенной отправки писем.
//
Функция ПолучитьНастройку(Пользователь) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запись = РегистрыСведений.НастройкиОтложеннойОтправкиПисем.СоздатьМенеджерЗаписи();
	Запись.Пользователь = Пользователь;
	Запись.Прочитать();
	
	Если Не Запись.Выбран() Тогда
		Возврат 0;
	КонецЕсли;
	
	Возврат Запись.Задержка;
	
КонецФункции

// Записывает настройку отложенной отправки писем.
//
Функция СохранитьНастройку(Пользователь, Задержка) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запись = РегистрыСведений.НастройкиОтложеннойОтправкиПисем.СоздатьМенеджерЗаписи();
	Запись.Пользователь = Пользователь;
	Запись.Прочитать();
	
	Запись.Пользователь = Пользователь;
	Запись.Задержка = Задержка;
	Запись.Записать(Истина);
	
КонецФункции
