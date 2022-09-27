import { createRouter, createWebHistory } from "vue-router";
import Home from '../views/Home.vue';
import Explore from '../views/Explore.vue';
import MainContent from '../components/MainContent.vue';
import Favourite from '../components/Favourite.vue';
import Login from '../views/Login.vue';
import Register from '../views/Register.vue';
import About from '../views/About.vue';
import Admin from '../views/Admin.vue';
import AdminSource from '../views/AdminSource.vue';
import AdminCategory from '../views/AdminCategory.vue';

const routes = [
  {
    name: "home",
    path: "/home",
    component: Home,
    redirect: {
      name: "explore"
    },
    children: [
      {
        name: "explore",
        path: "explore",
        component: Explore
      },
      {
        name: "content",
        path: "content",
        component: MainContent,
        props: true,
      },
      {
        name: "favourite",
        path: "favourite",
        component: Favourite
      }
    ]
  },
  { name: 'admin', path: '/admin', component: Admin, children: [
    { name: 'categories', path: 'categories', component: AdminCategory },
    { name: 'sources', path: 'sources', component: AdminSource }
  ] },
  { name: "login", path: "/login", component: Login },
  { name: "register", path: "/register", component: Register },
  { name: "about", path: "/about", component: About }
];

const router = createRouter({
  history: createWebHistory(),
  routes: routes,
});

export default router;
