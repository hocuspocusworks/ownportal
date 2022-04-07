<template>
  <router-view></router-view>
</template>

<script>
import router from './router/index';

export default {
  name: 'App',
  mounted() {
    router.push({name: "login"}); // if not logged in, switch to login page
  },
}
</script>
