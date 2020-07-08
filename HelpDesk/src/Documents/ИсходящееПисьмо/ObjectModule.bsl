////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Ссылка.Пустая() Тогда
		ПредыдущаяПометкаУдаления = ОбщегоНазначения.ПолучитьЗначениеРеквизита(Ссылка, "ПометкаУдаления");
		Если ПометкаУдаления <> ПредыдущаяПометкаУдаления Тогда 
			РаботаСФайламиВызовСервера.ПометитьНаУдалениеПриложенныеФайлы(Ссылка, ПометкаУдаления);
		КонецЕсли;
	КонецЕсли;
	
	Если ДополнительныеСвойства.Свойство("ТекстПисьма") Тогда
		УстановитьТекстПисьма(ДополнительныеСвойства.ТекстПисьма);
	КонецЕсли;
	
	Если ПометкаУдаления И ЗначениеЗаполнено(ПодготовленоКОтправке) Тогда
		ПодготовленоКОтправке = Дата(1, 1, 1);
		Если Не Ссылка.Пустая() Тогда
			РегистрыСведений.НеОтправленныеИсходящиеПисьма.ОчиститьИнформацию(Ссылка);
		КонецЕсли;
	КонецЕсли;
	
	ВстроеннаяПочтаСервер.ПрименитьПравила(ЭтотОбъект);
	
	Если Не ЗначениеЗаполнено(Папка) Тогда
		ВызватьИсключение НСтр("ru = 'Не указана папка письма'");
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Ссылка) И ПодготовленоКОтправке = Дата(1, 1, 1) Тогда
		РегистрыСведений.НеОтправленныеИсходящиеПисьма.ОчиститьИнформацию(Ссылка);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	СтруктураРеквизитов = СформироватьСтруктуруРеквизитовПисьма(ДанныеЗаполнения);
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, СтруктураРеквизитов);
	Если СтруктураРеквизитов.Свойство("ТекстПисьма") Тогда
		УстановитьТекстПисьма(СтруктураРеквизитов.ТекстПисьма);
	КонецЕсли;
	Если СтруктураРеквизитов.Свойство("ПолучателиПисьма") Тогда
		Для каждого СтруктураАдресата Из СтруктураРеквизитов.ПолучателиПисьма Цикл
			ЗаполнитьЗначенияСвойств(ПолучателиПисьма.Добавить(), СтруктураАдресата);
		КонецЦикла;
	КонецЕсли;
	Если СтруктураРеквизитов.Свойство("ПолучателиКопий") Тогда
		Для каждого СтруктураАдресата Из СтруктураРеквизитов.ПолучателиКопий Цикл
			ЗаполнитьЗначенияСвойств(ПолучателиКопий.Добавить(), СтруктураАдресата);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ЗначениеЗаполнено(ПодготовленоКОтправке) Тогда
		Если Не ЗначениеЗаполнено(УчетнаяЗапись) Тогда
			ВызватьИсключение НСтр("ru = 'Не выбрана учетная запись'");
		КонецЕсли;
		УчетнаяЗаписьИнфо = ОбщегоНазначения.ПолучитьЗначенияРеквизитов(УчетнаяЗапись, "ИспользоватьДляОтправки, ВариантИспользования");
		Если УчетнаяЗаписьИнфо.ВариантИспользования <> Перечисления.ВариантыИспользованияПочты.Встроенная Тогда
			ВызватьИсключение НСтр("ru = 'В учетной записи не установлен признак использования для встроенной почты'");
		КонецЕсли;
		Если Не УчетнаяЗаписьИнфо.ИспользоватьДляОтправки Тогда
			ВызватьИсключение НСтр("ru = 'В учетной записи снят флаг использования для отправки'");
		КонецЕсли;
		
		Для каждого ПолучательИнфо Из ПолучателиПисьма Цикл
			Если Не ЗаполненАдресЭлектроннойПочты(ПолучательИнфо.Адрес) Тогда
				ВызватьИсключение НСтр("ru = 'Не заполнены все адреса электронной почты получателей'");
			КонецЕсли;
		КонецЦикла;
		Для каждого ПолучательИнфо Из ПолучателиКопий Цикл
			Если Не ЗаполненАдресЭлектроннойПочты(ПолучательИнфо.Адрес) Тогда
				ВызватьИсключение НСтр("ru = 'Не заполнены все адреса электронной почты получателей'");
			КонецЕсли;
		КонецЦикла;
		Для каждого ПолучательИнфо Из ПолучателиСкрытыхКопий Цикл
			Если Не ЗаполненАдресЭлектроннойПочты(ПолучательИнфо.Адрес) Тогда
				ВызватьИсключение НСтр("ru = 'Не заполнены все адреса электронной почты получателей'");
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

