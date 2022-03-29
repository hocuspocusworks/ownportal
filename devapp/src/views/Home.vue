<template>
    <div class="container">
        <div class="row">
            <div class="col-12"><MainContent :contentUrl="url" /></div>
        </div>
    </div>
</template>

<script>
import MainContent from '../components/MainContent.vue'
import axios from 'axios'
import config from '../config'

export default {
    name: 'Home',
    components: {
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