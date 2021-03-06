﻿
&НаСервере
Процедура ОбновитьСписокПечатныхФормОбъекта()

	ПараметрыРегистрации = ЭтотОбъект().СведенияОВнешнейОбработке();
	
	Элементы.СписокПечатныхФормОбъекта.СписокВыбора.Очистить();
	
	Для каждого СтрокаТаблицы Из ПараметрыРегистрации.Команды Цикл
		Элементы.СписокПечатныхФормОбъекта.СписокВыбора.Добавить(СтрокаТаблицы.Идентификатор, СтрокаТаблицы.Представление);
	КонецЦикла;
	
	ПечатнаяФорма = Элементы.СписокПечатныхФормОбъекта.СписокВыбора[0].Значение;
	
КонецПроцедуры //ОбновитьСписокПечатныхФормОбъекта()

Процедура ВыполнитьПечать()
	
	МассивОбъектовНазначения = Новый Массив;
	МассивОбъектовНазначения.Добавить(СсыльНаДок);
	
	ПараметрыВывода = УправлениеПечатью.ПодготовитьСтруктуруПараметровВывода();
	
	ОбъектыПечати = Новый СписокЗначений;
	
	КоллекцияФорм = УправлениеПечатью.ПодготовитьКоллекциюПечатныхФорм(ПечатнаяФорма);
	
	ЭтотОбъект().Печать(МассивОбъектовНазначения, КоллекцияФорм, ОбъектыПечати, ПараметрыВывода);
	
	ТабличноеПоле.Очистить();
	
	Для каждого СтрокаТаблицы Из КоллекцияФорм Цикл
		Если СтрокаТаблицы.ТабличныйДокумент <> Неопределено Тогда
			ТабличноеПоле = СтрокаТаблицы.ТабличныйДокумент;
		КонецЕсли; 
	КонецЦикла;
	
КонецПроцедуры

Процедура УстановитьОграниченияТипа()
	
	Попытка
		РегистрационныеДанные = ЭтотОбъект().СведенияОВнешнейОбработке();
	Исключение
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru = 'Возможно, обработка (отчет) устарела или не является дополнительной:'")
					+ КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		Возврат;
	КонецПопытки;
	
	//Установим заголовок формы
	ЭтаФорма.Заголовок = "Отладка внешних печатных форм: " + РегистрационныеДанные.Наименование;
	
	ВидОбработки = Перечисления.ВидыДополнительныхОтчетовИОбработок[РегистрационныеДанные.Вид];
//	ПолноеНазначениеЗначение = ДополнительныеОтчетыИОбработки.НазначаемыеОбъектыМетаданныхПоВидуВнешнегоОбъекта(ВидОбработки);
	
	СписокОграниченияТипа = Новый Массив;
	
	//Если РегистрационныеДанные.Свойство("Назначение") Тогда
	//	Для Каждого ЭлементЗаданноеНазначение Из РегистрационныеДанные.Назначение Цикл
	//		РазделеннаяСтрока = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ЭлементЗаданноеНазначение, ".");
	//		Если РазделеннаяСтрока[1] = "*" Тогда
	//			НайденныеНазначения = ПолноеНазначениеЗначение.НайтиСтроки(Новый Структура("Класс", РазделеннаяСтрока[0]));
	//			Для Каждого ЭлементНайденноеНазначение Из НайденныеНазначения Цикл
	//				СписокОграниченияТипа.Добавить(ЭлементНайденноеНазначение.ПолноеИмяОбъектаМетаданных);
	//			КонецЦикла;
	//		Иначе
	//			Если ПолноеНазначениеЗначение.НайтиСтроки(Новый Структура("ПолноеИмяОбъектаМетаданных", ЭлементЗаданноеНазначение)).Количество() > 0 Тогда
	//				СписокОграниченияТипа.Добавить(ЭлементЗаданноеНазначение);
	//			КонецЕсли;
	//		КонецЕсли;
	//	КонецЦикла;
	//КонецЕсли;
	
	Если СписокОграниченияТипа.Количество() > 0 Тогда
		Для А = 0 По СписокОграниченияТипа.Количество() - 1 Цикл
			ЭлементМассива = СписокОграниченияТипа[А];
			ПозицияРазделителя = Найти(ЭлементМассива, ".");
			Если Лев(ЭлементМассива, ПозицияРазделителя - 1) = "Документ" Тогда
				ТипДокумента = Документы[Сред(ЭлементМассива, ПозицияРазделителя + 1)].ПустаяСсылка();
				ЭлементМассива = ТипЗнч(ТипДокумента);
			ИначеЕсли Лев(ЭлементМассива, ПозицияРазделителя - 1) = "Справочник" Тогда
				ТипСправочника = Справочники[Сред(ЭлементМассива, ПозицияРазделителя + 1)].ПустаяСсылка();
				ЭлементМассива = ТипЗнч(ТипСправочника);
			КонецЕсли;
			СписокОграниченияТипа[А] = ЭлементМассива;
		КонецЦикла;
		Элементы.СсылкаНаОбъект.ОграничениеТипа = Новый ОписаниеТипов(СписокОграниченияТипа);
	КонецЕсли; 
	
