<template>
    <div class="container">
        <header class="d-flex flex-wrap justify-content-center py-3 mb-4 border-bottom">
        <a href="/" class="d-flex align-items-center mb-3 mb-md-0 me-md-auto text-dark text-decoration-none">
            <svg class="bi me-2" width="40" height="32"><use xlink:href="#bootstrap"/></svg>
            <span class="fs-4">ownportal<sup><small>BETA</small></sup></span>
        </a>

        <ul class="nav nav-pills">
            <li class="nav-item"><a href="#" class="nav-link" @click="register">Register</a></li>
            <li class="nav-item"><a href="#" class="nav-link active" aria-current="page">About</a></li>
        </ul>
        </header>
    </div>

    <div v-if="err">
        <div class="alert alert-danger" role="alert">
            <span v-if="!errInfo">There are some issues logging you in. Please try again later.</span>
            <span v-if="errInfo">Error: {{ errInfo }}</span>
        </div>
    </div>

    <div class="container col-xl-10 col-xxl-8 px-4 py-5">
        <div class="row align-items-center g-lg-5 py-5">
        <div class="col-lg-7 text-center text-lg-start">
            <h1 class="display-4 fw-bold lh-1 mb-3">Curate your own Internet experience.</h1>
            <p class="col-lg-10 fs-4">
                ownportal is a simple to use RSS reader that allows you to add feeds and organise them as you like. Try it out, it's free!
            </p>
            <button type="button" class="btn btn-primary btn-lg px-4 gap-3" @click="register">Register</button>
        </div>
        <div class="col-md-10 mx-auto col-lg-5">
            <form class="p-4 p-md-5 border rounded-3 bg-light">
            <div class="input-group input-group-lg mb-3">
                <input v-model="username" type="email" class="form-control" id="floatingInput" placeholder="Email">
            </div>
            <div class="input-group input-group-lg mb-3">
                <input v-model="password" type="password" class="form-control" id="floatingPassword" placeholder="Password" @keyup.enter="login">
            </div>
            <div class="checkbox mb-3">
                <label>
                <input type="checkbox" value="remember-me"> Remember me
                </label>
            </div>
            <button v-if="!loading" class="w-100 btn btn-lg btn-primary" type="button" @click="login">Sign in</button>
            <div class="m-3" v-if="loading">
                <div class="spinner-border" role="status">
                    <span class="visually-hidden">Loading...</span>
                </div>
            </div>
            <hr class="my-4">
            <small class="text-muted">By clicking Sign in, you agree to the Privacy Policy and Terms of Use.</small>
            </form>
        </div>
        </div>
    </div>

    <div class="container my-5">
        <div class="row p-4 pb-0 pe-lg-0 pt-lg-5 align-items-center rounded-3 border shadow-lg">
        <div class="col-lg-7 p-3 p-lg-5 pt-lg-3">
            <h1 class="display-4 fw-bold lh-1">Simple yet powerful</h1>
            <p class="lead">
                Clean design lets you enjoy your favourite stories from your PC or mobile. It's like Google - you don't need yet another mobile app, you can read your feeds straight from your browser.
                Feeds are organised in groups letting you choose between showing feeds from an individual source or from multiple sources at the same time.
                Most importantly, feeds are always loaded fresh with no delays.
            </p>
            <div class="d-grid gap-2 d-md-flex justify-content-md-start mb-4 mb-lg-3">
            </div>
        </div>
        <div class="col-lg-4 offset-lg-1 p-0 overflow-hidden shadow-lg">
            <img class="rounded-lg-3" src="../assets/ownportal.png" alt="" width="720">
        </div>
        </div>
    </div>

    <div class="px-4 py-5 text-center">
        <svg xmlns="http://www.w3.org/2000/svg" width="72" height="57" fill="currentColor" class="bi bi-globe" viewBox="0 0 16 16">
        <path d="M0 8a8 8 0 1 1 16 0A8 8 0 0 1 0 8zm7.5-6.923c-.67.204-1.335.82-1.887 1.855A7.97 7.97 0 0 0 5.145 4H7.5V1.077zM4.09 4a9.267 9.267 0 0 1 .64-1.539 6.7 6.7 0 0 1 .597-.933A7.025 7.025 0 0 0 2.255 4H4.09zm-.582 3.5c.03-.877.138-1.718.312-2.5H1.674a6.958 6.958 0 0 0-.656 2.5h2.49zM4.847 5a12.5 12.5 0 0 0-.338 2.5H7.5V5H4.847zM8.5 5v2.5h2.99a12.495 12.495 0 0 0-.337-2.5H8.5zM4.51 8.5a12.5 12.5 0 0 0 .337 2.5H7.5V8.5H4.51zm3.99 0V11h2.653c.187-.765.306-1.608.338-2.5H8.5zM5.145 12c.138.386.295.744.468 1.068.552 1.035 1.218 1.65 1.887 1.855V12H5.145zm.182 2.472a6.696 6.696 0 0 1-.597-.933A9.268 9.268 0 0 1 4.09 12H2.255a7.024 7.024 0 0 0 3.072 2.472zM3.82 11a13.652 13.652 0 0 1-.312-2.5h-2.49c.062.89.291 1.733.656 2.5H3.82zm6.853 3.472A7.024 7.024 0 0 0 13.745 12H11.91a9.27 9.27 0 0 1-.64 1.539 6.688 6.688 0 0 1-.597.933zM8.5 12v2.923c.67-.204 1.335-.82 1.887-1.855.173-.324.33-.682.468-1.068H8.5zm3.68-1h2.146c.365-.767.594-1.61.656-2.5h-2.49a13.65 13.65 0 0 1-.312 2.5zm2.802-3.5a6.959 6.959 0 0 0-.656-2.5H12.18c.174.782.282 1.623.312 2.5h2.49zM11.27 2.461c.247.464.462.98.64 1.539h1.835a7.024 7.024 0 0 0-3.072-2.472c.218.284.418.598.597.933zM10.855 4a7.966 7.966 0 0 0-.468-1.068C9.835 1.897 9.17 1.282 8.5 1.077V4h2.355z"/>
        </svg>
        <h1 class="display-5 fw-bold">Your own personal portal<sup><small>BETA</small></sup></h1>
        <div class="col-lg-6 mx-auto">
        <p class="lead mb-4">
            Choose your own sources of information, whether it's about general news, technologies, cooking or many more.
            Then organise them in groups and enjoy reading. You will notice the <sup><small>BETA</small></sup> sign next to ownportal<sup><small>BETA</small></sup>.
            This is a one person hobby project. You will encounter some rough edges while using ownportal, but you can
            report issues <a target="_blank" href="https://github.com/hocuspocusworks/ownportal/issues">here</a>.
        </p>
        </div>
    </div>

</template>

<script>
import axios from "axios";
import config from "../config";
import router from "../router";

export default {
    data() {
        return {
            username: "",
            password: "",
            err: false,
            errInfo: '',
            loading: false
        }
    },
    methods: {
        register() {
            router.push({name: "register"});
        },
        loginView() {
            router.push({name: "login"});
        },
        login() {
            this.err = false;
            this.loading = true;
            let url = config.gateway + config.getPath('login')
            let payload = {"session": {"email": this.username, "password": this.password }};
            axios.post(url, payload)
                .then(resp => {
                    if (resp.status === 201) {
                        localStorage.setItem('token', resp.data.session.token);
                        router.push({name: "home"});
                    }
                }).catch(ex => {
                    this.reportError(ex.response);
                })
        },
        reportError(response) {
            this.err = true;
            this.loading = false;
            if (response && response.data) {
                this.errInfo = response.data.errors;
            }
        },
        isValidToken() {
            return localStorage.getItem('token') ? true : false;
        }
    },
    mounted() {
        if (this.isValidToken()) {
            router.push({name: "home"});
        }
    }
}
</script>