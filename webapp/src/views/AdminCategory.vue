<template>
  <div class="row">
    <div class="text-left">
      Categories
    </div>
    <div v-if="loading">
      <div class="spinner-border" role="status">
        <span class="visually-hidden">Loading...</span>
      </div>
    </div>
    <div class="col-4">
      <div class="input-group mb-3">
        <input type="text" class="form-control" placeholder="New category name" aria-label="New category name"
          aria-describedby="basic-addon2" v-model="category_name">
        <div class="input-group-append">
          <button class="btn btn-outline-secondary" type="button" @click="add_category">Add</button>
        </div>
      </div>
    </div>
  </div>

  <div>
    List of categories
  </div>

  <ul class="list-group" v-for="(item, i) in items" :key="i">
    <li class="list-group-item">{{ item.name }}</li>
  </ul>
</template>

<script>
import axios from 'axios';
import config from '../config';

export default {
  name: "AdminCategory",
  data() {
    return {
      items: null,
      category_name: null,
      loading: false
    }
  },
  methods: {
    add_category() {
      let url = config.gateway + config.getPath('admin_categories')
      let payload = { 'category': { 'name': this.category_name } }
      this.category_name = null
      axios.post(url, payload, { headers: config.authorisationHeader() })
        .then(response => {
          if (response.status === 201) {
            this.reload()
          }
        })
    },
    reload() {
      this.loading = true
      let request = config.gateway + config.getPath('admin_categories')
      axios.get(request, { headers: config.authorisationHeader() })
        .then(response => {
          if (response.status === 200) {
            this.items = response.data
            this.loading = false
          }
        })
    }
  },
  mounted() {
    this.reload()
  }
}
</script>
