&НаСервере
Функция ПолучитьСостояниеЗаявки(Заявка) Экспорт
	Возврат Заявка.ЗаявкаЗакрыта;
КонецФункции

&НаСервере
Функция ПроверитьОтказОтСоздания(Заявка) Экспорт
    ОтказОтСоздания = Ложь;
	
	ОтказОтСоздания = ПолучитьСостояниеЗаявки(Заявка.Ссылка);
	   
	Возврат ОтказОтСоздания; 	
КонецФункции	

&НаСервере
Функция ЭтоЗаявка(Значение) Экспорт
	#Если Сервер Тогда
		Возврат ТипЗнч(Значение) = Тип("ДокументСсылка.Заявка")
			Или ТипЗнч(Значение) = Тип("ДокументОбъект.Заявка");
	#Иначе
		Возврат ТипЗнч(Значение) = Тип("ДокументСсылка.Заявка");
	#КонецЕсли
КонецФункции

&НаСервере
Процедура ОбработатьУдалениеЗаявки(ТекДок) Экспорт
	
	ТекстСообщения = "";	
	Если ТекДок.Статус = Справочники.СостоянияЗаявок.Отменена Тогда	
		ТекОбъект = ТекДок.ПолучитьОбъект();
		ТекОбъект.ПометкаУдаления = Не ТекДок.ПометкаУдаления;
		ТекОбъект.записать();
		ТекстСообщения =  "Заявка "+ТекОбъект.Номер+?(ТекОбъект.ПометкаУдаления," помечена на удаление"," снята с удаления")+" !";
	Иначе
		ТекОбъект = ТекДок.ПолучитьОбъект();
		ТекОбъект.Статус = Справочники.СостоянияЗаявок.Отменена;
		ТекОбъект.записать();
		ТекстСообщения = "Заявка "+ТекОбъект.Номер+" отменена!";
	КонецЕсли;	
	
	Сообщение = Новый СообщениеПользователю();
	Сообщение.Текст =  ТекстСообщения;
	Сообщение.УстановитьДанные(ТекДок);
	Сообщение.Сообщить();
КонецПроцедуры

&НаСервере
Функция ПолучитьПроектнуюКоманду(Проект,ПроектЗадача,Дата) Экспорт
	ТаблицаРезультата = Новый ТаблицаЗначений;
	
	Запрос = Новый Запрос();
	
	Если Значениезаполнено(ПроектЗадача) Тогда
		ТекстЗапроса = 
		"ВЫБРАТЬ
		|	ПроектныеЗадачиИсполнители.Исполнитель,
		|	ПроектныеЗадачи.Владелец КАК Проект,
		|	ПроектныеЗадачи.Ссылка КАК ПроектЗадача
		|ПОМЕСТИТЬ ПроектКоманда
		|ИЗ
		|	Справочник.ПроектныеЗадачи.Исполнители КАК ПроектныеЗадачиИсполнители
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ПроектныеЗадачи КАК ПроектныеЗадачи
		|		ПО ПроектныеЗадачиИсполнители.Ссылка = ПроектныеЗадачи.Ссылка
		|ГДЕ
		|	ПроектныеЗадачи.Ссылка = &ПроектЗадача"
	Иначе
		ТекстЗапроса = 
		"ВЫБРАТЬ
		|	ПроектыПроектнаяКоманда.Исполнитель,
		|	ПроектыПроектнаяКоманда.Ссылка КАК проект
		|ПОМЕСТИТЬ ПроектКоманда
		|ИЗ
		|	Справочник.Проекты.ПроектнаяКоманда КАК ПроектыПроектнаяКоманда
		|ГДЕ
		|	ПроектыПроектнаяКоманда.Ссылка = &Проект"		
	КонецЕсли;	
		
		Запрос.Текст = ТекстЗапроса +"
		|;
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СоответствиеПроектовГруппПользователейСрезПоследних.ГруппаПользователей,
		|	СоответствиеРолейВГруппеПользователейСрезПоследних.РолиИсполнителей КАК Роль,
		|	СоответствиеРолейВГруппеПользователейСрезПоследних.Пользователь,
		|	СоответствиеПроектовГруппПользователейСрезПоследних.Проект
		|ПОМЕСТИТЬ СоответствиеПользователейИРолейПоПроектам
		|ИЗ
		|	РегистрСведений.СоответствиеПроектовГруппПользователей.СрезПоследних(&ДатаСреза, Проект = &Проект) КАК СоответствиеПроектовГруппПользователейСрезПоследних
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СоответствиеРолейВГруппеПользователей.СрезПоследних(&ДатаСреза, ) КАК СоответствиеРолейВГруппеПользователейСрезПоследних
		|		ПО СоответствиеПроектовГруппПользователейСрезПоследних.ГруппаПользователей = СоответствиеРолейВГруппеПользователейСрезПоследних.ГруппаПользователей
		|ГДЕ
		|	НЕ СоответствиеРолейВГруппеПользователейСрезПоследних.Пользователь ЕСТЬ NULL 
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ПроектКоманда.Исполнитель КАК Роль,
		|	СоответствиеПользователейИРолейПоПроектам.ГруппаПользователей,
		|	СоответствиеПользователейИРолейПоПроектам.Пользователь,
		|	СоответствиеПользователейИРолейПоПроектам.Роль,
		|	СоответствиеПользователейИРолейПоПроектам.Роль.Представление КАК ПредставлениеРоли
		|ИЗ
		|	ПроектКоманда КАК ПроектКоманда
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ СоответствиеПользователейИРолейПоПроектам КАК СоответствиеПользователейИРолейПоПроектам
		|		ПО ПроектКоманда.Исполнитель = СоответствиеПользователейИРолейПоПроектам.Роль
		|			И ПроектКоманда.Проект = СоответствиеПользователейИРолейПоПроектам.Проект";

	Запрос.УстановитьПараметр("ДатаСреза", Дата);
	Запрос.УстановитьПараметр("Проект", Проект);
	Запрос.УстановитьПараметр("ПроектЗадача", ПроектЗадача);

	РезультатЗапроса = Запрос.Выполнить();

	ТаблицаРезультата = РезультатЗапроса.Выгрузить();

	Для Каждого Стр Из ТаблицаРезультата Цикл
		Стр.ПредставлениеРоли = Стр.ПредставлениеРоли + " ("+Стр.Пользователь.Наименование+")"
	КонецЦикла;
	
	Возврат ТаблицаРезультата;
