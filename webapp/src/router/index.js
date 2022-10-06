import { createRouter, createWebHistory } from "vue-router";
import Home from '../views/Home.vue';
import Explore from '../views/Explore.vue';
import Setting from '../views/Setting.vue';
import MainContent from '../components/MainContent.vue';
import Favourite from '../components/Favourite.vue';
import Highlight from '../components/Highlight.vue';
import Login from '../views/Login.vue';
import Register from '../views/Register.vue';
import About from '../views/About.vue';
import Admin from '../views/Admin.vue';
import AdminSource from '../views/AdminSource.vue';
import AdminCategory from '../views/AdminCategory.vue';
import AdminStats from '../views/AdminStats.vue';
import Creator from '../views/Creator.vue';

const routes = [
  {
    name: "home",
    path: "/home",
    component: Home,
    redirect: {
      name: "explore"
    },
    children: [
      { name: "explore", path: "explore", component: Explore },
      { name: "content", path: "content", component: MainContent, props: true },
      { name: "favourite", path: "favourite", component: Favourite },
      { name: "highlight", path: "highlight", component: Highlight },
      { name: 'setting', path: 'setting', component: Setting }
    ]
  },
  {
    name: 'admin', path: '/admin', component: Admin, children: [
      { name: 'categories', path: 'categories', component: AdminCategory },
      { name: 'sources', path: 'sources', component: AdminSource, props: true },
      { name: 'stats', path: 'stats', component: AdminStats }
    ]
  },
  {
    name: 'creator', path: '/creator', component: Creator
  },
  { name: "login", path: "/login", component: Login },
  { name: "register", path: "/register", component: Register },
  { name: "about", path: "/about", component: About }
];

const router = createRouter({
  history: createWebHistory(),
  routes: routes,
});

export default router;
