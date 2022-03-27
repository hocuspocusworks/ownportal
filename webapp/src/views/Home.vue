<template>
    <div class="container">
        <div class="row">
            <div class="col-3"><SideMenu @feed-changed="feedCallback" @logout="logout" /></div>
            <div class="col-9"><MainContent :contentUrl="url" /></div>
        </div>
    </div>
</template>

<script>
import HelloWorld from '../components/HelloWorld.vue'
import SideMenu from '../components/SideMenu.vue'
import MainContent from '../components/MainContent.vue'
import axios from 'axios'
import config from '../config'

export default {
    name: 'Home',
    components: {
        HelloWorld,
        SideMenu,
        MainContent,
    },
    data() {
        return {
            url: "",
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