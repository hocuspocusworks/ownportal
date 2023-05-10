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
                    No articles in this feed. Try later.
                </div>
            </div>

            <div v-if="summaryView" class="row">
                <ul class="list-group list-unstyled" v-for="(item, i) in content" :key="i">
                    <li class="pb-2">
                        <div class="card" :class="themeCard">
                            <div class="card-body" @click="openFeed(item)">
                                <h5 class="card-title"><span v-html="processText(item.title)"></span></h5>
                                <h6 class="card-subtitle mb-2 text-muted">
                                    {{ time.since(item.published_date) }} | {{ item.publisher }}
                                </h6>
                            </div>
                            <div>
                                <button class="btn shadow-none" :class="themeText" @click="like(item)"><i class="bi"
                                        :class="{ 'bi-heart': !item.heart, 'bi-heart-fill': item.heart }"></i></button>
                                <button class="btn shadow-none" :class="themeText" @click="clipboard(item)"><i
                                        class="bi"
                                        :class="{ 'bi-files': !item.copied, 'bi-file-check-fill': item.copied }"></i></button>
                                <button class="btn shadow-none" :class="themeText, playable(item)"
                                    @click="play(item)"><i class="bi bi-play-circle"></i></button>
                            </div>
                        </div>
                    </li>
                </ul>
            </div>

            <div v-if="!summaryView" class="row">
                <div class="col-sm-12 col-lg-4 mb-4" v-for="(item, i) in content" :key="i">
                    <div class="card full-height my-link" :class="themeCard">
                        <div class="card-body" @click="openFeed(item)">
                            <h5 class="card-title"><span v-html="processText(item.title)"></span></h5>
                            <h6 class="card-subtitle mb-2 text-muted">
                                {{ item.publisher }} | {{ time.since(item.published_date) }}
                            </h6>
                            <p><span v-html="processText(item.description)"></span></p>
                        </div>
                        <div class="pb-3">
                            <button class="btn shadow-none" :class="themeText" @click="like(item)"><i class="bi"
                                    :class="{ 'bi-heart': !item.heart, 'bi-heart-fill': item.heart }"></i></button>
                            <button class="btn shadow-none" :class="themeText" @click="clipboard(item)"><i class="bi"
                                    :class="{ 'bi-files': !item.copied, 'bi-file-check-fill': item.copied }"></i></button>
                            <button class="btn shadow-none" :class="themeText, playable(item)" @click="play(item)"><i
                                    class="bi bi-play-circle"></i></button>
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
import time from '../time'
import media from '../media'

export default {
    name: 'MainContent',
    props: {
        contentSources: {
            type: String,
            default: ""
        }
    },
    data() {
        return {
            loading: false,
            err: false,
            content: [],
            highlights: [],
            regexCache: {},
            time: time
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
        },
        summaryView() {
            return config.isSummaryViewOn()
        }
    },
    watch: {
        contentSources: {
            handler: function (itemId) {
                this.updateView(itemId);
            },
            immediate: true
        }
    },
    methods: {
        dark() {
            return config.isDarkModeOn()
        },
        playable(item) {
            if (item.media_url) {
                return ""
            }
            return "d-none"
        },
        updateView(itemId) {
            console.log(itemId)
            this.content = null;
            this.loading = true;
            this.err = false;
            let request = config.gateway + config.getPath('rss_sources');
            // let payload = { "sources": itemId, "sort": "asc" }
            let payload = this.resolvePayload(itemId)
            axios.get(request, { headers: config.authorisationHeader(), params: payload })
                .then(response => {
                    this.content = response.data;
                })
                .then(load => {
                    this.loading = false;
                })
                .catch(err => {
                    this.loading = false;
                    this.err = err;
                });
            let highlight = config.gateway + config.getPath('highlights')
            axios.get(highlight, { headers: config.authorisationHeader() })
                .then(response => {
                    if (response.status === 200) {
                        this.highlights = response.data
                    }
                })
        },
        resolvePayload(itemId) {
            const item = itemId.split(':')
            return item[0] === 'source' ?
                { 'source': item[1], 'sort': 'asc' } :
                { 'group': item[1], 'sort': 'asc' }
        },
        baseUrl(url) {
            var pathArray = url.split('/');
            var protocol = pathArray[0];
            var host = pathArray[2];
            return protocol + '//' + host;
        },
        processText(text) {
            let shortenText = this.shortenText(text)
            let highlightedText = this.highlightedText(shortenText)
            return highlightedText
        },
        shortenText(text) {
            return text.length > 200 ?
                text.substring(0, 200) + "..." :
                text;
        },
        highlightedText(text) {
            this.highlights.forEach(highlight => {
                text = text.replace(this.regex(highlight.keyword),
                    `<span style="background-color: ${highlight.colour}">$1</span>`)
            })
            return text
        },
        regex(word) {
            if (this.regexCache[word] === undefined) {
                this.regexCache[word] = new RegExp('(\\b' + word + '\\b)', 'gi')
            }
            return this.regexCache[word]
        },
        openFeed(item) {
            let url = config.gateway + config.getPath('histories')
            let payload = { 'history': { 'article_id': item.id } }
            axios.post(url, payload, { headers: config.authorisationHeader() })

            window.open(item.link, '_blank').focus();
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
        },
        play(item) {
            this.$emit("mediaChanged")
            media.play(item.media_url)
        }
    }
}
</script>