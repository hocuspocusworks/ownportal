<template>
    <div class="grid">
        <div class="col-12 lg:col-8 lg:col-offset-2">
            <TabView>
                <TabPanel header="Feeds">
                    <div class="col-12 text-600">
                        <div class="flex">
                            <div class="flex-initial flex">
                                <p class="text-2xl">Discover new feeds and articles</p>
                            </div>
                        </div>
                        <div class="flex">
                            <span class="flex flex-grow-1 p-input-icon-left">
                                <i class="pi pi-search" />
                                <InputText v-model="search" type="text" class="inputfield w-full" placeholder="Start typing some subject or insert an RSS link" />
                            </span>
                        </div>
                        <div class="mt-4">
                            <div v-if="featured" class="grid">
                                <div class="col-12">
                                    <div class="flex text-xs font-semibold">TRENDING</div>
                                </div>
                                <div class="grid col-12">
                                    <div class="col-3" v-for="(item, i) in trending" :key="i">
                                        <div class="card border-round surface-200 h-14rem flex justify-content-center">
                                            <div class="flex align-items-center">{{ item.name }}</div>
                                        </div>
                                    </div>
                                </div>

                                <div class="col-12 mt-2">
                                    <div class="flex text-xs font-semibold">CATEGORIES</div>
                                </div>
                                <div class="grid col-12">
                                    <div class="col-3" v-for="(item, i) in categories" :key="i">
                                        <div class="card border-round surface-200 h-6rem flex justify-content-center">
                                            <div class="flex align-items-center">{{ item.name }}</div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div v-if="!featured">
                                <div class="card border-round surface-200 h-12rem justify-content-center" v-for="(item, i) in sources" :key="i">
                                    <div class="flex flex-grow-1 pl-3 pt-3">
                                        <div class="text-left text-2xl">{{ item.name }}</div>
                                        <div class="text-right text-sm">{{ item.language }}</div>
                                    </div>
                                    <div class="flex pl-3">
                                        <div class="text-left">{{ item.url }}</div>
                                    </div>
                                    <div class="flex pl-3 pt-3">
                                        <div class="text-left">{{ item.description }}</div>
                                    </div>
                                    <div class="flex pl-3 pt-5">
                                        <div class="text-left">
                                            <Dropdown v-model="selectedGroup" :options="groups" optionLabel="name" placeholder="Add to a Group" @click="streamSelection(item.name, item.url)" />
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </TabPanel>
            </TabView>
        </div>
        <div class="lg:col-2"></div>
    </div>
</template>

<script>
import axios from 'axios';
import config from '../config';
import TabView from 'primevue/tabview';
import TabPanel from 'primevue/tabpanel';
import InputText from 'primevue/inputtext';
import Dropdown from 'primevue/dropdown';

export default {
    name: "Explore",
    components: {
        TabView,
        TabPanel,
        InputText,
        Dropdown
    },
    data() {
        return {
            search: "",
            featured: true,
            sources: [],
            groups: [],
            selectedGroup: "",
            selectedStream: "",
            selectedName: "",
            trending: ["t1", "t2", "t3", "t4"],
            categories: ["a", "b", "c", "d"],
            items: [
                {label: 'Home', icon: 'pi pi-fw pi-home'},
                {label: 'Calendar', icon: 'pi pi-fw pi-calendar'},
            ]
        }
    },
    methods: {
        loadCategories() {
            let url = config.gateway + "/portal/explore/categories";
            axios.get(url, {withCredentials: true})
                .then(response => {
                    this.trending = response.data.categories.slice(0, 4);
                    this.categories = response.data.categories.slice(4);
                });
        },
        loadGroups() {
            let url = config.gateway + "/portal/feed/me";
            axios.get(url, {withCredentials: true})
                .then(response => {
                    this.groups = response.data.groups;
                });
        },
        streamSelection(name, url) {
            this.selectedName = name;
            this.selectedStream = url;
        },
        addToGroup() {
            let url = config.gateway + "/portal/feed/newStream";
            let payload = {group: this.selectedGroup.name, stream: this.selectedName, url: this.selectedStream};
            axios.post(url, payload, {withCredentials: true})
                .then(response => {
                    if (response.status === 200) {
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
        }
    },
    watch: {
        search: function(newValue, oldValue) {
            if (this.isValidHttpUrl(newValue) && newValue.length > 16) {
                let url = config.gateway + "/portal/explore/rss?url="+newValue;
                axios.get(url, {withCredentials: true})
                    .then(response => {
                        if (response.status === 200 && response.data.id !== null) {
                            this.sources = [response.data];
                            this.featured = false;
                        } else {
                            this.featured = true;
                        }
                    });
            }
        },
        selectedGroup: function(newValue, oldValue) {
            this.addToGroup(newValue);
        }
    },
    mounted() {
        this.loadCategories();
        this.loadGroups();
    }
}
</script>