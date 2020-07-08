
// Записывает личные контакты в информационную базу
Функция ЗаписатьКонтакты(МассивКонтактов) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ЧислоЗагруженных = 0;
	
	Для Каждого Описание Из МассивКонтактов Цикл
		
		Элемент = Справочники.ЛичныеАдресаты.СоздатьЭлемент();
		
		Элемент.Пользователь = Пользователи.ТекущийПользователь();
		
		Элемент.Наименование = Описание.Наименование;
		Если Не ЗначениеЗаполнено(Элемент.Наименование) Тогда
			Элемент.Наименование = Описание.ПредставлениеEmail;
		КонецЕсли;	
		
		Элемент.Организация = Описание.Организация;
		Элемент.Должность = Описание.Должность;
		
		// EmailАдресата
		Если ЗначениеЗаполнено(Описание.EmailАдресата) И Найти(Описание.EmailАдресата, "@") <> 0 Тогда
			НовСтр = Элемент.КонтактнаяИнформация.Добавить();
			НовСтр.ЗначенияПолей = Описание.EmailАдресата;
			НовСтр.АдресЭП = Описание.EmailАдресата;
			НовСтр.Представление = Описание.EmailАдресата;
			НовСтр.Вид = Справочники.ВидыКонтактнойИнформации.EmailАдресата;
			НовСтр.Тип = Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты;
		КонецЕсли;
		
		// РабочийТелефонАдресата
		Если ЗначениеЗаполнено(Описание.РабочийТелефонАдресата) Тогда
			НовСтр = Элемент.КонтактнаяИнформация.Добавить();
			НовСтр.НомерТелефона = Описание.РабочийТелефонАдресата;
			НовСтр.Представление = Описание.РабочийТелефонАдресата;
			НовСтр.ЗначенияПолей = Описание.РабочийТелефонАдресата;
			НовСтр.Вид = Справочники.ВидыКонтактнойИнформации.РабочийТелефонАдресата;
			НовСтр.Тип = Перечисления.ТипыКонтактнойИнформации.Телефон;
		КонецЕсли;
		
		// ФаксАдресата
		Если ЗначениеЗаполнено(Описание.ФаксАдресата) Тогда
			НовСтр = Элемент.КонтактнаяИнформация.Добавить();
			НовСтр.НомерТелефона = Описание.ФаксАдресата;
			НовСтр.Представление = Описание.ФаксАдресата;
			НовСтр.ЗначенияПолей = Описание.ФаксАдресата;
			НовСтр.Вид = Справочники.ВидыКонтактнойИнформации.ФаксАдресата;
			НовСтр.Тип = Перечисления.ТипыКонтактнойИнформации.Факс;
		КонецЕсли;
		
		// ПочтовыйАдресАдресата
		Если ЗначениеЗаполнено(Описание.ПочтовыйАдресАдресата) Тогда
			НовСтр = Элемент.КонтактнаяИнформация.Добавить();
			НовСтр.ЗначенияПолей = Описание.ПочтовыйАдресАдресата;
			НовСтр.Представление = Описание.ПочтовыйАдресАдресата;
			НовСтр.Вид = Справочники.ВидыКонтактнойИнформации.ПочтовыйАдресАдресата;
			НовСтр.Тип = Перечисления.ТипыКонтактнойИнформации.Адрес;
			НовСтр.Город = Описание.Город;
			НовСтр.Страна = Описание.Страна;
			НовСтр.Регион = Описание.Регион;
		КонецЕсли;
		
		Если ЕстьТакойЛичныйАдресат(Элемент) Тогда
			Продолжить;
		КонецЕсли;	
		
		Если ЕстьТакойКорреспондент(Элемент) Тогда
			Продолжить;
		КонецЕсли;	
		
		Если ЕстьТакоеКонтактноеЛицо(Элемент) Тогда
			Продолжить;
		КонецЕсли;	
		
		Элемент.Записать();
		ЧислоЗагруженных = ЧислоЗагруженных + 1;
		
	КонецЦикла;	
	
	Возврат ЧислоЗагруженных;
	
КонецФункции

