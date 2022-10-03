<template>
  <div>
    Stats
  </div>

  <div v-if="loading">
    <div class="spinner-border" role="status">
      <span class="visually-hidden">Loading...</span>
    </div>
  </div>

  <div class="container">
    <div class="row">
      <div class="col-6">
        <table class="table">
          <thead>
          </thead>
          <tbody>
            <tr>
              <td>Total number of users</td>
              <td>{{ stats.users_total }}</td>
            </tr>
            <tr>
              <td>Number of regular users</td>
              <td>{{ stats.user_count }}</td>
            </tr>
            <tr>
              <td>Number of active users</td>
              <td>{{ stats.user_active }}</td>
            </tr>
            <tr>
              <td>Total number of sources</td>
              <td>{{ stats.sources_total }}</td>
            </tr>
            <tr>
              <td>Number of restricted sources</td>
              <td>{{ stats.sources_restricted }}</td>
            </tr>
            <tr>
              <td>Number of published sources</td>
              <td>{{ stats.sources_published }}</td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import config from '../config';

export default {
  name: 'AdminStats',
  data() {
    return {
      stats: {},
      loading: false
    }
  },
  mounted() {
    this.loading = true
    let request = config.gateway + config.getPath('admin_stats')
    axios.get(request, { headers: config.authorisationHeader() })
      .then(response => {
        if (response.status === 200) {
          this.stats = response.data[0]
          this.loading = false
        }
      })
  }
}
</script>