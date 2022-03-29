<template>
    <h3>Register</h3>

    <form>
        <div>
            <table>
                <tr>
                    <td>
                        <label for="username">Username:</label>
                    </td>
                    <td>
                        <input id="username" v-model="username" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <label for="email">Email:</label>
                    </td>
                    <td>
                        <input id="email" v-model="email" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <label for="password">Password:</label>
                    </td>
                    <td>
                        <input type="password" id="password" v-model="password" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <label for="password_repeated">Repeat Password:</label>
                    </td>
                    <td>
                        <input
                            type="password_repeated"
                            id="password_repeated"
                            v-model="password_repeated"
                        />
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <button type="button" @click="register">Register</button>
                    </td>
                </tr>
            </table>
        </div>
    </form>
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
            email: "",
            password: "",
            password_repeated: ""
        }
    },
    methods: {
        register() {
            if (this.passwordValid()) {
                let url = config.gateway + "/developer/register";
                let payload = {'username': this.username, 'password': this.password, 'email': this.email};
                axios.post(url, payload)
                    .then(response => {
                        if (response.status === 200) {
                            router.push("/login");
                        }
                    });
            }
        },
        passwordValid() {
            return this.password === this.password_repeated ? true : false;
        }
    },
    mounted() {
    },
};

</script>