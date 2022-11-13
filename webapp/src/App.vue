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
    config.pullSettings()
    if (window.location.pathname.startsWith('/sidekiq')) {
      window.location.href = config.gateway + "/sidekiq";
    } else if (window.location.pathname.startsWith('/admin')) {
      router.push({name: 'admin'})
    } else if (window.location.pathname.startsWith('/creator')) {
      router.push({name: 'creator'})
    } else {
      router.push({name: 'login'})
    }
  },
}
</script>
