# Миграции

Узнайте, как можно постепенно перевести существующий Angular-проект на использование новейших возможностей.

<docs-card-container>
  <docs-card title="Standalone" link="Мигрировать" href="reference/migrations/standalone">
    Standalone-компоненты предоставляют упрощенный способ создания приложений Angular. Standalone-компоненты указывают свои зависимости напрямую, вместо того чтобы получать их через NgModules.
  </docs-card>
  <docs-card title="Синтаксис управления потоком" link="Мигрировать" href="reference/migrations/control-flow">
    Встроенный синтаксис управления потоком позволяет использовать более эргономичный синтаксис, близкий к JavaScript и обладающий лучшей проверкой типов. Он заменяет необходимость импорта `CommonModule` для использования таких функций, как `*ngFor`, `*ngIf` и `*ngSwitch`.
  </docs-card>
  <docs-card title="Функция inject()" link="Мигрировать" href="reference/migrations/inject-function">
    Функция `inject` в Angular предлагает более точные типы и лучшую совместимость со стандартными декораторами по сравнению с внедрением через конструктор.
  </docs-card>
  <docs-card title="Ленивая загрузка маршрутов" link="Мигрировать" href="reference/migrations/route-lazy-loading">
    Преобразуйте маршруты компонентов с немедленной загрузкой в маршруты с ленивой загрузкой. Это позволяет процессу сборки разделять производственные бандлы на более мелкие части, чтобы загружать меньше JavaScript при начальной загрузке страницы.
  </docs-card>
  <docs-card title="Новый API input()" link="Мигрировать" href="reference/migrations/signal-inputs">
    Преобразуйте существующие поля `@Input` в новый API сигнальных input-ов, который теперь готов к использованию в продакшене.
  </docs-card>
  <docs-card title="Новая функция output()" link="Мигрировать" href="reference/migrations/outputs">
    Преобразуйте существующие пользовательские события `@Output` в новую функцию output, которая теперь готова к использованию в продакшене.
  </docs-card>
  <docs-card title="Запросы как сигналы" link="Мигрировать" href="reference/migrations/signal-queries">
    Преобразуйте существующие поля запросов с декораторами в улучшенный API сигнальных запросов. Этот API теперь готов к использованию в продакшене.
  </docs-card>
  <docs-card title="Очистка неиспользуемых импортов" link="Попробовать" href="reference/migrations/cleanup-unused-imports">
    Удалите неиспользуемые импорты в вашем проекте.
  </docs-card>
  <docs-card title="Самозакрывающиеся теги" link="Мигрировать" href="reference/migrations/self-closing-tags">
    Преобразуйте шаблоны компонентов для использования самозакрывающихся тегов, где это возможно.
  </docs-card>
  <docs-card title="NgClass в привязку классов" link="Мигрировать" href="reference/migrations/ngclass-to-class">
      Преобразуйте шаблоны компонентов, отдавая предпочтение привязке классов вместо директивы `NgClass`, где это возможно.
  </docs-card>
  <docs-card title="NgStyle в привязку стилей" link="Мигрировать" href="reference/migrations/ngstyle-to-style">
      Преобразуйте шаблоны компонентов, отдавая предпочтение привязке стилей вместо директивы `NgStyle`, где это возможно.
  </docs-card>
  <docs-card title="Миграция RouterTestingModule" link="Мигрировать" href="reference/migrations/router-testing-module-migration">
    Замените использование `RouterTestingModule` на `RouterModule` в конфигурациях TestBed и добавьте `provideLocationMocks()`, где это необходимо.
  </docs-card>
  <docs-card title="CommonModule в standalone-импорты" link="Мигрировать" href="reference/migrations/common-to-standalone">
    Замените импорт `CommonModule` на импорт отдельных директив и пайпов, используемых в шаблонах, где это возможно.
  </docs-card>
</docs-card-container>
