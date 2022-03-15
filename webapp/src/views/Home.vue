<template>
    <!-- <img alt="Vue logo" src="../assets/logo.png" />
    <HelloWorld msg="Hello Vue 3.0 + Vite" />-->
    <div class="container">
        <div class="row">
            <div class="col-3"><SideMenu /></div>
            <div class="col-9"><MainContent /></div>
        </div>
    </div>
</template>

<script>
import HelloWorld from '../components/HelloWorld.vue'
import SideMenu from '../components/SideMenu.vue'
import MainContent from '../components/MainContent.vue'

export default {
    name: 'Home',
    components: {
    HelloWorld,
    SideMenu,
    MainContent
}
}
</script>