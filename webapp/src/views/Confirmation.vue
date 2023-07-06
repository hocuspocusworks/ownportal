<template>
  <div>
      <div class="d-flex" :class="themeHeader" style="height: 3.5rem;">
        <span v-if="success">
          <p>Your email has been confirmed! Sign in <a href="https://ownportal.net">here</a>.</p>
        </span>

        <span v-if="!success">
          <p>Could not confirm your email. Please contact the administrator at admin@ownportal.net.</p>
        </span>
      </div>
  </div>
</template>

<script>
import axios from 'axios';
import config from '../config';

export default {
  name: 'Confirmation',
  data() {
    return {
      success: false
    }
  },
  methods: {
    confirm() {
      let user_id = new Map(window.location.search.slice(1).split('&').map(q => q.split('='))).get('user')
      let registration_token = new Map(window.location.search.slice(1).split('&').map(q => q.split('='))).get('token')

      let url = config.gateway + config.getPath('confirmation')
      let payload = { user_id: user_id, registration_token: registration_token }
      axios.post(url, payload)
        .then(response => {
          if (response.status === 200) {
            this.success = true
          }
        })
    }
  },
  mounted() {
    this.confirm()
  }
}
</script>