Функция ЕстьТакойЛичныйАдресат(Элемент) 
	
	Запрос = Новый Запрос;
	Запрос.Текст
	 = "ВЫБРАТЬ
	   |	ЛичныеАдресаты.Наименование,
	   |	ЛичныеАдресаты.КонтактнаяИнформация.(
	   |		Ссылка,
	   |		НомерСтроки,
	   |		АдресЭП,
	   |		Вид,
	   |		Город,
	   |		ДоменноеИмяСервера,
	   |		ЗначенияПолей,
	   |		НомерТелефона,
	   |		НомерТелефонаБезКодов,
	   |		Представление,
	   |		Регион,
	   |		Страна,
	   |		Тип
	   |	)
	   |ИЗ
	   |	Справочник.ЛичныеАдресаты КАК ЛичныеАдресаты
	   |ГДЕ
	   |	ЛичныеАдресаты.Пользователь = &Пользователь";
	   
	Запрос.УстановитьПараметр("Пользователь", Пользователи.ТекущийПользователь());
	
	Таблица = Запрос.Выполнить().Выгрузить();
	Для Каждого Строка Из Таблица Цикл
		
		Наименование = Строка.Наименование;
		АдресПочты = ПолучитьАдресПочты(Строка.КонтактнаяИнформация);
		Телефон = ПолучитьТелефон(Строка.КонтактнаяИнформация);
		
		НаименованиеНовое = Элемент.Наименование;
		АдресПочтыНовый = ПолучитьАдресПочты(Элемент.КонтактнаяИнформация);
		ТелефонНовый = ПолучитьТелефон(Элемент.КонтактнаяИнформация);
		
		Если Наименование = НаименованиеНовое 
			И АдресПочты = АдресПочтыНовый
			И Телефон = ТелефонНовый Тогда
			Возврат Истина;
		КонецЕсли;	
		
	КонецЦикла;	
	
	Возврат Ложь;
	
КонецФункции

Функция ЕстьТакойКорреспондент(Элемент) 
	
	Запрос = Новый Запрос;
	Запрос.Текст
	 = "ВЫБРАТЬ
	   |	Корреспонденты.Наименование,
	   |	Корреспонденты.КонтактнаяИнформация.(
	   |		Ссылка,
	   |		НомерСтроки,
	   |		АдресЭП,
	   |		Вид,
	   |		Город,
	   |		ДоменноеИмяСервера,
	   |		ЗначенияПолей,
	   |		НомерТелефона,
	   |		НомерТелефонаБезКодов,
	   |		Представление,
	   |		Регион,
	   |		Страна,
	   |		Тип
	   |	)
	   |ИЗ
	   |	Справочник.Контрагенты КАК Корреспонденты";
	   
	Таблица = Запрос.Выполнить().Выгрузить();
	Для Каждого Строка Из Таблица Цикл
		
		АдресПочты = ПолучитьАдресПочты(Строка.КонтактнаяИнформация);
		Телефон = ПолучитьТелефон(Строка.КонтактнаяИнформация);
		
		АдресПочтыНовый = ПолучитьАдресПочты(Элемент.КонтактнаяИнформация);
		ТелефонНовый = ПолучитьТелефон(Элемент.КонтактнаяИнформация);
		
		Если (АдресПочты = АдресПочтыНовый И ЗначениеЗаполнено(АдресПочты))
			ИЛИ (Телефон = ТелефонНовый И ЗначениеЗаполнено(Телефон)) Тогда
			Возврат Истина;
		КонецЕсли;	
		
	КонецЦикла;	
	
	Возврат Ложь;
	
КонецФункции

Функция ЕстьТакоеКонтактноеЛицо(Элемент) 
	
	Запрос = Новый Запрос;
	Запрос.Текст
	 = "ВЫБРАТЬ
	   |	КонтактныеЛица.Наименование,
	   |	КонтактныеЛица.КонтактнаяИнформация.(
	   |		Ссылка,
	   |		НомерСтроки,
	   |		АдресЭП,
	   |		Вид,
	   |		Город,
	   |		ДоменноеИмяСервера,
	   |		ЗначенияПолей,
	   |		НомерТелефона,
	   |		НомерТелефонаБезКодов,
	   |		Представление,
	   |		Регион,
	   |		Страна,
	   |		Тип
	   |	)
	   |ИЗ
	   |	Справочник.КонтактныеЛица КАК КонтактныеЛица";
	   
	Таблица = Запрос.Выполнить().Выгрузить();
	Для Каждого Строка Из Таблица Цикл
		
		АдресПочты = ПолучитьАдресПочты(Строка.КонтактнаяИнформация);
		Телефон = ПолучитьТелефон(Строка.КонтактнаяИнформация);
		
		АдресПочтыНовый = ПолучитьАдресПочты(Элемент.КонтактнаяИнформация);
		ТелефонНовый = ПолучитьТелефон(Элемент.КонтактнаяИнформация);
		
		Если (АдресПочты = АдресПочтыНовый И ЗначениеЗаполнено(АдресПочты))
			ИЛИ (Телефон = ТелефонНовый И ЗначениеЗаполнено(Телефон)) Тогда
			Возврат Истина;
		КонецЕсли;	
		
	КонецЦикла;	
	
	Возврат Ложь;
	
