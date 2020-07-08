&НаКлиенте
Перем РаботаВВебКлиенте;

&НаКлиенте
Перем мТекстЗаявки;

&НаСервере
Функция СохранитьДополнениеСервер()
	Возврат ПеренестиДанныеДополненияВХранилище(ЭтотОбъект);
КонецФункции

&НаКлиенте
Процедура ЗакрытьФорму(Команда)
	СохранитьДанныеИзакрыть();
КонецПроцедуры

&НаКлиенте
Процедура  СохранитьДанныеИзакрыть()
	ТекстHTML = Элементы.ПолеHTMLДокумента.Документ.body.InnerHTML;
	ПропарситьСсылкиИзHTML(ТекстHTML);
	
	Для Каждого Стр Из ТаблицаВложений Цикл
		ТекстHTML = СтрЗаменить(ТекстHTML,?(ЗначениеЗаполнено(Стр.ИмяЛокальногоФайла),Стр.ИмяЛокальногоФайла,Стр.Адрес),Стр.Ключ);
	КонецЦикла;

	ЭтотОбъект.ТекстДополненияHTML = ТекстHTML;
	
	АдресХранилища = СохранитьДополнениеСервер();
	
	ЭтотОбъект.Модифицированность  = Ложь;
	ЭтотОбъект.Закрыть(АдресХранилища);
КонецПроцедуры

&НаСервере
Функция ПеренестиДанныеДополненияВХранилище(ЭтотОбъект) Экспорт
	СтруктураДополнения = Новый Структура();
	СтруктураДополнения.Вставить("ТекстHTML",ЭтотОбъект.ТекстДополненияHTML);
	СтруктураДополнения.Вставить("ТаблицаВложений",ЭтотОбъект.ТаблицаВложений);	
	АдресВложения = ПоместитьВоВременноеХранилище (СтруктураДополнения,ИдФормыРодителя);
	Возврат АдресВложения;
КонецФункции

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	РаботаВВебКлиенте = ТипЗнч(Элементы.ПолеHTMLДокумента.Документ) = Тип("ВнешнийОбъект") ИЛИ Элементы.ПолеHTMLДокумента.Документ = неопределено;
	
	Если Не РаботаВВебКлиенте Тогда
		//Готовим список заголовков
		Список = Элементы.КомандаformatBlock.СписокВыбора;
		Список.Добавить("<p>", "Обычный");
		Список.Добавить("<h1>", "Заголовок 1");
		Список.Добавить("<h2>", "Заголовок 2");
		Список.Добавить("<h3>", "Заголовок 3");
		Список.Добавить("<h4>", "Заголовок 4");
		Список.Добавить("<h5>", "Заголовок 5");
		Список.Добавить("<h6>", "Заголовок 6");
		Список.Добавить("<pre>", "Форматированный");
		Список.Добавить("<address>", "Адрес");
		ТекЭлемент = Список.НайтиПоИдентификатору(0);
		СтилиТекста = ТекЭлемент.Значение;
		
		// Заполнение списка шрифтов
		Список = Элементы.КомандаFontName.СписокВыбора;
		Список.Добавить("Arial");
		Список.Добавить("Arial Black");
		Список.Добавить("Arial Narrow");
		Список.Добавить("Comic Sans MS");
		Список.Добавить("Courier New");
		Список.Добавить("System");
		Список.Добавить("Tahoma");
		Список.Добавить("Times New Roman");
		Список.Добавить("Verdana");
		Список.Добавить("Wingdings");
		ТекЭлемент = Список.НайтиПоИдентификатору(0);
		ИмяШрифта = ТекЭлемент.Значение;
		
		// Заполнение списка размеров
		Список = Элементы.КомандаFontSize.СписокВыбора;
		Для Ном = 1 По 14 Цикл
			Список.Добавить(Ном);
		КонецЦикла;
		//Добавим текущий размер шрифта документа
		Текшрифт = Элементы.ПолеHTMLДокумента.Документ.body.currentStyle().fontFamily;
		Если Список.НайтиПоЗначению(Текшрифт) = Неопределено Тогда
			Список.Добавить(Текшрифт);
		КонецЕсли;
		ТекЭлемент = Список.НайтиПоИдентификатору(2);
		РазмерыШрифта = ТекЭлемент.Значение;
	КонецЕсли;

	Если ЗначениеЗаполнено(АдресВходящихДанных) Тогда
		ПрочитатьВходящийТекстHTML(АдресВходящихДанных);
		
		РаботаСHTML.ПередатьОбъектыСтраницыНаКлиента(ТекстДополненияHTML,ТаблицаВложений);
	КонецЕсли;
	
	УстановитьВидимость();