КонецПроцедуры

// Возвращает экземпляр текущего объекта
//
//
&НаСервере
Функция ЭтотОбъект()

	Обработка = РеквизитФормыВЗначение("Объект");
	Возврат Обработка;

КонецФункции // ЭтотОбъект()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	//Устанавливаем ограничение типа для поля СсылкаНаОбъект
	УстановитьОграниченияТипа();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	//Зарегистрируем обработку в справочнике "Дополнительные отчеты и обработки".
	СсылкаНаЭлемент = Неопределено;
	//Результат = ЗарегистрироватьОбработкуВИнформационнойБазеНаСервере("Поиск", СсылкаНаЭлемент);
	//Если ТипЗнч(Результат) = Тип("Строка") Тогда
	//	ОтветНаВопрос = Вопрос("В информационной базе зарегистрирована обработка под таким именем - " + Результат + ".
	//				|Обновить существующую?", РежимДиалогаВопрос.ДаНет);
	//	Если ОтветНаВопрос = КодВозвратаДиалога.Да Тогда 
	//		Результат = ЗарегистрироватьОбработкуВИнформационнойБазеНаСервере("Обновить", СсылкаНаЭлемент);
	//	КонецЕсли; 
	//КонецЕсли; 
	//
	//Если Результат = Истина Тогда
	//	
	//	ОповеститьОбИзменении(СсылкаНаЭлемент);
	//	Предупреждение("Обработка успешно зарегистрирована в справочнике ""Дополнительные отчеты и обработки"".
	//					|При необходимости укажите для обработки нужную группу.");
	//					
	//					
	//	ОтветНаВопрос = Вопрос("Закрыть форму регистрации?", РежимДиалогаВопрос.ДаНет);
	//	Если ОтветНаВопрос = КодВозвратаДиалога.Да Тогда 
	//		Отказ = Истина;
	//	КонецЕсли; 
	//	
	//КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьОтладку(Команда)
	
	ВыполнитьПечать();
	
КонецПроцедуры

&НаКлиенте
Процедура СсылкаНаОбъектПриИзменении(Элемент)
	
	ОбновитьСписокПечатныхФормОбъекта();
	
КонецПроцедуры

