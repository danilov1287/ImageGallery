# ImageGallery

Галерея изображений с загрузкой из Openverse API, кэшированием и локальным хранением в Core Data. Реализована по VIP-архитектуре, UI на UIKit.

## Особенности

- Загрузка изображений через Openverse API.
- Локальное хранение избранных изображений в Core Data.
- Кэш изображений через Kingfisher.
- VIP-архитектура (View, Interactor, Presenter, Router).

## Установка

1. Клонируйте репозиторий:
   ```bash
   git clone https://github.com/danilov1287/ImageGallery.git
   cd ImageGallery
2. Установите зависимость Kingfisher через File / Add Package Dependency 
https://github.com/onevcat/Kingfisher.git
3. Перейти в раздел "Настройки" и сохранить ключ(в основную часть приложения данные подтягиваются из локальной БД)
ключ можно сохранить как есть или использовать свой - получить его можно по инструкции здесь:
https://api.openverse.org/v1/#tag/auth/operation/register

## Скриншоты/гифка для демонстрации работы приложения
Пример работы приложения
https://drive.google.com/file/d/1XLzCnHmgfJmZ1TrhJbKNh_xOExm2JzK2/view?usp=drive_link
(весит 6 mb легка версия есть в презентации)

## Презентация проектной работы
Находится по адресу:
https://docs.google.com/presentation/d/1SuvP_rzonLRVWnhdSuiJvnxep6ZllpnZ/edit?usp=drive_link&ouid=114677136123466396953&rtpof=true&sd=true

## Сопроводительные материалы к перезентации
по адресу:
https://docs.google.com/document/d/12z8g9w0QFYL80w-QFnT57xkez8I6DtD8OqQ6GvUWq3Y/edit?usp=drive_link