КонецФункции

Функция ПолучитьАдресПочты(КонтактнаяИнформация)
	
	Для Каждого СтрокаКонтактнойИнформации Из КонтактнаяИнформация Цикл
		Если СтрокаКонтактнойИнформации.Тип = Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты Тогда
			Возврат СтрокаКонтактнойИнформации.АдресЭП;
		КонецЕсли;	
	КонецЦикла;
	
	Возврат "";
	
КонецФункции

Функция ПолучитьТелефон(КонтактнаяИнформация)
	
	Для Каждого СтрокаКонтактнойИнформации Из КонтактнаяИнформация Цикл
		Если СтрокаКонтактнойИнформации.Тип = Перечисления.ТипыКонтактнойИнформации.Телефон Тогда
			Возврат СтрокаКонтактнойИнформации.Представление;
		КонецЕсли;	
	КонецЦикла;
	
	Возврат "";
	
КонецФункции

// Заполнить корреспондента или контактное лицо данными личного адресата и заменить мылки в письмах
Процедура ЗаполнитьКонтактИЗаменитьСсылки(ЛичныйАдресат, Контакт, УникальныйИдентификатор = Неопределено) Экспорт
	
	Если ТипЗнч(Контакт) = Тип("СправочникСсылка.Контрагенты") Тогда
		// Заполним корреспондента
		
		// если Наименование и Ответственный совпадают - считаем что только что создали корреспондента и копировать не надо
		Если Контакт.Наименование <> ЛичныйАдресат.Наименование
			Или Контакт.Ответственный <> ЛичныйАдресат.Пользователь Тогда
			
			ЗаблокироватьДанныеДляРедактирования(Контакт);
			КорреспондентОбъект = Контакт.ПолучитьОбъект();
			
			НеиспользованныеПоля = ЛичныйАдресат.Комментарий;
			
			Для Каждого КонтактИнфоАдресата Из ЛичныйАдресат.КонтактнаяИнформация Цикл
				
				ЕстьПолеТакогоВида = Ложь;
				Для Каждого КонтактИнфоКорреспондента Из КорреспондентОбъект.КонтактнаяИнформация Цикл
					
					Если Строка(КонтактИнфоКорреспондента.Вид) = Строка(КонтактИнфоАдресата.Вид) Тогда
						ЕстьПолеТакогоВида = Истина;
						Прервать;
					КонецЕсли;	
					
				КонецЦикла;	
				
				Если ЕстьПолеТакогоВида = Ложь Тогда
					
					Если КонтактИнфоАдресата.Вид = Справочники.ВидыКонтактнойИнформации.EmailАдресата Тогда
						
						НовСтр = КорреспондентОбъект.КонтактнаяИнформация.Добавить();
						НовСтр.ЗначенияПолей = КонтактИнфоАдресата.ЗначенияПолей;
						НовСтр.АдресЭП = КонтактИнфоАдресата.АдресЭП;
						НовСтр.Представление = КонтактИнфоАдресата.Представление;
						НовСтр.Вид = Справочники.ВидыКонтактнойИнформации.EmailКорреспондента;
						НовСтр.Тип = Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты;
						
					КонецЕсли;	
					
					Если КонтактИнфоАдресата.Вид = Справочники.ВидыКонтактнойИнформации.РабочийТелефонАдресата Тогда
						
						НовСтр = КорреспондентОбъект.КонтактнаяИнформация.Добавить();
						НовСтр.ЗначенияПолей = КонтактИнфоАдресата.ЗначенияПолей;
						НовСтр.Представление = КонтактИнфоАдресата.Представление;
						НовСтр.НомерТелефона = КонтактИнфоАдресата.НомерТелефона;
						НовСтр.НомерТелефонаБезКодов = КонтактИнфоАдресата.НомерТелефонаБезКодов;
						НовСтр.Вид = Справочники.ВидыКонтактнойИнформации.ТелефонКорреспондента;
						НовСтр.Тип = Перечисления.ТипыКонтактнойИнформации.Телефон;
						
					КонецЕсли;	
					
					Если КонтактИнфоАдресата.Вид = Справочники.ВидыКонтактнойИнформации.ПочтовыйАдресАдресата Тогда
						
						НовСтр = КорреспондентОбъект.КонтактнаяИнформация.Добавить();
						НовСтр.ЗначенияПолей = КонтактИнфоАдресата.ЗначенияПолей;
						НовСтр.Представление = КонтактИнфоАдресата.Представление;
						НовСтр.Страна = КонтактИнфоАдресата.Страна;
						НовСтр.Регион = КонтактИнфоАдресата.Регион;
						НовСтр.Город = КонтактИнфоАдресата.Город;
						НовСтр.Вид = Справочники.ВидыКонтактнойИнформации.ПочтовыйАдресКорреспондента;
						НовСтр.Тип = Перечисления.ТипыКонтактнойИнформации.Адрес;
						
					КонецЕсли;	
					
				Иначе	
					
					НеиспользованныеПоля = НеиспользованныеПоля + " "
						+ Строка(КонтактИнфоАдресата.Вид) + ": " + КонтактИнфоАдресата.ЗначенияПолей + 
						" " + КонтактИнфоАдресата.Представление;
					
				КонецЕсли;	
				
			КонецЦикла;	
			
			КорреспондентОбъект.Комментарий = КорреспондентОбъект.Комментарий + " " + НеиспользованныеПоля;
			КорреспондентОбъект.Записать();
			РазблокироватьДанныеДляРедактирования(Контакт);
			
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(Контакт) = Тип("СправочникСсылка.КонтактныеЛица") Тогда	
		// заполним контактное лицо
		
		// если Наименование и Должность совпадают - считаем что только что создали контактное лицо и копировать не надо
		Если Контакт.Наименование <> ЛичныйАдресат.Наименование
			Или Контакт.Должность <> ЛичныйАдресат.Должность Тогда
		
			ЗаблокироватьДанныеДляРедактирования(Контакт);
			КонтактноеЛицоОбъект = Контакт.ПолучитьОбъект();
			
			НеиспользованныеПоля = ЛичныйАдресат.Комментарий;
			
			Для Каждого КонтактИнфоАдресата Из ЛичныйАдресат.КонтактнаяИнформация Цикл
				
				ЕстьПолеТакогоВида = Ложь;
				Для Каждого КонтактИнфоКорреспондента Из КонтактноеЛицоОбъект.КонтактнаяИнформация Цикл
					
					Если Строка(КонтактИнфоКорреспондента.Вид) = Строка(КонтактИнфоАдресата.Вид) Тогда
						ЕстьПолеТакогоВида = Истина;
						Прервать;
					КонецЕсли;	
					
				КонецЦикла;	
				
				Если ЕстьПолеТакогоВида = Ложь Тогда
					
					Если КонтактИнфоАдресата.Вид = Справочники.ВидыКонтактнойИнформации.EmailАдресата Тогда
						
						НовСтр = КонтактноеЛицоОбъект.КонтактнаяИнформация.Добавить();
						НовСтр.ЗначенияПолей = КонтактИнфоАдресата.ЗначенияПолей;
						НовСтр.АдресЭП = КонтактИнфоАдресата.АдресЭП;
						НовСтр.Представление = КонтактИнфоАдресата.Представление;
						НовСтр.Вид = Справочники.ВидыКонтактнойИнформации.EmailКонтактногоЛица;
						НовСтр.Тип = Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты;
						
					КонецЕсли;	
					
					Если КонтактИнфоАдресата.Вид = Справочники.ВидыКонтактнойИнформации.РабочийТелефонАдресата Тогда
						
						НовСтр = КонтактноеЛицоОбъект.КонтактнаяИнформация.Добавить();
						НовСтр.ЗначенияПолей = КонтактИнфоАдресата.ЗначенияПолей;
						НовСтр.Представление = КонтактИнфоАдресата.Представление;
						НовСтр.НомерТелефона = КонтактИнфоАдресата.НомерТелефона;
						НовСтр.НомерТелефонаБезКодов = КонтактИнфоАдресата.НомерТелефонаБезКодов;
						НовСтр.Вид = Справочники.ВидыКонтактнойИнформации.ТелефонКонтактногоЛица;
						НовСтр.Тип = Перечисления.ТипыКонтактнойИнформации.Телефон;
						
					КонецЕсли;	
					
				Иначе	
					
					НеиспользованныеПоля = НеиспользованныеПоля + " "
						+ Строка(КонтактИнфоАдресата.Вид) + ": " + КонтактИнфоАдресата.ЗначенияПолей;
					
				КонецЕсли;	
				
			КонецЦикла;	
			
			КонтактноеЛицоОбъект.Комментарий = КонтактноеЛицоОбъект.Комментарий + " " + НеиспользованныеПоля;
			КонтактноеЛицоОбъект.Записать();
			РазблокироватьДанныеДляРедактирования(Контакт);
			
		КонецЕсли;	
		
	КонецЕсли;	
	
	
	// Найдем учетные записи с одним ответственным - текущим пользователем
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	УчетныеЗаписиЭлектроннойПочтыОтветственныеЗаОбработкуПисем.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.УчетныеЗаписиЭлектроннойПочты.ОтветственныеЗаОбработкуПисем КАК УчетныеЗаписиЭлектроннойПочтыОтветственныеЗаОбработкуПисем
		|ГДЕ
		|	УчетныеЗаписиЭлектроннойПочтыОтветственныеЗаОбработкуПисем.Пользователь = &Пользователь";
		
	Запрос.УстановитьПараметр("Пользователь", Пользователи.ТекущийПользователь());	
	
	УчетныеЗаписи = Новый Массив;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		УчетнаяЗапись = Выборка.Ссылка;
		Если УчетнаяЗапись.ОтветственныеЗаОбработкуПисем.Количество() = 1 Тогда
			УчетныеЗаписи.Добавить(УчетнаяЗапись);
		КонецЕсли;
		
	КонецЦикла;	
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ЭлектроннаяПочта.Ссылка
		|ИЗ
		|	ЖурналДокументов.ЭлектроннаяПочта КАК ЭлектроннаяПочта
		|ГДЕ
		|	ЭлектроннаяПочта.УчетнаяЗапись В(&УчетныеЗаписи)";
		
	Запрос.УстановитьПараметр("ОтветственныйЗаОбработкуПисем", Пользователи.ТекущийПользователь());	
	Запрос.УстановитьПараметр("УчетныеЗаписи", УчетныеЗаписи);	
	
	//Обновление контактов во всех письмах
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		СсылкаНаПисьмо = Выборка.Ссылка;
		ЗаблокироватьДанныеДляРедактирования(СсылкаНаПисьмо);
		ПисьмоОбъект = СсылкаНаПисьмо.ПолучитьОбъект();
		
		Если ВстроеннаяПочтаСервер.ЗаменитьИнформациюОКонтактахВПисьме(ПисьмоОбъект, ЛичныйАдресат, Контакт) Тогда
		
			Если ТипЗнч(ПисьмоОбъект.Ссылка) = Тип("ДокументСсылка.ВходящееПисьмо") 
				И ЗначениеЗаполнено(ПисьмоОбъект.ОтправительКонтакт) Тогда
				
				ПисьмоОбъект.ОтправительОтображаемоеИмя = ВстроеннаяПочтаСервер.ПолучитьПредставлениеАдресата(
					ПисьмоОбъект.ОтправительКонтакт,
					ПисьмоОбъект.ОтправительОтображаемоеИмя,
					ПисьмоОбъект.ОтправительАдрес,
					ПисьмоОбъект.УчетнаяЗапись);
				КонецЕсли;
				
			ПисьмоОбъект.ОбменДанными.Загрузка = Истина;
			ПисьмоОбъект.Записать();
			
		КонецЕсли;
		
		РазблокироватьДанныеДляРедактирования(СсылкаНаПисьмо);
		
	КонецЦикла;
	
	// Пометим на удаление личный адресат
	ПометитьНаУдаление(ЛичныйАдресат, Истина, УникальныйИдентификатор);
	
КонецПроцедуры	

// Пометить на удаление личного адрестаа
Процедура ПометитьНаУдаление(Ссылка, Пометка, УникальныйИдентификатор = Неопределено) Экспорт
	
	ЗаблокироватьДанныеДляРедактирования(Ссылка, , УникальныйИдентификатор);
	СправочникОбъект = Ссылка.ПолучитьОбъект();
	СправочникОбъект.УстановитьПометкуУдаления(Пометка, Истина);
	РазблокироватьДанныеДляРедактирования(Ссылка, УникальныйИдентификатор);
	
КонецПроцедуры