//Универсальная функция для регистрации обработки в информационной базе
//
&НаСервере
Функция ЗарегистрироватьОбработкуВИнформационнойБазеНаСервере(РежимИспользования = "", СсылкаНаЭлемент = Неопределено)

	//Регистрируем обработку в информационной базе
	ОбъектЗн = РеквизитФормыВЗначение("Объект");
	
	Если НЕ ПравоДоступа("Изменение", Метаданные.Справочники.ДополнительныеОтчетыИОбработки) Тогда 
		Возврат Ложь;
	КонецЕсли;
	
	РегистрационныеДанные = ОбъектЗн.СведенияОВнешнейОбработке();
	
	Если СсылкаНаЭлемент = Неопределено Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	ДополнительныеОтчетыИОбработки.Версия,
			|	ДополнительныеОтчетыИОбработки.Ссылка
			|ИЗ
			|	Справочник.ДополнительныеОтчетыИОбработки КАК ДополнительныеОтчетыИОбработки
			|ГДЕ
			|	ДополнительныеОтчетыИОбработки.Наименование = &Наименование
			|	И ДополнительныеОтчетыИОбработки.Вид = &Вид
			|";

		Запрос.УстановитьПараметр("Наименование", РегистрационныеДанные.Наименование);
		Запрос.УстановитьПараметр("Вид", Перечисления.ВидыДополнительныхОтчетовИОбработок[РегистрационныеДанные.Вид]);
		Результат = Запрос.Выполнить();
		Выборка = Результат.Выбрать();

		Если Выборка.Следующий() Тогда
			СсылкаНаЭлемент = Выборка.Ссылка; 
		Иначе
			СсылкаНаЭлемент = Справочники.ДополнительныеОтчетыИОбработки.ПустаяСсылка(); 
		КонецЕсли;
	КонецЕсли; 
	
	Если РежимИспользования = "Поиск" Тогда
		Если СсылкаНаЭлемент = Справочники.ДополнительныеОтчетыИОбработки.ПустаяСсылка() Тогда 
			РежимИспользования = "Обновить"; 
		Иначе
			//Если СсылкаНаЭлемент.Версия <> РегистрационныеДанные.Версия Тогда
			Возврат РегистрационныеДанные.Наименование; 
		//Иначе
		//	Возврат Ложь; 
		КонецЕсли;
	КонецЕсли;
	
	Если РежимИспользования = "Обновить" Тогда
		Если СсылкаНаЭлемент = Справочники.ДополнительныеОтчетыИОбработки.ПустаяСсылка() Тогда
			ЭлементОбъект = Справочники.ДополнительныеОтчетыИОбработки.СоздатьЭлемент();
		Иначе
			ЭлементОбъект = СсылкаНаЭлемент.ПолучитьОбъект(); 
		КонецЕсли; 
	КонецЕсли;
	
	ПолноеИмяИмяФайла = ОбъектЗн.ИспользуемоеИмяФайла;
	МассивПодстрок = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ПолноеИмяИмяФайла, "\");
	ИмяФайла = МассивПодстрок.Получить(МассивПодстрок.ВГраница());
	
	Если ЭлементОбъект.ИмяФайла = ИмяФайла
		И ЭлементОбъект.Вид = Перечисления.ВидыДополнительныхОтчетовИОбработок[РегистрационныеДанные.Вид] Тогда
		// если это перерегистрация этой же обработи - не очищаем назначение
	Иначе
		ЭлементОбъект.Назначение.Очистить();
	КонецЕсли;
	
	// Инициализация сведений об обработке
	Если Не ЗначениеЗаполнено(ЭлементОбъект.Публикация) Тогда
		ЭлементОбъект.Публикация = Перечисления.ВариантыПубликацииДополнительныхОтчетовИОбработок.Используется;
	КонецЕсли; 
	ЭлементОбъект.Вид = Перечисления.ВидыДополнительныхОтчетовИОбработок[РегистрационныеДанные.Вид];
	ЭлементОбъект.Наименование		= РегистрационныеДанные.Наименование;
	ЭлементОбъект.Версия			= РегистрационныеДанные.Версия;
	ЭлементОбъект.БезопасныйРежим	= РегистрационныеДанные.БезопасныйРежим;
	ЭлементОбъект.Информация		= РегистрационныеДанные.Информация;
	
	// Устанавливаем имя файла обработки
	ЭлементОбъект.ИмяФайла = ИмяФайла;
	ЭлементОбъект.ХранилищеОбработки = Новый ХранилищеЗначения(Новый ДвоичныеДанные(ПолноеИмяИмяФайла)); 
	
	// Если новая обработка или не заполнено назначение - устанавливаем назначение из обработки
	Если (ЭлементОбъект.Ссылка = Справочники.ДополнительныеОтчетыИОбработки.ПустаяСсылка()
		 ИЛИ ЭлементОбъект.Назначение.Количество() = 0)
		И (ЭлементОбъект.Вид = Перечисления.ВидыДополнительныхОтчетовИОбработок.ЗаполнениеОбъекта
			ИЛИ ЭлементОбъект.Вид = Перечисления.ВидыДополнительныхОтчетовИОбработок.Отчет
			ИЛИ ЭлементОбъект.Вид = Перечисления.ВидыДополнительныхОтчетовИОбработок.ПечатнаяФорма
			ИЛИ ЭлементОбъект.Вид = Перечисления.ВидыДополнительныхОтчетовИОбработок.СозданиеСвязанныхОбъектов)
		 ТОГДА
		
		ЭлементОбъект.ИспользоватьДляФормыОбъекта = Истина;
		ЭлементОбъект.ИспользоватьДляФормыСписка = Истина;
		
		//ПолноеНазначениеЗначение = ДополнительныеОтчетыИОбработки.НазначаемыеОбъектыМетаданныхПоВидуВнешнегоОбъекта(ЭлементОбъект.Вид);
		//
		//Если РегистрационныеДанные.Свойство("Назначение") Тогда
		//	
		//	Для Каждого ЭлементЗаданноеНазначение Из РегистрационныеДанные.Назначение Цикл
		//		
		//		РазделеннаяСтрока = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ЭлементЗаданноеНазначение, ".");
		//		
		//		Если РазделеннаяСтрока[1] = "*" Тогда
		//			
		//			НайденныеНазначения = ПолноеНазначениеЗначение.НайтиСтроки(Новый Структура("Класс", РазделеннаяСтрока[0]));
		//			
		//			Для Каждого ЭлементНайденноеНазначение Из НайденныеНазначения Цикл
		//				НоваяСтрока = ЭлементОбъект.Назначение.Добавить();
		//				//НоваяСтрока.ПолноеИмяОбъектаМетаданных = ЭлементНайденноеНазначение.ПолноеИмяОбъектаМетаданных;
		//			КонецЦикла;
		//			
		//		Иначе
		//			
		//			Если ПолноеНазначениеЗначение.НайтиСтроки(Новый Структура("ПолноеИмяОбъектаМетаданных", ЭлементЗаданноеНазначение)).Количество() > 0 Тогда
		//				НоваяСтрока = ЭлементОбъект.Назначение.Добавить();
		//				//НоваяСтрока.ПолноеИмяОбъектаМетаданных = ЭлементЗаданноеНазначение;
		//			КонецЕсли;
		//			
		//		КонецЕсли;
		//		
		//	КонецЦикла;
		//КонецЕсли;
		//
		//ЭлементОбъект.Назначение.Свернуть("ПолноеИмяОбъектаМетаданных", "");
		
	КонецЕсли;
	
	КомандыСохраненные = ЭлементОбъект.Команды.Выгрузить();
	
	ЭлементОбъект.Команды.Очистить();
	
	// Инициализация команд
	
	Для Каждого ЭлементОписаниеКоманды Из РегистрационныеДанные.Команды Цикл
		
		НоваяСтрока = ЭлементОбъект.Команды.Добавить();
		НоваяСтрока.Идентификатор	= ЭлементОписаниеКоманды.Идентификатор;
		НоваяСтрока.Представление	= ЭлементОписаниеКоманды.Представление;
		НоваяСтрока.Модификатор		= ЭлементОписаниеКоманды.Модификатор;
		НоваяСтрока.ПоказыватьОповещение = ЭлементОписаниеКоманды.ПоказыватьОповещение;
		
		Если ЭлементОписаниеКоманды.Использование = "ОткрытиеФормы" Тогда
			НоваяСтрока.ВариантЗапуска = Перечисления.СпособыВызоваДополнительныхОбработок.ОткрытиеФормы;
		ИначеЕсли ЭлементОписаниеКоманды.Использование = "ВызовКлиентскогоМетода" Тогда
			НоваяСтрока.ВариантЗапуска = Перечисления.СпособыВызоваДополнительныхОбработок.ВызовКлиентскогоМетода;
		ИначеЕсли ЭлементОписаниеКоманды.Использование = "ВызовСерверногоМетода" Тогда
			НоваяСтрока.ВариантЗапуска = Перечисления.СпособыВызоваДополнительныхОбработок.ВызовСерверногоМетода;
		Иначе
			ТекстСообщения = НСтр("ru = 'Для команды %1 не определен способ запуска.'");
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, ЭлементОписаниеКоманды.Представление);
			ВызватьИсключение ТекстСообщения;
			Возврат Ложь;
		КонецЕсли;
		
	КонецЦикла;
	
//	ЭлементОбъект.Ответственный = ОбщегоНазначения.ТекущийПользователь();
	
	Попытка
		ЭлементОбъект.Записать();
		СсылкаНаЭлемент = ЭлементОбъект.Ссылка;
	Исключение
		НСтрока = НСтр("ru = 'Произошла ошибка при записи обработки.
							|Подробное описание ошибки: %1'");
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтрока,
								КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		ВызватьИсключение ТекстСообщения;
		Возврат Ложь;
	КонецПопытки;
	
	Возврат Истина;
	
КонецФункции
