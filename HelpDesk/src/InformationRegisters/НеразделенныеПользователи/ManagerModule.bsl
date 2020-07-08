// Возвращает список неразделенных администраторов
//
// Возвращаемое значение:
//   СписокЗначений   – список уникальных идентификаторов с представлениями (имена пользователей)
//
Функция СписокАдминистраторов() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	НеразделенныеПользователи.ИдентификаторПользователяИБ
		|ИЗ
		|	РегистрСведений.НеразделенныеПользователи КАК НеразделенныеПользователи";
	Выборка = Запрос.Выполнить().Выбрать();
	СписокАдминистраторов = Новый СписокЗначений;
	Пока Выборка.Следующий() Цикл
		ПользовательИБ = ПользователиИнформационнойБазы.НайтиПоУникальномуИдентификатору(
			Выборка.ИдентификаторПользователяИБ);
		Если ПользовательИБ = Неопределено Тогда
			Продолжить;
		КонецЕсли;		
		ЕстьРоли = Ложь;
		Для Каждого РольПользователя Из ПользовательИБ.Роли Цикл
			ЕстьРоли = Истина;
			Прервать;
		КонецЦикла;
		Если Не ЕстьРоли Тогда
			Продолжить;
		КонецЕсли;
		Если Не Пользователи.ЭтоПолноправныйПользователь(ПользовательИБ, Истина) Тогда
			Продолжить;
		КонецЕсли;
		СписокАдминистраторов.Добавить(Выборка.ИдентификаторПользователяИБ, ПользовательИБ.Имя);
	КонецЦикла;
	СписокАдминистраторов.СортироватьПоПредставлению();
	Возврат СписокАдминистраторов;
	
КонецФункции