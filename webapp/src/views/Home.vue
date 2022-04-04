<template>
    <div class="min-w-full">
        <div class="grid flex min-w-full bg-bluegray-400 m-0 p-0" >
            <div class="flex-grow-1 align-self-center">
                <div class="col-12 bg-bluegray-400 text-left pl-4">
                    <span class="p-input-icon-left">
                        <i class="pi pi-search" />
                        <InputText type="text" v-model="value3" placeholder="Search" />
                    </span>
                </div>
            </div>
            <div class="align-self-center">
                <Tag value="DEV" class="mr-2" />
            </div>
            <div class="align-self-center">
                <Button icon="pi pi-power-off" class="p-button-lg p-button-text p-button-rounded p-button-danger" />
            </div>
        </div>
        <div class="grid min-w-full m-0 p-0">
            <div class="sm:col-6 lg:col-2 bg-bluegray-600 pt-2 min-h-screen">
                <SideMenu @feed-changed="feedCallback" @logout="logout" />
            </div>
            <div class="sm:col-6 lg:col-10">
                <MainContent :contentUrl="url" />
            </div>
        </div>
    </div>
</template>

<script>
import HelloWorld from '../components/HelloWorld.vue'
import SideMenu from '../components/SideMenu.vue'
import MainContent from '../components/MainContent.vue'
import Menubar from 'primevue/menubar';
import InputText from 'primevue/inputtext';
import axios from 'axios'
import config from '../config'
import Tag from 'primevue/tag';
import Button from 'primevue/button';

export default {
    name: 'Home',
    components: {
        HelloWorld,
        SideMenu,
        MainContent,
        Menubar,
        InputText,
        Tag,
        Button
    },
    data() {
        return {
            url: "",
            items: [
				{
					label: 'Logout',
					icon: 'pi pi-power-off'
				}
            ]
        }
    },
    methods: {
        feedCallback(url) {
            this.url = url;
        },
        logout() {
            this.sendLogoutToServer();
            localStorage.setItem('loggedIn', 'false');
            location.reload();
        },
        sendLogoutToServer() {
            let url = config.gateway + '/user/logout';
            axios.post(url);
        }
    }
}
</script>