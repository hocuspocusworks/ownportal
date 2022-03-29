<template>
  <h1>Developer OwnPortal</h1>
  <p>
    <router-link to="/"></router-link>
    <router-link to="/login"></router-link>
  </p>
  <router-view></router-view>
</template>

<script>
import router from './router/index';
import 'bootstrap/dist/css/bootstrap.min.css';
import 'bootstrap/dist/js/bootstrap.min.js';

export default {
  name: 'App',
  mounted() {
    router.push("/login"); // if not logged in, switch to login page
  },
}
</script>
