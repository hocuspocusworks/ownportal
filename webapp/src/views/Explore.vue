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
                            <div v-if="!featured" class="flex">
                                Search results
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

export default {
    name: "Explore",
    components: {
        TabView,
        TabPanel,
        InputText
    },
    data() {
        return {
            search: "",
            featured: true,
            trending: ["t1", "t2", "t3", "t4"],
            categories: ["a", "b", "c", "d", "e", "f"],
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
        }
    },
    mounted() {
        this.loadCategories();
    }
}
</script>