
///////////////////////////////////////////////////////////////////////////////////////////////////
// Прикладной интерфейс

Перем мНастройки;
Перем Лог;
Перем мИдентификаторКластера;
Перем мИдентификаторБазы;
Перем ЭтоWindows;

Процедура ЗарегистрироватьКоманду(Знач ИмяКоманды, Знач Парсер) Экспорт
	
	ОписаниеКоманды = Парсер.ОписаниеКоманды(ИмяКоманды, "Управление сеансами информационной базы");
	
	Парсер.ДобавитьПозиционныйПараметрКоманды(ОписаниеКоманды, "Действие", "lock|unlock|kill");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "-ras", "Сетевой адрес RAS, по умолчанию localhost:1545");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "-rac", "Команда запуска RAC, по умолчанию находим в каталоге установки 1с");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "-db", "Имя информационной базы");
	
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, 
	"-db-user",
	"Пользователь информационной базы");
	
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, 
	"-db-pwd",
	"Пароль пользователя информационной базы");
	
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, 
	"-cluster-port",
	"Порт кластера");
	
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, 
	"-cluster-admin",
	"Администратор кластера");
	
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, 
	"-cluster-pwd",
	"Пароль администратора кластера");
	
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, 
	"-v8version",
	"Маска версии платформы 1С");
	
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, 
	"-lockmessage",
	"Сообщение блокировки");
	
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, 
	"-lockuccode",
	"Ключ разрешения запуска");
	
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, 
	"-lockstart",
	"Время старта блокировки пользователей, время указываем как '2040-12-31T23:59:59'");
	
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, 
	"-lockstartat",
	"Время старта блокировки через n сек");
	
	Парсер.ДобавитьКоманду(ОписаниеКоманды);
	
КонецПроцедуры

Функция ВыполнитьКоманду(Знач ПараметрыКоманды) Экспорт
	
	ПрочитатьПараметры(ПараметрыКоманды);
	
	Если Не ПараметрыВведеныКорректно() Тогда
		Возврат МенеджерКомандПриложения.РезультатыКоманд().НеверныеПараметры;
	КонецЕсли;
	
	Если мНастройки.Действие = "lock" Тогда
		УстановитьСтатусБлокировкиСеансов(Истина);
	ИначеЕсли мНастройки.Действие = "unlock" Тогда
		УстановитьСтатусБлокировкиСеансов(Ложь);
	ИначеЕсли мНастройки.Действие = "kill" Тогда
		УдалитьВсеСеансыИСоединенияБазы();
	Иначе
		Лог.Ошибка("Неизвестное действие: " + мНастройки.Действие);
		Возврат МенеджерКомандПриложения.РезультатыКоманд().НеверныеПараметры;
	КонецЕсли;
	
	Возврат МенеджерКомандПриложения.РезультатыКоманд().Успех;
	
КонецФункции

Процедура ПрочитатьПараметры(Знач ПараметрыКоманды)
	мНастройки = Новый Структура;
	
	Для Каждого КЗ Из ПараметрыКоманды Цикл
		Лог.Отладка(КЗ.Ключ + " = " + КЗ.Значение);
	КонецЦикла;
	
	мНастройки.Вставить("АдресСервераАдминистрирования", ПараметрыКоманды["-ras"]);
	мНастройки.Вставить("ПутьКлиентаАдминистрирования", ПараметрыКоманды["-rac"]);
	мНастройки.Вставить("ИмяБазыДанных", ПараметрыКоманды["-db"]);
	мНастройки.Вставить("АдминистраторИБ", ПараметрыКоманды["-db-user"]);
	мНастройки.Вставить("ПарольАдминистратораИБ", ПараметрыКоманды["-db-pwd"]);
	мНастройки.Вставить("ПортКластера", ПараметрыКоманды["-cluster-port"]);
	мНастройки.Вставить("АдминистраторКластера", ПараметрыКоманды["-cluster-admin"]);
	мНастройки.Вставить("ПарольАдминистратораКластера", ПараметрыКоманды["-cluster-pwd"]);
	мНастройки.Вставить("ИспользуемаяВерсияПлатформы", ПараметрыКоманды["-v8version"]);
	мНастройки.Вставить("КлючРазрешенияЗапуска", ПараметрыКоманды["-lockuccode"]);
	мНастройки.Вставить("СообщениеОблокировке", ПараметрыКоманды["-lockmessage"]);
	мНастройки.Вставить("ВремяСтратаБлокировки", ПараметрыКоманды["-lockstart"]);
	мНастройки.Вставить("ВремяСтратаБлокировкиЧерез", ПараметрыКоманды["-lockstartat"]);
	
	
	мНастройки.Вставить("Действие", ПараметрыКоманды["Действие"]);
	
	//Получим путь к платформе если вдруг не установленна
	мНастройки.ПутьКлиентаАдминистрирования = ПолучитьПутьКRAC(мНастройки.ПутьКлиентаАдминистрирования, мНастройки.ИспользуемаяВерсияПлатформы);
	Если ПустаяСтрока(мНастройки.АдресСервераАдминистрирования) Тогда
		мНастройки.АдресСервераАдминистрирования = "localhost:1545";
	КонецЕсли;
	
