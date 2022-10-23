<template>
  <div class="container">
    <div class="m-2">
      <h3>New post</h3>
    </div>

    <div class="col-12 m-2">
      <label for="inputEmail4" class="form-label">Post title</label>
      <input type="text" class="form-control" id="name" v-model="title">
    </div>

    <div class="col-12 m-2">
      <label for="inputEmail4" class="form-label">Content</label>
      <div id="editor" style="height: 300px"></div>
    </div>

    <button type="button" class="btn btn-secondary" @click="quillText">Save</button>
  </div>
</template>

<script>
import Quill from 'quill'
import "quill/dist/quill.snow.css"
import axios from 'axios'
import config from '../config'
import router from '../router'

export default {
  name: 'BlogCreated',
  data() {
    return {
      title: '',
      quill: null
    }
  },
  methods: {
    quillText() {
      let url = config.gateway + config.getPath('blogs')
      let payload = {
        'blog':
        {
          'heading': this.title,
          'content': this.parsedContent(),
          'language': 'en',
          'active': 'true',
          'space_id': config.spaceId()
        }
      }
      axios.post(url, payload, { headers: config.authorisationHeader() })
        .then(response => {
          if (response.status === 201) {
            router.push({ name: 'published' })
          }
        })
    },
    parsedContent() {
      var content = this.quill.root.innerHTML
      return content.replace('<br>', '')
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