КонецПроцедуры

/////////////////////////////////////////////////////////////////////////////////
//Обработчики командной панели редактора HTML

/////////////////////////////////////////////////////////////////////////////////
//Обработчики командной панели редактора HTML

&НаКлиенте
Процедура ПолеHTMLДокументаПриИзменении(Элемент)
	ЭтаФорма.Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьКомандуСписка(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	Если Элементы.ПолеHTMLДокумента.Документ = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекВыделение = Элементы.ПолеHTMLДокумента.Документ.selection;
	Если ТекВыделение = Неопределено Тогда
		Возврат;
	Иначе
		УзелЭлемента = ТекВыделение.createRange();
	КонецЕсли;
		
	Команда = Сред(Элемент.Имя, 8);
	Если УзелЭлемента.queryCommandSupported(Команда) Тогда
		УзелЭлемента.execCommand(Команда, Истина, ВыбранноеЗначение);
		ПоказатьРежимыКнопок();
	КонецЕсли;
	ЭтотОбъект.ТекущийЭлемент = Элементы.ПолеHTMLДокумента;
	ЭтотОбъект.Модифицированность = ИСтина;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьКоманду(Кнопка)
	Если Элементы.ПолеHTMLДокумента.Документ = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекВыделение = Элементы.ПолеHTMLДокумента.Документ.selection;
		
	Если ТекВыделение = Неопределено Тогда
		Возврат;
	Иначе
		УзелЭлемента = ТекВыделение.createRange();
	КонецЕсли;	

	Команда = Сред(Кнопка.Имя, 8);
	Если УзелЭлемента.queryCommandSupported(Команда) Тогда
		УзелЭлемента.execCommand(Команда, Ложь);
		ПоказатьРежимыКнопок();
	КонецЕсли;
	ЭтотОбъект.Модифицированность = ИСтина;
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьРежимыКнопок()
	Если Элементы.ПолеHTMLДокумента.Документ = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекВыделение = Элементы.ПолеHTMLДокумента.Документ.selection;
	Если ТекВыделение = Неопределено Тогда
		 Возврат;
	Иначе
		УзелЭлемента = ТекВыделение.createRange();
	КонецЕсли;
	
	Для каждого Группа Из Элементы.КоманднаяПанельКнопок.ПодчиненныеЭлементы Цикл
		Для каждого Кнопка Из Группа.ПодчиненныеЭлементы Цикл
			Если ТипЗнч(Кнопка) = тип("КнопкаФормы") Тогда
				Команда = Сред(Кнопка.Имя, 8);
				Если УзелЭлемента.queryCommandSupported(Команда) Тогда
					Попытка
						Кнопка.Пометка = УзелЭлемента.queryCommandState(Команда);
					Исключение
					КонецПопытки;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	//Отдельно покажем кнопку гипперссылки
	Попытка
		Элементы.Гиперссылка.Доступность =ЗначениеЗаполнено(УзелЭлемента.text);
	Исключение
	КонецПопытки;
КонецПроцедуры

&НаКлиенте
Процедура КоманднаяПанельРежим(Команда)
	Если Элементы.ПолеHTMLДокумента.Документ = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Кнопка = Элементы.Найти(Команда.Имя);
	Если Кнопка.Пометка Тогда
		Возврат;
	КонецЕсли; 
	
	ДоступностьКнопок = Истина;
	Элементы.КомандаFormatBlock.Доступность = ДоступностьКнопок;
	Элементы.КомандаFontName.Доступность = ДоступностьКнопок;
	Элементы.КомандаFontSize.Доступность = ДоступностьКнопок;
	
	Для каждого Группа Из Элементы.КоманднаяПанельКнопок.ПодчиненныеЭлементы Цикл
		Если Группа.Имя = "ГруппаУправлениеРежимом" Тогда
			УправлятьДоступностью = Ложь;
		Иначе
			УправлятьДоступностью = Истина;
		КонецЕсли;
		
		Для каждого Кн Из Группа.ПодчиненныеЭлементы Цикл
			Если ТипЗнч(Кн) = тип("КнопкаФормы") Тогда
				Если УправлятьДоступностью Тогда
					Кн.Доступность = ДоступностьКнопок
				КонецЕсли; 
			КонецЕсли;
		КонецЦикла;
		
	КонецЦикла; 
	
	ПредыдущийРежим = Кнопка;
	ПоказатьРежимыКнопок();
	
	ПропарситьСсылкиИзHTML(Элементы.ПолеHTMLДокумента.Документ.Body.InnerHTML);
КонецПроцедуры

&НаКлиенте
Процедура ВставитьКартинкуИзБуфера(Команда)
	Если Элементы.ПолеHTMLДокумента.Документ = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	КомпонентаУстановлена = РаботаСКартинкамиКлиент.ПроинициализироватьКомпоненту();
	Если Не КомпонентаУстановлена Тогда
		
		Обработчик = Новый ОписаниеОповещения("ВставитьКартинкуИзБуфераЗавершение", ЭтотОбъект);		
		РаботаСКартинкамиКлиент.УстановитьКомпоненту(Обработчик);
		Возврат;
		
	КонецЕсли;
	
	ВставитьКартинкуИзБуфераЗавершение(Истина, Неопределено);

КонецПроцедуры

&НаКлиенте
Процедура ВставитьКартинкуИзБуфераЗавершение(Результат, ПараметрыВыполнения) Экспорт
	
	Если Результат = Истина Тогда
		
		ПутьКФайлу = КомпонентаПолученияКартинкиИзБуфера.ПолучитьКартинкуИзБуфера();
	
		Если Не ПустаяСтрока(ПутьКФайлу) Тогда
    		ВыбраннаяКартинка = Новый Картинка(ПутьКФайлу);
    		НачатьУдалениеФайлов(Новый ОписаниеОповещения("ВставитьКартинкуИзБуфераЗавершениеЗавершение", ЭтотОбъект, Новый Структура("ВыбраннаяКартинка", ВыбраннаяКартинка)), ПутьКФайлу);
		Иначе
			ПоказатьПредупреждение(,НСтр("ru = 'Буфер обмена не содержит картинки'"));
		КонецЕсли;
	
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ВставитьКартинкуИзБуфераЗавершениеЗавершение(ДополнительныеПараметры) Экспорт
	
	ВыбраннаяКартинка = ДополнительныеПараметры.ВыбраннаяКартинка;
	
	
	АдресКартинки = ПоместитьВоВременноеХранилище(ВыбраннаяКартинка,ИдФормыРодителя);
	
	ТекВыделение = Элементы.ПолеHTMLДокумента.Документ.selection;
	Если ТекВыделение = Неопределено Тогда
		Возврат;
	Иначе
		УзелЭлемента = ТекВыделение.createRange();
	КонецЕсли;
	
	УзелЭлемента.execCommand("InsertImage",false,АдресКартинки);
	
	НоваяСтрока = ТаблицаВложений.Добавить();
	НоваяСтрока.Ключ = Новый УникальныйИдентификатор();
	НоваяСтрока.Адрес = АдресКартинки;
	
	ЭтотОбъект.Модифицированность = Истина;
	
	ПодготовитьHTMLСтраницу(Строка(Элементы.ПолеHTMLДокумента.Документ.Body.InnerHTML));
	
	РаботаСHTML.ПередатьОбъектыСтраницыНаКлиента(ТекстДополненияHTML,ТаблицаВложений);
	
	ПоказатьРежимыКнопок();

КонецПроцедуры

&НаКлиенте
Процедура ВставитьКартинкуИзФайла(Команда)
	Если Элементы.ПолеHTMLДокумента.Документ = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	Диалог.Заголовок = "Выберите файл с фотографией";
	Диалог.ПолноеИмяФайла = "";
	Диалог.ПредварительныйПросмотр = Истина;
	Диалог.Фильтр = 
	"Все картинки (*.bmp;*.dib;*.rle;*.jpg;*.jpeg;*.tif;*.gif;*.png;*.ico;*.wmf;*.emf)|*.bmp;*.dib;*.rle;*.jpg;*.jpeg;*.tif;*.gif;*.png;*.ico;*.wmf;*.emf|" 
	+ "Формат bmp (*.bmp;*.dib;*.rle)|*.bmp;*.dib;*.rle|"
	+ "Формат JPEG (*.jpg;*.jpeg)|*.jpg;*.jpeg|"
	+ "Формат TIFF (*.tif)|*.tif|"
	+ "Формат GIF (*.gif)|*.gif|"
	+ "Формат PNG (*.png)|*.png|"
	+ "Формат icon (*.ico)|*.ico|"
	+ "Формат метафайл (*.wmf;*.emf)|*.wmf;*.emf|"; // картинки
	
	Диалог.Показать(Новый ОписаниеОповещения("ВставитьКартинкуИзФайлаЗавершение", ЭтотОбъект, Новый Структура("Диалог", Диалог)));
			
КонецПроцедуры

&НаКлиенте
Процедура ВставитьКартинкуИзФайлаЗавершение(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	
	Диалог = ДополнительныеПараметры.Диалог;
	
	
	Если (ВыбранныеФайлы <> Неопределено) Тогда
		
		//Вставляем картинку на форму
		Попытка						
			ВыбраннаяКартинка = Новый Картинка(Диалог.ПолноеИмяФайла,Ложь);
			АдресКартинки = ПоместитьВоВременноеХранилище(ВыбраннаяКартинка,ИдФормыРодителя);
			
			ТекВыделение = Элементы.ПолеHTMLДокумента.Документ.selection;
			Если ТекВыделение = Неопределено Тогда
				Возврат;
			Иначе
				УзелЭлемента = ТекВыделение.createRange();
			КонецЕсли;
			
			УзелЭлемента.execCommand("InsertImage",false,АдресКартинки);
			
			НоваяСтрока = ТаблицаВложений.Добавить();
			НоваяСтрока.Ключ = Новый УникальныйИдентификатор();
			НоваяСтрока.Адрес = АдресКартинки;
		Исключение КонецПопытки;
		ЭтотОбъект.Модифицированность = Истина;
		
		ПодготовитьHTMLСтраницу(Строка(Элементы.ПолеHTMLДокумента.Документ.Body.InnerHTML));
		РаботаСHTML.ПередатьОбъектыСтраницыНаКлиента(ТекстДополненияHTML,ТаблицаВложений);
		
		ПоказатьРежимыКнопок();
	Иначе
		Отказ = Истина;
		Возврат;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ВставитьГиперссылку(Команда)
	Если Элементы.ПолеHTMLДокумента.Документ = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	//Получим ссылку и представление
	ТекВыделение = Элементы.ПолеHTMLДокумента.Документ.selection;
	Если ТекВыделение = Неопределено Тогда
		Возврат;
	Иначе
		УзелЭлемента = ТекВыделение.createRange();
	КонецЕсли;
	
	ТекЭлемент = УзелЭлемента.parentElement();
	
	Если Не ЗначениеЗаполнено(УзелЭлемента.text) Тогда 
		Возврат;
	КонецЕсли;	
	
	ФормаГиперСсылки = ПолучитьФорму("ОбщаяФорма.ВыборГиперссылки");
	Попытка
		ФормаГиперСсылки.ГиперСсылка = ТекЭлемент.href;
	Исключение 
		//не нашли ссылку так, попробуем по другому:
		ГиперСсылка = "";
		ВыделенныйТекстHTML = УзелЭлемента.htmlText;
		СимволНачала = СтрНайти(ВыделенныйТекстHTML,"href=");
		Если СимволНачала <> 0 Тогда
			Для Инд = СимволНачала+5 По СтрДлина(ВыделенныйТекстHTML) Цикл
				ТекСимвол = Сред(ВыделенныйТекстHTML,Инд,1);
				Если ТекСимвол <> ">" Тогда
					ГиперСсылка = ГиперСсылка+ТекСимвол;
				Иначе
					Прервать;
				КонецЕсли;	
			КонецЦикла;	
		КонецЕсли;
		ГиперСсылка = СтрЗаменить(ГиперСсылка,"""","");
		ФормаГиперСсылки.ГиперСсылка = ГиперСсылка;
	КонецПопытки;
	ФормаГиперСсылки.Представление =УзелЭлемента.text;
	ФормаГиперСсылки.ДоступностьПредставления =Истина;
	ФормаГиперСсылки.СсылкаНаОбъект = СсылкаНаОбъект;
	
	СтруктураВозврата = ФормаГиперСсылки.ОткрытьМодально();
	Если ТипЗнч(СтруктураВозврата) = Тип("Структура") Тогда
		Представление  = СтруктураВозврата.Представление;
		Гиперссылка = НРег(СтруктураВозврата.Гиперссылка);
		
		УзелЭлемента.execCommand("CreateLink", Ложь, Гиперссылка);
		
		//после установки ссылки у нас остается выделенный текст представления
		//В него поместим новое представление
		Попытка
			ТекВыделение = Элементы.ПолеHTMLДокумента.Документ.selection;
			Если ТекВыделение = Неопределено Тогда
				Возврат;
			Иначе
				УзелЭлемента = ТекВыделение.createRange();
			КонецЕсли;
			
			ТекЭлемент = УзелЭлемента.parentElement();
			Если ТекЭлемент.tagName <>"A" тогда
				УзелЭлемента.text = Представление;
			Иначе
				ТекЭлемент.innerHTML = Представление;
			КонецЕсли;
	
		Исключение
			
		КонецПопытки;
		
		ЭтотОбъект.Модифицированность = ИСтина;
		
	КонецЕсли;
	ПоказатьРежимыКнопок();
КонецПроцедуры

&НаКлиенте
Процедура ВыборЦвета(Команда)
	Если Элементы.ПолеHTMLДокумента.Документ = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Цвет = ПолучитьФорму("ОбщаяФорма.ВыборЦвета").ОткрытьМодально();
	
	Если Цвет <> Неопределено Тогда
		Кнопка = Сред(Команда.Имя, 8);
		Если Элементы.ПолеHTMLДокумента.Документ.queryCommandSupported(Кнопка) Тогда
			Элементы.ПолеHTMLДокумента.Документ.execCommand(Кнопка, Ложь, "" + БазаЗнанийКлиентСервер.ПеревестиИз10(Цвет.Красный) + БазаЗнанийКлиентСервер.ПеревестиИз10(Цвет.Зеленый) + БазаЗнанийКлиентСервер.ПеревестиИз10(Цвет.Синий));
		КонецЕсли;
		ЭтотОбъект.Модифицированность = ИСтина;
		
	КонецЕсли;
	ПоказатьРежимыКнопок();
	
КонецПроцедуры

&НаКлиенте
Процедура ПеречитатьHTML(Команда)
	Если Элементы.ПолеHTMLДокумента.Документ = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПропарситьСсылкиИзHTML(Элементы.ПолеHTMLДокумента.Документ.Body.InnerHTML);
КонецПроцедуры

//////////////////////////////////////////////////////////////////////////////// 
// Процедуры модуля формы сервер
// 
&НаСервере
Процедура ПропарситьСсылкиИзHTML(ТекстДляПарсинга)
	//В процессе работы с текстом HTML (если переколючались в режим просмотра HTML к примеру) ослик и платформа периодически добавляет мусор в пути
	//отучаем его от этого плохого занятия
	Для Каждого Стр из ЭтотОбъект.ТаблицаВложений Цикл
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

&НаКлиенте
Процедура ПолеHTMLДокументаДокументСформирован(Элемент)
	Инд = 0;
	Пока Элемент.Документ.readyState <> "complete" Цикл
		//Анализируем когда документ загрузится
		Если Инд = 500 тогда //ограничение сколько ждем
			Прервать;
		КонецЕсли;
		Инд = Инд + 1;
	КонецЦикла; 
	
	Элемент.Документ.Body.ContentEditable ="true";
	Элемент.Документ.Body.scroll = "yes";

	мТекстЗаявки = Элементы.ПолеHTMLДокумента.Документ.Body.InnerHTML;
	
	ПодключитьОбработчикОжидания("ПроверитьИзменениеТекстаЗаявки",1,Ложь);

	УстановитьВидимость();
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВидимость();

	Элементы.КоманднаяПанельКнопок.Доступность = Не РаботаВВебКлиенте;
	Элементы.ГруппаВыпадающихСписков.Видимость = Не РаботаВВебКлиенте;

	Элементы.НадписьВебКлиент.Видимость  =  РаботаВВебКлиенте;
КонецПроцедуры

&НаКлиенте
Процедура ПолеHTMLДокументаПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	СвойстваЭлемента = Неопределено;
	Если ДанныеСобытия.свойство("Element",СвойстваЭлемента) Тогда
		Если СвойстваЭлемента <> Неопределено Тогда
			Если СвойстваЭлемента.nodeName = "IMG" Тогда
				СтандартнаяОбработка = Ложь;

				ПропарситьСсылкиИзHTML(Элементы.ПолеHTMLДокумента.Документ.body.InnerHTML)
			КонецЕсли;	
		КонецЕсли;	
	КонецЕсли;	
	
	ПоказатьРежимыКнопок();
КонецПроцедуры

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Служебные процедуры и функции

&НаСервере
Процедура ПодготовитьHTMLСтраницу(ТекстHTML)
	
	//Добавим тег HTML если он отсутствует. 
	//Необходимо для корректного отображения в элементе формы.
	Если СтрЧислоВхождений(ТекстHTML,"<body") = 0 Тогда
		ЗаголовокHTML = "<html>
		|<style type='text/css'>	
  		|Body{
  		|border:0; margin: 0 0 0 5px; /* Отступ Body*/
  		|} 
		|P{
  		|border:0; margin: 5px 0 0 10px; /* Отступ P*/
  		|}
		|</style>
		|<head>
		|<meta http-equiv=""Content-Type"" content=""text/html; charset=utf-8"" />
		|<meta http-equiv=""X-UA-Compatible"" content=""IE=EmulateIE7"" />
		|<meta name=""format-detection"" content=""telephone=no"" />
		|</head>
		|<body>";
		
		ПодвалHTML = "</body>
		|</html>";
		
		ПропарситьСсылкиИзHTML(ТекстHTML);

		ТекстHTML = ЗаголовокHTML + ТекстHTML + ПодвалHTML;
	Иначе
		//Возможно у нас уже есть Body, тогда проверим тег overflow в body
		ТекстHTML = СтрЗаменить(ТекстHTML,"overflow:hidden;","");
	КонецЕсли;	
	
	ЭтотОбъект.ТекстДополненияHTML = ТекстHTML;
	
КонецПроцедуры

&НаСервере
Процедура ПрочитатьВходящийТекстHTML(Адрес)
	Если Не ЭтоАдресВременногоХранилища(Адрес) Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураДополнения = ПолучитьИзВременногоХранилища(Адрес);
	Если Не ТипЗнч(СтруктураДополнения) = Тип("Структура") Тогда
		Возврат;
	КонецЕсли;	
	ТекстHTML = СтруктураДополнения.ТекстHTML;
	ТаблВложений = ?(СтруктураДополнения.ТаблицаВложений=Неопределено,Новый ТаблицаЗначений,СтруктураДополнения.ТаблицаВложений);
	
	Для Каждого Стр Из ТаблВложений Цикл
		НоваяСтрока = ТаблицаВложений.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока,Стр);
	КонецЦикла;
	
	ПодготовитьHTMLСтраницу(ТекстHTML);
	

КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	АдресВходящихДанных = Параметры.АдресВходящихДанных;	
	ИдФормыРодителя = Параметры.ИдФормыРодителя;
	СсылкаНаОбъект  = Параметры.СсылкаНаОбъект;
	
	ЭтаФорма.Заголовок = Параметры.Заголовок;
	
	ПодготовитьHTMLСтраницу("");
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "ЗакрытаФормаЗаявки" И СсылкаНаОбъект = Источник И ЭтаФорма.Открыта() Тогда
		Если Параметр = Истина Тогда
			СохранитьДанныеИзакрыть();
		Иначе
			ЭтаФорма.Закрыть();
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	ОтключитьОбработчикОжидания("ПроверитьИзменениеТекстаЗаявки");
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	Если ЗавершениеРаботы Тогда
		ТекстПредупреждения = "Данные были изменены! Изменения могут быть не сохранены!";
		Возврат;
	КонецЕсли;
	
	Если ЭтотОбъект.Модифицированность  = Истина Тогда
		Отказ = Истина;
		ПоказатьВопрос(Новый ОписаниеОповещения("ПередЗакрытиемЗавершение",ЭтотОбъект),"Данные были изменены. Сохранить изменения?",РежимДиалогаВопрос.ДаНетОтмена);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(РезультатВопроса,ДополнительныеПараметры) Экспорт
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ЭтотОбъект.Модифицированность = Ложь; 
		СохранитьДанныеИзакрыть();
	ИначеЕсли РезультатВопроса = КодВозвратаДиалога.Нет Тогда
		ЭтотОбъект.Модифицированность = Ложь;  
		Закрыть();
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьИзменениеТекстаЗаявки()
	Если ЭтаФорма.Модифицированность = Истина Тогда
		Возврат;
	КонецЕсли;

	Если Элементы.ПолеHTMLДокумента.Документ = Неопределено Тогда
		Возврат;
	КонецЕсли;

	ТекущийТекстЗаявки = Элементы.ПолеHTMLДокумента.Документ.Body.InnerHTML;
	Если мТекстЗаявки <> ТекущийТекстЗаявки Тогда
		ЭтаФорма.Модифицированность = Истина;
	КонецЕсли;	
КонецПроцедуры

