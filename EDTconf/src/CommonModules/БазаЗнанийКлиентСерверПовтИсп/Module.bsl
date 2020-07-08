
// Таблица стилей

Функция ТаблицаСтилей_ОбщаяЧасть()
	
	Возврат 
	"/*General styles*/
	|html {height:100%; width:800px;}
	|body {background: #fff; font-family: sans-serif; font-size: 13px;}
	|a {color: #0066bc; text-decoration:none;}
	|a:hover {text-decoration:none;}
	|
	|#allpage{width:100%; margin-top:12px;}
	|#wrap {width:100%; overflow: hidden;}";
	
КонецФункции

Функция ТаблицаСтилей_ЛевоеМеню()
	
	Возврат
	"/*ЛЕВОЕ МЕНЮ*/
	|#left {padding: 0 10px 0 20px; float:left; background: #fff;}
	|.left_menu {margin-bottom: 35px;}
	|.left_menu p{color:#444444; padding-bottom:7px; margin-bottom:7px; border-bottom:1px solid #D8D8D8;}
	|.left_menu li{padding-bottom:5px;}";
	
КонецФункции

Функция ТаблицаСтилей_Контент(ДляПечати = Ложь)
	
	Возврат
	"/*КОНТЕНТ ОБЕРТКА*/"+
	?(ДляПечати,"#content{margin: 0 5px 0 0px; background:#fff; }","#content{margin: 0 5px 0 180px; background:#fff; }")+
	"|#content_main{border-left: 1px solid #D8D8D8; padding: 0 25px 25px 25px; overflow:hidden;}
	|
	|/*ОСНОВНОЙ КОНТЕНТ*/
	|#content_main h1{font-size:20px; font-weight:bold; border-bottom: 1px solid #AAAAAA; padding-bottom:3px; margin-bottom: 15px;}
	|#content_main h2{font-size:17px; font-weight:bold; border-bottom: 1px solid #AAAAAA; padding-bottom:3px; margin: 15px 0;}
	|#content_main h3{font-size:13px; font-weight:bold; border-bottom: 1px solid #AAAAAA; padding-bottom:3px; margin: 15px 0;}
	|#content_main ul{list-style-type: disc; margin-left:20px;}
	|
	|/*НАВИГАЦИЯ В КОНТЕНТЕ*/
	|.content_menu_header {float:right; position:absolute;}";
	
КонецФункции

Функция ТаблицаСтилей_ПутьКСтранице()
	
	Возврат
	"/*ПУТЬ К СТРАНИЦЕ*/
	|.page_navigation {font-size:12px; color:#000; line-height:20px; border-bottom:1px dotted #666; margin-bottom:5px; padding-bottom:2px;} 
	|.page_navigation_pict {color:#0066bc; float:left; display:table-cell; vertical-align:middle; margin: 0 2px 0 0;}";
	
КонецФункции

Функция ТаблицаСтилей_Разделы()
	
	Возврат  
	"/*РАЗДЕЛЫ*/
	|.categories {border:1px solid #D5E2F1; border-radius:5px; padding:5px; background-color:#F1F5F8; margin: 0 0 15px 0; width:100%}
	|.categories table{cellspacing: 2%; cellpading: 0; width:100%}
	|.categories tr{vertical-align:top;}
	|
	|.categories_title {font-size:20px; font-weight:bold; border-bottom: 1px solid #AAAAAA; padding-bottom:3px; margin-bottom: 15px;}
	|
	|.category {padding: 0 5px 0 5px; margin: 0 0 10px 0;}
	|
	|.category_head {color:#0066bc; font-size:14px; line-height:20px; margin: 0 0 2px 0; padding: 0 0 2px 0}
	|.category_head_pict {color:#0066bc; float:left; display:table-cell; vertical-align:middle; margin: 0 2px 0 0;}
	|.category_head_name {color:#0066bc; padding:0 0 0 2px; font-weight:bold; font-size:13px; line-height:18px}
	|.category_head_count {font-weight:normal; color:#333;}
	|
	|.category_info {color:#666; font-size:11px; text-align:justify;}";	
	
КонецФункции

Функция ТаблицаСтилей_Статьи()
	
	Возврат
	"/*СТАТЬИ*/
	|.articles{border: solid 1px #c5f8ac; border-radius:5px; padding:0 5px 0 5px; margin: 0 0 15px 0; width:100%}
	|.articles table{cellspacing: 0; cellpadding: 0; width:100%}
	|.articles tr{vertical-align:top;}
	|
	|.articles_title {color: #669933; font-size: 15px; font-weight: bold; padding: 6px 0px; border-bottom: solid 1px #CCCCCC; margin-bottom: 5px; }
	|.articles_title a {color: #669933; text-decoration:none;}
	|
	|/*СТАТЬЯ КРАТКО*/
	|.article_head {color:#0066bc; font-size:14px; line-height:20px; margin: 0 0 2px 0; padding: 0 0 2px 0; width:100%}
	|.article_head_pict {float:left; display:table-cell; vertical-align:middle; margin: 0 2px 0 0;}
	|.article_head_title {color:#0066bc; padding:0 0 0 2px; font-weight:bold; font-size:13px; line-height:18px}
	|.article_head_info {color:#666; font-weight:normal; font-size:11px; text-align:justify;}
	|
	|/*СТАТЬЯ СТРАНИЦА*/
	|.article_content {border: solid 1px #c5f8ac; border-radius:5px; padding:0 5px 0 5px; margin: 0 0 15px 0;}
	|
	|.article_title {color: #669933; font-size: 15px; font-weight: bold; padding: 6px 0; border-bottom: solid 1px #CCCCCC; margin: 0 5px 5px 0;}
	|
	|.article_rating_out {display:block; text-align:center; margin:15px 0 15px 0;}
	|.article_rating {border: solid 1px #C60; padding: 10px; border-radius: 5px; width: 175px; margin-bottom: 25px; background-color: #FFF4EA;}
	|.article_rating_title {font-size: 14px; font-weight: bold; color: #C60; text-align: center;}
	|.article_rating_bar {margin: 6px 0px 25px 0px; width: 124px; height: 30px;}
	|.article_rating_bar a {margin: 0; padding: 0;}
	|
	|.article_text {font-size:13px; width:100%; margin:0 5px 25px 0; line-height:1.2}
	|.article_text a {text-decoration:underline;}
	|.article_text p {margin: 5px 0 2px 0}
	|.article_text ul {margin: 5px 0 2px 0}
	|.article_text li {margin-left: 10px}
	|.article_text h1 {font-size:20px; font-weight:bold; border-bottom: 1px solid #AAAAAA; padding-bottom:3px; margin-bottom: 15px;}
	|.article_text h2 {font-size:17px; font-weight:bold; border-bottom: 1px solid #AAAAAA; padding-bottom:3px; margin: 15px 0;}
	|.article_text h3 {font-size:15px; font-weight:bold; border-bottom: 1px solid #AAAAAA; padding-bottom:3px; margin: 15px 0;}";
	
КонецФункции

Функция ТаблицаСтилей_КоманднаяПанель()
	
	Возврат
	"/*КОМАНДНАЯ ПАНЕЛЬ*/
	|.command_panel {border:0; margin:0 0 0 5px;}
	|.command_panel img {border:0; margin:0; height:16px;}";
	
КонецФункции

Функция ПолучитьТаблицуСтилей(ДляПечати = Ложь) Экспорт
	
	СтрокаТаблицыСтилей = 
	"<style type='text/css'>
	|/*
	|PTB wiki theme
	|Version: 1.0.1
	|Author Siraev I., Aniskov A.
	|*/
	|
	|" + ТаблицаСтилей_ОбщаяЧасть() + "
	|
	|" + ?(ДляПечати,"",ТаблицаСтилей_ЛевоеМеню()) + "
	|
	|" + ТаблицаСтилей_Контент(ДляПечати) + "
	|
	|" + ТаблицаСтилей_ПутьКСтранице() + "
	|
	|" + ТаблицаСтилей_Разделы() + "
	|
	|" + ТаблицаСтилей_Статьи() + "
	|
	|" + ТаблицаСтилей_КоманднаяПанель() + "
	|
	|/*ДОПОЛНИТЕЛЬНО*/
	|</style>";
	
	Возврат СтрокаТаблицыСтилей;
	
КонецФункции

// Прочие методы

Функция ПолучитьДопустимыеСимволыИмени() Экспорт
	
	Возврат "абвгдежзийклмнопрстуфхцчшщъыьэюя" + 
		"0123456789" + 
		"abcdefghijklmnopqrstuvwxyz";
	
КонецФункции
	
Функция ТекстHTML_ВыравниваниеОбтекание(знач Выравнивание, знач Обтекание) Экспорт
	
	// -- Выравнивание
	// 0 - по левому краю
	// 1 - по правому краю
	// 2 - по центру
	// 3 - по ширине
	
	// -- Обтекание текста
	// 0 - по границам рисунка (только если выравнивание = 0 или 1)
	// 1 - сверху и снизу (
	
	Если Выравнивание = 0 Тогда
		Выравнивание = "left";
	ИначеЕсли Выравнивание = 1 Тогда
		Выравнивание = "right";
	ИначеЕсли Выравнивание = 2 Тогда
		Выравнивание = "center";
	ИначеЕсли Выравнивание = 3 Тогда
		Выравнивание = "justify";
	Иначе 
		Выравнивание = "inherit";
	КонецЕсли;
	
	Если Обтекание = 0 Тогда
		Если Выравнивание = "left" Тогда
			Обтекание = "left";
		ИначеЕсли Выравнивание = "right" Тогда
			Обтекание = "right";
		Иначе 
			Обтекание = "none";
		КонецЕсли;
	Иначе
		Обтекание = "none";
	КонецЕсли;
	
	Возврат "text-align:" + Выравнивание + "; float:" + Обтекание;
	
КонецФункции

