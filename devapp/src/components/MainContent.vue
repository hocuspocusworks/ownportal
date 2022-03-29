<template>
    <div class="text-start">
        <ul class="nav nav-tabs" id="myTab" role="tablist">
            <!-- <li class="nav-item" role="presentation">
                <button class="nav-link active" id="docs-tab" data-bs-toggle="tab" data-bs-target="#docs" type="button" role="tab" aria-controls="docs" aria-selected="false">Docs</button>
            </li> -->
            <li class="nav-item" role="presentation">
                <button class="nav-link active" id="profile-tab" data-bs-toggle="tab" data-bs-target="#profile" type="button" role="tab" aria-controls="profile" aria-selected="true">Profile</button>
            </li>
            <!-- <li class="nav-item" role="presentation">
                <button class="nav-link" id="contact-tab" data-bs-toggle="tab" data-bs-target="#contact" type="button" role="tab" aria-controls="contact" aria-selected="false">Contact</button>
            </li> -->
            </ul>
            <div class="tab-content" id="myTabContent">
            <!-- <div class="tab-pane fade show active" id="docs" role="tabpanel" aria-labelledby="docs-tab">
                Docs
            </div> -->
            <div class="tab-pane fade show active" id="profile" role="tabpanel" aria-labelledby="profile-tab">
                <div class="card col-12">
                    <div class="card-body">
                        <h5 class="card-title">{{ name }}</h5>
                        <h6 class="card-subtitle mb-2 text-muted">{{ email }}</h6>
                        <br>
                        <div class="container">
                            <div class="row mb-2">
                                <div class="col-2">
                                Subscription
                                </div>
                                <div class="col">
                                    <span v-if="paid" class="badge bg-success">Paid subscription</span>
                                    <span v-if="!paid" class="badge bg-danger">Free subscription</span>
                                </div>
                            </div>

                            <div class="row mb-2">
                                <div class="col-2">
                                Qouta
                                </div>
                                <div class="col">
                                    <span class="badge bg-primary">{{qouta}}</span>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-2">
                                Token
                                </div>
                                <div class="col-6">
                                    <div class="row align-middle">
                                        <div class="col-8">
                                            <input class="form-control form-control-sm text-truncate" id="tokenEl" :value="token" readonly>
                                        </div>
                                        <div class="col">
                                            <button type="button" class="btn btn-secondary btn-sm" :onclick="copy">Copy</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="mt-4">
                            <button type="button" class="btn btn-primary me-2">Documentation</button>
                            <button type="button" class="btn btn-danger" :onclick="logout">Logout</button>
                        </div>
                    </div>
                </div>
            </div>
            <!-- <div class="tab-pane fade" id="contact" role="tabpanel" aria-labelledby="contact-tab">...</div> -->
        </div>
    </div>
</template>

<script>
import axios from 'axios';
import config from '../config';
import util from '../util';

export default {
    name: 'MainContent',
    props: {
        contentUrl: String,
    },
    data() {
        return {
            name: "",
            email: "",
            token: "",
            qouta: "",
            paid: false
        }
    },
    methods: {
        me() {
            let url = config.gateway + "/portal/developer/me";
            axios.get(url, {withCredentials: true})
                .then(response => {
                    if (response.status === 200) {
                        this.name = response.data.username;
                        this.email = response.data.email;
                        this.paid = response.data.paidSubscription;
                        this.qouta = response.data.qouta;
                        this.token = response.data.token;
                    }
                    console.log(response.data);
                });
        },
        copy() {
            console.log('copy called');
            console.log('copying ' + document.getElementById('tokenEl').value);
            util.copyToClipboard('tokenEl');
        },
        logout() {
            localStorage.setItem('loggedIn', 'false');
            location.reload();
        }
    },
    mounted() {
        this.me();
    }
}
</script>