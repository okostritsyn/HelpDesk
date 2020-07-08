////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Перем ТекстЗаголовкаФормы;
	Если Параметры.Свойство("ЗаголовокФормы", ТекстЗаголовкаФормы) И
		НЕ ПустаяСтрока(ТекстЗаголовкаФормы) Тогда
		Заголовок = ТекстЗаголовкаФормы;
		АвтоЗаголовок = Ложь;
				
	КонецЕсли;
	
	Если Параметры.Свойство("БизнесПроцесс") Тогда
		СтрокаБизнесПроцесса = Параметры.БизнесПроцесс;
		СтрокаЗадачи = Параметры.Задача;
		Элементы.ГруппаЗаголовок.Видимость = Истина;
	КонецЕсли;
	
	Если Параметры.Свойство("ПоказыватьЗадачи") Тогда
		ПоказыватьЗадачи = Параметры.ПоказыватьЗадачи;
	Иначе
		ПоказыватьЗадачи = 2;
	КонецЕсли;
	
	Если Параметры.Свойство("ВидимостьОтборов") Тогда
		Элементы.ГруппаОтбор.Видимость = Параметры.ВидимостьОтборов;
	Иначе	
		ПоАвтору = Пользователи.ТекущийПользователь();
	КонецЕсли;
	УстановитьОтбор();
	
	Если Параметры.Свойство("БлокировкаОкнаВладельца") Тогда
		РежимОткрытияОкна = Параметры.БлокировкаОкнаВладельца;
	КонецЕсли;	
		
	ИспользоватьДатуИВремяВСрокахЗадач = ПолучитьФункциональнуюОпцию("ИспользоватьДатуИВремяВСрокахЗадач");
	Элементы.СрокИсполнения.Формат = ?(ИспользоватьДатуИВремяВСрокахЗадач, "ДЛФ=DT", "ДЛФ=D");
	Элементы.ДатаИсполнения.Формат = ?(ИспользоватьДатуИВремяВСрокахЗадач, "ДЛФ=DT", "ДЛФ=D");
	
	БизнесПроцессыИЗадачиСервер.УстановитьОформлениеЗадач(Список.УсловноеОформление);

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "Запись_ЗадачаИсполнителя" Тогда
		Элементы.Список.Обновить();
 	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПередЗагрузкойДанныхИзНастроекНаСервере(Настройки)

	ИмяНастройки = ?(Параметры.Свойство("БизнесПроцесс"), "ФормаСпискаБП", "ФормаСписка");
	НастройкиОтбора = ОбщегоНазначения.ХранилищеСистемныхНастроекЗагрузить("Задачи.ЗадачаИсполнителя.Формы.ФормаСписка", ИмяНастройки);
	Если НастройкиОтбора = Неопределено Тогда 
		Настройки.Очистить();
		Возврат;
	КонецЕсли;
	
	Для Каждого Элемент Из НастройкиОтбора Цикл
		Настройки.Вставить(Элемент.Ключ, Элемент.Значение);
	КонецЦикла;
	УстановитьОтборСписка(Список, НастройкиОтбора);
	
КонецПроцедуры

&НаСервере
Процедура ПриСохраненииДанныхВНастройкахНаСервере(Настройки)
	ИмяНастроек = ?(Элементы.ГруппаЗаголовок.Видимость, "ФормаСпискаБП", "ФормаСписка");
	ОбщегоНазначения.ХранилищеСистемныхНастроекСохранить("Задачи.ЗадачаИсполнителя.Формы.ФормаСписка", ИмяНастроек, Настройки);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ПоИсполнителюПриИзменении(Элемент)
	УстановитьОтбор();
КонецПроцедуры

&НаКлиенте
Процедура ПоАвторуПриИзменении(Элемент)
	УстановитьОтбор();
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьЗадачиПриИзменении(Элемент)
	УстановитьОтбор();
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ПринятьКИсполнению(Команда)
	
	КомандыРаботыСБизнесПроцессамиКлиент.ПринятьЗадачиКИсполнению(Элементы.Список.ВыделенныеСтроки);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьПринятиеКИсполнению(Команда)
	
	КомандыРаботыСБизнесПроцессамиКлиент.ОтменитьПринятиеЗадачКИсполнению(Элементы.Список.ВыделенныеСтроки);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ Список

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	БизнесПроцессыИЗадачиКлиент.СписокЗадачПередНачаломДобавления(ЭтотОбъект, Элемент, Отказ, Копирование, 
		Родитель, Группа);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	БизнесПроцессыИЗадачиКлиент.СписокЗадачВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	БизнесПроцессыИЗадачиКлиент.СписокЗадачПередНачаломИзменения(Элемент, Отказ);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура УстановитьОтбор()
	ПараметрыОтбора = Новый Соответствие();
	ПараметрыОтбора.Вставить("ПоАвтору", ПоАвтору);
	ПараметрыОтбора.Вставить("ПоИсполнителю", ПоИсполнителю);
	ПараметрыОтбора.Вставить("ПоказыватьЗадачи", ПоказыватьЗадачи);
	УстановитьОтборСписка(Список, ПараметрыОтбора);
КонецПроцедуры	

&НаСервереБезКонтекста
Процедура УстановитьОтборСписка(Список, ПараметрыОтбора)
	
	Если ПараметрыОтбора["ПоАвтору"].Пустая() Тогда
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(Список.Отбор, "Автор");
	Иначе
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
			Список.Отбор, "Автор", ПараметрыОтбора["ПоАвтору"]);
	КонецЕсли;
	
	Если ПараметрыОтбора["ПоИсполнителю"].Пустая() Тогда
		Список.Параметры.УстановитьЗначениеПараметра("Исполнитель", NULL);
	Иначе	
		Список.Параметры.УстановитьЗначениеПараметра("Исполнитель", ПараметрыОтбора["ПоИсполнителю"]);
	КонецЕсли;
		
	ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(Список.Отбор, "Выполнена");
	Если ПараметрыОтбора["ПоказыватьЗадачи"] <> 0 Тогда 
		
		Если ПараметрыОтбора["ПоказыватьЗадачи"] = 1 Тогда
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
				Список.Отбор, "Выполнена", Истина);
		КонецЕсли;
		
		Если ПараметрыОтбора["ПоказыватьЗадачи"] = 2 Тогда
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
				Список.Отбор, "Выполнена", Ложь);
		КонецЕсли;	
	
	КонецЕсли;
	
КонецПроцедуры
