<template>
  <router-view></router-view>
</template>

<script>
import router from '../router'

export default {
  name: 'Creator',
  methods: {
    blogs() {
      router.push({ name: 'blogs' })
    }
  }
}
</script>