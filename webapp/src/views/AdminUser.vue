<template>
  <div class="container p-4">
    <div class="input-group mb-3">
      <input type="text" class="form-control" placeholder="Search users" aria-label="Search users"
        aria-describedby="button-addon2" v-model="searchTerm">
      <button class="btn btn-outline-secondary" type="button" id="button-addon2" @click="searchUsers()">Search</button>
    </div>

    <div>
      <table class="table">
        <thead>
          <tr>
            <th scope="col">Email</th>
            <th scope="col">Sysadmin</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(user, i) in users" :key="i">
            <td>{{ user.email }}</td>
            <td><input class="form-check-input me-1" type="checkbox" @click="toggleSysadmin(user)" aria-label="admin" v-model="user.sysadmin"></td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<script>
import axios from 'axios'
import config from '../config'

export default {
  name: 'AdminUser',
  data() {
    return {
      users: [],
      searchTerm: ''
    }
  },
  methods: {
    searchUsers() {
      let url = config.gateway + config.getPath('users') + '/all_users'
      axios.get(url, { headers: config.authorisationHeader() })
        .then(response => {
          if (response.status === 200) {
            this.users = response.data
            console.log(this.users)
          }
        })
    },
    makeUserAdmin(user) {
      let url = config.gateway + config.getPath('users') + '/' + user.id
      let payload = { 'user': { 'sysadmin': 'true' } }
      axios.patch(url, payload, { headers: config.authorisationHeader() })
        .then(response => {
          console.log(response)
        })
    },
    toggleSysadmin(user) {
      let url = config.gateway + config.getPath('users') + '/' + user.id
      let permission = !(user.sysadmin)
      let payload = { 'user': { 'sysadmin': permission.toString() } }
      console.log(payload)
      axios.patch(url, payload, { headers: config.authorisationHeader() })
        .then(response => {
          console.log(response)
        })
    }
  }
}
</script>