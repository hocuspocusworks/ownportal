import { createRouter, createWebHistory } from "vue-router";
import Home from '../views/Home.vue';
import Explore from '../views/Explore.vue';
import MainContent from '../components/MainContent.vue';
import Login from '../views/Login.vue';
import Register from '../views/Register.vue';

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
      }
    ]
  },
  { name: "login", path: "/login", component: Login },
  { name: "register", path: "/register", component: Register }
];

const router = createRouter({
  history: createWebHistory(),
  routes: routes,
});

export default router;
