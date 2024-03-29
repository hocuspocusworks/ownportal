<template>
    <div class="container-fluid text-gray-600">
        <div class="mt-5"></div>
        <div class="row">
            <div class="col-sm-0 col-lg-2"></div>

            <div class="col-sm-12 col-lg-8">
                <div class="row">
                    <div class="d-flex ps-4">
                        <p class="fs-4">Discover new feeds and articles</p>
                    </div>

                    <div class="d-flex p-4">
                        <div class="input-group input-group-lg">
                            <span class="input-group-text" id="basic-addon1"><i class="bi bi-search"></i></span>
                            <input v-model="search" type="text" class="form-control shadow-none" placeholder="Start typing some subject or insert an RSS link" aria-label="Start typing some subject or insert an RSS link" aria-describedby="basic-addon1">
                        </div>
                    </div>

                    <div v-if="loading">
                        <div class="spinner-border" role="status">
                            <span class="visually-hidden">Loading...</span>
                        </div>
                    </div>

                    <div v-if="!results" class="row p-0 m-0">
                        <div class="alert alert-danger" role="alert">
                            No results.
                        </div>
                    </div>

                    <div v-if="!featured" class="p-0 m-0">
                        <div class="mb-3" v-for="(item, i) in sources" :key="i">
                            <div class="row border rounded gx-0">
                                <div class="col-12 text-start gx-3 fs-4">
                                    {{ item.name }}
                                </div>
                                <div class="col-12 text-start gx-3">
                                    {{ item.description }}
                                </div>
                                <div class="col-12 gx-3">
                                    <div class="input-group justify-content-end">
                                        <button class="btn btn-outline-secondary dropdown-toggle" type="button" data-bs-toggle="dropdown" aria-expanded="false">Add to a Group</button>
                                        <ul class="dropdown-menu">
                                            <li><a class="dropdown-item" href="#" v-for="(grp, j) in groups" @click="addToGroup(grp, item.name, item.url)">{{ grp }}</a></li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="row p-0 m-0">
                        <div v-for="(category, i) in categories" :key="i">
                            <div class="d-flex mt-3 ps-4">
                                <div><small class="fw-bold" style="text-transform: uppercase">{{ category }}</small></div>
                            </div>

                            <div class="row ms-1 mt-2">
                                <div class="col-sm-12 col-lg-3 p-2" v-for="(item, j) in suggestions[category]" :key="j">
                                    <div class="card bg-gray-200 full-height">
                                        <div class="card-body">
                                            <h5 class="card-title">{{ shortenText(item.name, 36) }}</h5>
                                            <p class="card-text">{{ shortenText(item.description, 36 * 2) }}</p>
                                            <div class="input-group justify-content-center">
                                                <button class="btn btn-outline-secondary dropdown-toggle" type="button" data-bs-toggle="dropdown" aria-expanded="false">Add to a Group</button>
                                                <ul class="dropdown-menu">
                                                    <li><a class="dropdown-item" href="#" v-for="(grp, j) in groups" @click="addToGroup(grp, item.name, item.url)">{{ grp }}</a></li>
                                                </ul>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-sm-0 col-lg-2"></div>
        </div>
    </div>
</template>

<script>
import axios from 'axios';
import config from '../config';

export default {
    name: "Explore",
    data() {
        return {
            search: "",
            loading: false,
            featured: true,
            results: true,
            sources: [],
            groups: [],
            suggestions: {},
            categories: ["News", "Podcast", "Economy", "Science", "Cooking"],
            items: [
                {label: 'Home', icon: 'pi pi-fw pi-home'},
                {label: 'Calendar', icon: 'pi pi-fw pi-calendar'},
            ]
        }
    },
    methods: {
        loadGroups() {
            this.groups = config.fetchGroups()
        },
        addToGroup(grpName, name, uri) {
            let url = config.gateway + config.getPath('streams');
            let payload = { 'stream': { group: grpName, name: name, url: uri } }
            axios.post(url, payload, { headers: config.authorisationHeader() })
                .then(response => {
                    if (response.status === 201) {
                        this.$emit("exploreChanged", payload);
                    }
                });
        },
        isValidHttpUrl(string) {
            let url;
            try {
                url = new URL(string);
            } catch (_) {
                return false;  
            }
            return url.protocol === "http:" || url.protocol === "https:";
        },
        safeSearch() {
            return config.isSafeSearchOn() ? '&safe=true' : '&safe=false'
        },
        loadSuggestions() {
            let url = config.gateway + config.getPath('top') + '?categories=News,Science,Cooking,Podcast,Economy'
            axios.get(url, { headers: config.authorisationHeader() })
                .then(response => {
                    if (response.status === 200) {
                        response.data.forEach(item => {
                            this.pushSuggestion(item)
                        })
                    }
                })
        },
        pushSuggestion(item) {
            if (item.categories[0] !== undefined &&
                item.categories[0] in this.suggestions &&
                this.suggestions[item.categories[0]].length < 4) {
                this.suggestions[item.categories[0]].push(item)
            } else if (item.categories[0] !== undefined &&
                       this.suggestions[item.categories[0]] === undefined) {
                this.suggestions[item.categories[0]] = [item]
            }
        },
        shortenText(text, length) {
            return text.length > length ?
                text.substring(0, length) + "..." :
                text;
        }
    },
    mounted() {
        this.loadGroups()
        this.loadSuggestions()
    },
    watch: {
        search: function(newValue, oldValue) {
            this.loading = true;
            this.sources = [];
            this.results = true;
            if (this.isValidHttpUrl(newValue) && newValue.length > 16) {
                let url = config.gateway + config.getPath('explore_rss') + "?url=" + newValue;
                axios.get(url, { headers: config.authorisationHeader() })
                    .then(response => {
                        if (response.status === 200 && response.data !== null) {
                            this.sources = [response.data];
                            this.featured = false;
                            this.loadGroups(); // should be watched separetly and invoked only when new group created
                        } else {
                            this.results = false
                            this.featured = true
                        }
                        this.loading = false
                    })
                    .catch(_exception => {
                        this.results = false
                        this.loading = false
                    })
            } else if (newValue.length >= 2) {
                let url = config.gateway + config.getPath('explore_search') + "?keyword="+newValue + this.safeSearch();
                axios.get(url, { headers: config.authorisationHeader() })
                    .then(response => {
                        if (response.status === 200) {
                            this.sources = response.data;
                            this.featured = false;
                            this.loadGroups();
                            if (this.sources.length === 0) {
                                this.results = false;
                            }
                        } else {
                            this.featured = true;
                        }
                        this.loading = false;
                    });
            } else {
                this.loading = false;
            }
        }
    }
}
</script>