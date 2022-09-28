<template>
  <table class="table">
    <thead>
      <tr>
        <th scope="col">Setting</th>
        <th scope="col">Value</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td>Toggle sidebar</td>
        <td><input type="checkbox" v-model="toggle" @click="save('toggle')" /></td>
      </tr>
      <tr>
        <td>Safe search</td>
        <td><input type="checkbox" v-model="safe" @click="save('safe')" /></td>
      </tr>
      <tr>
        <td>Dark mode</td>
        <td><input type="checkbox" v-model="dark" @click="save('dark')" /></td>
      </tr>
    </tbody>
  </table>
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
      this.my_settings = my_settings
      this.toggle = my_settings.includes('toggle') ? true : false
      this.safe = my_settings.includes('safe') ? true : false
      this.dark = my_settings.includes('dark') ? true : false
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
      let payload = { 'user': {'settings': this.my_settings} }
      axios.patch(request, payload, { headers: config.authorisationHeader() })
        .then(response => {
          if (response.status === 200) {
            this.saveLocal()
            console.log('success')
          }
        })
    },
    saveLocal() {
      localStorage.setItem('settings', this.my_settings);
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