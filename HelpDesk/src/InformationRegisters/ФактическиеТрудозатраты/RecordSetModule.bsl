
Процедура ПередЗаписью(Отказ, Замещение)
	Для Каждого Запись Из ЭтотОбъект Цикл
		Если Не ЗначениеЗаполнено(Запись.МесяцНачисления) Тогда
			Запись.МесяцНачисления = НачалоМесяца(Запись.ДатаДобавления);
		КонецЕсли;	
	КонецЦикла		
КонецПроцедуры
