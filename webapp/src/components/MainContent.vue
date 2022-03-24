<template>
    <div v-if="loading" class="spinner-border" role="status">
      <span class="visually-hidden">Loading...</span>
    </div>
    <div v-if="err" class="alert alert-danger" role="alert">
        Cannot load the feed.
    </div>

    <div v-for="(item,i) in content" :key="i" class="card mb-3 w-100">
        <div class="row g-0">
            <div class="col-md-4">
                <!-- <img src="..." class="img-fluid rounded-start" alt="..." /> -->
                <svg
                    class="bd-placeholder-img img-fluid rounded-start"
                    width="100%"
                    xmlns="http://www.w3.org/2000/svg"
                    role="img"
                    aria-label="Placeholder: Image"
                    preserveAspectRatio="xMidYMid slice"
                    focusable="false"
                >
                    <title>Placeholder</title>
                    <rect width="100%" height="100%" fill="#868e96" />
                </svg>
            </div>
            <div class="col-md-8">
                <div class="card-body">
                    <h5 class="card-title"><a target="_blank" :href="item.link">{{ item.title }}</a></h5>
                    <p class="card-text">{{ item.description }}</p>
                    <p class="card-text">
                        <small class="text-muted">{{ item.publishedDate }}</small>
                        <span class="ms-2 badge rounded-pill bg-light text-dark">{{ item.source }}</span>
                    </p>
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
        }
    }
}
</script>