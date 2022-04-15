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
                    <div class="card full-height my-link">
                        <div class="card-body" @click="openFeed(item.link)">
                            <h5 class="card-title">{{ item.title }}</h5>
                            <h6 class="card-subtitle mb-2 text-muted">{{ item.publisher }} | {{ item.publishedDate }}</h6>
                            <p>{{ processText(item.description) }}</p>
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
            content: null
        }
    },
    methods: {
        loadFavourites() {
            let url = config.gateway + "/portal/story/favourite";
            axios.get(url, {withCredentials: true})
                .then(response => {
                    if (response.status === 200) {
                        this.content = response.data;
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
        }
    },
    mounted() {
        this.loadFavourites();
    }
}
</script>