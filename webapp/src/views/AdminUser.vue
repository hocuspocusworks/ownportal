<template>
  <div class="container p-4">
    <div class="input-group mb-3">
      <input type="text" class="form-control" placeholder="Search users" aria-label="Search users"
        aria-describedby="button-addon2" v-model="searchTerm">
      <button class="btn btn-outline-secondary" type="button" id="button-addon2" @click="searchUsers()">Search</button>
    </div>

    <div>
      <ul class="list-group">
        <li class="list-group-item" v-for="(user, i) in users" :key="i">
          <input class="form-check-input me-1" type="checkbox" @click="makeUserAdmin(user)" aria-label="admin">
          {{ user.email }}
        </li>
      </ul>
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
    }
  }
}
</script>