КонецФункции	

&НаСервере
Функция СформироватьДанныеВыбораИсполнителя(Проект,ПроектЗадача,ПоРолям = Ложь,ПолучатьПредставление = Истина) Экспорт
	СписокИсполнителей = Новый СписокЗначений();
	
	//Получим данные по проекту
	ТаблицаИсполнителей = РаботаСЗаявками.ПолучитьПроектнуюКоманду(Проект,ПроектЗадача,ТекущаяДата());
	
	Для Каждого Строка Из ТаблицаИсполнителей Цикл
		Если  ПоРолям Тогда
			Если Не ПолучатьПредставление И СписокИсполнителей.НайтиПоЗначению(Строка.Роль)= Неопределено Тогда
				СписокИсполнителей.Добавить(Строка.Роль);
			ИначеЕсли ПолучатьПредставление Тогда
				СписокИсполнителей.Добавить(Строка.Роль,Строка.ПредставлениеРоли);
			КонецЕсли;	
		Иначе
			СтруктураДанных = Новый Структура();
			СтруктураДанных.Вставить("Роль",Строка.Роль);
			СтруктураДанных.Вставить("Пользователь",Строка.Пользователь);
			СписокИсполнителей.Добавить(СтруктураДанных,Строка.ПредставлениеРоли);
		КонецЕсли;
	КонецЦикла;	
		
	Возврат СписокИсполнителей;
КонецФункции

&НаСервере
Функция ПроверитьПревышениеНормыТрудозатрат(Проект,
			ПроектнаяЗадача,
			Источник,
			РольПользователя,
			ТекстСообщения,НоваяДлительность = 0) Экспорт
			
	ПланируемаяДлительность = ПолучитьПланируемуюДлительностьТрудозатрат(Проект,
			ПроектнаяЗадача,
			Источник,
			РольПользователя);		
	ТекущаяДлительностьТрудозатрат = ПолучитьТекущуюДлительностьТрудозатрат(Проект,
			ПроектнаяЗадача,
			Источник,
			РольПользователя);
			
	ПланЧас = Окр(ПланируемаяДлительность/3600,2);
	ФактЧас = Окр((ТекущаяДлительностьТрудозатрат+НоваяДлительность)/3600,2);
	
	Если ФактЧас > ПланЧас И ПланЧас <> 0 Тогда
		ТекстСообщения = "По источнику превышены планируемые затраты! Планировалось "+ПланЧас+" затрачено "+ФактЧас+""+Символы.ПС+"Укажите причину превышения трудозатрат!";
		Возврат Ложь;
	КонецЕсли;
	Возврат Истина;	
КонецФункции			

Функция ПолучитьПланируемуюДлительностьТрудозатрат(Проект,
			ПроектнаяЗадача,
			Источник,
			РольПользователя) Экспорт
			
	Длительность = 0;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЕСТЬNULL(СУММА(ПлановыеТрудозатратыПоЗаявкам.Длительность), 0) КАК Длительность
		|ИЗ
		|	РегистрСведений.ПлановыеТрудозатратыПоЗаявкам.СрезПоследних(&ДатаСреза, ) КАК ПлановыеТрудозатратыПоЗаявкам
		|ГДЕ
		|	ПлановыеТрудозатратыПоЗаявкам.Исполнитель = &Исполнитель
		|	И ПлановыеТрудозатратыПоЗаявкам.Источник = &Источник
		|	И ПлановыеТрудозатратыПоЗаявкам.Проект = &Проект
		|	И ПлановыеТрудозатратыПоЗаявкам.ПроектнаяЗадача = &ПроектнаяЗадача";

	Запрос.УстановитьПараметр("Источник", Источник);
	Запрос.УстановитьПараметр("Исполнитель", РольПользователя);
	Запрос.УстановитьПараметр("Проект", Проект);
	Запрос.УстановитьПараметр("ПроектнаяЗадача", ПроектнаяЗадача);
	Запрос.УстановитьПараметр("ДатаСреза", ТекущаяДата());

	РезультатЗапроса = Запрос.Выполнить();

	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();

	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		Длительность = ВыборкаДетальныеЗаписи.Длительность;
	КонецЕсли;	
	
	Возврат Длительность;
КонецФункции

Функция ПолучитьТекущуюДлительностьТрудозатрат(Проект,
			ПроектнаяЗадача,
			Источник,
			РольПользователя) Экспорт
			
	Длительность = 0;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЕСТЬNULL(СУММА(ФактическиеТрудозатраты.Длительность), 0) КАК Длительность
		|ИЗ
		|	РегистрСведений.ФактическиеТрудозатраты КАК ФактическиеТрудозатраты
		|ГДЕ
		|	ФактическиеТрудозатраты.Источник = &Источник
		|	И ФактическиеТрудозатраты.Проект = &Проект
		|	И ФактическиеТрудозатраты.ПроектнаяЗадача = &ПроектнаяЗадача
		|	И ФактическиеТрудозатраты.РольПользователя = &РольПользователя";

	Запрос.УстановитьПараметр("Источник", Источник);
	Запрос.УстановитьПараметр("РольПользователя", РольПользователя);
	Запрос.УстановитьПараметр("Проект", Проект);
	Запрос.УстановитьПараметр("ПроектнаяЗадача", ПроектнаяЗадача);

	РезультатЗапроса = Запрос.Выполнить();

	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();

	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		Длительность = ВыборкаДетальныеЗаписи.Длительность;
	КонецЕсли;	
	
	Возврат Длительность;
