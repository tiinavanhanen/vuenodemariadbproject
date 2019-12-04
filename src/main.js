import Vue from 'vue'
import App from './App.vue'
import 'bootstrap/dist/css/bootstrap.min.css'

import Axios from 'axios'

Vue.prototype.$http = Axios;

import VueRouter from 'vue-router';
Vue.use(VueRouter);

import vSelect from 'vue-select';
Vue.component('v-select', vSelect);

Vue.config.productionTip = false;

import HomeComponent from './components/HomeComponent.vue';
import CreateComponent from './components/CreateComponent.vue';
import IndexComponent from './components/IndexComponent.vue';
import CommentsComponent from './components/CommentsComponent.vue';
import RecommendComponent from './components/RecommendComponent';
import ShowComponent from './components/ShowComponent';
import Register from './components/Register';
import Login from "@/components/Login";

const routes = [
  {
    name: 'home',
    path: '/',
    component: HomeComponent,
    meta: {
      guest: true
    }
  },
  {
    name: 'addseries',
    path: '/addseries',
    component: CreateComponent,
    meta: {
      requiresAuth: true
    }
  },
  {
    name: 'editseries',
    path: '/editseries',
    component: CreateComponent,
    meta: {
      requiresAuth: true
    }
  },
  {
    name: 'deleteseries',
    path: '/deleteseries',
    component: CreateComponent,
    meta: {
      requiresAuth: true
    }
  },
  {
    name: 'posts',
    path: '/posts',
    component: IndexComponent,
    meta: {
      requiresAuth: true
    }
  },
  {
    name: 'comments',
    path: '/comments',
    component: CommentsComponent,
    meta: {
      requiresAuth: true
    }
  },
  {
    name: 'addcomment',
    path: '/addcomments',
    component: CommentsComponent,
    meta: {
      requiresAuth: true
    }
  },
  {
    name: 'recommend',
    path: '/recommend',
    component: RecommendComponent,
    meta: {
      requiresAuth: true
    }
  },
  {
    name: 'show',
    path: '/show',
    props: true,
    component: ShowComponent,
    meta: {
      requiresAuth: true
    }
  },
  {
    path: '/register',
    name: 'register',
    component: Register,
    meta: {
      guest: true
    }
  },
  {
    path: '/login',
    name: 'login',
    component: Login,
    meta: {
      guest: true
    }
  },
];

const router = new VueRouter({ mode: 'history', routes: routes});

/*
router.beforeEach((to, from, next) => {
  if(to.matched.some(record => record.meta.requiresAuth)) {
    if (localStorage.getItem('jwt') == null) {
      next({
        path: '/login',
        params: { nextUrl: to.fullPath }
      })
    } else {
          next({ name: 'addseries'})
    }

  } else if(to.matched.some(record => record.meta.guest)) {
    if(localStorage.getItem('jwt') == null){
      next()
    }
    else{
      next({ name: 'addseries'})
    }


  }else {
    next({
      path: '/login',
      params: { nextUrl: to.fullPath }
    })
  }
});
*/
new Vue(Vue.util.extend({ router }, App)).$mount('#app');
