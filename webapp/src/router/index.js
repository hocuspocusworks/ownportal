import { createRouter, createWebHistory } from "vue-router";
import Home from '../views/Home.vue';
import Explore from '../views/Explore.vue';
import MainContent from '../components/MainContent.vue';
import Favourite from '../components/Favourite.vue';
import Login from '../views/Login.vue';
import Register from '../views/Register.vue';
import About from '../views/About.vue';

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
  { name: "login", path: "/login", component: Login },
  { name: "register", path: "/register", component: Register },
  { name: "about", path: "/about", component: About }
];

const router = createRouter({
  history: createWebHashHistory(),
  routes: routes,
});

export default router;