КонецФункции

&НаСервере
Функция ПолучитьТаблицуРаботПоЗаявке(Ссылка,ТЧТекстыДополнений) Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЗаявкаТекстыДополнений.ТипДополнения КАК ТипДополнения,
		|	ЗаявкаТекстыДополнений.ОписаниеДополненияHTML КАК ОписаниеДополненияHTML,
		|	ЗаявкаТекстыДополнений.ОписаниеДополнения КАК ОписаниеДополнения,
		|	ЗаявкаТекстыДополнений.Пользователь КАК Пользователь,
		|	ЗаявкаТекстыДополнений.ИдДополнения КАК ИдДополнения,
		|	ЗаявкаТекстыДополнений.ДатаСоздания КАК ДатаСоздания,
		|	ЗаявкаТекстыДополнений.Получатель КАК Получатель
		|ПОМЕСТИТЬ ТекстыДополнений
		|ИЗ
		|	&ТекстыДополнений КАК ЗаявкаТекстыДополнений
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	ДатаСоздания
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВложенныйЗапрос.ТипДополнения,
		|	ВложенныйЗапрос.ОписаниеДополненияHTML,
		|	ВложенныйЗапрос.ОписаниеДополнения,
		|	ВложенныйЗапрос.Пользователь,
		|	ВложенныйЗапрос.ИдДополнения,
		|	ВложенныйЗапрос.ДатаСоздания КАК ДатаСоздания,
		|	ВложенныйЗапрос.Получатель
		|ИЗ
		|	(ВЫБРАТЬ
		|		ЗаявкаТекстыДополнений.ТипДополнения КАК ТипДополнения,
		|		ЗаявкаТекстыДополнений.ОписаниеДополненияHTML КАК ОписаниеДополненияHTML,
		|		ЗаявкаТекстыДополнений.ОписаниеДополнения КАК ОписаниеДополнения,
		|		ЗаявкаТекстыДополнений.Пользователь КАК Пользователь,
		|		ЗаявкаТекстыДополнений.ИдДополнения КАК ИдДополнения,
		|		ЗаявкаТекстыДополнений.ДатаСоздания КАК ДатаСоздания,
		|		ЗаявкаТекстыДополнений.Получатель КАК Получатель
		|	ИЗ
		|		ТекстыДополнений КАК ЗаявкаТекстыДополнений
		|	) КАК ВложенныйЗапрос
		|
		|УПОРЯДОЧИТЬ ПО
		|	ДатаСоздания";

	Запрос.УстановитьПараметр("Заявка", Ссылка);
	Запрос.УстановитьПараметр("ТекстыДополнений", ТЧТекстыДополнений);
	
	РезультатЗапроса = Запрос.Выполнить();

	ТаблицаРезультата = РезультатЗапроса.Выгрузить();
	Возврат  ТаблицаРезультата;
КонецФункции

&НаСервере
Функция ПолучитьПроектПоКонтрагенту(Контрагент) Экспорт
	Проект = Справочники.Проекты.ПустаяСсылка();
	
	Если Не ЗначениеЗаполнено(Контрагент) Тогда
		Возврат Проект;
	КонецЕсли;	
		
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Проекты.Ссылка
		|ИЗ
		|	Справочник.Проекты КАК Проекты
		|ГДЕ
		|	Проекты.ПометкаУдаления = ЛОЖЬ
		|	И Проекты.Заказчик = &Заказчик";
	
	Запрос.УстановитьПараметр("Заказчик", Контрагент);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ТаблПроектов = РезультатЗапроса.Выгрузить();
	
	Если ТаблПроектов.Количество() = 1 Тогда
		Проект = ТаблПроектов.Получить(0).Ссылка;
	КонецЕсли;	
	Возврат Проект;
КонецФункции

&НаСервере
Функция ПолучитьПроектнуюЗадачуПоПроекту(Проект)  Экспорт
	ПроектнаяЗадача = Справочники.ПроектныеЗадачи.ПустаяСсылка();
	
	Если Не ЗначениеЗаполнено(Проект) Тогда
		Возврат ПроектнаяЗадача;
	КонецЕсли;	
		
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПроектныеЗадачи.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.ПроектныеЗадачи КАК ПроектныеЗадачи
		|ГДЕ
		|	ПроектныеЗадачи.ПометкаУдаления = ЛОЖЬ
		|	И ПроектныеЗадачи.Владелец = &Владелец
		|
		|УПОРЯДОЧИТЬ ПО
		|	ПроектныеЗадачи.Наименование";
	
	Запрос.УстановитьПараметр("Владелец", Проект);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ТаблЗадач = РезультатЗапроса.Выгрузить();
	
	Если ТаблЗадач.Количество() = 1 Тогда
		ПроектнаяЗадача = ТаблЗадач.Получить(0).Ссылка;
	КонецЕсли;
	Возврат ПроектнаяЗадача;
КонецФункции

