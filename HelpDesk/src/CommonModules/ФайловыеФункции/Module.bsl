////////////////////////////////////////////////////////////////////////////////
// Подсистема "Файловые функции".
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Возвращает максимальный размер файла.
Функция МаксимальныйРазмерФайла() Экспорт
	
	Возврат ФайловыеФункцииСлужебный.ПолучитьМаксимальныйРазмерФайла();
	
КонецФункции

// Возвращает максимальный размер файла провайдера.
Функция МаксимальныйРазмерФайлаОбщий() Экспорт
	
	Возврат ФайловыеФункцииСлужебный.ПолучитьМаксимальныйРазмерФайлаОбщий();
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Работа с томами файлов

//Есть ли хоть один том хранения файлов.
Функция ЕстьТомаХраненияФайлов() Экспорт
	
	Возврат ФайловыеФункцииСлужебный.ЕстьТомаХраненияФайлов();
	
КонецФункции

