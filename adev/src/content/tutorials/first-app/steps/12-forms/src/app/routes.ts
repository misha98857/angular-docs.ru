import {Routes} from '@angular/router';
import {Home} from './home/home';
import {Details} from './details/details';

const routeConfig: Routes = [
  {
    path: '',
    component: Home,
    title: 'Главная',
  },
  {
    path: 'details/:id',
    component: Details,
    title: 'Подробности жилья',
  },
];

export default routeConfig;
