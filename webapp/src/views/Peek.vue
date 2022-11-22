<template>
  <div class="d-flex justify-content-center" v-if="loading">
    <div class="spinner-border" role="status">
      <span class="visually-hidden">Loading...</span>
    </div>
  </div>

  <div v-if="err">
    <div class="alert alert-danger" role="alert">
      Could not load the feed. Try again later.
    </div>
  </div>

  <div class="container p-2">
    <div class="row">
      <div v-for="(items, name) in content" :key="name" class="col-6">
        <div class="card" :class="themeHeader">
          <div class="card-body">
            <h5 class="card-title d-flex">{{ name }}</h5>
          </div>
          <ul class="list-group list-group-flush">
            <li v-for="(item, i) in items" :key="i" class="list-group-item d-flex" :class="themeContent">
              <span class="pe-3 text-muted">{{ item.publishedDate }}</span>
              <span class="d-flex text-start"><a :href="item.link" target="_blank">{{ item.title }}</a></span>
            </li>
          </ul>
        </div>
        <br>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import config from '../config';

export default {
  name: 'Peek',
  data() {
    return {
      loading: false,
      err: null,
      response: null,
      content: {},
      elements: []
    }
  },
  computed: {
    themeHeader() {
      return {
        'bg-dark-middle': this.dark(),
        'bg-bluegray-50': !this.dark()
      }
    },
    themeContent() {
      return {
        'text-light': this.dark(),
        'text-light-black': !this.dark(),
        'bg-dark-middle': this.dark(),
        'bg-bluegray-50': !this.dark()
      }
    }
  },
  methods: {
    dark() {
      return config.isDarkModeOn()
    },
    loadFeed() {
      this.loading = true
      let me = config.gateway + config.getPath('my_feed')
      axios.get(me, { headers: config.authorisationHeader() })
        .then(response => {
          this.streams(response.data)
          this.loadView()
        })
    },
    loadView() {
      let request = config.gateway + config.getPath('rss_sources');
      let payload = { "urls": this.urls(), "sort": "asc" }
      axios.post(request, payload, { headers: config.authorisationHeader() })
        .then(response => {
          this.response = response.data.data.nodes
          this.processResponse()
        })
        .then(_response => {
          this.loading = false
        })
        .catch(err => {
          this.loading = false
          this.err = err
        });
    },
    streams(data) {
      data.forEach(item => {
        if (item.sources.length > 0) {
          item.sources.forEach(el => {
            this.elements.push({ name: el.name, url: el.url })
          })
        }
      })
    },
    urls() {
      return this.elements.map(el => el.url)
    },
    processResponse() {
      this.response.forEach(item => {
        let element = {
          'title': item.title,
          'link': item.link,
          'publishedDate': this.timeSince(item.publishedDate)
        }
        if (this.content[item.source] === undefined) {
          this.content[item.source] = []
        }
        this.content[item.source].push(element)
      })
    },
    timeSince(date) {
      return this.toMinutes(date)
    },
    toMinutes(date) {
      let minutes = (Date.now() - new Date(date)) / 1000 / 60
      if (minutes < 60) {
        return Math.floor(minutes) + 'm'
      }
      return this.toHours(minutes)
    },
    toHours(minutes) {
      let hours = minutes / 60
      if (hours < 24) {
        return Math.floor(hours) + 'h'
      }
      return this.toDays(hours)
    },
    toDays(hours) {
      let days = Math.floor(hours) / 24
      if (days < 7) {
        return Math.floor(days) + 'd'
      }
      return this.toWeeks(days)
    },
    toWeeks(days) {
      let weeks = days / 7
      return Math.floor(weeks) + 'w'
    }
  },
  mounted() {
    this.loadFeed()
  }
}
</script>
