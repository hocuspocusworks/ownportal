<template>
  <div>
    List of sources
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
            <p class="card-text">Public: <input type="checkbox" v-model="items[i].published" /></p>
            <a href="#" class="card-link" @click="save(items[i].id)">Save</a>
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
  data() {
    return {
      items: null,
      categories: [],
      selected_categories: []
    }
  },
  methods: {
    save(index) {
      let position = this.dbToInternalIndex(index)
      let request = config.gateway + config.getPath('admin_sources') + '/' + index
      let payload = {
        'source': {
          'name': this.items[position].name,
          'description': this.items[position].description,
          'language': this.items[position].language,
          'published': this.items[position].published === true ? '1' : '0',
          'categories': this.selected_categories[position]
        }
      }
      axios.patch(request, payload, { headers: config.authorisationHeader() })
        .then(response => {
          if (response.status === 200) {
            console.log('success')
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
      let request = config.gateway + config.getPath('admin_sources')
      axios.get(request, { headers: config.authorisationHeader() })
        .then(response => {
          if (response.status === 200) {
            this.items = response.data
            console.log(response.data)
          }
        })
    },
    getCategories() {
      let request = config.gateway + config.getPath('admin_categories')
      axios.get(request, { headers: config.authorisationHeader() })
        .then(response => {
          if (response.status === 200) {
            this.categories = response.data
          }
        })
    }
  },
  mounted() {
    this.getCategories()
    this.getSources()
  }
}
</script>
