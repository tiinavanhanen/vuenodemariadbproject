import Vue from 'vue'
import App from './App.vue'
import 'bootstrap/dist/css/bootstrap.min.css'

import VueRouter from 'vue-router';
Vue.use(VueRouter);

import vSelect from 'vue-select';
Vue.component('v-select', vSelect);

Vue.config.productionTip = false;

import HomeComponent from './components/HomeComponent.vue';
import CreateComponent from './components/CreateComponent.vue';
import IndexComponent from './components/IndexComponent.vue';
import EditComponent from './components/EditComponent.vue';
import CommentsComponent from './components/CommentsComponent.vue';
import RecommendComponent from './components/RecommendComponent';
import ShowComponent from './components/ShowComponent';

const routes = [
  {
    name: 'home',
    path: '/',
    component: HomeComponent
  },
  {
    name: 'add',
    path: '/addseries',
    component: CreateComponent
  },
  {
    name: 'addseries',
    path: '/addseries',
    component: CreateComponent
  },
  {
    name: 'posts',
    path: '/posts',
    component: IndexComponent
  },
  {
    name: 'edit',
    path: '/edit/:id',
    component: EditComponent
  },
  {
    name: 'comments',
    path: '/comments',
    component: CommentsComponent
  },
  {
    name: 'addcomment',
    path: '/addcomments',
    component: CommentsComponent
  },
  {
    name: 'recommend',
    path: '/recommend',
    component: RecommendComponent
  },
  {
    name: 'show',
    path: '/show',
    props: true,
    component: ShowComponent
  }
];

const router = new VueRouter({ mode: 'history', routes: routes});

new Vue(Vue.util.extend({ router }, App)).$mount('#app');