&НаСервере
Функция ПолучитьМассивОбъединенныхЗаявок(Заявка) экспорт
	МассивЗаявок = Новый Массив();
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ОбъединенныеЗаявки.Заявка,
		|	ОбъединенныеЗаявки.ГлавнаяЗаявка
		|ИЗ
		|	РегистрСведений.ОбъединенныеЗаявки КАК ОбъединенныеЗаявки
		|ГДЕ
		|	ОбъединенныеЗаявки.ГлавнаяЗаявка = &ГлавнаяЗаявка";
	
	Запрос.УстановитьПараметр("ГлавнаяЗаявка", Заявка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		МассивЗаявок.Добавить(ВыборкаДетальныеЗаписи.Заявка);
	КонецЦикла;
	
	Возврат МассивЗаявок;
КонецФункции

&НаСервере
Функция ОбъединитьЗаявки(ЗаявкаИсход,ГлавнЗаявка) экспорт

	Менеджерзаписи = РегистрыСведений.ОбъединенныеЗаявки.СоздатьМенеджерЗаписи();
	Менеджерзаписи.Активность = Истина;
	Менеджерзаписи.ГлавнаяЗаявка = ГлавнЗаявка;
	Менеджерзаписи.Заявка = ЗаявкаИсход;
	Менеджерзаписи.Записать();
	
	//Перенесем подписчиков и пользователей для получения оповещений по заявке
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПодписчикиЗаявок.Пользователь
	|ИЗ
	|	РегистрСведений.ПодписчикиЗаявок КАК ПодписчикиЗаявок
	|ГДЕ
	|	ПодписчикиЗаявок.Заявка = &Заявка
	|
	|СГРУППИРОВАТЬ ПО
	|	ПодписчикиЗаявок.Пользователь";
	
	Запрос.УстановитьПараметр("Заявка", ЗаявкаИсход);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		МенеджерЗаписи = РегистрыСведений.ПодписчикиЗаявок.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.Пользователь = Выборка.Пользователь;
		МенеджерЗаписи.Заявка = ГлавнЗаявка;
		МенеджерЗаписи.Прочитать();
		
		Если Не МенеджерЗаписи.Выбран() Тогда
			МенеджерЗаписи.Пользователь = Выборка.Пользователь;
			МенеджерЗаписи.Заявка = ГлавнЗаявка;
			МенеджерЗаписи.Записать();
		КонецЕсли;			 
	КонецЦикла;	
	
	МенеджерЗаписи = РегистрыСведений.ПодписчикиЗаявок.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Пользователь = ЗаявкаИсход.Постановщик;
	МенеджерЗаписи.Заявка = ГлавнЗаявка;
	МенеджерЗаписи.Прочитать();
	
	Если Не МенеджерЗаписи.Выбран() Тогда
		МенеджерЗаписи.Пользователь = ЗаявкаИсход.Постановщик;
		МенеджерЗаписи.Заявка = ГлавнЗаявка;
		МенеджерЗаписи.Записать();
	КонецЕсли;
КонецФункции

&НаСервере
Функция ПолучитьТекстЗаявкиИзОбъекта(СтруктураПараметров,СтруктураАдресовКартинок) Экспорт
	
	АдресКартинкиОбъединения = СтруктураАдресовКартинок.АдресКартинкиОбъединения;
	АдресКартинкиРедактирования = СтруктураАдресовКартинок.АдресКартинкиРедактирования;

	ОписаниеЗаявкиHTML = СтруктураПараметров.ОписаниеЗаявкиHTML;
	Ссылка = СтруктураПараметров.Ссылка;
	ТекстыДополнений = СтруктураПараметров.ТекстыДополнений;
	ТаблицаВложений = СтруктураПараметров.ТаблицаВложений;
	УникальныйИдентификатор = СтруктураПараметров.УникальныйИдентификатор;
	ГлавнаяЗаявка = СтруктураПараметров.ГлавнаяЗаявка;
	ЗапретитьРедактированиеЗаявки = СтруктураПараметров.ЗапретитьРедактированиеЗаявки;
	НеВставлятьСлужебныеСсылкиВТекст = СтруктураПараметров.НеВставлятьСлужебныеСсылкиВТекст;
	ЗаменятьИдентификаторыКартинок =  СтруктураПараметров.ЗаменятьИдентификаторыКартинок;

	
	ТекстТекущейЗаявкиHTML = "<DIV>"+ОписаниеЗаявкиHTML+"</DIV>";	
	ТекстРаботПоЗаявке = ПолучитьТекстРаботПоЗаявке(ТекстыДополнений,УникальныйИдентификатор,СтруктураАдресовКартинок,ГлавнаяЗаявка,ТаблицаВложений,НеВставлятьСлужебныеСсылкиВТекст);
	
	МассивОбъедЗаявок = РаботаСЗаявками.ПолучитьМассивОбъединенныхЗаявок(Ссылка);
	
	Если ЗначениеЗаполнено(Ссылка) Тогда
		ИДКомбоБокса = Строка(Новый УникальныйИдентификатор());
		
		ШаблонКнопки = "<a class='command_panel' title='Изменить текст заявки' href='addition:"+Ссылка.УникальныйИдентификатор()+"'><img src='image0000'/>Изменить текст заявки</a>";		
			
		МассивСтрок = ТаблицаВложений.НайтиСтроки(Новый Структура("Ключ",АдресКартинкиРедактирования));
		Если МассивСтрок.Количество() = 0 Тогда
			НоваяСтрока = ТаблицаВложений.Добавить();
			НоваяСтрока.Ключ = АдресКартинкиРедактирования;
			НоваяСтрока.Адрес = ПоместитьВоВременноеХранилище(БиблиотекаКартинок.БазаЗнанийРедактирование,УникальныйИдентификатор);
		Иначе
			НоваяСтрока = МассивСтрок.Получить(0);
		КонецЕсли;	
		Если ТекстыДополнений.Количество() > 0 ИЛИ ЗапретитьРедактированиеЗаявки Тогда
			ОписаниеПользователю = ""; //Редактировать заявку можно пока на нее не ответили
		Иначе	
			ОписаниеПользователю = СтрЗаменить(ШаблонКнопки,"img src='image0000","img src='"+НоваяСтрока.Ключ);
		КонецЕсли;
		
		ТекстТекущейЗаявкиHTML = ?(ЗначениеЗаполнено(ОписаниеПользователю),ОписаниеПользователю,"")+Символы.ПС+ТекстТекущейЗаявкиHTML;
	КонецЕсли;

	МассивСтрок = ТаблицаВложений.НайтиСтроки(Новый Структура("Ключ",АдресКартинкиОбъединения));
	Если МассивСтрок.Количество() = 0 Тогда
		НоваяСтрока = ТаблицаВложений.Добавить();
		НоваяСтрока.Ключ = АдресКартинкиОбъединения;
		НоваяСтрока.Адрес = ПоместитьВоВременноеХранилище(БиблиотекаКартинок.ОбновитьФайлИзФайлаНаДиске,УникальныйИдентификатор);
	Иначе
		НоваяСтрока = МассивСтрок.Получить(0);
	КонецЕсли;	
	КлючКартинки = НоваяСтрока.Ключ;
		
	ТекстОбъединенныхЗаявокHTML = ?(МассивОбъедЗаявок.Количество() = 0,"","<p><a class='command_panel' title='Объединенные заявки:' style='color: #800000'><img src='"+КлючКартинки+"'/>Объединенные заявки:</a></p>");
	Для Каждого ЭлЗаявки Из МассивОбъедЗаявок Цикл 		
		ПредставлениеЗаявки = "Заявка №"+Формат(ЭлЗаявки.Номер,"ЧГ=0")+" от "+Формат(ЭлЗаявки.дата,"ДФ=dd.MM.yyyy");
		ОписаниеПользователю = "<DIV><a class='command_panel' title='"+ПредставлениеЗаявки+?(НеВставлятьСлужебныеСсылкиВТекст,"","' href='ticket:"+Строка(ЭлЗаявки.УникальныйИдентификатор()))+"'>"+ПредставлениеЗаявки+"</a></DIV>";		
		ТекстОбъединеннойЗаявкиHTML = "";//ЭлЗаявки.ОписаниеЗаявкиHTML; 
		ТекстОбъединенныхЗаявокHTML = ТекстОбъединенныхЗаявокHTML +Символы.ПС+ОписаниеПользователю+Символы.ПС+ТекстОбъединеннойЗаявкиHTML;
	КонецЦикла;	
	
	//ТекстHTML = ТекстТекущейЗаявкиHTML+Символы.ПС+ТекстРаботПоЗаявке;
	ТекстHTML = ТекстТекущейЗаявкиHTML+Символы.ПС+ТекстОбъединенныхЗаявокHTML+Символы.ПС+ТекстРаботПоЗаявке+"<br>";

	Возврат ПодготовитьHTMLСтраницу(ТекстHTML,ТаблицаВложений,ЗаменятьИдентификаторыКартинок);
	
КонецФункции

&НаСервере
Функция ПолучитьТекстРаботПоЗаявке(ТекстыДополнений,УникальныйИдентификатор,СтруктураАдресовКартинок,ГлавнаяЗаявка,ТаблицаВложений,НеВставлятьСлужебныеСсылкиВТекст)
	ТекстРаботHTML = "";
	Для Каждого Стр Из ТекстыДополнений Цикл		
		ИдДополнения = Стр.ИдДополнения;
		Пользователь = Стр.Пользователь;
		ДатаСоздания = Стр.ДатаСоздания;
		ТекстHTML = Стр.ОписаниеДополненияHTML;
		ТипДополнения = Стр.ТипДополнения;
		Получатель = Стр.Получатель;
		ДопОписание = Стр.ОписаниеДополнения;

		ТекстРаботHTML = ТекстРаботHTML + Символы.ПС+ОбработатьТекстДополненияЗаявки(ТекстHTML,ДопОписание,Пользователь,Получатель,ТипДополнения,ИдДополнения,ДатаСоздания,УникальныйИдентификатор,ГлавнаяЗаявка,СтруктураАдресовКартинок,ТаблицаВложений,НеВставлятьСлужебныеСсылкиВТекст);
		
	КонецЦикла;
	
	Возврат ТекстРаботHTML;
КонецФункции

&НаСервере
Функция ОбработатьТекстДополненияЗаявки(ТекстHTML,ДопОписание,Пользователь,Получатель,ТипДополнения,ИдДополнения,ДатаСоздания,УникальныйИдентификатор,ГлавнаяЗаявка,СтруктураАдресовКартинок,ТаблицаВложений,НеВставлятьСлужебныеСсылкиВТекст)
	
	ИДКомбоБокса = Строка(Новый УникальныйИдентификатор());
	
	АдресКартинкиДополнения = СтруктураАдресовКартинок.АдресКартинкиДополнения;
	АдресКартинкиУдаления   = СтруктураАдресовКартинок.АдресКартинкиУдаления;
	АдресКартинкиПередачи   = СтруктураАдресовКартинок.АдресКартинкиПередачи;
	АдресКартинкиСостояния  = СтруктураАдресовКартинок.АдресКартинкиСостояния;
	
	Если ТипДополнения = Перечисления.ВидыСобытийПоЗаявке.Дополнение Тогда  
		ШаблонОписания = "<p><a class='command_panel' title='Изменить ответ' "+?(НеВставлятьСлужебныеСсылкиВТекст,"","href='addition:"+ИдДополнения)+"'><img src='image0000'/><span class='command_panel' style='color: #0f833f'>ИмяЭлемента</span></a><a class='command_panel' title='Удалить дополнение' "+?(НеВставлятьСлужебныеСсылкиВТекст,"","href='deleteaddition:"+ИдДополнения)+"'><img src='image0001'/></a></p>";
		
		//Добавим картинку заголовка
		МассивСтрок = ТаблицаВложений.НайтиСтроки(Новый Структура("Ключ",АдресКартинкиДополнения));
		Если МассивСтрок.Количество() = 0 Тогда
			НоваяСтрока = ТаблицаВложений.Добавить();
			НоваяСтрока.Ключ = АдресКартинкиДополнения;
			НоваяСтрока.Адрес = ПоместитьВоВременноеХранилище(БиблиотекаКартинок.ДобавитьПримечание24x24,УникальныйИдентификатор);
		Иначе
			НоваяСтрока = МассивСтрок.Получить(0);
		КонецЕсли;
		
		ШаблонОписания = СтрЗаменить(ШаблонОписания,"img src='image0000","img src='"+НоваяСтрока.Ключ);
		
		МассивСтрок = ТаблицаВложений.НайтиСтроки(Новый Структура("Ключ",АдресКартинкиУдаления));
		Если МассивСтрок.Количество() = 0 Тогда
			НоваяСтрока = ТаблицаВложений.Добавить();
			НоваяСтрока.Ключ = АдресКартинкиУдаления;
			НоваяСтрока.Адрес = ПоместитьВоВременноеХранилище(БиблиотекаКартинок.УдалитьНепосредственно,УникальныйИдентификатор);
		Иначе
			НоваяСтрока = МассивСтрок.Получить(0);
		КонецЕсли;
		
		ШаблонОписания = СтрЗаменить(ШаблонОписания,"img src='image0001","img src='"+НоваяСтрока.Ключ);
		
		//Вставляем ссылку на пользователя, который сделал этот ответ		
		ОписаниеПользователю = СтрЗаменить(ШаблонОписания,"ИмяЭлемента","Ответ от "+Пользователь.Наименование+"  "+Формат(ДатаСоздания,"ДЛФ=DDT"));
		СсылкаПользователю = "";
	ИначеЕсли ТипДополнения = Перечисления.ВидыСобытийПоЗаявке.Передача Тогда 
		ШаблонОписания = "<p><img src='image0000'/><span class='command_panel' style='color: #FF501E'>ИмяЭлемента</span><a class='command_panel' title='Отменить передачу' "+?(НеВставлятьСлужебныеСсылкиВТекст,"","href='deleteaddition:"+ИдДополнения)+"'><img src='image0001'/></a></p>";
		
		//Добавим картинку заголовка
		МассивСтрок = ТаблицаВложений.НайтиСтроки(Новый Структура("Ключ",АдресКартинкиПередачи));
		Если МассивСтрок.Количество() = 0 Тогда
			НоваяСтрока = ТаблицаВложений.Добавить();
			НоваяСтрока.Ключ = АдресКартинкиПередачи;
			НоваяСтрока.Адрес = ПоместитьВоВременноеХранилище(БиблиотекаКартинок.ВзаимодействиеСотрудников,УникальныйИдентификатор);
		Иначе
			НоваяСтрока = МассивСтрок.Получить(0);
		КонецЕсли;
		
		ШаблонОписания = СтрЗаменить(ШаблонОписания,"img src='image0000","img src='"+НоваяСтрока.Ключ);
		
		МассивСтрок = ТаблицаВложений.НайтиСтроки(Новый Структура("Ключ",АдресКартинкиУдаления));
		Если МассивСтрок.Количество() = 0 Тогда
			НоваяСтрока = ТаблицаВложений.Добавить();
			НоваяСтрока.Ключ = АдресКартинкиУдаления;
			НоваяСтрока.Адрес = ПоместитьВоВременноеХранилище(БиблиотекаКартинок.УдалитьНепосредственно,УникальныйИдентификатор);
		Иначе
			НоваяСтрока = МассивСтрок.Получить(0);
		КонецЕсли;
		
		ШаблонОписания = СтрЗаменить(ШаблонОписания,"img src='image0001","img src='"+НоваяСтрока.Ключ);
		
		//ОписаниеПользователю = СтрЗаменить(ШаблонОписания,"ИмяЭлемента","Заявка передана пользователю "+Получатель.Наименование+" от "+Пользователь.Наименование+" "+Формат(ДатаСоздания,"ДЛФ=DDT"));
		Если  Получатель = Пользователь Тогда
			ОписаниеПользователю = СтрЗаменить(ШаблонОписания,"ИмяЭлемента","Заявка передана пользователю "+Получатель.Наименование+" "+Формат(ДатаСоздания,"ДЛФ=DDT"));	
		Иначе	
			ОписаниеПользователю = СтрЗаменить(ШаблонОписания,"ИмяЭлемента","Заявка передана пользователю "+Получатель.Наименование+" от "+Пользователь.Наименование+" "+Формат(ДатаСоздания,"ДЛФ=DDT"));
		КонецЕсли;
		
		СсылкаПользователю = "";
	ИначеЕсли ТипДополнения = Перечисления.ВидыСобытийПоЗаявке.ИзмененСтатус Тогда 				
		ШаблонОписания = "<p><a class='command_panel' title='Изменен статус'><img src='image0000'/><span class='command_panel' style='color: #3366FF'>ИмяЭлемента</span></a></p>";		
		//Добавим картинку заголовка
		МассивСтрок = ТаблицаВложений.НайтиСтроки(Новый Структура("Ключ",АдресКартинкиСостояния));
		Если МассивСтрок.Количество() = 0 Тогда
			НоваяСтрока = ТаблицаВложений.Добавить();
			НоваяСтрока.Ключ = АдресКартинкиСостояния;
			НоваяСтрока.Адрес = ПоместитьВоВременноеХранилище(БиблиотекаКартинок.СрочнаяЗадача,УникальныйИдентификатор);
		Иначе
			НоваяСтрока = МассивСтрок.Получить(0);
		КонецЕсли;
		ШаблонОписания = СтрЗаменить(ШаблонОписания,"img src='image0000","img src='"+НоваяСтрока.Ключ);	
		
		ОписаниеПользователю = СтрЗаменить(ШаблонОписания,"ИмяЭлемента","Статус заявки изменен пользователем "+Пользователь.Наименование+" на <"+ ДопОписание +"> "+Формат(ДатаСоздания,"ДЛФ=DDT"));
		СсылкаПользователю = "";
	ИначеЕсли ТипДополнения = Перечисления.ВидыСобытийПоЗаявке.Объединена Тогда 				
		ШаблонОписания = "<p><a class='command_panel' title='Заявка объединена'><img src='image0000'/><span class='command_panel' style='color: #800000'>ИмяЭлемента</span></a></p>";		
		//Добавим картинку заголовка
		МассивСтрок = ТаблицаВложений.НайтиСтроки(Новый Структура("Ключ",АдресКартинкиСостояния));
		Если МассивСтрок.Количество() = 0 Тогда
			НоваяСтрока = ТаблицаВложений.Добавить();
			НоваяСтрока.Ключ = АдресКартинкиСостояния;
			НоваяСтрока.Адрес = ПоместитьВоВременноеХранилище(БиблиотекаКартинок.ОбновитьФайлИзФайлаНаДиске,УникальныйИдентификатор);
		Иначе
			НоваяСтрока = МассивСтрок.Получить(0);
		КонецЕсли;
		ШаблонОписания = СтрЗаменить(ШаблонОписания,"img src='image0000","img src='"+НоваяСтрока.Ключ);	
		
		ПредставлениеЗаявки = "Заявка №"+Формат(ГлавнаяЗаявка.Номер,"ЧГ=0")+" от "+Формат(ГлавнаяЗаявка.дата,"ДФ=dd.MM.yyyy");
		ОписаниеПользователю = "<a class='command_panel' title='"+ПредставлениеЗаявки+"' "+?(НеВставлятьСлужебныеСсылкиВТекст,"","href='ticket:"+Строка(ГлавнаяЗаявка.УникальныйИдентификатор()))+"'>"+ПредставлениеЗаявки+"</a>";

		ОписаниеПользователю = СтрЗаменить(ШаблонОписания,"ИмяЭлемента","Заявка объединена с заявкой "+ОписаниеПользователю+" пользователем "+Пользователь.Наименование+" "+Формат(ДатаСоздания,"ДЛФ=DDT"));
		СсылкаПользователю = "";	
	Иначе
		Сообщить("Неизвестный тип дополнения!");
		Возврат ТекстHTML;
	КонецЕсли;
	
	НовыйТекстДополнения = ОписаниеПользователю+Символы.ПС+"<DIV Name="+ИДКомбоБокса+" ID="+ИДКомбоБокса+" Style='display:block'>"+ТекстHTML+Символы.ПС+СсылкаПользователю+"</DIV>";	
	
	Возврат НовыйТекстДополнения;
КонецФункции

&НаСервере
Функция ПодготовитьHTMLСтраницу(ТекстHTML,Знач ТаблицаВложений,ОбрабатыватьТекстЗаявки=Истина)  Экспорт
	
	Если ОбрабатыватьТекстЗаявки = Истина Тогда
		//Добавим тег HTML если он отсутствует. 
		//Необходимо для корректного отображения в элементе формы.
		Если СтрЧислоВхождений(ТекстHTML,"<body") = 0 Тогда
			ЗаголовокHTML = "<html>
			|<head>
			|<meta http-equiv=""Content-Type"" content=""text/html; charset=utf-8"" />
			//|<meta http-equiv=""X-UA-Compatible"" content=""IE=EmulateIE7"" />
			//|<meta http-equiv=""X-UA-Compatible"" content=""IE=edge,chrome=1"" />
			|<meta name=""format-detection"" content=""telephone=no"" />" + "
			|<style type='text/css'>	
			|Body{
			|border:0; margin: 0 0 0 5px; /* Отступ Body*/
			|} 
			|P{
			|border:0; margin: 5px 0 0 10px; /* Отступ P*/
			|}
			|.command_panel border:0; margin:0 0 0 5px;font-size: 100%}
			|.command_panel img {border:0; margin:0; height:16px;}	
			|</style>
			|</head>
			//Добавим скрипт раскрытия разделов по нажатию на ссылку
			|<script type=""text/javascript"">
			|function OpenComboBox(IDElement)
			|{
			|var obj=document.getElementById(IDElement);
			|if(obj.style.display=='none')
			|	obj.style.display='block';
			|else
			|	obj.style.display='none';
			|}
			|</script>
			|<body>";
			
			ПодвалHTML = "</body>
			|</html>";
			
			ТекстHTML = ЗаголовокHTML + ТекстHTML + ПодвалHTML;
		Иначе
			//Возможно у нас уже есть Body, тогда проверим тег overflow в body
			ТекстHTML = СтрЗаменить(ТекстHTML,"overflow:hidden;","");
		КонецЕсли;
		
		ЗаменитьИдентификаторыОбъектовНаАдресаВHTML(ТекстHTML,ТаблицаВложений);	
	КонецЕсли;	
	
	ПропарситьСсылкиИзHTML(ТекстHTML,ТаблицаВложений);	
	
	Возврат  ТекстHTML;
