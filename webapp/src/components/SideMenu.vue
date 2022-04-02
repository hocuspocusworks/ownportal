<template>
    <div class="grid">
        <div class="col-12 bg-bluegray-400">
            <span class="p-input-icon-left">
                <i class="pi pi-search" />
                <InputText type="text" v-model="value3" placeholder="Search" />
            </span>
        </div>
        <div class="col-12 text-left">
            <Button label="Dashboard" icon="pi pi-bars" class="p-button-text ml-3 text-white" />
        </div>
        <div class="col-12 text-left">
            <Button label="Read later" icon="pi pi-star" class="p-button-text ml-3 text-white" />
        </div>
        <div class="col-12 text-left">
            <Button label="Explore" icon="pi pi-cloud" class="p-button-text ml-3 text-white" />
        </div>
    </div>
    <Tree :value="root" class="border-none text-white bg-bluegray-600" @node-select="onNodeSelect"
            selectionMode="single" v-model:selectionKeys="selectedKey"></Tree>

    <div v-if="loading" class="spinner-border" role="status">
      <span class="visually-hidden">Loading...</span>
    </div>
    <div v-if="err" class="alert alert-danger" role="alert">
        Cannot load the feed.
    </div>

</template>

<script>
import axios from 'axios';
import config from '../config';
import Card from 'primevue/card';
import Tree from 'primevue/tree';
import Button from 'primevue/button';
import InputText from 'primevue/inputtext';

export default {
    name: "SideMenu",
    components: {
        Card,
        Tree,
        Button,
        InputText
    },
    data() {
        return {
            err: false,
            loading: true,
            root: [],
            selectedKey: "",
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
            axios.post(group, payload, {withCredentials: true});
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
            let me = config.gateway + "/portal/feed/prime/me";
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
            this.root = data;
            this.loading = false;
        },
        updateError() {
            this.err = true;
            this.loading = false;
        },
        logout() {
            this.$emit('logout');
        },
        onNodeSelect(node) {
            let url = [];
            if (node.children !== null) {
                node.children.forEach(el => {
                    url.push(el.data);
                });
            } else {
                if (node.data !== null) {
                    url.push(node.data);
                }
            }
            console.log(url);
            this.$emit('feedChanged', url);
        }
    },
    mounted() {
        this.fetchFeed();
    },
};
</script>