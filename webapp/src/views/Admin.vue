<template>
  <nav class="navbar navbar-expand-lg navbar-light bg-light">
    <div class="container-fluid">
      <a class="navbar-brand" href="#">Admin</a>
      <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent"
        aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
      </button>
      <div class="collapse navbar-collapse" id="navbarSupportedContent">
        <ul class="navbar-nav me-auto mb-2 mb-lg-0">
          <li class="nav-item">
            <a class="nav-link" href="#" @click="categories">Categories</a>
          </li>
          <li class="nav-item active">
            <a class="nav-link" href="#" @click="sources('admin')">Admin Sources</a>
          </li>
          <li class="nav-item active">
            <a class="nav-link" href="#" @click="sources('contributor')">Contributor Sources</a>
          </li>
          <li class="nav-item active">
            <a class="nav-link" href="#" @click="stats()">Stats</a>
          </li>
        </ul>
      </div>
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
      router.push({ name: 'categories' })
    },
    sources(kind) {
      router.push({ name: 'sources', params: { kind: kind } })
    },
    stats() {
      router.push({ name: 'stats' })
    }
  }
}
</script>
