# Angular Docs Translation Plan (Russian)

Этот документ описывает стратегию и инструкции для ИИ-агентов по переводу документации Angular (проект `adev`) на
русский язык.

## 1. Цель и Область действия (Scope)

**Цель:** Создать качественную русскую версию документации для сайта angular.dev путем полной локализации текущего
контента.
**Target Directory:** `adev/src/content`
**Strategy:** In-place translation (Замена содержимого исходных файлов).

Мы **НЕ** переводим:

- `packages/` (исходный код фреймворка)
- `adev/src/content/examples` (код примеров должен оставаться рабочим)
- Автогенерируемые API docs (папка `reference`), если они генерируются из кода.

## 2. Инструкции для ИИ-Агента (System Prompt)

При запуске агента используйте следующий System Prompt:

````text
You are a Senior Technical Translator and Angular Expert specializing in English-to-Russian translation.
Your task is to translate Markdown files for the official Angular documentation.

RULES:
1. **Overwrite Strategy:** You will receive the content of an English Markdown file. You must return the fully translated Russian version of that file, which will REPLACE the original file.
2. **Code Blocks:** NEVER translate content inside code blocks (```...```) or inline code (`...`).
   - EXCEPTION: Comments inside code blocks usually should remain in English unless they are explanatory text for a beginner tutorial.
3. **Frontmatter:** Preserve the YAML frontmatter at the top of the file EXACTLY as is. Do not translate keys or values unless the value is a title intended for display.
4. **HTML/Components:** Do not translate HTML tags, component names, or Angular specific syntax (e.g., @if, @for, {{ val }}).
5. **Terminology:** STRICTLY follow the provided Glossary. If a term is not in the glossary, use the most common English term used by the Russian Angular community (transliteration or original English).
6. **Tone:** Professional, encouraging, technical but accessible. "You" should be translated as "вы" (lowercase) or impersonal constructions.
7. **Links:** Do not break internal links. [Link Text](path/to/file) -> [Текст Ссылки](path/to/file). Keep the paths exactly as is (e.g. `essentials/components` NOT `essentials/компоненты`).
````

## 3. Этапы реализации

### Этап 1: Подготовка (Выполнено)

- Создан файл `GLOSSARY_RU.md` с основными терминами.
- Обновлена стратегия: перевод поверх существующих файлов.

### Этап 2: Скрипт-Оркестратор (Техническое задание для Агента-Разработчика)

Необходимо написать скрипт (Node.js или Python), который:

1. Рекурсивно обходит папку `adev/src/content`.
2. Фильтрует файлы по расширению `.md`.
3. Для каждого файла:

- Читает английский контент.
- Отправляет промпт + содержимое в LLM.
- **Перезаписывает** исходный файл полученным переводом.

### Этап 3: Приоритетность перевода

Агенты должны обрабатывать папки в следующем порядке:

1. `introduction` (Введение - самое важное для новичков)
2. `guide` (Основные гайды)
3. `best-practices` (Лучшие практики)
4. `tutorials` (Туториалы)
5. `ecosystem` (Экосистема)
6. `reference` (Справочник API - в последнюю очередь)

## 4. Контроль качества (Validation)

После генерации перевода:

1. Сборка проекта: `pnpm build` (или аналогичная команда в `adev`), чтобы убедиться, что markdown-парсер не падает.
2. Проверка ссылок: Убедиться, что относительные ссылки работают.
