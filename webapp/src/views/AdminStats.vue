<template>
  <div>
    Stats
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
              <td>{{ stats.total_count }}</td>
            </tr>
            <tr>
              <td>Number of regular users</td>
              <td>{{ stats.user_count }}</td>
            </tr>
            <tr>
              <td>Number of active users</td>
              <td>{{ stats.active_count }}</td>
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
      stats: null
    }
  },
  mounted() {
    let request = config.gateway + config.getPath('admin_stats')
    axios.get(request, { headers: config.authorisationHeader() })
      .then(response => {
        if (response.status === 200) {
          this.stats = response.data[0]
        }
      })
  }
}
</script>