Функция ЗаполненАдресЭлектроннойПочты(Адрес)
	
	Если Не ЗначениеЗаполнено(Адрес) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если Не РаботаСоСтроками.ЭтоАдресЭлектроннойПочты(Адрес) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции


////////////////////////////////////////////////////////////////////////////////
// ЗАПОЛНЕНИЕ НА ОСНОВАНИИ

// Возвращает структуру реквизитов письма, заполненную по ДаннымЗаполнения.
//
Функция СформироватьСтруктуруРеквизитовПисьма(Знач ДанныеЗаполнения) Экспорт
	
	Результат = Новый Структура;
	
	ТекущийПользователь = Пользователи.ТекущийПользователь();
	
	Результат.Вставить("Дата", ТекущаяДата());
	Результат.Вставить("Автор", ТекущийПользователь);
	Результат.Вставить("Важность", Перечисления.ВажностьПисем.Обычная);
	
	КодировкаИсходящихПисем = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"ВстроеннаяПочта",
		"КодировкаИсходящихПисем",
		"utf-8");
	Результат.Вставить("Кодировка", КодировкаИсходящихПисем);
	
	УчетнаяЗаписьДляОтправки = ВстроеннаяПочтаСервер.ПолучитьУчетнуюЗаписьДляОтправки();
	Если ЗначениеЗаполнено(УчетнаяЗаписьДляОтправки) Тогда
		УчетнаяЗаписьИнфо = ОбщегоНазначения.ПолучитьЗначенияРеквизитов(
			УчетнаяЗаписьДляОтправки,
			"ИмяПользователя, АдресЭлектроннойПочты");
		
		Результат.Вставить("УчетнаяЗапись", УчетнаяЗаписьДляОтправки);
		Результат.Вставить("ОтправительОтображаемоеИмя", УчетнаяЗаписьИнфо.ИмяПользователя);
		Результат.Вставить("ОтправительАдрес", УчетнаяЗаписьИнфо.АдресЭлектроннойПочты);
	КонецЕсли;
	
	Если ДанныеЗаполнения = Неопределено Тогда
		ЗаполнитьСтруктуруРеквизитовНовогоПисьма(Результат);
	КонецЕсли;
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура")
		И ДанныеЗаполнения.Свойство("Команда")
		И ДанныеЗаполнения.Свойство("Письмо")
		И ВстроеннаяПочтаКлиентСервер.ЭтоПисьмо(ДанныеЗаполнения.Письмо) Тогда
		ЗаполнитьСтруктуруРеквизитовПоПисьму(Результат, ДанныеЗаполнения.Письмо, ДанныеЗаполнения.Команда);
	КонецЕсли;
	
	Если ДелопроизводствоКлиентСервер.ЭтоВнутреннийДокумент(ДанныеЗаполнения) Тогда
		ЗаполнитьСтруктуруРеквизитовПоВнутреннемуДокументу(Результат, ДанныеЗаполнения);
	КонецЕсли;
	
	Если ДелопроизводствоКлиентСервер.ЭтоВходящийДокумент(ДанныеЗаполнения) Тогда
		ЗаполнитьСтруктуруРеквизитовПоВходящемуДокументу(Результат, ДанныеЗаполнения);
	КонецЕсли;
	
	Если ДелопроизводствоКлиентСервер.ЭтоИсходящийДокумент(ДанныеЗаполнения) Тогда
		ЗаполнитьСтруктуруРеквизитовПоИсходящемуДокументу(Результат, ДанныеЗаполнения);
	КонецЕсли;
	
	Если ДелопроизводствоКлиентСервер.ЭтоПроект(ДанныеЗаполнения) Тогда
		ЗаполнитьСтруктуруРеквизитовПоПроекту(Результат, ДанныеЗаполнения);
	КонецЕсли;
	
	Если ДелопроизводствоКлиентСервер.ЭтоПроектнаяЗадача(ДанныеЗаполнения) Тогда
		ЗаполнитьСтруктуруРеквизитовПоПроектнойЗадаче(Результат, ДанныеЗаполнения);
	КонецЕсли;
		
	Если ДелопроизводствоКлиентСервер.ЭтоЗадачаИсполнителя(ДанныеЗаполнения) Тогда
		ЗаполнитьСтруктуруРеквизитовПоЗадачеИсполнителя(Результат, ДанныеЗаполнения);
	КонецЕсли;
	
	Если ДелопроизводствоКлиентСервер.ЭтоФайл(ДанныеЗаполнения) Тогда
		ЗаполнитьСтруктуруРеквизитовПоФайлу(Результат, ДанныеЗаполнения);
	КонецЕсли;
	
	Если ДелопроизводствоКлиентСервер.ЭтоКорреспондент(ДанныеЗаполнения) Тогда
		ЗаполнитьСтруктуруРеквизитовПоКорреспонденту(Результат, ДанныеЗаполнения);
	КонецЕсли;
	
	Если РаботаСЗаявками.Этозаявка(ДанныеЗаполнения) Тогда
		ЗаполнитьСтруктуруРеквизитовПоЗаявке(Результат, ДанныеЗаполнения);
	КонецЕсли;
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура")
		И ДанныеЗаполнения.Свойство("Команда")
		И ДанныеЗаполнения.Свойство("Письмо")
		И РаботаСЗаявками.Этозаявка(ДанныеЗаполнения.Письмо) Тогда
		ЗаполнитьСтруктуруРеквизитовПоЗаявке(Результат, ДанныеЗаполнения.Письмо);
	КонецЕсли;
	
	Если Результат.Свойство("ПолучателиПисьма") И Результат.ПолучателиПисьма.Количество() > 0 Тогда
		ПолучателиСтрокой = ВстроеннаяПочтаСервер.ТаблицаПолучателейВСтроку(Результат.ПолучателиПисьма, Результат.УчетнаяЗапись);
		Результат.Вставить("ПолучателиПисьмаСтрокой", ПолучателиСтрокой);
	Иначе
		Результат.Вставить("ПолучателиПисьмаСтрокой", "");
	КонецЕсли;
	
	Если Не Результат.Свойство("Проект") Или Не ЗначениеЗаполнено(Результат.Проект) Тогда 
		Результат.Вставить("Проект", РаботаСПроектами.ПолучитьПроектПоУмолчанию());
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Процедура ЗаполнитьСтруктуруРеквизитовНовогоПисьма(СтруктураРеквизитов)
	
	ПодписьДляНовыхПисем =
		ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
			"ВстроеннаяПочта",
			"ПодписьДляНовыхПисем",
			Неопределено);
	
	Если ТипЗнч(ПодписьДляНовыхПисем) = Тип("СправочникСсылка.ПодписиПисемПользователей")
		И ЗначениеЗаполнено(ПодписьДляНовыхПисем) Тогда
		Подпись = Символы.ПС + ПодписьДляНовыхПисем.Подпись;
	Иначе
		Подпись = Символы.ПС;
	КонецЕсли;
	
	СтруктураРеквизитов.Вставить("ТекстПисьма", Подпись);
	
