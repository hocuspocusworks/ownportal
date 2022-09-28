<template>
  <nav class="navbar navbar-expand-lg navbar-light bg-light">
    <a class="navbar-brand" href="#">Admin</a>

    <div class="collapse navbar-collapse" id="navbarNav">
      <ul class="navbar-nav">
        <li class="nav-item">
          <a class="nav-link" href="#" @click="categories">Categories</a>
        </li>
        <li class="nav-item active">
          <a class="nav-link" href="#" @click="sources('admin')">Admin Sources</a>
        </li>
        <li class="nav-item active">
          <a class="nav-link" href="#" @click="sources('contributor')">Contributor Sources</a>
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
    categories() {
      router.push({name: 'categories'})
    },
    sources(kind) {
      router.push({name: 'sources', params: {kind: kind}})
    }
  }
}
</script>
