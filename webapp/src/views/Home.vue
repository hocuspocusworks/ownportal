<template>
    <div>
        <div class="d-flex" :class="themeHeader" style="height: 3.5rem;">
            <div class="flex-grow-1 text-start">
                <a href="javascript:;"><i class="bi bi-list text-white" @click="toggleSidebar" style="font-size: 2.5rem;"></i></a>
            </div>
            <div class="align-self-center">
                <button class="btn text-white fs-4 rounded-circle me-3" @click="logout"><i class="bi bi-power"></i></button>
            </div>
        </div>
        <div class="d-flex min-h-screen" :class="themeText">
            <SideMenu @feed-changed="feedCallback" @logout="logout" @explore="explore" @notification="notification"
                @favourite="favourite" @highlight="highlight" @space="space" @setting="setting" @admin="admin" :needRefresh="refreshMenu" />
            <div id="myContent" class="f-equal" :class="themeContent">
                <router-view @explore-changed="informMenu" @media-changed="mediaChanged"></router-view>
            </div>
        </div>

        <nav id="bottomNav" class="navbar fixed-bottom bg-dark-light">
            <div class="container-fluid justify-content-center" :class="showPlayer">
                <audio class="player" id="mediaPlayer" controls></audio>
            </div>
            <div class="container-fluid justify-content-center">
                <a class="navbar-brand" @click="toTop"><i class="bi bi-house text-white"></i></a>
            </div>
        </nav>
    </div>
</template>

<script>
import SideMenu from '../components/SideMenu.vue'
import axios from 'axios'
import config from '../config'
import router from "../router";
import sidebar from '../sidebar';
import media from '../media'

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
            ],
            media: media,
            mediaVisible: false
        }
    },
    computed: {
        themeHeader() {
            return {
                'bg-dark-light': this.dark(),
                'bg-bluegray-400': !this.dark()
            }
        },
        themeContent() {
            return {
                'bg-dark-middle': this.dark(),
                'bg-bluegray-50': !this.dark()
            }
        },
        themeText() {
            return {
                'text-light': this.dark(),
                'text-light-black': !this.dark()
            }
        },
        themeMenu() {
            return {
                'bg-dark-strong': this.dark(),
                'bg-bluegray-600': !this.dark()
            }
        },
        showPlayer() {
            if (this.mediaVisible) {
                return ""
            }
            return "d-none"
        }
    },
    methods: {
        dark() {
            return config.isDarkModeOn()
        },
        feedCallback(sources) {
            router.push({name: "content", params: {contentSources: sources}});
            this.toggleSidebar();
        },
        informMenu() {
            this.refreshMenu = (Math.random() + 1).toString(36).substring(7);
        },
        mediaChanged() {
            this.mediaVisible = true
        },
        admin() {
            router.push({name: 'admin'})
            this.toggleSidebar()
        },
        explore() {
            router.push({name: "explore"});
            this.toggleSidebar()
        },
        favourite() {
            router.push({name: "favourite"});
            this.toggleSidebar()
        },
        highlight() {
            router.push({name: 'highlight'})
            this.toggleSidebar()
        },
        notification() {
            router.push({name: 'notification'})
            this.toggleSidebar()
        },
        space() {
            router.push({name: 'creator'})
            this.toggleSidebar()
        },
        setting() {
            router.push({name: 'setting'})
            this.toggleSidebar()
        },
        logout() {
            this.sendLogoutToServer();
            localStorage.setItem('token', '');
            localStorage.setItem('sysadmin', '')
            localStorage.setItem('userId', '')
            router.push({name: "login"});
        },
        sendLogoutToServer() {
            let url = config.gateway + config.getPath('login') + '/' + config.userId();
            axios.delete(url, { headers: config.authorisationHeader() })
        },
        toggleSidebar() {
            sidebar.toggleSidebar();
        },
        toTop() {
            scroll(0,0)
        }
    },
    mounted() {
        this.toggleSidebar()
    }
}
</script>
