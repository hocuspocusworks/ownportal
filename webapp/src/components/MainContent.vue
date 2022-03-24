<template>
    <div v-if="loading" class="spinner-border" role="status">
      <span class="visually-hidden">Loading...</span>
    </div>
    <div v-if="err" class="alert alert-danger" role="alert">
        Cannot load the feed.
    </div>

    <div v-for="(item,i) in content" :key="i" class="card mb-3 w-100">
    <a style="text-decoration: none; color: black;" target="_blank" :href="item.link">
        <div class="row g-0">
            <div class="col-md-2">
                <div style="display: flex; align-items: center; justify-content: center; min-height: 100%;">
                    <img style="width: 32px; height: 32px;" :src="baseUrl(item.link)+'/favicon.ico'" />
                </div>
            </div>
            <div class="col-md-10">
                <div class="card-body">
                    <h5 class="card-title">{{ item.title }}</h5>
                    <p class="card-text">{{ item.description }}</p>
                    <p class="card-text">
                        <small class="text-muted">{{ item.publishedDate }}</small>
                        <span class="ms-2 badge rounded-pill bg-light text-dark">{{ item.source }}</span>
                    </p>
                </div>
            </div>
        </div>
    </a>
    </div>
</template>

<script>
import axios from 'axios';
import config from '../config';

export default {
    name: 'MainContent',
    props: {
        contentUrl: String,
    },
    data() {
        return {
            loading: false,
            err: false,
            content: null,
        }
    },
    watch: {
        contentUrl: function(newUrl, oldUrl) {
            this.updateView(newUrl);
        }
    },
    methods: {
        updateView(url) {
            this.content = null;
            this.loading = true;
            this.err = false;
            let request = config.fetcher + "/rss/fetchAll";
            let data = {"urls": Object.values(url).map(i => i.url)};
            axios.post(request, data)
                .then(response => {
                    this.content = response.data.data.nodes;
                    console.log(this.content);
                })
                .then(load => {
                    this.loading = false;
                })
                .catch(err => {
                    this.loading = false;
                    this.err = err;
                });
        },
        baseUrl(url) {
            var pathArray = url.split('/');
            var protocol = pathArray[0];
            var host = pathArray[2];
            return protocol + '//' + host;
        }
    }
}
</script>