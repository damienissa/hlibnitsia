#!/bin/bash

set -e  # Зупинити скрипт у разі помилки

# Функція для інкрементації build number
increment_build_number() {
  # Зчитуємо версію з pubspec.yaml
  version_line=$(grep "^version:" pubspec.yaml)
  version=$(echo $version_line | cut -d " " -f 2)
  version_name=$(echo $version | cut -d "+" -f 1)
  build_number=$(echo $version | cut -d "+" -f 2)

  # Інкрементуємо build number
  new_build_number=$((build_number + 1))
  new_version="$version_name+$new_build_number"

  # Оновлюємо pubspec.yaml
  sed -i "s/^version: .*/version: $new_version/" pubspec.yaml
  echo "Updated version to $new_version"
}

# Інкрементуємо номер білду
increment_build_number

# Додаємо зміни в git
git add pubspec.yaml
git commit -m "chore: Bump version"
git tag "v$(grep '^version:' pubspec.yaml | cut -d " " -f 2)"

# Будуємо веб-додаток
flutter build web

# Деплоїмо на Firebase
firebase deploy --only hosting

# Виводимо повідомлення про успішний деплой
echo "Successfully deployed new version to Firebase!"
