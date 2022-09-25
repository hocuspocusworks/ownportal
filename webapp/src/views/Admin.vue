<template>
  <nav class="navbar navbar-expand-lg navbar-light bg-light">
    <a class="navbar-brand" href="#">Admin</a>

    <div class="collapse navbar-collapse" id="navbarNav">
      <ul class="navbar-nav">
        <li class="nav-item active">
          <a class="nav-link" href="#" @click="sources">Sources</a>
        </li>
      </ul>
    </div>
  </nav>
  <router-view></router-view>
</template>

<script>
import router from '../router';

export default {
  name: "Admin",
  methods: {
    sources() {
      router.push({name: 'sources'})
    }
  }
}
</script>
