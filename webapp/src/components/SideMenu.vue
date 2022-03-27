<template>
    <div v-if="loading" class="spinner-border" role="status">
      <span class="visually-hidden">Loading...</span>
    </div>
    <div v-if="err" class="alert alert-danger" role="alert">
        Cannot load the feed.
    </div>
    <div class="accordion accordion-flush" id="accordionExample" v-for="(item,i) in groups" :key="i">
        <div class="accordion-item">
            <h2 class="accordion-header" :id="'heading'+i">
                <button
                    class="accordion-button collapsed"
                    type="button"
                    data-bs-toggle="collapse"
                    :data-bs-target="'#collapse'+i"
                    aria-expanded="false"
                    :aria-controls="'collapse'+i"
                >{{ item.name }}</button>
            </h2>
            <div
                :id="'collapse'+i"
                class="accordion-collapse collapse"
                :aria-labelledby="'heading'+i"
                data-bs-parent="#accordionExample"
            >
                <div class="accordion-body">
                    <strong>Sources</strong>
                    <div v-for="(src,j) in item.streams" :key="j">
                        {{ src.name }}
                    </div>
                    <div>
                        <button type="button" class="btn btn-secondary me-2" @click="feed(i)">Open Feed</button>
                        <button
                            type="button"
                            class="btn btn-secondary"
                            data-bs-toggle="modal"
                            data-bs-target="#addSourceModal"
                            @click="source(i)"
                        >Add Source</button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div v-if="!err && !loading" class="mt-2">
        <button
            type="button"
            class="btn btn-primary w-100"
            data-bs-toggle="modal"
            data-bs-target="#addGroupModal"
        >Add Group</button>
    </div>

    <div class="mt-2">
        <button type="button" class="btn btn-danger w-100" @click="logout">Logout</button>
    </div>

    <!-- addSourceModal -->
    <div
        class="modal fade"
        id="addSourceModal"
        tabindex="-1"
        aria-labelledby="addSourceModal"
        aria-hidden="true"
    >
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="addSourceModal">Add Source</h5>
                    <button
                        type="button"
                        class="btn-close"
                        data-bs-dismiss="modal"
                        aria-label="Close"
                        @click="fetchFeed"
                    ></button>
                </div>
                <div class="modal-body">
                    <form>
                        <div class="input-group mb-3">
                            <span class="input-group-text" id="basic-addon1">Source name</span>
                            <input
                                type="text"
                                class="form-control"
                                placeholder="Source name"
                                aria-label="Source name"
                                aria-describedby="basic-addon1"
                                v-model="newSourceName"
                            />
                        </div>
                        <div class="input-group mb-3">
                            <span class="input-group-text" id="basic-addon1">RSS Feed URL</span>
                            <input
                                type="text"
                                class="form-control"
                                placeholder="Feed URL"
                                aria-label="Feed URL"
                                aria-describedby="basic-addon1"
                                v-model="newRssFeedUrl"
                            />
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button
                        type="button"
                        class="btn btn-secondary"
                        data-bs-dismiss="modal"
                        @click="fetchFeed"
                    >Close</button>
                    <button
                        type="button"
                        class="btn btn-primary"
                        @click="createSourceCallback"
                    >Save changes</button>
                </div>
            </div>
        </div>
    </div>

    <!-- addGroupModal -->
    <div
        class="modal fade"
        id="addGroupModal"
        tabindex="-1"
        aria-labelledby="addGroupModal"
        aria-hidden="true"
    >
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="addGroupModal">Add Group</h5>
                    <button
                        type="button"
                        class="btn-close"
                        data-bs-dismiss="modal"
                        aria-label="Close"
                        @click="fetchFeed"
                    ></button>
                </div>
                <div class="modal-body">
                    <form>
                        <div class="input-group mb-3">
                            <span class="input-group-text" id="basic-addon1">Group name</span>
                            <input
                                type="text"
                                class="form-control"
                                placeholder="Group name"
                                aria-label="Group name"
                                aria-describedby="basic-addon1"
                                v-model="newGroupName"
                            />
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button
                        type="button"
                        class="btn btn-secondary"
                        data-bs-dismiss="modal"
                        @click="fetchFeed"
                    >Close</button>
                    <button
                        type="button"
                        class="btn btn-primary"
                        @click="createGroupCallback"
                    >Save changes</button>
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
    data() {
        return {
            newGroupName: "",
            newSourceName: "",
            newRssFeedUrl: "",
            groups: null,
            selectedGroup: -1,
            err: false,
            loading: true,
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
            axios.post(group, payload);
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
            axios.post(stream, payload);
            this.newSourceName = "";
            this.newRssFeedUrl = "";
        },
        fetchFeed() {
            let me = config.gateway + "/portal/feed/me";
            axios({
                method: "get",
                url: me,
                withCredentials: true,
                timeout: 1000*5
                }).then(response => {
                    this.updateView(response.data);
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
            this.groups = data.groups;
            this.loading = false;
        },
        updateError() {
            this.err = true;
            this.loading = false;
        },
        logout() {
            this.$emit('logout');
        }
    },
    mounted() {
        this.fetchFeed();
    },
};
</script>