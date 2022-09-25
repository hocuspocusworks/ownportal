<template>
  <router-view></router-view>
</template>

<script>
import router from './router/index';

export default {
  name: 'App',
  mounted() {
    if (!window.location.pathname.startsWith('/admin')) {
      router.push({name: "login"});
    }
  },
}
</script>
