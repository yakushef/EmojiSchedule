### Playful Tasks - таск-лист на день

Проект сделан чтобы на практике освоить работу с UITableView, а затем и Realm.
В будущем я планирую провести рефакторинг на архитектуру MVVM, добавить возможность облачной синхронизации и реализовать реактивный интерфейс на Combine или RxSwift.

### О чем проект

Приложение работает на устройствах с iOS 13 и выше, ориентация экрана - портретная, без поддержки поворотов экрана. 
Поддерживается темная тема. 

При запуске показывается главный экран со списком задач на день. В конце каждого дня вычеркнутые задачи удаляются:

<img src="https://github.com/yakushef/EmojiSchedule/blob/28de79540b9194a434069d32e690f304dd563441/VisualScheduleApp/Screenshots/Simulator%20Screenshot%20-%20iPhone%2015%20Pro%20-%202023-12-16%20at%2021.57.55.png" width="250"> <img src="https://github.com/yakushef/EmojiSchedule/blob/e7fce54674fc01416dcf8d23571c76318556d200/VisualScheduleApp/Screenshots/Simulator%20Screenshot%20-%20iPhone%2015%20Pro%20-%202023-12-16%20at%2021.57.13.png" width="250">

При создании задачи можно добавить emoji как визульный символ, подробное описание и список подзадач. Цвет для задачи подбирается исходя из палитры эмодзи - близкий или комплиментарный к преобладающему в палитре. Отмеченный важными задачи выделяются цветовой заливкой: 

<img src="https://github.com/yakushef/EmojiSchedule/blob/e7fce54674fc01416dcf8d23571c76318556d200/VisualScheduleApp/Screenshots/Simulator%20Screenshot%20-%20iPhone%2015%20Pro%20-%202023-12-16%20at%2021.51.39.png" width="250"> <img src="https://github.com/yakushef/EmojiSchedule/blob/e7fce54674fc01416dcf8d23571c76318556d200/VisualScheduleApp/Screenshots/Simulator%20Screenshot%20-%20iPhone%2015%20Pro%20-%202023-12-16%20at%2021.54.58.png" width="250">

Можно удалить любую задачу в списке, отредактировать все ее поля, изменить порядок задач (и, конечно, отметить задачу или подзадачу как выполненную):

<img src="https://github.com/yakushef/EmojiSchedule/blob/e7fce54674fc01416dcf8d23571c76318556d200/VisualScheduleApp/Screenshots/Simulator%20Screenshot%20-%20iPhone%2015%20Pro%20-%202023-12-16%20at%2021.56.29.png" width="250"> <img src="https://github.com/yakushef/EmojiSchedule/blob/e7fce54674fc01416dcf8d23571c76318556d200/VisualScheduleApp/Screenshots/Simulator%20Screenshot%20-%20iPhone%2015%20Pro%20-%202023-12-16%20at%2021.57.25.png" width="250">

### Как написан проект
- Приложение выполнено с использованием фраемворков UIKit, ColorKit, MCEmojiPicker
- Архитектура MVC, для хранения данных используется Realm
- UI сверстан на XIB и Storyboard
