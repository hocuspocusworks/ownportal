<template>
    <h3>Login</h3>

    <form>
        <div>
            <label for="username">Username: </label>
            <input id="username" v-model="username" />
        </div>
        <div>
            <label for="password">Password: </label>
            <input type="password" id="password" v-model="password" />
        </div>
        <div>
            <button type="button" class="btn btn-primary m-2" @click="login">Login</button>
            <button type="button" class="btn btn-primary m-2" @click="register">Register</button>
        </div>
    </form>
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
                        router.push("/");
                    }
                    console.log(resp);
                });
        },
        register() {
            router.push("/register");
        },
        isValidCredentials() {
            return this.username === "admin" && this.password === "admin" ? true : false;
        },
        isValidToken() {
            return localStorage.getItem('loggedIn') === "true" ? true : false;
        }
    },
    mounted() {
        if (this.isValidToken()) {
            router.push("/");
        }
    },
};

</script>