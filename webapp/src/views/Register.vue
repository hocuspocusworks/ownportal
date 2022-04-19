<template>
    <div class="container">
        <header class="d-flex flex-wrap justify-content-center py-3 mb-4 border-bottom">
        <a href="/" class="d-flex align-items-center mb-3 mb-md-0 me-md-auto text-dark text-decoration-none">
            <svg class="bi me-2" width="40" height="32"><use xlink:href="#bootstrap"/></svg>
            <span class="fs-4">Ownportal<sup><small>BETA</small></sup></span>
        </a>

        <ul class="nav nav-pills">
            <li class="nav-item"><a href="#" class="nav-link" @click="login">Login</a></li>
            <li class="nav-item"><a href="#" class="nav-link active" aria-current="page" @click="register">Register</a></li>
            <li class="nav-item"><a href="#" class="nav-link">About</a></li>
        </ul>
        </header>
    </div>

    <div class="form-signin">
        <form>
            <!-- <img class="mb-4" src="../assets/brand/bootstrap-logo.svg" alt="" width="72" height="57"> -->
            <h1 class="h3 mb-3 fw-normal">Register</h1>
    
            <div class="form-floating">
            <input v-model="username" type="email" class="form-control" id="floatingInput" placeholder="name@example.com">
            <label for="floatingInput">Email address</label>
            </div>
            <div class="form-floating">
            <input v-model="password" type="password" class="form-control" id="floatingPassword" placeholder="Password">
            <label for="floatingPassword">Password</label>
            </div>
            <div class="form-floating">
            <input v-model="password_repeated" type="password" class="form-control" id="floatingPassword" placeholder="Repeat password">
            <label for="floatingPassword">Repeat password</label>
            </div>
    
            <div class="checkbox mt-3 mb-3"></div>
            <button class="w-100 btn btn-lg btn-primary" type="button" @click="register">Register</button>
            <p class="mt-5 mb-3 text-muted">&copy; 2022</p>
        </form>
    </div>
</template>

<script>
import router from "../router";
import axios from 'axios';
import config from "../config";

export default {
    name: 'Register',
    data() {
        return {
            username: "",
            password: "",
            password_repeated: ""
        }
    },
    methods: {
        register() {
            if (this.passwordValid()) {
                let url = config.gateway + "/user/register";
                let payload = {'username': this.username, 'password': this.password, 'email': this.username};
                axios.post(url, payload)
                    .then(response => {
                        if (response.status === 200) {
                            router.push({name: "login"});
                        }
                    });
            }
        },
        passwordValid() {
            return this.password === this.password_repeated ? true : false;
        },
        login() {
            router.push({name: "login"});
        }
    },
    mounted() {
    },
};

</script>