КонецПроцедуры

Процедура ЗаполнитьСтруктуруРеквизитовПоПисьму(СтруктураРеквизитов, Знач Письмо, Знач Команда)
	
	Если Команда = "ОтветитьВсем" Тогда
		ПеренестиОтправителяВПолучатели = Истина;
		ПеренестиВсехПолучателейВПолучатели = Истина;
		ДобавитьПриставкуКТеме = НСтр("ru = 'Ответ на: '");
	ИначеЕсли Команда = "Ответить" Тогда
		ПеренестиОтправителяВПолучатели = Истина;
		ПеренестиВсехПолучателейВПолучатели = Ложь;
		ДобавитьПриставкуКТеме = НСтр("ru = 'Ответ на: '");
	ИначеЕсли Команда = "Переслать" Тогда
		ПеренестиОтправителяВПолучатели = Ложь;
		ПеренестиВсехПолучателейВПолучатели = Ложь;
		ДобавитьПриставкуКТеме = НСтр("ru = 'Пересылка: '");
	Иначе
		ВызватьИсключение НСтр("ru = 'Некорректная команда работы с письмом'");
	КонецЕсли;
	
	ПисьмоИнфо = Неопределено;
	Если ВстроеннаяПочтаКлиентСервер.ЭтоВходящееПисьмо(Письмо) Тогда
		ПисьмоИнфо = ОбщегоНазначения.ПолучитьЗначенияРеквизитов(
			Письмо,
			"Ссылка,
			|Кодировка,
			|Предмет,
			|Проект,
			|Тема,
			|УчетнаяЗапись,
			|ОтправительАдрес,
			|ОтправительКонтакт,
			|ОтправительОтображаемоеИмя");
		ДанныеУчетнойЗаписи = Почта.ПолучитьДанныеУчетнойЗаписи(ПисьмоИнфо.УчетнаяЗапись);
	ИначеЕсли ВстроеннаяПочтаКлиентСервер.ЭтоИсходящееПисьмо(Письмо) Тогда
		ПисьмоИнфо = ОбщегоНазначения.ПолучитьЗначенияРеквизитов(
			Письмо,
			"Ссылка,
			|Кодировка,
			|Предмет,
			|Проект,
			|Тема,
			|УчетнаяЗапись,
			|ОтправительКонтакт");
		ДанныеУчетнойЗаписи = Почта.ПолучитьДанныеУчетнойЗаписи(ПисьмоИнфо.УчетнаяЗапись);
		ПисьмоИнфо.Вставить("ОтправительАдрес", ДанныеУчетнойЗаписи.АдресЭлектроннойПочты);
		ПисьмоИнфо.Вставить("ОтправительОтображаемоеИмя", ДанныеУчетнойЗаписи.ОтображаемоеИмя);
	КонецЕсли;
	
	СтруктураРеквизитов.Вставить("Кодировка", ПисьмоИнфо.Кодировка);
	СтруктураРеквизитов.Вставить("Предмет", ПисьмоИнфо.Предмет);
	СтруктураРеквизитов.Вставить("Проект", ПисьмоИнфо.Проект);
	
	СтруктураРеквизитов.Вставить("Тема", ДобавитьПриставкуКТеме + ПисьмоИнфо.Тема);
	СтруктураРеквизитов.Вставить("УчетнаяЗапись", ПисьмоИнфо.УчетнаяЗапись);
	
	СтруктураРеквизитов.Вставить("ОтправительОтображаемоеИмя", ПисьмоИнфо.ОтправительОтображаемоеИмя);
	СтруктураРеквизитов.Вставить("ОтправительАдрес", ПисьмоИнфо.ОтправительАдрес);
	
	СтруктураРеквизитов.Вставить("ПолучателиПисьма", Новый Массив);
	СтруктураРеквизитов.Вставить("ПолучателиКопий", Новый Массив);
	
	АдресаПолучателей = Новый Массив; // Массив для контроля уникальности адресов получателей.
	Если ПеренестиОтправителяВПолучатели Тогда
		СтруктураАдресата = Новый Структура;
		СтруктураАдресата.Вставить("Адрес", ПисьмоИнфо.ОтправительАдрес);
		СтруктураАдресата.Вставить("Контакт", ПисьмоИнфо.ОтправительКонтакт);
		СтруктураАдресата.Вставить("ОтображаемоеИмя", ПисьмоИнфо.ОтправительОтображаемоеИмя);
		СтруктураРеквизитов.ПолучателиПисьма.Добавить(СтруктураАдресата);
		АдресаПолучателей.Добавить(НРег(ПисьмоИнфо.ОтправительАдрес));
	КонецЕсли;
	
	Если ПеренестиВсехПолучателейВПолучатели Тогда
		АдресУчетнойЗаписи = ПисьмоИнфо.УчетнаяЗапись.АдресЭлектроннойПочты;
		Для каждого Адресат Из Письмо.ПолучателиПисьма Цикл
			Если НРег(Адресат.Адрес) <> НРег(АдресУчетнойЗаписи)
				И АдресаПолучателей.Найти(НРег(Адресат.Адрес)) = Неопределено Тогда
				СтруктураАдресата = Новый Структура;
				СтруктураАдресата.Вставить("Адрес", Адресат.Адрес);
				СтруктураАдресата.Вставить("Контакт", Адресат.Контакт);
				СтруктураАдресата.Вставить("ОтображаемоеИмя", Адресат.ОтображаемоеИмя);
				СтруктураРеквизитов.ПолучателиПисьма.Добавить(СтруктураАдресата);
			КонецЕсли;
		КонецЦикла;
		Для каждого Адресат Из Письмо.ПолучателиКопий Цикл
			Если НРег(Адресат.Адрес) <> НРег(АдресУчетнойЗаписи)
				И АдресаПолучателей.Найти(НРег(Адресат.Адрес)) = Неопределено Тогда
				СтруктураАдресата = Новый Структура;
				СтруктураАдресата.Вставить("Адрес", Адресат.Адрес);
				СтруктураАдресата.Вставить("Контакт", Адресат.Контакт);
				СтруктураАдресата.Вставить("ОтображаемоеИмя", Адресат.ОтображаемоеИмя);
				СтруктураРеквизитов.ПолучателиКопий.Добавить(СтруктураАдресата);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	ТекстПисьма = "";
	ДобавитьПодписьПриОтветеИПересылке(ТекстПисьма);
	
	ВставлятьТекстИсходногоПисьмаПриОтвете = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"ВстроеннаяПочта",
		"ВставлятьТекстИсходногоПисьмаПриОтвете",
		Истина);
	Если ВставлятьТекстИсходногоПисьмаПриОтвете Тогда
		ДобавитьТекстИсходногоПисьма(ТекстПисьма, Письмо, "> ");
	КонецЕсли;
	
	СтруктураРеквизитов.Вставить("ТекстПисьма", ТекстПисьма);
	
КонецПроцедуры

Процедура ДобавитьТекстИсходногоПисьма(ТекстПисьма, ИсходноеПисьмо, Знач СимволКвотирования = Неопределено)
	
	ТелоИсходногоПисьма = ВстроеннаяПочтаСервер.СформироватьПростойТекстДляПисьма(ИсходноеПисьмо);
	Если ЗначениеЗаполнено(СимволКвотирования) Тогда
		РаботаСоСтроками.ДобавитьКвотирование(ТелоИсходногоПисьма, СимволКвотирования);
	КонецЕсли;
	
	ТекстИсходногоПисьма = ВстроеннаяПочтаСервер.СформироватьШапкуПисьмаПростойТекст(ИсходноеПисьмо);
	ДобавитьЗначениеКСтрокеЧерезРазделитель(
		ТекстИсходногоПисьма,
		Символы.ПС,
		ТелоИсходногоПисьма);
	
	ДобавитьЗначениеКСтрокеЧерезРазделитель(
		ТекстПисьма,
		Символы.ПС,
		ТекстИсходногоПисьма);
	
КонецПроцедуры

Процедура ЗаполнитьСтруктуруРеквизитовПоВнутреннемуДокументу(СтруктураРеквизитов, Знач Документ)
	
	ДокументИнфо = ОбщегоНазначения.ПолучитьЗначенияРеквизитов(Документ, "Заголовок, Содержание, Проект");
	
	ТекстПисьма = ДокументИнфо.Содержание;
	ДобавитьПодписьДляНовыхПисем(ТекстПисьма);
	
	СтруктураРеквизитов.Вставить("Тема", ДокументИнфо.Заголовок);
	СтруктураРеквизитов.Вставить("ТекстПисьма", ТекстПисьма);
	СтруктураРеквизитов.Вставить("Проект", ДокументИнфо.Проект);
	СтруктураРеквизитов.Вставить("Предмет", Документ);
	
КонецПроцедуры

Процедура ЗаполнитьСтруктуруРеквизитовПоВходящемуДокументу(СтруктураРеквизитов, Знач Документ)
	
	ДокументИнфо = ОбщегоНазначения.ПолучитьЗначенияРеквизитов(Документ, "Заголовок, Содержание, Подписал, Проект");
	
	ТекстПисьма = ДокументИнфо.Содержание;
	ДобавитьПодписьПриОтветеИПересылке(ТекстПисьма);
	
	СтруктураРеквизитов.Вставить("Тема", ДокументИнфо.Заголовок);
	СтруктураРеквизитов.Вставить("ТекстПисьма", ТекстПисьма);
	СтруктураРеквизитов.Вставить("ПолучателиПисьма", Новый Массив);
	СтруктураРеквизитов.Вставить("Проект", ДокументИнфо.Проект);
	СтруктураРеквизитов.Вставить("Предмет", Неопределено);
	
	Если ЗначениеЗаполнено(ДокументИнфо.Подписал) Тогда
		АдресатАдрес = ПолучитьАдресКорреспондентаИлиКонтактногоЛица(ДокументИнфо.Подписал);
		Если ЗначениеЗаполнено(АдресатАдрес) Тогда
			АдресатКонтакт = ДокументИнфо.Подписал;
			АдресатПредставление = Строка(ДокументИнфо.Подписал);
			
			СтруктураАдресата = Новый Структура;
			СтруктураАдресата.Вставить("Адрес", АдресатАдрес);
			СтруктураАдресата.Вставить("Контакт", АдресатКонтакт);
			СтруктураАдресата.Вставить("ОтображаемоеИмя", АдресатПредставление);
			СтруктураРеквизитов.ПолучателиПисьма.Добавить(СтруктураАдресата);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьСтруктуруРеквизитовПоИсходящемуДокументу(СтруктураРеквизитов, Знач Документ)
	
	ДокументИнфо = ОбщегоНазначения.ПолучитьЗначенияРеквизитов(Документ, "Заголовок, Содержание, Проект");
	
	ТекстПисьма = ДокументИнфо.Содержание;
	ДобавитьПодписьДляНовыхПисем(ТекстПисьма);
	
	СтруктураРеквизитов.Вставить("Тема", ДокументИнфо.Заголовок);
	СтруктураРеквизитов.Вставить("ТекстПисьма", ТекстПисьма);
	СтруктураРеквизитов.Вставить("ПолучателиПисьма", Новый Массив);
	СтруктураРеквизитов.Вставить("Проект", ДокументИнфо.Проект);
	СтруктураРеквизитов.Вставить("Предмет", Неопределено);
	
	Для каждого ПолучателиСтрока Из Документ.Получатели Цикл
		Корреспондент = ПолучателиСтрока.Получатель;
		Если ЗначениеЗаполнено(Корреспондент) Тогда
			Адресат = ПолучателиСтрока.Адресат;
			СтруктураАдресата = Новый Структура;
			СтруктураАдресата.Вставить("Адрес", ПолучитьАдресКорреспондентаИлиКонтактногоЛица(Адресат));
			СтруктураАдресата.Вставить("Контакт", Адресат);
			СтруктураАдресата.Вставить("ОтображаемоеИмя", Строка(Корреспондент));
			Если Не ЗначениеЗаполнено(СтруктураАдресата.Адрес) Тогда
				СтруктураАдресата.Адрес = ПолучитьАдресКорреспондентаИлиКонтактногоЛица(Корреспондент);
				СтруктураАдресата.Контакт = Корреспондент;
			КонецЕсли;
			Если ЗначениеЗаполнено(СтруктураАдресата.Адрес) Тогда
				СтруктураРеквизитов.ПолучателиПисьма.Добавить(СтруктураАдресата);
			КонецЕсли;	
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьСтруктуруРеквизитовПоПроекту(СтруктураРеквизитов, Знач Проект)
	
	ПроектИнфо = ОбщегоНазначения.ПолучитьЗначенияРеквизитов(Проект, "Наименование, Описание");
	
	ТекстПисьма = ПроектИнфо.Описание;
	ДобавитьПодписьДляНовыхПисем(ТекстПисьма);
	
	СтруктураРеквизитов.Вставить("Тема", ПроектИнфо.Наименование);
	СтруктураРеквизитов.Вставить("ТекстПисьма", ТекстПисьма);
	СтруктураРеквизитов.Вставить("Проект", Проект);
	СтруктураРеквизитов.Вставить("Предмет", Проект);
	
КонецПроцедуры

Процедура ЗаполнитьСтруктуруРеквизитовПоФайлу(СтруктураРеквизитов, Знач Файл)
	
	ФайлИнфо = ОбщегоНазначения.ПолучитьЗначенияРеквизитов(Файл, "Наименование, Описание, Проект");
	
	ТекстПисьма = ФайлИнфо.Описание;
	ДобавитьПодписьДляНовыхПисем(ТекстПисьма);
	
	СтруктураРеквизитов.Вставить("Тема", ФайлИнфо.Наименование);
	СтруктураРеквизитов.Вставить("ТекстПисьма", ТекстПисьма);
	СтруктураРеквизитов.Вставить("Проект", ФайлИнфо.Проект);
	
КонецПроцедуры

Процедура ЗаполнитьСтруктуруРеквизитовПоПроектнойЗадаче(СтруктураРеквизитов, Знач ПроектнаяЗадача)
	
	ПроектнаяЗадачаИнфо = ОбщегоНазначения.ПолучитьЗначенияРеквизитов(ПроектнаяЗадача, "Наименование, Описание, Владелец");
	
	ТекстПисьма = ПроектнаяЗадачаИнфо.Описание;
	ДобавитьПодписьДляНовыхПисем(ТекстПисьма);
	
	СтруктураРеквизитов.Вставить("Тема", ПроектнаяЗадачаИнфо.Наименование);
	СтруктураРеквизитов.Вставить("ТекстПисьма", ТекстПисьма);
	СтруктураРеквизитов.Вставить("ПолучателиПисьма", Новый Массив);
	СтруктураРеквизитов.Вставить("Проект", ПроектнаяЗадачаИнфо.Владелец);
	СтруктураРеквизитов.Вставить("Предмет", ПроектнаяЗадача);
	
	Для Каждого ИсполнительСтрока Из ПроектнаяЗадача.Исполнители Цикл
		Корреспондент = ИсполнительСтрока.Исполнитель;
		Если ЗначениеЗаполнено(Корреспондент) И ТипЗнч(Корреспондент) = Тип("СправочникСсылка.Пользователи") Тогда
			Адрес = ПолучитьАдресКорреспондентаИлиКонтактногоЛица(Корреспондент);
			Если ЗначениеЗаполнено(Адрес) Тогда
				СтруктураАдресата = Новый Структура;
				СтруктураАдресата.Вставить("Адрес", Адрес);
				СтруктураАдресата.Вставить("Контакт", Корреспондент);
				СтруктураАдресата.Вставить("ОтображаемоеИмя", Строка(Корреспондент));
				СтруктураРеквизитов.ПолучателиПисьма.Добавить(СтруктураАдресата);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьСтруктуруРеквизитовПоЗадачеИсполнителя(СтруктураРеквизитов, Знач ЗадачаИсполнителя)
	
	ЗадачаИсполнителяИнфо = ОбщегоНазначения.ПолучитьЗначенияРеквизитов(ЗадачаИсполнителя, "Наименование, Описание, Проект");
	
	ТекстПисьма = ЗадачаИсполнителяИнфо.Описание;
	ДобавитьПодписьДляНовыхПисем(ТекстПисьма);
	
	СтруктураРеквизитов.Вставить("Тема", ЗадачаИсполнителяИнфо.Наименование);
	СтруктураРеквизитов.Вставить("ТекстПисьма", ТекстПисьма);
	СтруктураРеквизитов.Вставить("Проект", ЗадачаИсполнителяИнфо.Проект);
	СтруктураРеквизитов.Вставить("Предмет", ЗадачаИсполнителя);
	
КонецПроцедуры

Процедура ЗаполнитьСтруктуруРеквизитовПоКорреспонденту(СтруктураРеквизитов, Знач Сообщение)
	
	ТекстПисьма = "";
	ДобавитьПодписьДляНовыхПисем(ТекстПисьма);
	
	СтруктураРеквизитов.Вставить("ТекстПисьма", ТекстПисьма);
	
КонецПроцедуры

 Процедура ЗаполнитьСтруктуруРеквизитовПоЗаявке(СтруктураРеквизитов, Знач Документ)
	 
	ДокументИнфо = ОбщегоНазначения.ПолучитьЗначенияРеквизитов(Документ, "Контрагент, ОписаниеЗаявки, Проект");
	
	ТекстПисьма = СформироватьТекстПисьмаНаОснованииЗаявки(Документ);
	
	ДобавитьПодписьПриОтветеИПересылке(ТекстПисьма);
	
	Заголовок = СформироватьТемуПисьмаНаОснованииЗаявки(Документ);
	
	СтруктураРеквизитов.Вставить("Тема",Заголовок);
	СтруктураРеквизитов.Вставить("ТекстПисьма", ТекстПисьма);
	СтруктураРеквизитов.Вставить("ПолучателиКопий", Новый Массив);
	СтруктураРеквизитов.Вставить("ПолучателиПисьма", Новый Массив);
	СтруктураРеквизитов.Вставить("Проект", ДокументИнфо.Проект);
	СтруктураРеквизитов.Вставить("Предмет", Документ);
	Если ЗначениеЗаполнено(ДокументИнфо.Контрагент.УчетнаяЗаписьДляОповещений) Тогда
		СтруктураРеквизитов.Вставить("УчетнаяЗапись", ДокументИнфо.Контрагент.УчетнаяЗаписьДляОповещений);
	КонецЕсли;
	//Если ЗначениеЗаполнено(ДокументИнфо.Контрагент) Тогда
	//	АдресатАдрес = ПолучитьАдресКорреспондентаИлиКонтактногоЛица(ДокументИнфо.Контрагент);
	//	Если ЗначениеЗаполнено(АдресатАдрес) Тогда
	//		АдресатКонтакт = ДокументИнфо.Контрагент;
	//		АдресатПредставление = Строка(ДокументИнфо.Контрагент);
	//		
	//		СтруктураАдресата = Новый Структура;
	//		СтруктураАдресата.Вставить("Адрес", АдресатАдрес);
	//		СтруктураАдресата.Вставить("Контакт", АдресатКонтакт);
	//		СтруктураАдресата.Вставить("ОтображаемоеИмя", АдресатПредставление);
	//		СтруктураРеквизитов.ПолучателиПисьма.Добавить(СтруктураАдресата);
	//	КонецЕсли;
	//КонецЕсли;	
	
	//Отправляем постановщику
	Получатель = Документ.Постановщик;
	Если ЗначениеЗаполнено(Получатель) Тогда
		АдресПолучателя = РаботаСЗаявкамиИПочтой.ПолучитьАдресПользователя(Получатель);
		Если ЗначениеЗаполнено(АдресПолучателя) Тогда
			СтруктураАдресата = Новый Структура;
			СтруктураАдресата.Вставить("Адрес", АдресПолучателя);
			СтруктураАдресата.Вставить("Контакт", Получатель);
			СтруктураАдресата.Вставить("ОтображаемоеИмя", Получатель.Наименование);
			СтруктураРеквизитов.ПолучателиПисьма.Добавить(СтруктураАдресата);
		КонецЕсли;
	КонецЕсли;

	//Добавим данные подписчиков
	ТаблицаПодписчиков = РаботаСЗаявкамиИПочтой.ПолучитьТаблицуПодписчиков(Документ);
	Для Каждого Стр Из ТаблицаПодписчиков Цикл
		Получатель = Стр.Пользователь;
		Если ЗначениеЗаполнено(Получатель) Тогда
			АдресПодписчика = РаботаСЗаявкамиИПочтой.ПолучитьАдресПользователя(Получатель);
			Если ЗначениеЗаполнено(АдресПодписчика) Тогда
				СтруктураАдресата = Новый Структура;
				СтруктураАдресата.Вставить("Адрес", АдресПодписчика);
				СтруктураАдресата.Вставить("Контакт", Получатель);
				СтруктураАдресата.Вставить("ОтображаемоеИмя", Получатель.Наименование);
				СтруктураРеквизитов.ПолучателиКопий.Добавить(СтруктураАдресата);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

Функция СформироватьТекстПисьмаНаОснованииЗаявки(Заявка)
	Если Не РаботаСЗаявками.Этозаявка(Заявка) Тогда
		Возврат "";
	КонецЕсли;
	
	Возврат "";
	
КонецФункции

Функция СформироватьТемуПисьмаНаОснованииЗаявки(Заявка)
	Если Не РаботаСЗаявками.Этозаявка(Заявка) Тогда
		Возврат "";
	КонецЕсли;
    Возврат "Заявка "+Заявка.Номер+" от "+Формат(Заявка.Дата,"ДФ=dd.MM.yyyy")+" "+Заявка.Тема;
КонецФункции	
 
////////////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ

Функция ПолучитьАдресКорреспондентаИлиКонтактногоЛица(Корреспондент)
	
	ТаблицаКонтактов = УправлениеКонтактнойИнформацией.ЗначенияКонтактнойИнформацииОбъекта(
		Корреспондент,
		Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты);
		
	Если ТаблицаКонтактов.Количество() > 0 Тогда
		Возврат ТаблицаКонтактов[0].Значение;
	КонецЕсли;
	
	Возврат "";
	
КонецФункции

Процедура ДобавитьПодписьДляНовыхПисем(ТекстПисьма)
	
	ПодписьДляНовыхПисем =
		ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
			"ВстроеннаяПочта",
			"ПодписьДляНовыхПисем",
			Неопределено);
	Подпись = "";
	Если ТипЗнч(ПодписьДляНовыхПисем) = Тип("СправочникСсылка.ПодписиПисемПользователей")
		И ЗначениеЗаполнено(ПодписьДляНовыхПисем) Тогда
		Подпись = ПодписьДляНовыхПисем.Подпись;
	КонецЕсли;
	
	ДобавитьЗначениеКСтрокеЧерезРазделитель(
		ТекстПисьма,
		Символы.ПС,
		Подпись);
	
