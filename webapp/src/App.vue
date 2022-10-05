<template>
  <router-view></router-view>
</template>

<script>
import config from './config';
import router from './router/index';

export default {
  name: 'App',
  mounted() {
    config.setScreenSize()
    if (!window.location.pathname.startsWith('/admin')) {
      router.push({name: "login"});
    }
  },
}
</script>
