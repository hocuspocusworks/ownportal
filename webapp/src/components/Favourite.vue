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
                    Favourites list is empty. Favourite some items first.
                </div>
            </div>

            <div class="row">
                <div class="col-sm-12 col-lg-4 mb-4" v-for="(item,i) in content" :key="i">
                    <div class="card full-height my-link" :class="themeCard">
                        <div class="card-body" @click="openFeed(item.link)">
                            <h5 class="card-title">{{ item.title }}</h5>
                            <h6 class="card-subtitle mb-2 text-muted">{{ item.publisher }} | {{ item.published_date }}</h6>
                            <p>{{ processText(item.description) }}</p>
                        </div>
                        <div class="pb-3">
                            <button v-if="!trashLoading[i]" class="btn shadow-none" :class="themeText" @click="destroy(item, i)"><i class="bi bi-trash"></i></button>
                            <div v-if="trashLoading[i]" class="spinner-border" style="width: 1rem !important; height: 1rem !important;" role="status"></div>
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
    name: 'Favourite',
    data() {
        return {
            loading: true,
            err: false,
            content: [],
            trashLoading: []
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
        loadFavourites() {
            let url = config.gateway + config.getPath('favourites');
            axios.get(url, { headers: config.authorisationHeader() })
                .then(response => {
                    if (response.status === 200) {
                        this.content = response.data;
                        this.trashLoading = Array.from({length: this.content.length}, () => false)
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
        destroy(item, i) {
            this.trashLoading[i] = true
            let url = config.gateway + config.getPath('favourites') + `/${item.id}`
            axios.delete(url, { headers: config.authorisationHeader() })
                .then(response => {
                    if (response.status === 204) {
                        this.loadFavourites()
                    }
                })
        }
    },
    mounted() {
        this.loadFavourites();
    }
}
</script>