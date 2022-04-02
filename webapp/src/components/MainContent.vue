<template>
    <div class="grid min-w-full bg-bluegray-400" style="height: 62px;">
    </div>
    <div class="grid min-w-full mt-2">
        <div v-if="loading" class="spinner-border" role="status">
        <span class="visually-hidden">Loading...</span>
        </div>
        <div v-if="err" class="alert alert-danger" role="alert">
            Cannot load the feed.
        </div>

        <div v-for="(item,i) in content" :key="i" class="p-2 sm:col-12 lg:col-4">
        <div class="min-h-full border-1 border-round border-bluegray-100" style="height: 300px;">
            <a style="text-decoration: none; color: black;" target="_blank" :href="item.link">
                <Card>
                    <template #title>
                        {{ item.title }}
                    </template>
                    <template #subtitle>
                        {{ item.source }}
                    </template>
                    <template class="flex-grow-1" #content>
                        {{ item.description }}
                    </template>
                    <template #footer>
                        <small class="text-muted">{{ item.publishedDate }}</small>
                    </template>
                </Card>
            </a>
        </div>
        </div>
    </div>
</template>

<script>
import axios from 'axios';
import config from '../config';
import Card from 'primevue/card';

export default {
    name: 'MainContent',
    components: {
        Card
    },
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
            let request = config.gateway + "/api/rss/fetchAll";
            let data = {"urls": url};
            axios.post(request, data, {withCredentials: true})
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