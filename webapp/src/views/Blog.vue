<template>
  <nav class="navbar navbar-expand-lg navbar-light bg-light">
    <div class="container-fluid">
      <a class="navbar-brand" href="#">Creator</a>
      <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent"
        aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
      </button>
      <div class="collapse navbar-collapse" id="navbarSupportedContent">
        <ul class="navbar-nav me-auto mb-2 mb-lg-0">
          <li class="nav-item active">
            <a class="nav-link" href="#" @click="published">Published</a>
          </li>
          <li class="nav-item">
            <a class="nav-link" href="#" @click="newPost">New post</a>
          </li>
        </ul>
      </div>
    </div>
  </nav>
  <router-view></router-view>
</template>

<script>
import Quill from 'quill'
import "quill/dist/quill.snow.css"
import axios from 'axios'
import config from '../config'
import router from '../router'

export default {
  name: 'Blog',
  data() {
    return {
      quill: null
    }
  },
  methods: {
    published() {
      router.push({ name: 'published' })
    },
    newPost() {
      router.push({ name: 'post' })
    },
    quillText() {
      let url = config.gateway + config.getPath('blogs')
      let payload = {
        'blog':
        {
          'title': 'test',
          'heading': 'title',
          'content': this.quill.root.innerHTML,
          'language': 'en',
          'active': 'true',
          'space_id': '2'
        }
      }
      axios.post(url, payload, { headers: config.authorisationHeader() })
        .then(response => {
          console.log('sent')
        })
    }
  },
  mounted() {
    var toolbarOptions = [
      [{ 'header': [1, 2, 3, 4, 5, 6, false] }],

      ['bold', 'italic', 'underline'],

      ['clean']
    ]
    let options = {
      modules: {
        toolbar: toolbarOptions
      },
      theme: 'snow'
    }
    this.quill = new Quill('#editor', options)
  }
}
</script>
