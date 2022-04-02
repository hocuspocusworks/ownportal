<template>
    <!-- <Menubar :model="items">
        <template #start>
            <img alt="logo" src="https://www.primefaces.org/wp-content/uploads/2020/05/placeholder.png" height="40" class="mr-2">
        </template>
        <template #end>
            <InputText placeholder="Search" type="text" />
        </template>
    </Menubar> -->
    <div class="grid min-w-full min-h-screen">
        <div class="sm:col-6 lg:col-2 bg-bluegray-600">
            <SideMenu @feed-changed="feedCallback" @logout="logout" />
        </div>
        <div class="sm:col-6 lg:col-10">
            <MainContent :contentUrl="url" />
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

export default {
    name: 'Home',
    components: {
        HelloWorld,
        SideMenu,
        MainContent,
        Menubar,
        InputText
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