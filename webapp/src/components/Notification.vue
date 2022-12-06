<template>
  <div class="d-flex justify-content-center p-2">
      <div class="container-fluid">
          <div v-if="loading">
              <div class="spinner-border" role="status">
                  <span class="visually-hidden">Loading...</span>
              </div>
          </div>

          <div v-if="err">
              <div class="alert alert-danger" role="alert">
                  Could not load the feed. Try later.
              </div>
          </div>

          <div v-if="contentEmpty">
              <div class="alert alert-warning" role="alert">
                  No new notifications. Add keywords in highlights that will show matching items here.
              </div>
          </div>

          <div class="row">
              <div class="col-sm-12 col-lg-4 mb-4" v-for="(item,i) in content" :key="i">
                  <div class="card full-height my-link" :class="themeCard">
                      <div class="card-body" @click="openFeed(item.article.link)">
                          <h5 class="card-title">{{ item.article.title }}</h5>
                          <h6 class="card-subtitle mb-2 text-muted">{{ item.article.publisher }} | {{ item.article.published_date }}</h6>
                          <p>{{ processText(item.article.description) }}</p>
                      </div>
                  </div>
              </div>
          </div>
      </div>
  </div>
</template>

<script>
import axios from "axios";
import config from "../config";

export default {
  name: 'Notification',
  data() {
      return {
          loading: true,
          err: false,
          content: []
      }
  },
  computed: {
      themeCard() {
          return {
              'bg-dark-middle': this.dark(),
              'bg-bluegray-50': !this.dark()
          }
      },
      themeText() {
          return {
              'text-light': this.dark(),
              'text-light-black': !this.dark()
          }
      },
      contentEmpty() {
        return this.content == null || this.content.length == 0 ? true : false
      }
  },
  methods: {
      dark() {
          return config.isDarkModeOn()
      },
      loadNotifications() {
          let url = config.gateway + config.getPath('notifications');
          axios.get(url, { headers: config.authorisationHeader() })
              .then(response => {
                  if (response.status === 200) {
                      this.content = response.data
                      this.notificationRead()
                  }
                  this.loading = false;
              }).catch(e => {
                  this.loading = false;
                  this.err = true;
              })
      },
      processText(text) {
          return text.length > 200 ?
              text.substring(0, 200) + "..." :
              text;
      },
      openFeed(url) {
          window.open(url, '_blank').focus();
      },
      notificationRead() {
        let notify = config.gateway + config.getPath('notification_read')
        let payload = { 'read_ids': this.content.flatMap(element => element.id) }
        axios.post(notify, payload, { headers: config.authorisationHeader() })
      }
  },
  mounted() {
      this.loadNotifications();
  }
}
</script>