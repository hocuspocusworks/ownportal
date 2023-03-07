<template>
  <div class="container">
    <div v-if="passwordChanged" class="alert alert-success alert-dismissible fade show" role="alert">
      <strong>Password successfully changed.</strong>
      <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"
        @click="hidePasswordChanged"></button>
    </div>

    <div v-if="passwordNotChanged" class="alert alert-danger alert-dismissible fade show" role="alert">
      <strong>Password did not change due to: {{ passwordError }}.</strong>
      <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"
        @click="hidePasswordChanged"></button>
    </div>

    <div class="row pt-2 p-lg-4">
      <div class="col-12 col-lg-3">
        <div class="card mx-auto m-2" :class="themeCard" style="width: 18rem;">
          <div class="card-body">
            <h5 class="card-title">Safe search</h5>
            <h6 class="card-subtitle mb-2 text-muted d-flex justify-content-center">
              <div class="form-check form-switch">
                <input class="form-check-input" type="checkbox" v-model="safe" @click="save('safe')"
                  id="flexSwitchCheckDefault">
              </div>
            </h6>
            <p class="card-text">Show only RSS feeds which are marked safe in search bar.</p>
          </div>
        </div>
      </div>
      <div class="col-12 col-lg-3">
        <div class="card mx-auto m-2" :class="themeCard" style="width: 18rem;">
          <div class="card-body">
            <h5 class="card-title">Dark mode</h5>
            <h6 class="card-subtitle mb-2 text-muted d-flex justify-content-center">
              <div class="form-check form-switch">
                <input class="form-check-input" type="checkbox" v-model="dark" @click="save('dark')"
                      id="flexSwitchCheckDefault">
              </div>
            </h6>
            <p class="card-text">Switch between light and dark mode.</p>
          </div>
        </div>
      </div>
      <div class="col-12 col-lg-3">
        <div class="card mx-auto m-2" :class="themeCard" style="width: 18rem;">
          <div class="card-body">
            <h5 class="card-title">Summary view</h5>
            <h6 class="card-subtitle mb-2 text-muted d-flex justify-content-center">
              <div class="form-check form-switch">
                <input class="form-check-input" type="checkbox" v-model="summary" @click="save('summary')"
                      id="flexSwitchCheckDefault">
              </div>
            </h6>
            <p class="card-text">Show feed titles without their description.</p>
          </div>
        </div>
      </div>
      <div class="col-12 col-lg-3">
        <div class="card mx-auto m-2" :class="themeCard" style="width: 18rem;">
          <div class="card-body">
            <h5 class="card-title">Keep history</h5>
            <h6 class="card-subtitle mb-2 text-muted d-flex justify-content-center">
              <div class="form-check form-switch">
                <input class="form-check-input" type="checkbox" v-model="history" @click="save('history')"
                      id="flexSwitchCheckDefault">
              </div>
            </h6>
            <p class="card-text">Keep history of all RSS items you clicked on.</p>
          </div>
        </div>
      </div>
    </div>

    <div class="row pt-4">
      <div class="col-3"></div>
      <div class="col">
        <button type="button" class="btn btn-outline-secondary" data-bs-toggle="modal" data-bs-target="#passwordModal">
          Change password
        </button>
      </div>
      <div class="col">
        <button type="button" class="btn btn-outline-danger" @click="remove()">Delete account</button>
      </div>
      <div class="col-3"></div>
    </div>

  </div>

  <!-- Modal -->
  <div id="passwordModal" class="modal" tabindex="-1">
    <div class="modal-dialog">
      <div class="modal-content text-dark">
        <div class="modal-header">
          <h5 class="modal-title">Change password</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body">
          <form>
            <div class="row mb-3">
              <label for="inputPassword" class="col-sm-6 col-form-label">New password</label>
              <div class="col-sm-6">
                <input type="password" class="form-control" id="inputPassword" v-model="new_password">
              </div>
            </div>
            <div class="row mb-3">
              <label for="repeatPassword" class="col-sm-6 col-form-label">Repeat password</label>
              <div class="col-sm-6">
                <input type="password" class="form-control" id="repeatPassword" v-model="repeated_password">
              </div>
            </div>
          </form>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
          <button type="button" class="btn btn-primary" data-bs-dismiss="modal" @click="changePassword">Apply</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import config from '../config';

export default {
  name: 'Setting',
  data() {
    return {
      my_settings: [],
      toggle: false,
      safe: false,
      dark: false,
      summary: false,
      history: false,
      user_id: 0,
      new_password: null,
      repeated_password: null,
      passwordChanged: false,
      passwordNotChanged: false,
      passwordError: ''
    }
  },
  computed: {
    themeCard() {
      return {
        'bg-dark-middle': this.darkTheme(),
        'bg-bluegray-50': !this.darkTheme()
      }
    },
    themeText() {
      return {
        'text-light': this.darkTheme(),
        'text-light-black': !this.darkTheme()
      }
    },
  },
  methods: {
    darkTheme() {
      return config.isDarkModeOn()
    },
    changePassword() {
      if (this.new_password != null &&
        this.new_password == this.repeated_password) {
        let url = config.gateway + config.getPath('users') + '/' + config.userId()
        let payload = { 'user': { 'password': this.new_password } }
        axios.patch(url, payload, { headers: config.authorisationHeader() })
          .then(response => {
            if (response.status === 200) {
              this.passwordChanged = true
              this.passwordNotChanged = false
            }
          }).catch(ex => {
            this.passwordNotChanged = true
            this.passwordChanged = false
            this.passwordError = ex.response.data.errors
          })
      }
      this.new_password = null
      this.repeated_password = null
    },
    hidePasswordChanged() {
      this.passwordChanged = false
      this.passwordNotChanged = false
    },
    updateSettings(my_settings) {
      this.my_settings = my_settings == null ? [] : my_settings
      this.toggle = this.my_settings.includes('toggle') ? true : false
      this.safe = this.my_settings.includes('safe') ? true : false
      this.dark = this.my_settings.includes('dark') ? true : false
      this.summary = this.my_settings.includes('summary') ? true : false
      this.history = this.my_settings.includes('history') ? true : false
    },
    save(value) {
      if (this.my_settings.includes(value)) {
        let index = this.my_settings.indexOf(value)
        if (index > -1) {
          this.my_settings.splice(index, 1)
        }
      } else {
        this.my_settings.push(value)
      }
      let request = config.gateway + config.getPath('users') + '/' + this.user_id
      let payload = { 'user': { 'settings': this.my_settings } }
      axios.patch(request, payload, { headers: config.authorisationHeader() })
        .then(response => {
          if (response.status === 200) {
            this.saveLocal()
            config.reload()
          }
        })
    },
    saveLocal() {
      localStorage.setItem('settings', this.my_settings);
    },
    remove() {
      if (!confirm('Are you sure?')) {
        return
      }

      let request = config.gateway + config.getPath('users') + '/' + this.user_id
      axios.delete(request, { headers: config.authorisationHeader() })
        .then(response => {
          if (response.status === 204) {
            config.clearAll()
            config.reload()
          }
        })
    }
  },
  mounted() {
    let request = config.gateway + config.getPath('users')
    axios.get(request, { headers: config.authorisationHeader() })
      .then(response => {
        if (response.status === 200) {
          this.user_id = response.data.id
          this.updateSettings(response.data.settings)
        }
      })
  }
}
</script>