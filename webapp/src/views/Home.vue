<template>
    <div>
        <div class="d-flex bg-bluegray-400" style="height: 3.5rem;">
            <div class="flex-grow-1 text-start">
                <i class="bi bi-list text-white" @click="toggleSidebar" style="font-size: 3rem;"></i>
            </div>
            <div class="align-self-center">
                <Button icon="pi pi-power-off" class="p-button-lg p-button-text p-button-rounded p-button-danger" @click="logout" />
            </div>
        </div>
        <div class="d-flex min-h-screen">
            <SideMenu @feed-changed="feedCallback" @logout="logout" @explore="explore" :needRefresh="refreshMenu" />
            <div class="f-equal bg-bluegray-50">
                <router-view @explore-changed="informMenu"></router-view>
            </div>
        </div>
    </div>
</template>

<script>
import SideMenu from '../components/SideMenu.vue'
import Menubar from 'primevue/menubar';
import InputText from 'primevue/inputtext';
import axios from 'axios'
import config from '../config'
import Tag from 'primevue/tag';
import Button from 'primevue/button';
import router from "../router";
import sidebar from '../sidebar';

export default {
    name: 'Home',
    components: {
        SideMenu,
        Menubar,
        InputText,
        Tag,
        Button
    },
    data() {
        return {
            refreshMenu: "",
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
            router.push({name: "content", params: {contentUrl: url}});
        },
        informMenu() {
            this.refreshMenu = (Math.random() + 1).toString(36).substring(7);
        },
        explore() {
            router.push({name: "explore"});
        },
        logout() {
            this.sendLogoutToServer();
            localStorage.setItem('loggedIn', 'false');
            location.reload();
        },
        sendLogoutToServer() {
            let url = config.gateway + '/user/logout';
            axios.post(url);
        },
        toggleSidebar() {
            sidebar.toggleSidebar();
        }
    }
}
</script>