КонецФункции

&НаСервере
Процедура ЗаменитьИдентификаторыОбъектовНаАдресаВHTML(ТекстHTML,ТаблицаВложений)  Экспорт
	//Получим вложения и поместим их во временное хранилище
	Для Каждого Стр Из ТаблицаВложений Цикл
		АдресКартинки = Стр.Адрес;
		Если Не ЗначениеЗаполнено(АдресКартинки) Тогда
			Продолжить;
		КонецЕсли;	
		//Если у нас прописано через cid
		ТекстHTML = СтрЗаменить(ТекстHTML,"cid:"+Стр.Ключ,АдресКартинки);
		//Если прописано через img src
		ТекстHTML = СтрЗаменить(ТекстHTML,"src='"+Стр.Ключ,"src='"+АдресКартинки);
		ТекстHTML = СтрЗаменить(ТекстHTML,"src="""+Стр.Ключ,"src="""+АдресКартинки);
	КонецЦикла;	
КонецПроцедуры

&НаСервере
Процедура ПропарситьСсылкиИзHTML(ТекстДляПарсинга,ТаблицаВложений)  Экспорт
	//В процессе работы с текстом HTML (если переколючались в режим просмотра HTML к примеру) ослик и 1с периодически добавляет мусор в пути
	//отучаем его от этого плохого занятия
	Для Каждого Стр из ТаблицаВложений Цикл
		Адрес = ?(ЗначениеЗаполнено(Стр.ИмяЛокальногоФайла),Стр.ИмяЛокальногоФайла,Стр.Адрес);
		
		//убираем за осликом about: в ссылках без HTTP://
		ТекстДляПарсинга = СтрЗаменить(ТекстДляПарсинга,"about:"+Адрес,Адрес);
		
		//Также платформа может для ссылок добавить ссылку на базу
		ТекстДляПарсинга = СтрЗаменить(ТекстДляПарсинга, ПолучитьНавигационнуюСсылкуИнформационнойБазы()+"/"+Адрес,Адрес);
		
		//Или ослик может добавить file там где его не надо. При этом слеши он поменяет на обратные
		ТекстДляПарсинга = СтрЗаменить(ТекстДляПарсинга, "file:///"+СтрЗаменить(Адрес,"\","/"),Адрес);
		
		//Или платформа дописать к идентификатору лишнего
		ТекстДляПарсинга = СтрЗаменить(ТекстДляПарсинга, ПолучитьНавигационнуюСсылкуИнформационнойБазы()+"/"+Стр.Ключ,Стр.Ключ);
		
	КонецЦикла;	
КонецПроцедуры

&НаСервере
Функция ПолучитьТекстHTMLЗаявки(Заявка,Кодировка,УникальныйИдентификатор,КодироватьКартинкиЧерезФайл = Ложь) Экспорт
	
	МассивВременныхФайлов = Новый Массив();
	
	ТаблицаКартинок = РаботаСЗаявкамиИПочтой.ПолучитьКартинкиИзЗаявки(Заявка,УникальныйИдентификатор);	
	ТаблицаКартинок.Колонки.Добавить("ИмяЛокальногоФайла");
	ТаблицаКартинок.ЗаполнитьЗначения("","ИмяЛокальногоФайла");
	
	СтруктураАдресовКартинок = Новый Структура();
	СтруктураАдресовКартинок.Вставить("АдресКартинкиДополнения",Строка(Новый УникальныйИдентификатор));
	СтруктураАдресовКартинок.Вставить("АдресКартинкиОбъединения",Строка(Новый УникальныйИдентификатор));
	СтруктураАдресовКартинок.Вставить("АдресКартинкиПередачи",Строка(Новый УникальныйИдентификатор));
	СтруктураАдресовКартинок.Вставить("АдресКартинкиРедактирования",Строка(Новый УникальныйИдентификатор));
	СтруктураАдресовКартинок.Вставить("АдресКартинкиРешения",Строка(Новый УникальныйИдентификатор));
	СтруктураАдресовКартинок.Вставить("АдресКартинкиСостояния",Строка(Новый УникальныйИдентификатор));
	СтруктураАдресовКартинок.Вставить("АдресКартинкиУдаления",Строка(Новый УникальныйИдентификатор));

	СтруктураПараметров = Новый Структура();
	СтруктураПараметров.Вставить("ОписаниеЗаявкиHTML",Заявка.ОписаниеЗаявкиHTML);
	СтруктураПараметров.Вставить("Ссылка",Заявка.Ссылка);
	СтруктураПараметров.Вставить("ТекстыДополнений",Заявка.ТекстыДополнений);
	СтруктураПараметров.Вставить("ТаблицаВложений",ТаблицаКартинок);
	СтруктураПараметров.Вставить("УникальныйИдентификатор",УникальныйИдентификатор);
	СтруктураПараметров.Вставить("ГлавнаяЗаявка",Заявка.ГлавнаяЗаявка);
	СтруктураПараметров.Вставить("ЗапретитьРедактированиеЗаявки",Истина);
	СтруктураПараметров.Вставить("НеВставлятьСлужебныеСсылкиВТекст",Истина);
	СтруктураПараметров.Вставить("ЗаменятьИдентификаторыКартинок",Ложь);	
	
	ТекстHTML = РаботаСЗаявками.ПолучитьТекстЗаявкиИзОбъекта(СтруктураПараметров,СтруктураАдресовКартинок);
	
	МассивФайлов = Новый Массив();			
	Для Каждого Стр Из ТаблицаКартинок Цикл
		Если СтрНайти(ТекстHTML,Стр.Ключ)> 0 Тогда
			Картинка = ПолучитьИзВременногоХранилища(Стр.Адрес);
			Если ТипЗнч(Картинка) = Тип("Картинка") Тогда
				Картинка = Картинка.ПолучитьДвоичныеДанные()
			ИначеЕсли ТипЗнч(Картинка) <> Тип("ДвоичныеДанные") Тогда 
				СообщениеОбОшибке = "Во время подготовки текста заявки произошла ошибка - ""Не предусмотреный тип картинки в тексте!""";
				Продолжить;
			КонецЕсли;
			//ТекстHTML = СтрЗаменить(ТекстHTML,"src='"+Стр.Ключ,"src='data:image;base64," + Base64Строка(Картинка));
			//ТекстHTML = СтрЗаменить(ТекстHTML,"src="""+Стр.Ключ,"src=""data:image;base64," + Base64Строка(Картинка));
			
			Если КодироватьКартинкиЧерезФайл = Истина Тогда
				ИмяВремФайла = ПолучитьИмяВременногоФайла("jpg");
				Картинка.Записать(ИмяВремФайла);
				ТекстHTML = СтрЗаменить(ТекстHTML,"src='"+Стр.Ключ,"src='file://" + ИмяВремФайла);
				ТекстHTML = СтрЗаменить(ТекстHTML,"src="""+Стр.Ключ,"src=""file://" + ИмяВремФайла);
				МассивВременныхФайлов.Добавить(ИмяВремФайла);
			Иначе
				ТекстHTML = СтрЗаменить(ТекстHTML,"src='"+Стр.Ключ,"src='data:image;base64," + Base64Строка(Картинка));
				ТекстHTML = СтрЗаменить(ТекстHTML,"src="""+Стр.Ключ,"src=""data:image;base64," + Base64Строка(Картинка));
			КонецЕсли;
		КонецЕсли;					
	КонецЦикла; 	
	
	Если не ЗначениеЗаполнено(Кодировка) Тогда
		Кодировка = ?(ТипЗнч(Заявка.ДокументОснование) = Тип("ДокументСсылка.ВходящееПисьмо"),Заявка.ДокументОснование.Кодировка,"UTF-8");	
	КонецЕсли;
	
	Возврат ТекстHTML;	

КонецФункции