КонецПроцедуры

Функция ПараметрыВведеныКорректно()
	
	Успех = Истина;
	
	Если Не ЗначениеЗаполнено(мНастройки.АдресСервераАдминистрирования) Тогда
		Лог.Ошибка("Не указан сервер администрирования");
		Успех = Ложь;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(мНастройки.ПутьКлиентаАдминистрирования) Тогда
		Лог.Ошибка("Не указан клиент администрирования");
		Успех = Ложь;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(мНастройки.ИмяБазыДанных) Тогда
		Лог.Ошибка("Не указано имя базы данных");
		Успех = Ложь;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(мНастройки.Действие) Тогда
		Лог.Ошибка("Не указано действие lock/unlock");
		Успех = Ложь;
	КонецЕсли;
	
	Возврат Успех;
	
КонецФункции

/////////////////////////////////////////////////////////////////////////////////
// Взаимодействие с кластером

Процедура УдалитьВсеСеансыИСоединенияБазы()
	
	УстановитьСтатусБлокировкиСеансов(Истина);
	ОтключитьСуществующиеСеансы();
	Приостановить(500);
	Сеансы = ПолучитьСписокСеансов();
	
	Если Сеансы.Количество() Тогда
		Лог.Информация("Пауза перед отключением соединений");
		Приостановить(10000);
		ОтключитьСоединенияСРабочимиПроцессами();
	КонецЕсли;
	
КонецПроцедуры

Процедура УстановитьСтатусБлокировкиСеансов(Знач Блокировать)
	
	КлючиАвторизацииВБазе = КлючиАвторизацииВБазе();
	
	ИдентификаторКластера = ИдентификаторКластера();
	ИдентификаторБазы = ИдентификаторБазы();
	
	КлючРазрешенияЗапуска = ?(ПустаяСтрока(мНастройки.КлючРазрешенияЗапуска), ИдентификаторБазы, мНастройки.КлючРазрешенияЗапуска);
	ВремяБлокировки = мНастройки.ВремяСтратаБлокировки;
	Если ПустаяСтрока(ВремяБлокировки) И Не ПустаяСтрока(мНастройки.ВремяСтратаБлокировкиЧерез) Тогда
		Секунды = 0;
		Попытка
			Секунды = Число(мНастройки.ВремяСтратаБлокировкиЧерез);
		Исключение
		КонецПопытки;
		
		ВремяБлокировки = Формат(ТекущаяДата()+Секунды,"ДФ='yyyy-MM-ddTHH:mm:ss'");
	КонецЕсли;
	
	КомандаВыполнения = СтрокаЗапускаКлиента() + СтрШаблон("infobase update --infobase=""%3""%4 --cluster=""%1""%2 --sessions-deny=%5 --denied-message=""%6"" --denied-from=""%8"" --permission-code=""%7""",
	ИдентификаторКластера,
	КлючиАвторизацииВКластере(),
	ИдентификаторБазы,
	КлючиАвторизацииВБазе,
	?(Блокировать, "on", "off"), 
	мНастройки.СообщениеОблокировке, 
	КлючРазрешенияЗапуска, 
	ВремяБлокировки);
	
	ЗапуститьПроцесс(КомандаВыполнения);
	
	Лог.Информация("Сеансы " + ?(Блокировать, "запрещены", "разрешены"));
	
КонецПроцедуры

