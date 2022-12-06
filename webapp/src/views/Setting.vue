<template>
  <div class="container">
    <div class="row p-4">
      <div class="col-2"></div>
      <div class="col-8">
        <div class="card">
          <div class="card-body text-black">
            <h5 class="card-title">Settings</h5>
            <p class="card-text">Adjust the account to your needs.</p>
          </div>
          <ul class="list-group list-group-flush">
            <li class="list-group-item">
              <div class="row">
                <div class="col-6">
                  Safe search
                </div>
                <div class="col-6">
                  <div class="form-check form-switch">
                    <input class="form-check-input" type="checkbox" v-model="safe" @click="save('safe')"
                      id="flexSwitchCheckDefault">
                  </div>
                </div>
              </div>
            </li>
            <li class="list-group-item">
              <div class="row">
                <div class="col-6">
                  Dark mode
                </div>
                <div class="col-6">
                  <div class="form-check form-switch">
                    <input class="form-check-input" type="checkbox" v-model="dark" @click="save('dark')"
                      id="flexSwitchCheckDefault">
                  </div>
                </div>
              </div>
            </li>
          </ul>
        </div>
      </div>
      <div class="col-2"></div>
    </div>
    
    <button type="button" class="btn btn-outline-danger" @click="remove()">Delete account</button>

  </div>
</template>

<script>
import axios from 'axios';
import config from '../config';

export default {
  name: 'Setting',
  data() {
    return {
      my_settings: [],
      toggle: false,
      safe: false,
      dark: false,
      user_id: 0
    }
  },
  methods: {
    updateSettings(my_settings) {
      this.my_settings = my_settings == null ? [] : my_settings
      this.toggle = this.my_settings.includes('toggle') ? true : false
      this.safe = this.my_settings.includes('safe') ? true : false
      this.dark = this.my_settings.includes('dark') ? true : false
    },
    save(value) {
      if (this.my_settings.includes(value)) {
        let index = this.my_settings.indexOf(value)
        if (index > -1) {
          this.my_settings.splice(index, 1)
        }
      } else {
        this.my_settings.push(value)
      }
      let request = config.gateway + config.getPath('users') + '/' + this.user_id
      let payload = { 'user': { 'settings': this.my_settings } }
      axios.patch(request, payload, { headers: config.authorisationHeader() })
        .then(response => {
          if (response.status === 200) {
            this.saveLocal()
            config.reload()
          }
        })
    },
    saveLocal() {
      localStorage.setItem('settings', this.my_settings);
    },
    remove() {
      if (!confirm('Are you sure?')) {
        return
      }

      let request = config.gateway + config.getPath('users') + '/' + this.user_id
      axios.delete(request, { headers: config.authorisationHeader() })
        .then(response => {
          if (response.status === 204) {
            config.clearAll()
            config.reload()
          }
        })
    }
  },
  mounted() {
    let request = config.gateway + config.getPath('users')
    axios.get(request, { headers: config.authorisationHeader() })
      .then(response => {
        if (response.status === 200) {
          this.user_id = response.data.id
          this.updateSettings(response.data.settings)
        }
      })
  }
}
</script>