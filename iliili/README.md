#  или или

Игра, где пользователю предлагается два противоположных варианта, из которых необходимо выбрать один.

## TODO:

- [x] Вопросы из Struct -> JSON, например
- [x] Запрос к серверу для получения списка вопросов
    - [x] При отсутствии интернета загружать базовый набор вопросов ИЛИ сделать один запрос, чтобы скачать все вопросы на устройство?
- [x] Full screen
- [x] Show the main view as it used to be shown
- [x] The initial loading ("Start" pressed -> show the questions) is long, what can I do about it?
- [ ] Getting %
    - [x] Write to the json on the server (if connected)
    - [ ] How do I check if this specific user has already chosen an option (using Firebase databases maybe?)
    - [x] Fix the json, add the % section. Get the %
    - [x] Fix the extra vote on the first call of getNewQuestion
    - [ ] Show animated view with %
- [ ] Getting the questions to a local variable
- [ ] Check if works without connection
- [ ] Show the new question after the votes result animation 

## Optional:

- [ ] Возможность добавлять свои варианты (UI, куда прикрутить такую кнопку?) для одобрения модератором
