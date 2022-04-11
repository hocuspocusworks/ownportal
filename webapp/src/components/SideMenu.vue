<template>
    <div id="mySidebar" class="text-white bg-bluegray-600" style="min-width: 320px;">
        <div class="p-3">
            <div class="d-flex p-2 align-items-center">
                <i class="bi bi-archive me-2"></i>
                <button class="btn shadow-none flex-grow-1 text-start text-white">Read later</button>
            </div>
            <div class="d-flex p-2 align-items-center">
                <i class="bi bi-balloon-heart me-2"></i>
                <button class="btn shadow-none flex-grow-1 text-start text-white">Favourites</button>
            </div>
            <div class="d-flex p-2 align-items-center">
                <i class="bi bi-globe me-2"></i>
                <button class="btn shadow-none flex-grow-1 text-start text-white" @click="toExplore">Explore</button>
            </div>
        </div>

        <div class="ps-3 pe-3">
            <div class="d-flex p-2 align-items-center">
                <i class="bi bi-plus-circle me-2"></i>
                <button class="btn shadow-none text-white" type="button" data-bs-toggle="collapse" data-bs-target="#new-group" aria-expanded="false" aria-controls="new-group">New group</button>
            </div>
            <div class="collapse" id="new-group">
                <input type="text" class="form-control" id="new-group-name" v-model="newGroupName" placeholder="type name followed by enter" @keyup.enter="createGroupCallback">
            </div>
        </div>

        <div class="ps-3 pe-3">
            <div class="d-flex justify-content-center" v-if="loading">
                <div class="spinner-border" role="status">
                    <span class="visually-hidden">Loading...</span>
                </div>
            </div>
            <div v-for="(item, i) in data" :key="item.name">
                <div class="d-flex ps-2 pe-2 align-items-center">
                    <button @click="swapDropdownIcon(i)" class="btn shadow-none p-0" type="button" data-bs-toggle="collapse" :data-bs-target="'#i-'+i" aria-expanded="false" :aria-controls="'i-'+i">
                        <i class="bi me-1 text-white" :class="{'bi-chevron-down': icon[i], 'bi-chevron-right': !icon[i]}"></i>
                    </button>
                    <button class="btn shadow-none flex-grow-1 text-start text-white" @click="onItemSelect(item)">{{ item.name }}</button>
                    <button class="btn shadow-none text-white" @click="deleteGroup(item.name)"><i class="bi bi-trash"></i></button>
                </div>
                <div class="collapse" :id="'i-'+i">
                    <div class="d-flex" v-for="(subitem, j) in item.streams" :key="subitem.name">
                        <button type="button" class="btn my-li-text shadow-none ps-5" @click="onItemSelect(subitem)">
                            {{ subitem.name }}
                        </button>
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
            icon: [],
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
        },
        deleteGroup(name) {
            let url = config.gateway + "/portal/feed/group";
            axios.delete(url, {data: name, withCredentials: true})
                .then(response => {
                    if (response.status === 200) {
                        this.fetchFeed();
                    }
                });
        },
        swapDropdownIcon(el) {
            this.icon[el] = this.icon[el] ? false : true;
            console.log(this.icon);
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