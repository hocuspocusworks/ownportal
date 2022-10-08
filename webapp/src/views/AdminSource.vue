<template>
  <div>
    List of sources
  </div>

  <div v-if="loading">
    <div class="spinner-border" role="status">
      <span class="visually-hidden">Loading...</span>
    </div>
  </div>

  <div v-if="success" class="alert alert-success" role="alert">
    Saved successfully.
  </div>

  <div class="container-fluid">
    <div class="row">
      <div class="col-sm-12 col-lg-3 mb-4" v-for="(item,i) in items" :key="i">
        <div class="card">
          <div class="card-body">
            <h5 class="card-title">Name: <input type="text" v-model="items[i].name"></h5>
            <h6 class="card-subtitle mb-2 text-muted"><a :href="items[i].url" target="_blank">{{ items[i].url }}</a>
            </h6>
            <p class="card-text">Description: <textarea v-model="items[i].description" /></p>
            <p class="card-text">Language: <input v-model="items[i].language" /></p>
            <p class="card-text">Icon URL: <input v-model="items[i].icon" /></p>
            <p class="card-text">Categories: {{items[i].categories}}</p>
            <select class="custom-select" v-model="selected_categories[i]" multiple>
              <option selected>Choose one or more categories</option>
              <option v-for="(category, j) in categories" :key="j">{{category.name}}</option>
            </select>
            <p class="card-text">Visibility (current: <b>{{ items[i].visibility }}</b>)</p>
            <select class="form-select" v-model="visibility[i]" aria-label="Select visibility">
              <option v-for="visibility_type in visibility_types" :key="visibility_type.value">{{ visibility_type.text
              }}</option>
            </select>
            <a href="#" class="card-link" @click="save(items[i].id)">Save</a>
            <a href="#" class="card-link" @click="remove(items[i].id)">Delete</a>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import config from '../config';

export default {
  name: "AdminSource",
  props: ['kind', 'status'],
  data() {
    return {
      items: [],
      categories: [],
      selected_categories: [],
      loading: false,
      success: false,
      last_kind: '',
      last_status: '',
      visibility: [],
      visibility_types: [
        { text: 'Nobody', value: 0 },
        { text: 'Restricted', value: 1 },
        { text: 'Safe', value: 2 }
      ]
    }
  },
  watch: {
    kind: {
      handler: function (new_kind) {
        if (new_kind !== undefined && this.last_kind !== new_kind) {
          this.last_kind = new_kind
          this.getSources()
        }
      }
    },
    status: {
      handler: function(new_status) {
        if (new_status !== undefined && this.new_status !== new_status) {
          this.last_status = new_status
          this.getSources()
        }
      }
    }
  },
  methods: {
    save(index) {
      let position = this.dbToInternalIndex(index)
      let request = config.gateway + config.getPath('admin_sources') + '/' + index
      let payload = { 'source': { ...this.basicSettings(position), ...this.visible(position) } }
      axios.patch(request, payload, { headers: config.authorisationHeader() })
        .then(response => {
          if (response.status === 200) {
            this.success = true
            setTimeout(() => {
              this.success = false
              this.getSources()
            }, 1000)
          }
        })
    },
    remove(index) {
      let request = config.gateway + config.getPath('admin_sources') + '/' + index
      axios.delete(request, { headers: config.authorisationHeader() })
        .then(response => {
          if (response.status === 204) {
            this.getSources()
          }
        })
    },
    dbToInternalIndex(dbIndex) {
      for (let i = 0; i < this.items.length; i++) {
        if (this.items[i].id === dbIndex) {
          return i;
        }
      }
    },
    getSources() {
      this.loading = true
      let request = config.gateway + config.getPath('admin_sources') + '?kind=' + this.last_kind + '&status=' + this.last_status
      axios.get(request, { headers: config.authorisationHeader() })
        .then(response => {
          if (response.status === 200) {
            this.items = response.data
            this.visibility = []
            this.loading = false
          }
        })
    },
    getCategories() {
      this.loading = true
      let request = config.gateway + config.getPath('admin_categories')
      axios.get(request, { headers: config.authorisationHeader() })
        .then(response => {
          if (response.status === 200) {
            this.categories = response.data
            this.loading = false
          }
        })
    },
    basicSettings(position) {
      return {
        'name': this.items[position].name,
        'description': this.items[position].description,
        'language': this.items[position].language,
        'categories': this.selected_categories[position]
      }
    },
    visible(position) {
      if (this.visibility[position] === undefined) {
        return {}
      }
      return { 'visibility': this.visibility[position].toLowerCase() }
    },
  },
  mounted() {
    this.last_kind = this.kind
    this.last_status = this.status
    this.getCategories()
    this.getSources()
  }
}
</script>