Функция КлючиАвторизацииВБазе()
	КлючиАвторизацииВБазе = "";
	Если ЗначениеЗаполнено(мНастройки.АдминистраторИБ) Тогда
		КлючиАвторизацииВБазе = КлючиАвторизацииВБазе + СтрШаблон(" --infobase-user=""%1""", мНастройки.АдминистраторИБ);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(мНастройки.ПарольАдминистратораИБ) Тогда
		КлючиАвторизацииВБазе = КлючиАвторизацииВБазе + СтрШаблон(" --infobase-pwd=""%1""", мНастройки.ПарольАдминистратораИБ);
	КонецЕсли;
	
	Возврат КлючиАвторизацииВБазе;
	
КонецФункции


Функция ИдентификаторКластера()
	
	Если мИдентификаторКластера = Неопределено Тогда
		Лог.Информация("Получаю список кластеров");
		
		КомандаВыполнения = СтрокаЗапускаКлиента() + "cluster list";
		
		СписокКластеров = ЗапуститьПроцесс(КомандаВыполнения);
		
		УИДКластера = Сред(СписокКластеров,(Найти(СписокКластеров,":")+1),Найти(СписокКластеров,"host")-Найти(СписокКластеров,":")-1);
		Если ЗначениеЗаполнено(мНастройки.ПортКластера) Тогда			
			ВремСписокКластеров = СписокКластеров;
			Пока Найти(ВремСписокКластеров,"cluster") Цикл
				
				ВремСписокКластеров = Сред(ВремСписокКластеров,Найти(ВремСписокКластеров,"cluster")+7 );	
				cluster =  СокрЛП(СтрЗаменить(Сред(ВремСписокКластеров,(Найти(ВремСписокКластеров,":")+1),Найти(ВремСписокКластеров,"host")-Найти(ВремСписокКластеров,":")-1),Символы.ПС,""));				
				ВремСписокКластеров = Сред(ВремСписокКластеров, (Найти(ВремСписокКластеров,":")+1)+ СтрДлина(cluster));
				
				ВремСписокКластеров = Сред(ВремСписокКластеров,Найти(ВремСписокКластеров,"port")+4);			
				port     =  СокрЛП(СтрЗаменить(Сред(ВремСписокКластеров,(Найти(ВремСписокКластеров,":")+1),Найти(ВремСписокКластеров,"name")-Найти(ВремСписокКластеров,":")-1),Символы.ПС,""));				
				ВремСписокКластеров = Сред(ВремСписокКластеров, (Найти(ВремСписокКластеров,":")+1)+ СтрДлина(port));
				
				Если port = мНастройки.ПортКластера Тогда			
					УИДКластера = cluster;				
					Прервать;								
				КонецЕсли;
			КонецЦикла;			
		КонецЕсли;	
		
		мИдентификаторКластера = СокрЛП(СтрЗаменить(УИДКластера,Символы.ПС,""));
		
	КонецЕсли;
	
	Если ПустаяСтрока(мИдентификаторКластера) Тогда
		ВызватьИсключение "Кластер серверов отсутствует";
	КонецЕсли;
	
	Возврат мИдентификаторКластера;
	
КонецФункции

Функция ИдентификаторБазы()
	Если мИдентификаторБазы = Неопределено Тогда
		мИдентификаторБазы = НайтиБазуВКластере();
	КонецЕсли;
	
	Возврат мИдентификаторБазы;
КонецФункции

Функция НайтиБазуВКластере()
	
	КомандаВыполнения = СтрокаЗапускаКлиента() + СтрШаблон("infobase summary list --cluster=""%1""%2",
	ИдентификаторКластера(), 
	КлючиАвторизацииВКластере());
	
	Лог.Информация("Получаю список баз кластера");
	
	СписокБазВКластере = ЗапуститьПроцесс(КомандаВыполнения);    
	ЧислоСтрок = СтрЧислоСтрок(СписокБазВКластере);
	НайденаБазаВКластере = Ложь;
	Для К = 1 По ЧислоСтрок Цикл
		
		СтрокаРазбора = СтрПолучитьСтроку(СписокБазВКластере,К);   
		ПозицияРазделителя = Найти(СтрокаРазбора,":");
		Если Найти(СтрокаРазбора,"infobase")>0 Тогда						
			УИДИБ =  СокрЛП(Сред(СтрокаРазбора,ПозицияРазделителя+1));	
		ИначеЕсли Найти(СтрокаРазбора,"name")>0 Тогда 
			ИмяБазы = СокрЛП(Сред(СтрокаРазбора,ПозицияРазделителя+1));
			Если Нрег(ИмяБазы) = НРег(мНастройки.ИмяБазыДанных) Тогда
				Лог.Информация("Получен УИД базы");
				НайденаБазаВКластере = Истина;
				Прервать;
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	Если Не НайденаБазаВКластере Тогда
		ВызватьИсключение "База "+мНастройки.ИмяБазыДанных +" не найдена в кластере";
	КонецЕсли;
	
	Возврат УИДИБ;
	
