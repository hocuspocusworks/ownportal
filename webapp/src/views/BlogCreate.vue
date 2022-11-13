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
  props: {
    blog_id: {
      type: String,
      default: ""
    }
  },
  data() {
    return {
      title: '',
      quill: null,
      patch: false,
      id: '0'
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
      if (this.patch) {
        this.patch = false
        url = url + '/' + this.id
        axios.patch(url, payload, { headers: config.authorisationHeader() })
          .then(response => {
            if (response.status === 200) {
              this.id = 0
              location.reload()
            }
          })
      } else {
        axios.post(url, payload, { headers: config.authorisationHeader() })
          .then(response => {
            if (response.status === 201) {
              location.reload()
            }
          })
      }
    },
    parsedContent() {
      var content = this.quill.root.innerHTML
      return content.replaceAll('<br>', '')
    },
    loadBlog(id) {
      if (!id || id === '0') return

      this.id = id
      let url = config.gateway + config.getPath('blogs') + '/' + id
      axios.get(url, { headers: config.authorisationHeader() })
        .then(response => {
          if (response.status === 200) {
            this.patch = true
            this.title = response.data.heading
            this.quill.root.innerHTML = response.data.content
          }
        })
    },
    imageHandler() {
      var range = this.quill.getSelection();
      var value = prompt('What is the image URL');
      this.quill.insertEmbed(range.index, 'image', value, Quill.sources.USER);
    }
  },
  watch: {
    blog_id: {
      handler: function(id) {
        this.loadBlog(id)
      },
      immediate: true
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
