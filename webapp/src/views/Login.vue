<template>
    <div class="container">
        <header class="d-flex flex-wrap justify-content-center py-3 mb-4 border-bottom">
        <a href="/" class="d-flex align-items-center mb-3 mb-md-0 me-md-auto text-dark text-decoration-none">
            <svg class="bi me-2" width="40" height="32"><use xlink:href="#bootstrap"/></svg>
            <span class="fs-4">Ownportal<sup><small>BETA</small></sup></span>
        </a>

        <ul class="nav nav-pills">
            <li class="nav-item"><a href="#" class="nav-link active" aria-current="page">Login</a></li>
            <li class="nav-item"><a href="#" class="nav-link" @click="register">Register</a></li>
            <li class="nav-item"><a href="#" class="nav-link" @click="about">About</a></li>
        </ul>
        </header>
    </div>
    
    <div class="form-signin">
        <form>
            <!-- <img class="mb-4" src="../assets/brand/bootstrap-logo.svg" alt="" width="72" height="57"> -->
            <h1 class="h3 mb-3 fw-normal">Sign in</h1>
    
            <div class="form-floating">
            <input v-model="username" type="email" class="form-control" id="floatingInput" placeholder="name@example.com">
            <label for="floatingInput">Email address</label>
            </div>
            <div class="form-floating">
            <input v-model="password" type="password" class="form-control" id="floatingPassword" placeholder="Password">
            <label for="floatingPassword">Password</label>
            </div>
    
            <div class="checkbox mt-3 mb-3">
            <label>
                <input type="checkbox" value="remember-me"> Remember me
            </label>
            </div>
            <button class="w-100 btn btn-lg btn-primary" type="button" @click="login">Sign in</button>
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
            username: "",
            password: ""
        }
    },
    methods: {
        login() {
            let url = config.gateway + "/user/login";
            let payload = {"username": this.username, "password": this.password };
            axios.post(url, payload, {withCredentials: true})
                .then(resp => {
                    if (resp.status === 200) {
                        localStorage.setItem('loggedIn', 'true');
                        router.push({name: "home"});
                    }
                });
        },
        register() {
            router.push({name: "register"});
        },
        isValidCredentials() {
            return this.username === "admin" && this.password === "admin" ? true : false;
        },
        isValidToken() {
            return localStorage.getItem('loggedIn') === "true" ? true : false;
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