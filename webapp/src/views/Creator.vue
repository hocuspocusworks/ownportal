<template>
  <div>
    <div class="container">
      <div class="row">
        <div class="col-8">
          <h4>New blog</h4>
          <div id="editor" style="height: 300px"></div>
          <button type="button" class="btn btn-secondary" @click="quillText">Save</button>
        </div>

        <div class="col-4">
          <h4>Posted blogs</h4>

          <ul class="list-group">
            <li class="list-group-item">An item</li>
            <li class="list-group-item">A second item</li>
            <li class="list-group-item">A third item</li>
            <li class="list-group-item">A fourth item</li>
            <li class="list-group-item">And a fifth one</li>
          </ul>

        </div>
      </div>
    </div>
  </div>
</template>

<script>
import Quill from 'quill'
import "quill/dist/quill.snow.css"
import axios from 'axios'
import config from '../config'

export default {
  name: 'Creator',
  data() {
    return {
      quill: null
    }
  },
  methods: {
    quillText() {
      let url = config.gateway + config.getPath('blogs')
      let payload = { 'blog':
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