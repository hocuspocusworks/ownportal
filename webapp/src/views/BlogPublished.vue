<template>
  <table class="table">
    <thead>
      <tr>
        <th scope="col">#</th>
        <th scope="col">Title</th>
        <th scope="col">Published date</th>
        <th scope="col">Options</th>
      </tr>
    </thead>
    <tbody>
      <tr v-for="(item, i) in blogs" :key="i">
        <th scope="row">{{ i+1 }}</th>
        <td>{{ item.heading }}</td>
        <td>{{ item.published_date }}</td>
        <td>
          <button type="button" class="btn btn-primary me-2" @click="open(item.html_file_name)">Open</button>
          <button type="button" class="btn btn-primary me-2" @click="edit(item.id)">Edit</button>
          <button type="button" class="btn btn-danger" @click="remove(item.id)">Remove</button>
        </td>
      </tr>
    </tbody>
  </table>
</template>

<script>
import axios from 'axios';
import config from '../config';
import router from '../router';

export default {
  name: 'BlogPublished',
  data() {
    return {
      blogs: []
    }
  },
  methods: {
    loadPublishedBlogs() {
      let url = config.gateway + config.getPath('blogs')
      axios.get(url, { headers: config.authorisationHeader() })
        .then(response => {
          this.blogs = response.data
        })
    },
    open(path) {
      let space = config.spacePath()
      let url = `https://space.ownportal.net/${space}/${path}.html`
      window.open(url, '_blank')
    },
    edit(id) {
      router.push({name: "post", params: {blog_id: id}})
    },
    remove(id) {
      let url = config.gateway + config.getPath('blogs') + '/' + id
      axios.delete(url, { headers: config.authorisationHeader() })
        .then(response => {
          if (response.status === 204) {
            router.go({ name: 'published' })
          }
        })
    }
  },
  mounted() {
    this.loadPublishedBlogs()
  }
}
</script>
