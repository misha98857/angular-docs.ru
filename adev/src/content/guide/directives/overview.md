<docs-decorative-header title="Встроенные директивы" imgSrc="adev/src/assets/images/directives.svg"> <!-- markdownlint-disable-line -->
Директивы — это классы, которые добавляют дополнительное поведение к элементам в ваших приложениях Angular.
</docs-decorative-header>

Используйте встроенные директивы Angular для управления формами, списками, стилями и тем, что видят пользователи.

Различные типы директив Angular:

| Directive Types                                                  | Details                                                                         |
|:-----------------------------------------------------------------|:--------------------------------------------------------------------------------|
| [Компоненты](guide/components)                                   | Используются с шаблоном. Этот тип директивы является наиболее распространенным. |
| [Директивы атрибутов](#built-in-attribute-directives)            | Изменяют внешний вид или поведение элемента, компонента или другой директивы.   |
| [Структурные директивы](/guide/directives/structural-directives) | Изменяют макет DOM, добавляя и удаляя элементы DOM.                             |

В этом руководстве рассматриваются встроенные [директивы атрибутов](#built-in-attribute-directives).

## Встроенные директивы атрибутов

Директивы атрибутов прослушивают и изменяют поведение других элементов HTML, атрибутов, свойств и компонентов.

Наиболее распространенные директивы атрибутов:

| Common directives                                      | Details                                                       |
|:-------------------------------------------------------|:--------------------------------------------------------------|
| [`NgClass`](#adding-and-removing-classes-with-ngclass) | Добавляет и удаляет набор CSS классов.                        |
| [`NgStyle`](#setting-inline-styles-with-ngstyle)       | Добавляет и удаляет набор стилей HTML.                        |
| [`NgModel`](guide/forms/template-driven-forms)         | Добавляет двустороннюю привязку данных к элементу формы HTML. |

HELPFUL: Встроенные директивы используют только публичные API. У них нет специального доступа к каким-либо приватным
API, к которым другие директивы не могут получить доступ.

## Добавление и удаление классов с помощью `NgClass`

Добавляйте или удаляйте несколько классов CSS одновременно с помощью `ngClass`.

HELPFUL: Чтобы добавить или удалить _один_ класс, используйте [привязку класса](guide/templates/class-binding) вместо
`NgClass`.

### Импорт `NgClass` в компонент

Чтобы использовать `NgClass`, добавьте его в список `imports` компонента.

<docs-code header="app.component.ts (NgClass import)" path="adev/src/content/examples/built-in-directives/src/app/app.component.ts" visibleRegion="import-ng-class"/>

### Использование `NgClass` с выражением

На элементе, который вы хотите стилизовать, добавьте `[ngClass]` и установите его равным выражению.
В этом случае `isSpecial` — это булево значение, установленное в `true` в `app.component.ts`.
Поскольку `isSpecial` истинно, `ngClass` применяет класс `special` к `<div>`.

<docs-code header="app.component.html" path="adev/src/content/examples/built-in-directives/src/app/app.component.html" visibleRegion="special-div"/>

### Использование `NgClass` с методом

1. Чтобы использовать `NgClass` с методом, добавьте метод в класс компонента.
   В следующем примере `setCurrentClasses()` устанавливает свойство `currentClasses` с объектом, который добавляет или
   удаляет три класса на основе состояния `true` или `false` трех других свойств компонента.

   Каждый ключ объекта — это имя класса CSS.
   Если ключ `true`, `ngClass` добавляет класс.
   Если ключ `false`, `ngClass` удаляет класс.

   <docs-code header="app.component.ts" path="adev/src/content/examples/built-in-directives/src/app/app.component.ts" visibleRegion="setClasses"/>

1. В шаблоне добавьте привязку свойства `ngClass` к `currentClasses`, чтобы установить классы элемента:

<docs-code header="app.component.html" path="adev/src/content/examples/built-in-directives/src/app/app.component.html" visibleRegion="NgClass-1"/>

Для этого случая использования Angular применяет классы при инициализации и в случае изменений, вызванных
переназначением объекта `currentClasses`.
Полный пример вызывает `setCurrentClasses()` изначально с `ngOnInit()`, когда пользователь нажимает кнопку
`Refresh currentClasses`.
Эти шаги не обязательны для реализации `ngClass`.

## Установка встроенных стилей с помощью `NgStyle`

HELPFUL: Чтобы добавить или удалить _один_ стиль,
используйте [привязки стилей](guide/templates/binding#css-class-and-style-property-bindings) вместо `NgStyle`.

### Импорт `NgStyle` в компонент

Чтобы использовать `NgStyle`, добавьте его в список `imports` компонента.

<docs-code header="app.component.ts (NgStyle import)" path="adev/src/content/examples/built-in-directives/src/app/app.component.ts" visibleRegion="import-ng-style"/>

Используйте `NgStyle` для одновременной установки нескольких встроенных стилей на основе состояния компонента.

1. Чтобы использовать `NgStyle`, добавьте метод в класс компонента.

   В следующем примере `setCurrentStyles()` устанавливает свойство `currentStyles` с объектом, который определяет три
   стиля на основе состояния трех других свойств компонента.

   <docs-code header="app.component.ts" path="adev/src/content/examples/built-in-directives/src/app/app.component.ts" visibleRegion="setStyles"/>

1. Чтобы установить стили элемента, добавьте привязку свойства `ngStyle` к `currentStyles`.

<docs-code header="app.component.html" path="adev/src/content/examples/built-in-directives/src/app/app.component.html" visibleRegion="NgStyle-2"/>

Для этого случая использования Angular применяет стили при инициализации и в случае изменений.
Чтобы сделать это, полный пример вызывает `setCurrentStyles()` изначально с `ngOnInit()` и когда зависимые свойства
изменяются при нажатии кнопки.
Однако эти шаги не обязательны для реализации `ngStyle` самостоятельно.

## Размещение директивы без элемента DOM

Angular `<ng-container>` — это группирующий элемент, который не влияет на стили или макет, потому что Angular не
помещает его в DOM.

Используйте `<ng-container>`, когда нет ни одного элемента для размещения директивы.

Вот условный абзац, использующий `<ng-container>`.

<docs-code header="app.component.html (ngif-ngcontainer)" path="adev/src/content/examples/structural-directives/src/app/app.component.html" visibleRegion="ngif-ngcontainer"/>

<img alt="ngcontainer paragraph with proper style" src="assets/images/guide/structural-directives/good-paragraph.png">

1. Импортируйте директиву `ngModel` из `FormsModule`.

1. Добавьте `FormsModule` в раздел imports соответствующего модуля Angular.

1. Чтобы условно исключить `<option>`, оберните `<option>` в `<ng-container>`.

   <docs-code header="app.component.html (select-ngcontainer)" path="adev/src/content/examples/structural-directives/src/app/app.component.html" visibleRegion="select-ngcontainer"/>

   <img alt="ngcontainer options work properly" src="assets/images/guide/structural-directives/select-ngcontainer-anim.gif">

## Что дальше

<docs-pill-row>
  <docs-pill href="guide/directives/attribute-directives" title="Директивы атрибутов"/>
  <docs-pill href="guide/directives/structural-directives" title="Структурные директивы"/>
  <docs-pill href="guide/directives/directive-composition-api" title="API композиции директив"/>
</docs-pill-row>
