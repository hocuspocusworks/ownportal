<template>
    <div class="container-fluid p-2 bg-bluegray-600">
        <ul class="list-group">
            <li class="my-li my-li-item">
                <button class="btn my-li-text shadow-none"><i class="bi bi-archive me-2"></i>Read later</button>
            </li>
            <div class="mt-2"></div>
            <li class="my-li my-li-item">
                <button class="btn my-li-text shadow-none"><i class="bi bi-balloon-heart me-2"></i>Favourites</button>
            </li>
            <div class="mt-2"></div>
            <li class="my-li my-li-item">
                <button class="btn my-li-text shadow-none" @click="toExplore"><i class="bi bi-globe me-2"></i>Explore</button>
            </li>
        </ul>
        <div class="mt-3"></div>
        <ul class="list-group">
            <li class="my-li my-li-item">
                <button class="btn my-li-text shadow-none" type="button" data-bs-toggle="collapse" data-bs-target="#new-group" aria-expanded="false" aria-controls="new-group"><i class="bi bi-plus-circle me-2"></i>New group</button>
                <div class="collapse" id="new-group">
                    <ul class="list-group list-group-flush">
                        <li class="my-li ps-4 my-li-item">
                            <div class="mb-3">
                                <input type="text" class="form-control" id="new-group-name" v-model="newGroupName" placeholder="type name followed by enter" @keyup.enter="createGroupCallback">
                            </div>
                        </li>
                    </ul>
                </div>
            </li>
        </ul>
        <div class="d-flex justify-content-center" v-if="loading">
            <div class="spinner-border" role="status">
                <span class="visually-hidden">Loading...</span>
            </div>
        </div>
        <ul class="list-group">
            <li class="my-li my-li-item" v-for="(item, i) in data" :key="item.name">
                <button class="btn my-li-text shadow-none" type="button" data-bs-toggle="collapse" :data-bs-target="'#i-'+i" aria-expanded="false" :aria-controls="'i-'+i" @click="onItemSelect(item)">
                    <i class="bi bi-chevron-right me-2"></i>{{ item.name }}
                </button>
                <div class="collapse" :id="'i-'+i">
                    <ul class="list-group list-group-flush">
                        <li class="my-li ps-4 my-li-item" v-for="(subitem, j) in item.streams" :key="subitem.name">
                            <button type="button" class="btn my-li-text shadow-none" @click="onItemSelect(subitem)">
                                {{ subitem.name }}
                            </button>
                        </li>
                    </ul>
                </div>
            </li>
        </ul>
    </div>
</template>

<script>
import axios from 'axios';
import config from '../config';

export default {
    name: "SideMenu",
    props: {
        needRefresh: {
            type: String,
            default: ""
        }
    },
    data() {
        return {
            err: false,
            loading: true,
            data: [],
            selectedKey: "",
            newGroupName: "",
        }
    },
    methods: {
        createGroupCallback() {
            this.createGroup();
        },
        createSourceCallback() {
            this.createSource();
        },
        createGroup() {
            let payload = {
                "name": this.newGroupName
            };
            let group = config.gateway + "/portal/feed/newGroup";
            axios.post(group, payload, {withCredentials: true})
                .then(response => {
                    if (response.status === 200) {
                        this.fetchFeed();
                    }
                });
            this.newGroupName = "";
        },
        createSource() {
            let groupName = this.groups[this.selectedGroup].name;
            let payload = {
                "group": groupName,
                "stream": this.newSourceName,
                "url": this.newRssFeedUrl
            };
            let stream = config.gateway + "/portal/feed/newStream";
            axios.post(stream, payload, {withCredentials: true});
            this.newSourceName = "";
            this.newRssFeedUrl = "";
        },
        fetchFeed() {
            this.loading = true;
            let me = config.gateway + "/portal/feed/me";
            axios({
                method: "get",
                url: me,
                withCredentials: true,
                timeout: 1000*5
                }).then(response => {
                    this.updateView(response.data.groups);
                }).catch(error => {
                    this.updateError();
                });
        },
        feed(number) {
            let url = this.groups[number].streams;
            this.$emit("feedChanged", url);
        },
        source(number) {
            this.selectedGroup = number;
        },
        updateView(data) {
            this.data = data;
            this.loading = false;
        },
        updateError() {
            this.err = true;
            this.loading = false;
        },
        logout() {
            this.$emit('logout');
        },
        onItemSelect(item) {
            let url = [];
            if (item.streams !== undefined) {
                item.streams.forEach(el => {
                    url.push(el.url);
                });
            } else {
                url.push(item.url);
            }
            this.$emit('feedChanged', url);
        },
        toExplore() {
            this.$emit('explore');
        }
    },
    mounted() {
        this.fetchFeed();
    },
    watch: {
        needRefresh: {
            handler: function() {
                this.fetchFeed();
            },
            immediate: true
        }
    }
};
</script>