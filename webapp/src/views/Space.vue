<template>
  <div class="container">
    <h3>New space</h3>
  
    <div class="alert alert-info" role="alert">
      Use a space to create a personal blog-alike website. Spaces are automatically converted into RSS feeds which you can
      share with others. There is one space per account limit.
    </div>
  
    <form class="row g-3">
      <div class="col-12">
        <label for="inputEmail4" class="form-label">Space name</label>
        <input type="text" class="form-control" id="name" v-model="name">
        <span>URL: https://space.ownportal.net/<span v-text="parameterisedPath"></span></span>
      </div>
      <div class="col-12">
        <label for="inputPassword4" class="form-label">Description</label>
        <textarea class="form-control" aria-label="With textarea" v-model="description"></textarea>
      </div>
      <div class="col-12">
        <button type="button" @click="createSpace" class="btn btn-primary">Create</button>
      </div>
    </form>
  </div>
</template>

<script>
import axios from 'axios';
import config from '../config';
import router from '../router';

export default {
  name: 'Space',
  data() {
    return {
      name: '',
      description: ''
    }
  },
  computed: {
    parameterisedPath() {
      return this.parameterise(this.name)
    }
  },
  methods: {
    loadSpace() {
      let url = config.gateway + config.getPath('spaces') + '/' + config.userId()
      axios.get(url, { headers: config.authorisationHeader() })
        .then(response => {
          if (response.status === 200) {
            localStorage.setItem('spaceId', response.data.id)
            localStorage.setItem('spacePath', response.data.path)
            router.push({ name: 'blogs' })
          }
        })
    },
    createSpace() {
      let url = config.gateway + config.getPath('spaces')
      let payload = { 'space': { 'name': this.name, 'description': this.description } }
      axios.post(url, payload, { headers: config.authorisationHeader() })
        .then(response => {
          if (response.status === 201) {
            localStorage.setItem('spaceId', response.data.id)
            localStorage.setItem('spacePath', response.data.path)
            router.push({ name: 'blogs' })
          }
        })
    },
    parameterise(text) {
      return text.trim().toLowerCase().replace(/[^a-zA-Z0-9 -]/, "").replace(/\s/g, "-")
    }
  },
  mounted() {
    this.loadSpace()
  }
}
</script>