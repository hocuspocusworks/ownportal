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

            <div class="row">
                <div class="col-sm-12 col-lg-4 mb-4" v-for="(item,i) in content" :key="i">
                    <div class="card full-height my-link" :class="themeCard">
                        <div class="card-body" @click="openFeed(item.link)">
                            <h5 class="card-title">{{ item.title }}</h5>
                            <h6 class="card-subtitle mb-2 text-muted">{{ item.source }} | {{ item.publishedDate }}</h6>
                            <p>{{ processText(item.description) }}</p>
                        </div>
                        <div class="pb-3">
                            <button class="btn shadow-none" :class="themeText" @click="like(item)"><i class="bi" :class="{'bi-heart': !item.heart, 'bi-heart-fill': item.heart}"></i></button>
                            <button class="btn shadow-none" :class="themeText" @click="clipboard(item)"><i class="bi bi-link-45deg"></i></button>
                        </div>
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
    name: 'MainContent',
    props: {
        contentUrl: {
            type: Array,
            default: []
        }
    },
    data() {
        return {
            loading: false,
            err: false,
            content: null,
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
        }
    },
    watch: {
        contentUrl: {
            handler: function(newUrl) {
                this.updateView(newUrl);
            },
            immediate: true
        }
    },
    methods: {
        dark() {
            return config.isDarkModeOn()
        },
        updateView(url) {
            this.content = null;
            this.loading = true;
            this.err = false;
            let request = config.gateway + config.getPath('rss_sources');
            let payload = { "urls": url, "sort": "asc" }
            axios.post(request, payload, { headers: config.authorisationHeader() })
                .then(response => {
                    this.content = response.data.data.nodes;
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
        },
        processText(text) {
            return text.length > 200 ?
                text.substring(0, 200) + "..." :
                text;
        },
        openFeed(url) {
            window.open(url, '_blank').focus();
        },
        like(item) {
            item.heart = true; // should replace with loading
            let url = config.gateway + config.getPath('favourites')
            let payload = { 'favourite': {
                'title': item.title, 'description': item.description, 'link': item.link,
                'publisher': item.source, 'published_date': item.publishedDate } }
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
        }
    }
}
</script>