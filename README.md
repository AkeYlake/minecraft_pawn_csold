# minecraft_pawn_csold
Майнкрафт блоки с правильной постановкой.
Тестировал на amxmodx 1.9.0, но должно работать и на 1.8.2

Видео демонстрация https://youtu.be/irX7buhFVeM

ВАЖНО!!! использует натив jbe_get_chief_id()
Т.к. разрабатывался для jail мода, НО любой человек +- поверхностными знаниями скриптинга исправит это и сделает как надо.

Все функции без натива, сделал по командам в консоль.
Блоками пользоваться может только начальник.

Команды:
block - поставить блок
delete - удалить блок
ChooseBlock - открыть меню выбора блока
BlockMenu - Меню блоков(Само меню которое включает весь функционал)

Сама моделька блока 1,но с 12 скинами - все ради оптимизации)0))
В ланг документе можно даже скобочки которые вокруг циферок поменять
Правда в недоступном пункте # вместо циферки поставить нельзя.

Установка:
Закинуть архив на сервер(В папочку cstrike)
В plugins.ini прописать minecraft.amxx
Находится он addons/amxmodx/config/plugins.ini

Ланг документ находиться по пути addons/amxmodx/data/lang/minecraft.txt
