<template>
    <div class="grid min-w-full bg-bluegray-400 align-content-center" style="height: 62px;">
    </div>
    <div class="grid min-w-full mt-2">
        <ProgressSpinner v-if="loading" />
        <Message v-if="err" severity="error" closable="false" class="col-12">Cannot load the feed.</Message>

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
import ProgressSpinner from 'primevue/progressspinner';
import Message from 'primevue/message';

export default {
    name: 'MainContent',
    components: {
        Card,
        ProgressSpinner,
        Message
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