КонецФункции

Функция КлючиАвторизацииВКластере()
	КомандаВыполнения = "";
	Если ЗначениеЗаполнено(мНастройки.АдминистраторКластера) Тогда
		КомандаВыполнения = КомандаВыполнения + СтрШаблон(" --cluster-user=""%1""", мНастройки.АдминистраторКластера);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(мНастройки.ПарольАдминистратораКластера) Тогда
		КомандаВыполнения = КомандаВыполнения + СтрШаблон(" --cluster-pwd=""%1""", мНастройки.ПарольАдминистратораКластера);
	КонецЕсли;
	Возврат КомандаВыполнения;
КонецФункции

Функция СтрокаЗапускаКлиента()
	Перем ПутьКлиентаАдминистрирования;
	Если ЭтоWindows Тогда 
		ПутьКлиентаАдминистрирования = ЗапускПриложений.ОбернутьВКавычки(мНастройки.ПутьКлиентаАдминистрирования);
	Иначе
		ПутьКлиентаАдминистрирования = мНастройки.ПутьКлиентаАдминистрирования;
	КонецЕсли;
	
	Возврат  ПутьКлиентаАдминистрирования + " " + 
	мНастройки.АдресСервераАдминистрирования + " "; 
КонецФункции

Функция ЗапуститьПроцесс(Знач СтрокаВыполнения)
	Перем ПаузаОжиданияЧтенияБуфера;
	
	ПаузаОжиданияЧтенияБуфера = 10;
	
	Лог.Отладка(СтрокаВыполнения);
	Процесс = СоздатьПроцесс(СтрокаВыполнения,,Истина);
	Процесс.Запустить();
	
	ТекстБазовый = "";
	Счетчик = 0; МаксСчетчикЦикла = 100000;
	
	Пока Истина Цикл 
		Текст = Процесс.ПотокВывода.Прочитать();
		Лог.Отладка("Цикл ПотокаВывода "+Текст);
		Если Текст = Неопределено ИЛИ ПустаяСтрока(СокрЛП(Текст))  Тогда 
			Прервать;
		КонецЕсли;
		Счетчик = Счетчик + 1;
		Если Счетчик > МаксСчетчикЦикла Тогда 
			Прервать;
		КонецЕсли;
		ТекстБазовый = ТекстБазовый + Текст;
		
		sleep(ПаузаОжиданияЧтенияБуфера); //Подождем, надеюсь буфер не переполнится. 
		
	КонецЦикла;
	
	Процесс.ОжидатьЗавершения();
	
	Если Процесс.КодВозврата = 0 Тогда
		Текст = Процесс.ПотокВывода.Прочитать();
		ТекстБазовый = ТекстБазовый + Текст;
		Лог.Отладка(ТекстБазовый);
		Возврат ТекстБазовый;
	Иначе
		ВызватьИсключение "Сообщение от RAS/RAC 
		|" + Процесс.ПотокОшибок.Прочитать();
	КонецЕсли;	
	
КонецФункции

Процедура ОтключитьСуществующиеСеансы()
	
	Лог.Информация("Отключаю существующие сеансы");
	
	СеансыБазы = ПолучитьСписокСеансов();
	Для Каждого Сеанс Из СеансыБазы Цикл
		Попытка
			ОтключитьСеанс(Сеанс);
		Исключение
			Лог.Ошибка(ОписаниеОшибки());
		КонецПопытки;
	КонецЦикла;
	
КонецПроцедуры

