import {Component} from '@angular/core';

@Component({
  selector: 'app-home',
  template: `
    <section>
      <form>
        <input type="text" placeholder="Фильтр по городу" />
        <button class="primary" type="button">Найти</button>
      </form>
    </section>
  `,
  styleUrls: ['./home.css'],
})
export class Home {}
