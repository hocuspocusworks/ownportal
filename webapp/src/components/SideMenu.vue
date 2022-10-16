<template>
    <div id="mySidebar" class="text-white sidebarWidth" :class="themeMenu">
        <div class="p-3">
            <div class="d-flex p-2 align-items-center">
                <i class="bi bi-globe me-2"></i>
                <button class="btn shadow-none flex-grow-1 text-start text-white" @click="toExplore">Explore</button>
            </div>
            <div class="d-flex p-2 align-items-center">
                <i class="bi bi-balloon-heart me-2"></i>
                <button class="btn shadow-none flex-grow-1 text-start text-white" @click="toFavourites">Favourites</button>
            </div>
            <div class="d-flex p-2 align-items-center">
                <i class="bi bi-pen me-2"></i>
                <button class="btn shadow-none flex-grow-1 text-start text-white" @click="toHighlights">Highlights</button>
            </div>
            <div class="d-flex p-2 align-items-center">
                <i class="bi bi-gear me-2"></i>
                <button class="btn shadow-none flex-grow-1 text-start text-white" @click="toSettings">Settings</button>
            </div>
            <div class="d-flex p-2 align-items-center" :class="{ 'd-none': !isAdmin }">
                <i class="bi bi-person me-2"></i>
                <button class="btn shadow-none flex-grow-1 text-start text-white" @click="toAdmin">Admin</button>
            </div>
        </div>

        <div class="ps-3 pe-3">
            <div class="d-flex p-2 align-items-center">
                <i class="bi bi-plus-circle me-2" type="button" data-bs-toggle="collapse" data-bs-target="#new-group" aria-expanded="false" aria-controls="new-group"></i>
                <button class="btn shadow-none text-white" type="button" data-bs-toggle="collapse" data-bs-target="#new-group" aria-expanded="false" aria-controls="new-group">New group</button>
            </div>
            <div class="collapse" id="new-group">
                <div class="container pb-4 ps-0 pe-0">
                    <div class="row">
                        <div class="col-9">
                            <input type="text" class="form-control" id="new-group-name" v-model="newGroupName" placeholder="New group name" @keyup.enter="createGroupCallback">
                        </div>
                        <div class="col-2 ps-0">
                            <button type="button" class="btn btn-dark bg-header" @click="createGroupCallback">OK</button>
                        </div>
                    </div>    
                </div>
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
                    <button class="btn shadow-none text-white" @click="deleteGroup(item.id)"><i class="bi bi-folder-x"></i></button>
                </div>
                <div class="collapse" :id="'i-'+i">
                    <div class="d-flex" v-for="(subitem, j) in item.streams" :key="subitem.name">
                        <button type="button" class="btn my-li-text shadow-none ps-5 flex-grow-1" @click="onItemSelect(subitem)">
                            {{ subitem.name }}
                        </button>
                        <button class="btn shadow-none text-white" @click="deleteFeed(subitem.id)"><i class="bi bi-trash3"></i></button>
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
    computed: {
        themeMenu() {
            return {
                'bg-dark-strong': this.dark(),
                'bg-bluegray-600': !this.dark()
            }
        }
    },
    data() {
        return {
            err: false,
            loading: true,
            isAdmin: config.isAdmin(),
            data: [],
            icon: [],
            selectedKey: "",
            newGroupName: ""
        }
    },
    methods: {
        dark() {
            return config.isDarkModeOn()
        },
        createGroupCallback() {
            if (this.newGroupName.length > 2) {
                this.createGroup();
            }
        },
        createSourceCallback() {
            this.createSource();
        },
        createGroup() {
            let group = config.gateway + config.getPath('my_feed')
            let payload = { 'group': { 'name': this.newGroupName } }
            axios.post(group, payload, { headers: config.authorisationHeader() })
                .then(response => {
                    if (response.status === 201) {
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
            let stream = config.gateway + "/api/streams";
            axios.post(stream, payload, { headers: config.authorisationHeader() });
            this.newSourceName = "";
            this.newRssFeedUrl = "";
        },
        fetchFeed() {
            this.loading = true;
            let me = config.gateway + config.getPath('my_feed')
            axios({
                method: "get",
                url: me,
                timeout: 1000*5,
                headers: config.authorisationHeader()
                }).then(response => {
                    this.updateView(response.data)
                }).catch(error => {
                    this.updateError();
                });
        },
        source(number) {
            this.selectedGroup = number;
        },
        updateView(data) {
            this.data = data
            this.loading = false
            config.fetchGroups(data)
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
                    let src = item.sources.find(obj => obj.id === el.source_id)
                    url.push(src.url)
                });
            } else {
                this.data.forEach(group => {
                    if (group.id === item.group_id) {
                        group.sources.forEach(src => {
                            if (src.id === item.source_id) {
                                url.push(src.url)
                            }
                        })
                    }
                })
            }
            this.$emit('feedChanged', url);
        },
        toAdmin() {
            this.$emit('admin')
        },
        toFavourites() {
            this.$emit('favourite')
        },
        toHighlights() {
            this.$emit('highlight')
        },
        toExplore() {
            this.$emit('explore')
        },
        toSettings() {
            this.$emit('setting')
        },
        deleteGroup(id) {
            let url = config.gateway + config.getPath('my_feed') + '/' + id;
            let headers = {Authorization: localStorage.getItem('token')};
            axios.delete(url, {headers})
                .then(response => {
                    if (response.status === 204) {
                        this.fetchFeed();
                    }
                });
        },
        deleteFeed(id) {
            let url = config.gateway + config.getPath('streams') + '/' + id;
            let headers = {Authorization: localStorage.getItem('token')};
            axios.delete(url, {headers})
                .then(response => {
                    if (response.status === 204) {
                        this.fetchFeed();
                    }
                });
        },
        swapDropdownIcon(el) {
            this.icon[el] = this.icon[el] ? false : true;
        }
    },
    mounted() {
        this.fetchFeed()
    },
    watch: {
        needRefresh: {
            handler: function() {
                this.fetchFeed();
            }
        }
    }
};
</script>