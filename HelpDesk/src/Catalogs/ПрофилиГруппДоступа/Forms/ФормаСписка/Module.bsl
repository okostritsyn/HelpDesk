////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Возврат при получении формы для анализа.
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Список.Параметры.УстановитьЗначениеПараметра(
		"РежимВыбораТолькоГрупп",
		  Параметры.РежимВыбора
		И Параметры.ВыборГруппИЭлементов = ИспользованиеГруппИЭлементов.Группы);
	
	СписокНедоступныхПрофилей = Новый СписокЗначений;
	
	Если Параметры.РежимВыбора Тогда
		СписокНедоступныхПрофилей.Добавить(Справочники.ПрофилиГруппДоступа.Администратор);
		
		// Отбор не помеченных на удаление.
		//Список.Отбор.Элементы[1].Использование = Истина;
		
		Элементы.Список.РежимВыбора = Истина;
		Элементы.Список.ВыборГруппИЭлементов = Параметры.ВыборГруппИЭлементов;
		
		Если Параметры.ВыборГруппИЭлементов = ИспользованиеГруппИЭлементов.Группы Тогда
			
			Элементы.Список.Отображение = ОтображениеТаблицы.Дерево;
			Элементы.Список.НачальноеОтображениеДерева =
				НачальноеОтображениеДерева.РаскрыватьВерхнийУровень;
		КонецЕсли;
		
		АвтоЗаголовок = Ложь;
		Если Параметры.ЗакрыватьПриВыборе = Ложь Тогда
			// Режим подбора.
			Элементы.Список.МножественныйВыбор = Истина;
			Элементы.Список.РежимВыделения = РежимВыделенияТаблицы.Множественный;
			
			Заголовок = НСтр("ru = 'Подбор профилей групп доступа'");
		Иначе
			Заголовок = НСтр("ru = 'Выбор профиля групп доступа'");
		КонецЕсли;
	КонецЕсли;
	 
	//Список.Отбор.Элементы[0].ПравоеЗначение = СписокНедоступныхПрофилей;
	
	Список.Параметры.УстановитьЗначениеПараметра(
		"СписокНедоступныхПрофилей", СписокНедоступныхПрофилей);
КонецПроцедуры
