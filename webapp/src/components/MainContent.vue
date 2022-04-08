<template>
    <div class="grid min-w-full mt-2">
        <ProgressSpinner v-if="loading" />
        <Message v-if="err" severity="error" closable="false" class="col-12">Cannot load the feed.</Message>

        <div v-for="(item,i) in content" :key="i" class="p-2 sm:col-12 lg:col-4">
        <div class="min-h-full border-1 border-round border-bluegray-50 text-600 no-underline" style="height: 300px;">
                <Card>
                    <template #title>
                        <a class="text-800 no-underline" target="_blank" :href="item.link">{{ item.title }}</a>
                    </template>
                    <template #subtitle>
                        <small>{{ item.source }}</small>
                    </template>
                    <template class="flex-grow-1" #content>
                        <a v-if="!item.description" class="text-600 no-underline"  target="_blank" :href="item.link">Missing content...</a>
                        <a class="text-600 no-underline" target="_blank" :href="item.link">{{ item.description }}</a>
                    </template>
                    <template #footer>
                        <div class="flex">
                            <div class="flex-grow-1 text-left">
                                <Button icon="pi pi-check" class="p-button-text p-button-rounded" />
                                <Button icon="pi pi-heart" class="p-button-text p-button-rounded p-button-help" />
                                <Button icon="pi pi-bookmark" class="p-button-text p-button-rounded p-button-secondary" />
                            </div>
                            <div class="flex-column align-items-center" style="margin: auto;"><small class="text-muted">{{ item.publishedDate }}</small></div>
                        </div>
                    </template>
                </Card>
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
import Button from 'primevue/button';
import Tag from 'primevue/tag';

export default {
    name: 'MainContent',
    components: {
        Card,
        ProgressSpinner,
        Message,
        Button,
        Tag
    },
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
    watch: {
        contentUrl: {
            handler: function(newUrl) {
                this.updateView(newUrl);
            },
            immediate: true
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