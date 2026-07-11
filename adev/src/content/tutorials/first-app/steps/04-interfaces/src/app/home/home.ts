import {Component} from '@angular/core';
import {HousingLocation} from '../housing-location/housing-location';

@Component({
  selector: 'app-home',
  imports: [HousingLocation],
  template: `
    <section>
      <form>
        <input type="text" placeholder="Фильтр по городу" />
        <button class="primary" type="button">Найти</button>
      </form>
    </section>
    <section class="results">
      <app-housing-location />
    </section>
  `,
  styleUrls: ['./home.css'],
})
export class Home {}