КонецПроцедуры

Процедура ДобавитьПодписьПриОтветеИПересылке(ТекстПисьма)
	
	ПодписьПриОтветеИПересылке =
		ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
			"ВстроеннаяПочта",
			"ПодписьПриОтветеИПересылке",
			Неопределено);
	Подпись = "";
	Если ТипЗнч(ПодписьПриОтветеИПересылке) = Тип("СправочникСсылка.ПодписиПисемПользователей")
		И ЗначениеЗаполнено(ПодписьПриОтветеИПересылке) Тогда
		Подпись = ПодписьПриОтветеИПересылке.Подпись;
	КонецЕсли;
	
	ДобавитьЗначениеКСтрокеЧерезРазделитель(
		ТекстПисьма,
		Символы.ПС,
		Подпись);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// РАСБОТА С ТЕКСТОМ ПИСЬМА

// Устанавливает текст письма.
//
Процедура УстановитьТекстПисьма(Текст) Экспорт
	
	ТекстХранилище = Новый ХранилищеЗначения(Текст, Новый СжатиеДанных);
	
КонецПроцедуры

Функция ПолучитьСтруктуруТекстаПисьма() Экспорт
	
	ТекстПисьма = ТекстХранилище.Получить();
	Если ТекстПисьма = Неопределено Тогда
		ТекстПисьма = "";
	КонецЕсли;
	
	Результат = Новый Структура;
	//Результат.Вставить("ТипТекста", Перечисления.ТипыТекстовПочтовыхСообщений.ПростойТекст);
	Если ЗначениеЗаполнено(ТипТекста) Тогда
		Результат.Вставить("ТипТекста", ТипТекста);
	Иначе
		Результат.Вставить("ТипТекста", Перечисления.ТипыТекстовПочтовыхСообщений.ПростойТекст);
	КонецЕсли;

	Результат.Вставить("ПростойТекст", ТекстПисьма);
	Результат.Вставить("Текст",ТекстПисьма);
	Результат.Вставить("Кодировка", Кодировка);
	
	Возврат Результат;
	
КонецФункции

Функция СформироватьИсходящееHTML(Текст) Экспорт
	//Получим ДокументHTML входящего письма
	ДокументHTML = РаботаСHTML.ПолучитьДокументHTMLИзОбычногоТекста(Текст);
	
	ЭлементТелоПисьма = ДокументHTML.Тело;
	Если ЭлементТелоПисьма = Неопределено Тогда
		Возврат Текст;
	КонецЕсли;
		
	Возврат РаботаСHTML.ПолучитьТекстHTMLИзОбъектаДокументHTML(ДокументHTML);
КонецФункции