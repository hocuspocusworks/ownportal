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
      <div id="editor" style="height: 350px"></div>
    </div>

    <button type="button" class="btn btn-secondary" @click="quillText">Save</button>
  </div>
</template>

<script>
import Quill from 'quill'
import "quill/dist/quill.snow.css"
import axios from 'axios'
import config from '../config'

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
            location.reload()
          }
        })
    },
    parsedContent() {
      var content = this.quill.root.innerHTML
      return content.replaceAll('<br>', '')
    },
    imageHandler() {
      var range = this.quill.getSelection();
      var value = prompt('What is the image URL');
      this.quill.insertEmbed(range.index, 'image', value, Quill.sources.USER);
    }
  },
  mounted() {
    var toolbarOptions = [
      [{ 'header': [1, 2, 3, 4, 5, 6, false] }],

      ['bold', 'italic', 'underline'],

      [{ 'align': [] }],

      [{ 'color': [] }, { 'background': [] }],

      ['blockquote', 'code-block'],

      [{ 'script': 'sub'}, { 'script': 'super' }],

      ['link', 'image'],

      ['clean']
    ]
    let options = {
      modules: {
        toolbar: {
          container: toolbarOptions,
          handlers: {
            image: this.imageHandler
          }
        }
      },
      theme: 'snow'
    }
    this.quill = new Quill('#editor', options)
  }
}
</script>
