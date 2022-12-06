<template>
  <div class="container p-4">
    <div class="input-group mb-3">
      <span class="input-group-text">
        <input type="color" v-model="colour">
      </span>
      <input type="text" class="form-control" placeholder="New keyword" aria-label="Example text with button addon"
        aria-describedby="button-addon1" v-model="keyword">
      <button class="btn btn-secondary" type="button" id="button-addon2" @click="addHighlight">Add keyword</button>
    </div>

    <ul class="list-group">
      <div v-if="contentEmpty">
          <div class="alert alert-warning" role="alert">
              No highlights yet. Start by adding a case insensitive keyword.
          </div>
      </div>

      <li class="list-group-item" v-for="(item, i) in highlights" :key="i" :style="{ 'background-color': item.colour }">
        <div class="d-flex">
          <div class="justify-content-start flex-fill">
            <b class="pe-4">{{ item.keyword }}</b>
          </div>
          <div class="justify-content-end">
            <button class="btn btn-dark" type="button" aria-label="delete" @click="deleteHighlight(item)"><i class="bi bi-trash me-2"></i></button>
          </div>
        </div>
      </li>
    </ul>
  </div>
</template>

<script>
import axios from 'axios';
import config from "../config";

export default {
  name: 'Highlight',
  data() {
    return {
      url: config.gateway + config.getPath('highlights'),
      highlights: [],
      keyword: '',
      colour: '#ffffff'
    }
  },
  computed: {
    contentEmpty() {
      return this.highlights == null || this.highlights.length == 0 ? true : false
    }
  },
  methods: {
    addHighlight() {
      if (this.keyword.length < 3) return

      let payload = { 'highlight': { 'keyword': this.keyword, 'colour': this.colour } }
      axios.post(this.url, payload, { headers: config.authorisationHeader() })
        .then(response => {
          if (response.status === 201) {
            this.keyword = ''
            this.fetchHighlights()
          }
        })
    },
    deleteHighlight(item) {
      let resource = this.url + '/' + item.id
      axios.delete(resource, { headers: config.authorisationHeader() })
        .then(response => {
          if (response.status === 204) {
            this.fetchHighlights()
          }
        })
    },
    fetchHighlights() {
      axios.get(this.url, { headers: config.authorisationHeader() })
        .then(response => {
          if (response.status === 200) {
            this.highlights = response.data
          }
        })
    }
  },
  mounted() {
    this.fetchHighlights()
  }
}
</script>