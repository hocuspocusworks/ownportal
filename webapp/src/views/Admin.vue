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
          <li class="nav-item active">
            <a class="nav-link" href="#" @click="portal()">Portal</a>
          </li>
          <li class="nav-item">
            <a class="nav-link" href="#" @click="categories">Categories</a>
          </li>
          <li class="nav-item dropdown">
            <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown"
              aria-expanded="false">
              Admin Sources
            </a>
            <ul class="dropdown-menu" aria-labelledby="navbarDropdown">
              <!-- <li><a class="dropdown-item" href="#">New</a></li>
              <li><a class="dropdown-item" href="#">Restricted</a></li> -->
              <li><a class="dropdown-item" href="#" @click="sources('admin')">All</a></li>
            </ul>
          </li>
          <li class="nav-item dropdown">
            <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown"
              aria-expanded="false">
              Contributor Sources
            </a>
            <ul class="dropdown-menu" aria-labelledby="navbarDropdown">
              <!-- <li><a class="dropdown-item" href="#">Pending</a></li> -->
              <li><a class="dropdown-item" href="#" @click="sources('contributor')">All</a></li>
            </ul>
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
    },
    portal() {
      router.push({ name: 'home' })
    }
  }
}
</script>
