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
    } else if (window.location.pathname.startsWith('/confirmation')) {
      const user = new Map(window.location.search.slice(1).split('&').map(q => q.split('='))).get('user')
      const token = new Map(window.location.search.slice(1).split('&').map(q => q.split('='))).get('token')
      router.push({name: 'confirmation', query: {user: user, token: token}})
    } else if (window.location.pathname.startsWith('/admin')) {
      router.push({name: 'admin'})
    } else if (window.location.pathname.startsWith('/creator')) {
      router.push({name: 'creator'})
    } else {
      router.push({name: 'about'})
    }
  },
}
</script>
