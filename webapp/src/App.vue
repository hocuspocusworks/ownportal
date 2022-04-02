<template>
  <p class="m-0 p-0">
    <router-link to="/"></router-link>
    <router-link to="/login"></router-link>
  </p>
  <router-view></router-view>
</template>

<script>
import router from './router/index';

export default {
  name: 'App',
  mounted() {
    router.push("/login"); // if not logged in, switch to login page
  },
}
</script>
