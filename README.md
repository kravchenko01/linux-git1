# linux-git1

## process.sh
Скрипт process.sh на вход принимает путь к датасету hotels.csv.
Поля датасета: doc_id,hotel_name,hotel_url,street,city,state, country,zip,class,price,num_reviews,CLEANLINESS,ROOM,SERVICE,LOCATION,VALUE,COMFORT,overall_ratingsource.
Скрипт выводит:
- Средний рейтинг (overall_ratingsource)
- Число отелей в каждой стране
- Средний балл cleanliness по стране (колонка cleanliness) для отелей сети Holiday Inn vs. отелей Hilton
- Строит график зависимости чистоты (CLEANLINESS) от общей оценки (overal_ratingsource) и сохратяет в файл cleanliness_vs_overalRatingSource.png 

## pulls.sh
Скрипт pulls.sh на вход принимает GitHub ник ученика и выводит:
- Число всех (закрытых и открытых) пулл-реквестов, которые этот пользователь сделал в репо datamove/linux-git2
- Номер самого раннего (первого) пулл-реквеста этого пользователя, независимо от статуса пулл-реквеста
- Бинарный флаг MERGED, =1, если этот самый ранний пулл-реквест смержен, иначе =0

## project2
Проект 2 - автоматизация обучения и тестирования модели