Функция ПолучитьСписокСеансов()
	
	ТаблицаСеансов = Новый ТаблицаЗначений;
	ТаблицаСеансов.Колонки.Добавить("Идентификатор");
	ТаблицаСеансов.Колонки.Добавить("Приложение");
	ТаблицаСеансов.Колонки.Добавить("Пользователь");
	ТаблицаСеансов.Колонки.Добавить("НомерСеанса");
	
	КомандаЗапуска = СтрокаЗапускаКлиента() + СтрШаблон("session list --cluster=""%1""%2 --infobase=""%3""",
	ИдентификаторКластера(), 
	КлючиАвторизацииВКластере(),
	ИдентификаторБазы());
	
	СписокСеансовИБ = ЗапуститьПроцесс(КомандаЗапуска);	
	
	Данные = РазобратьПоток(СписокСеансовИБ);
	
	Для Каждого Элемент Из Данные Цикл
		
		ТекСтрока = ТаблицаСеансов.Добавить();
		ТекСтрока.Идентификатор = Элемент["session"];
		ТекСтрока.Пользователь  = Элемент["user-name"];
		ТекСтрока.Приложение    = Элемент["app-id"];
		ТекСтрока.НомерСеанса   = Элемент["session-id"];
		
	КонецЦикла;
	
	Возврат ТаблицаСеансов;
	
КонецФункции

Процедура ОтключитьСеанс(Знач Сеанс)
	
	СтрокаВыполнения = СтрокаЗапускаКлиента() + СтрШаблон("session terminate --cluster=""%1""%2 --session=""%3""",
	ИдентификаторКластера(),
	КлючиАвторизацииВКластере(),
	Сеанс.Идентификатор);
	
	Лог.Информация(СтрШаблон("Отключаю сеанс: %1 [%2] (%3)", Сеанс.НомерСеанса, Сеанс.Пользователь, Сеанс.Приложение));
	
	ЗапуститьПроцесс(СтрокаВыполнения);
	
КонецПроцедуры

Функция ОтключитьСоединенияСРабочимиПроцессами()
	
	Процессы = ПолучитьСписокРабочихПроцессов();
	
	Для Каждого РабочийПроцесс Из Процессы Цикл
		Если РабочийПроцесс["running"] = "yes" Тогда
			
			СписокСоединений = ПолучитьСоединенияРабочегоПроцесса(РабочийПроцесс);
			Для Каждого Соединение Из СписокСоединений Цикл
				
				Попытка
					РазорватьСоединениеСПроцессом(РабочийПроцесс, Соединение);
				Исключение
					Лог.Ошибка(ОписаниеОшибки());
				КонецПопытки;
				
			КонецЦикла;
			
		КонецЕсли;
	КонецЦикла;
	
КонецФункции

Функция ПолучитьСписокРабочихПроцессов()
	
	КомандаЗапускаПроцессы = СтрокаЗапускаКлиента() + СтрШаблон("process list --cluster=""%1""%2",
	ИдентификаторКластера(), 
	КлючиАвторизацииВКластере());
	
	Лог.Информация("Получаю список рабочих процессов...");
	СписокПроцессов = ВыполнитьКоманду(КомандаЗапускаПроцессы);
	
	Возврат РазобратьПоток(СписокПроцессов);
	
КонецФункции

Функция ПолучитьСоединенияРабочегоПроцесса(Знач РабочийПроцесс)
	
	КомандаЗапускаСоединения = СтрокаЗапускаКлиента() + СтрШаблон("connection list --cluster=""%1""%2 --infobase=%3%4 --process=%5",
	ИдентификаторКластера(), 
	КлючиАвторизацииВКластере(),
	ИдентификаторБазы(),
	КлючиАвторизацииВБазе(),
	РабочийПроцесс["process"]);
	
	Лог.Информация("Получаю список соединений...");
	Возврат РазобратьПоток(ВыполнитьКоманду(КомандаЗапускаСоединения));
	
КонецФункции

Функция РазорватьСоединениеСПроцессом(Знач РабочийПроцесс, Знач Соединение)
	
	КомандаРазрывСоединения = СтрокаЗапускаКлиента() + СтрШаблон("connection disconnect --cluster=""%1""%2 --infobase=%3%4 --process=%5 --connection=%6",
	ИдентификаторКластера(), 
	КлючиАвторизацииВКластере(),
	ИдентификаторБазы(),
	КлючиАвторизацииВБазе(),
	РабочийПроцесс["process"],
	Соединение["connection"]);
	
	Сообщение = СтрШаблон("Отключаю соединение %1 [%2] (%3)",
	Соединение["conn-id"],
	Соединение["app-id"],
	Соединение["user-name"]);
	
	Лог.Информация(Сообщение);
	
	Возврат ВыполнитьКоманду(КомандаРазрывСоединения);
	
