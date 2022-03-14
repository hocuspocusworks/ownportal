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
            if (this.isValidToken() || this.isValidCredentials()) {
                localStorage.token = "new_token";
                router.push("/");
            }
        },
        register() {
            router.push("/register");
        },
        isValidCredentials() {
            return this.username === "admin" && this.password === "admin" ? true : false;
        },
        isValidToken() {
            return localStorage.token === "new_token" ? true : false;
        }
    },
    mounted() {
        console.log(localStorage.token);
        if (localStorage.token === "new_token") {
            router.push("/");
        }
    },
};

</script>