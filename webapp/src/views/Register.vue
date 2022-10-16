<template>
    <div class="container">
        <header class="d-flex flex-wrap justify-content-center py-3 mb-4 border-bottom">
        <a href="/" class="d-flex align-items-center mb-3 mb-md-0 me-md-auto text-dark text-decoration-none">
            <svg class="bi me-2" width="40" height="32"><use xlink:href="#bootstrap"/></svg>
            <span class="fs-4">OwnPortal<sup><small>BETA</small></sup></span>
        </a>

        <ul class="nav nav-pills">
            <li class="nav-item"><a href="#" class="nav-link" @click="login">Login</a></li>
            <li class="nav-item"><a href="#" class="nav-link active" aria-current="page">Register</a></li>
            <li class="nav-item"><a href="#" class="nav-link" @click="about">About</a></li>
        </ul>
        </header>

        <div v-if="err">
            <div class="alert alert-danger" role="alert">
                Could not register {{username}} at the moment. Please try again later.
            </div>
        </div>

        <div v-if="userError">
            <div class="alert alert-danger" role="alert">
                {{ userErrors }}
            </div>
        </div>
    </div>

    <div class="form-signin">
        <form>
            <!-- <img class="mb-4" src="../assets/brand/bootstrap-logo.svg" alt="" width="72" height="57"> -->
            <h1 class="h3 mb-3 fw-normal">Register</h1>
    
            <div class="input-group input-group-lg mb-3">
                <input v-model="username" type="email" class="form-control" id="floatingInput" placeholder="Email">
            </div>
            <div class="input-group input-group-lg mb-3">
                <input v-model="password" type="password" class="form-control" id="floatingPassword" placeholder="Password">
            </div>
            <div class="input-group input-group-lg mb-3">
                <input v-model="password_repeated" type="password" class="form-control" id="floatingPasswordRepeated" placeholder="Repeat password">
            </div>
    
            <div class="checkbox mt-3 mb-3"></div>
            <button class="w-100 btn btn-lg btn-primary" type="button" @click="register">Register</button>
            
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
import router from "../router";
import axios from 'axios';
import config from "../config";

export default {
    name: 'Register',
    data() {
        return {
            err: false,
            loading: false,
            username: "",
            password: "",
            password_repeated: "",
            userError: false,
            userErrors: []
        }
    },
    methods: {
        register() {
            if (this.passwordValid()) {
                this.err = false;
                this.loading = true;
                let url = config.gateway + config.getPath('register');
                let payload = {'user': {'password': this.password, 'email': this.username}}
                axios.post(url, payload)
                    .then(response => {
                        if (response.status === 201) {
                            router.push({name: "login"});
                        } else {
                            this.reportError();
                        }
                    })
                    .catch(ex => {
                        this.reportError(ex.response);
                    });
            }
        },
        reportError(response) {
            this.err = true;
            this.loading = false;
            this.processError(response);
        },
        processError(response) {
            let data = response.data
            if (data.errors !== undefined) {
                this.err = false
                this.userError = true
                this.userErrors = data.errors.user
            }
        },
        passwordValid() {
            return this.password === this.password_repeated ? true : false;
        },
        login() {
            router.push({name: "login"});
        },
        about() {
            router.push({name: "about"});
        }
    },
    mounted() {
    },
};

</script>