КонецФункции

Функция РазобратьПоток(Знач Поток) Экспорт
	
	ТД = Новый ТекстовыйДокумент;
	ТД.УстановитьТекст(Поток);
	
	СписокОбъектов = Новый Массив;
	ТекущийОбъект = Неопределено;
	
	Для Сч = 1 По ТД.КоличествоСтрок() Цикл
		
		Текст = ТД.ПолучитьСтроку(Сч);
		Если ПустаяСтрока(Текст) или ТекущийОбъект = Неопределено Тогда
			Если ТекущийОбъект <> Неопределено и ТекущийОбъект.Количество() = 0 Тогда
				Продолжить; // очередная пустая строка подряд
			КонецЕсли;
			
			ТекущийОбъект = Новый Соответствие;
			СписокОбъектов.Добавить(ТекущийОбъект);
		КонецЕсли;
		
		СтрокаРазбораИмя      = "";
		СтрокаРазбораЗначение = "";
		
		Если РазобратьНаКлючИЗначение(Текст, СтрокаРазбораИмя, СтрокаРазбораЗначение) Тогда
			ТекущийОбъект[СтрокаРазбораИмя] = СтрокаРазбораЗначение;
		КонецЕсли;
		
	КонецЦикла;
	
	Если ТекущийОбъект <> Неопределено и ТекущийОбъект.Количество() = 0 Тогда
		СписокОбъектов.Удалить(СписокОбъектов.ВГраница());
	КонецЕсли; 
	
	Возврат СписокОбъектов;
	
КонецФункции

Функция ПолучитьПутьКRAC(ТекущийПуть, Знач ВерсияПлатформы="")
	
	Если НЕ ПустаяСтрока(ТекущийПуть) Тогда 
		ФайлУтилиты = Новый Файл(ТекущийПуть);
		Если ФайлУтилиты.Существует() Тогда 
			Лог.Отладка("Текущая версия rac "+ФайлУтилиты.ПолноеИмя);
			Возврат ФайлУтилиты.ПолноеИмя;
		КонецЕсли;
	КонецЕсли;
	
	Если ПустаяСтрока(ВерсияПлатформы) Тогда 
		ВерсияПлатформы="8.3";
	КонецЕсли;
	
	Конфигуратор = Новый УправлениеКонфигуратором;
	ПутьКПлатформе = Конфигуратор.ПолучитьПутьКВерсииПлатформы(ВерсияПлатформы);
	Лог.Отладка("Используемый путь для поиска rac "+ПутьКПлатформе);
	КаталогУстановки = Новый Файл(ПутьКПлатформе);
	Лог.Отладка(КаталогУстановки.Путь);
	
	
	ИмяФайла = ?(ЭтоWindows, "rac.exe", "rac");
	
	ФайлУтилиты = Новый Файл(ОбъединитьПути(Строка(КаталогУстановки.Путь), ИмяФайла));
	Если ФайлУтилиты.Существует() Тогда 
		Лог.Отладка("Текущая версия rac "+ФайлУтилиты.ПолноеИмя);
		Возврат ФайлУтилиты.ПолноеИмя;
	КонецЕсли;
	
	Возврат ТекущийПуть;
	
КонецФункции

Функция РазобратьНаКлючИЗначение(Знач СтрокаРазбора, Ключ, Значение)
	
	ПозицияРазделителя = Найти(СтрокаРазбора,":");
	Если ПозицияРазделителя = 0 Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Ключ     = СокрЛП(Лев(СтрокаРазбора,ПозицияРазделителя-1));
	Значение = СокрЛП(Сред(СтрокаРазбора,ПозицияРазделителя+1));
	
	Возврат Истина;
	
КонецФункции

/////////////////////////////////////////////////////////////////////////////////
СистемнаяИнформация = Новый СистемнаяИнформация;
ЭтоWindows = Найти(НРег(СистемнаяИнформация.ВерсияОС), "windows") > 0;
Лог = Логирование.ПолучитьЛог("vanessa.app.deployka");