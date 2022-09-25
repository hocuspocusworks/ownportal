<template>
    <div class="container">
        <header class="d-flex flex-wrap justify-content-center py-3 mb-4 border-bottom">
        <a href="/" class="d-flex align-items-center mb-3 mb-md-0 me-md-auto text-dark text-decoration-none">
            <svg class="bi me-2" width="40" height="32"><use xlink:href="#bootstrap"/></svg>
            <span class="fs-4">OwnPortal<sup><small>BETA</small></sup></span>
        </a>

        <ul class="nav nav-pills">
            <li class="nav-item"><a href="#" class="nav-link active" aria-current="page">Login</a></li>
            <li class="nav-item"><a href="#" class="nav-link" @click="register">Register</a></li>
            <li class="nav-item"><a href="#" class="nav-link" @click="about">About</a></li>
        </ul>
        </header>

        <div v-if="err">
            <div class="alert alert-danger" role="alert">
                <span v-if="!errInfo">There are some issues logging you in. Please try again later.</span>
                <span v-if="errInfo">Error: {{ errInfo }}</span>
            </div>
        </div>
    </div>
    
    <div class="form-signin">
        <form>
            <!-- <img class="mb-4" src="../assets/brand/bootstrap-logo.svg" alt="" width="72" height="57"> -->
            <h1 class="h3 mb-3 fw-normal">Sign in</h1>
    
            <div class="input-group input-group-lg mb-3">
                <input v-model="username" type="email" class="form-control" id="floatingInput" placeholder="Email">
            </div>
            <div class="input-group input-group-lg mb-3">
                <input v-model="password" type="password" class="form-control" id="floatingPassword" placeholder="Password" @keyup.enter="login">
            </div>
    
            <div class="checkbox mt-3 mb-3">
            <label>
                <input type="checkbox" value="remember-me"> Remember me
            </label>
            </div>
            <button class="w-100 btn btn-lg btn-primary" type="button" @click="login">Sign in</button>

            <div class="m-3" v-if="loading">
                <div class="spinner-border" role="status">
                    <span class="visually-hidden">Loading...</span>
                </div>
            </div>

            <p class="mt-5 mb-3 text-muted">&copy; 2022</p>
        </form>
    </div>
</template>

<script>
import axios from "axios";
import config from "../config";
import router from "../router";

export default {
    name: 'Login',
    data() {
        return {
            err: false,
            errInfo: '',
            loading: false,
            username: '',
            password: ''
        }
    },
    methods: {
        login() {
            this.err = false;
            this.loading = true;
            let url = config.gateway + config.getPath('login')
            let payload = {"session": {"email": this.username, "password": this.password }}
            axios.post(url, payload)
                .then(resp => {
                    if (resp.status === 201) {
                        localStorage.setItem('token', resp.data.session.token);
                        router.push({name: "home"});
                    } else {
                        this.reportError(resp);
                    }
                })
                .catch(ex => {
                    this.reportError(ex.response);
                });
        },
        reportError(response) {
            this.err = true;
            this.loading = false;
            if (response && response.data) {
                this.errInfo = response.data.errors;
            }
        },
        register() {
            router.push({name: "register"});
        },
        isValidToken() {
            return localStorage.getItem('token') ? true : false;
        },
        about() {
            router.push({name: "about"});
        }
    },
    mounted() {
        if (this.isValidToken()) {
            router.push({name: "home"});
        }
    },
};

</script>
