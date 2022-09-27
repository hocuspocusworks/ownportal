<template>
  <div>
    List of sources
  </div>
  
  <ul class="list-group" v-for="(item, i) in items" :key="i">
    <li class="list-group-item">{{ item.id }} - {{ item.name }}</li>
  </ul>
</template>

<script>
import axios from 'axios';
import config from '../config';

export default {
  name: "AdminSource",
  data() {
    return {
      items: null
    }
  },
  methods: {
  },
  mounted() {
    let request = config.gateway + config.getPath('admin_sources')
    axios.get(request, { headers: config.authorisationHeader() })
      .then(response => {
        if (response.status === 200) {
          this.items = response.data
        }
      })
  }
}
</script>
