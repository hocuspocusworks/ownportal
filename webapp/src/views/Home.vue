<template>
    <div>
        <div class="d-flex bg-bluegray-400" style="height: 3.5rem;">
            <div class="flex-grow-1 text-start">
                <a href="javascript:;"><i class="bi bi-list text-white" @click="toggleSidebar" style="font-size: 2.5rem;"></i></a>
            </div>
            <div class="align-self-center">
                <button class="btn text-white fs-4 rounded-circle me-3" @click="logout"><i class="bi bi-power"></i></button>
            </div>
        </div>
        <div class="d-flex min-h-screen">
            <SideMenu @feed-changed="feedCallback" @logout="logout" @explore="explore" @favourite="favourite" @setting="setting" :needRefresh="refreshMenu" />
            <div class="f-equal bg-bluegray-50">
                <router-view @explore-changed="informMenu"></router-view>
            </div>
        </div>
    </div>
</template>

<script>
import SideMenu from '../components/SideMenu.vue'
import axios from 'axios'
import config from '../config'
import router from "../router";
import sidebar from '../sidebar';

export default {
    name: 'Home',
    components: {
        SideMenu
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
            this.toggleSidebar();
        },
        informMenu() {
            this.refreshMenu = (Math.random() + 1).toString(36).substring(7);
        },
        explore() {
            router.push({name: "explore"});
            this.toggleSidebar();
        },
        favourite() {
            router.push({name: "favourite"});
            this.toggleSidebar();
        },
        setting() {
            router.push({name: 'setting'})
        },
        logout() {
            localStorage.setItem('token', '');
            this.sendLogoutToServer();
            router.push({name: "login"});
        },
        sendLogoutToServer() {
            let url = config.gateway + '/api/sessions';
            let headers = {Authorization: localStorage.getItem('token')};
            axios.delete(url, {headers});
        },
        toggleSidebar() {
            if (config.isToggleOn()) {
                sidebar.toggleSidebar();
            }
        }
    }
}
</script>
