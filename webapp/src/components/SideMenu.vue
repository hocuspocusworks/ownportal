<template>
    <div>
        <div class="col-12 text-left">
            <Button label="Read later" icon="pi pi-bookmark" class="p-button-text ml-3 text-white" />
        </div>
        <div class="col-12 text-left">
            <Button label="Favourites" icon="pi pi-heart" class="p-button-text ml-3 text-white" />
        </div>
        <div class="col-12 text-left">
            <Button label="Explore" icon="pi pi-cloud" class="p-button-text ml-3 text-white" @click="toExplore" />
        </div>
    </div>
    <ProgressSpinner v-if="loading" />
    <Message v-if="err" severity="error" closable="false" class="col-12">Cannot load the feed.</Message>
    <Tree :value="root" class="border-none text-white bg-bluegray-600" @node-select="onNodeSelect"
            selectionMode="single" v-model:selectionKeys="selectedKey"></Tree>
    <Inplace :closable="true">
        <template #display>
            <span class="pi pi-plus" style="vertical-align: middle"></span>
            {{newGroupName || 'Add new group'}}
        </template>
        <template #content>
            <InputText v-model="newGroupName" placeholder="type name followed by enter" autoFocus @keyup.enter="createGroupCallback" />
        </template>
    </Inplace>
</template>

<script>
import axios from 'axios';
import config from '../config';
import Card from 'primevue/card';
import Tree from 'primevue/tree';
import Button from 'primevue/button';
import InputText from 'primevue/inputtext';
import Inplace from 'primevue/inplace';
import ProgressSpinner from 'primevue/progressspinner';
import Message from 'primevue/message';

export default {
    name: "SideMenu",
    components: {
        Card,
        Tree,
        Button,
        InputText,
        Inplace,
        ProgressSpinner,
        Message
    },
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
            root: [],
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