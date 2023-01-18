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
                      <div class="card-body" @click="openFeed(item.article)">
                          <h5 class="card-title">{{ item.article.title }}</h5>
                          <h6 class="card-subtitle mb-2 text-muted">{{ item.article.publisher }} | {{ item.article.published_date }}</h6>
                          <p>{{ processText(item.article.description) }}</p>
                      </div>
                      <div>
                        <button class="btn shadow-none" :class="themeText" @click="like(item.article)"><i class="bi"
                              :class="{ 'bi-heart': !item.article.heart, 'bi-heart-fill': item.article.heart }"></i></button>
                        <button class="btn shadow-none" :class="themeText" @click="clipboard(item.article)"><i
                                class="bi"
                                :class="{ 'bi-files': !item.article.copied, 'bi-file-check-fill': item.article.copied }"></i></button>
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
        return !this.loading && (this.content == null || this.content.length == 0) ? true : false
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
      openFeed(item) {
        let url = config.gateway + config.getPath('histories')
        let payload = { 'history': { 'article_id': item.id } }
        axios.post(url, payload, { headers: config.authorisationHeader() })

        window.open(item.link, '_blank').focus();
      },
      notificationRead() {
        let notify = config.gateway + config.getPath('notification_read')
        let payload = { 'read_ids': this.content.flatMap(element => element.id) }
        axios.post(notify, payload, { headers: config.authorisationHeader() })
      },
      like(item) {
        item.heart = true; // should replace with loading
        let url = config.gateway + config.getPath('favourites')
        let payload = {
            'favourite': {
                'title': item.title, 'description': item.description, 'link': item.link,
                'publisher': item.publisher, 'published_date': item.published_date
            }
        }
        axios.post(url, payload, { headers: config.authorisationHeader() })
            .then(response => {
                if (response.status === 201) {
                    item.heart = true;
                }
            }).catch(err => {
                console.log(err);
            });
      },
      clipboard(item) {
        navigator.clipboard.writeText(item.link)
        item.copied = true
      }
  },
  mounted() {
      this.loadNotifications();
  }
}
</script>