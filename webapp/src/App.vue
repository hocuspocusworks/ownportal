<template>
  <router-view></router-view>
</template>

<script>
import axios from 'axios';
import config from './config';
import router from './router/index';

export default {
  name: 'App',
  mounted() {
    config.setScreenSize()
    config.pullSettings()
    if (window.location.pathname.startsWith('/sidekiq')) {
      window.location.href = config.gateway + "/sidekiq";
    } else if (window.location.pathname.startsWith('/activate')) {
      const urlParams = new URLSearchParams(window.location.search);
      const key = urlParams.get('key');
      axios.get(config.gateway + config.getPath('users') + '/activate?key=' + key)
        .then(_response => {
          window.location.href = config.gateway + '/login'
        })
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
